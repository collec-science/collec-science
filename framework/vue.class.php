<?php

/**
 * Created : 22 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
/**
 * Classe de gestion des messages generes
 * dans l'application
 *
 * @author quinton
 *
 */
class VueException extends Exception
{
}

class Message
{

  /**
   * Tableau contenant l'ensemble des messages generes
   *
   * @var array
   */
  private $_message = array();

  private $_syslog = array();

  private $_displaySyslog = false;

  public $is_error = false;

  function __construct($displaySyslog = false)
  {
    $this->_displaySyslog = $displaySyslog;
  }

  function set($value, $is_error = false)
  {
    $this->_message[] = $value;
    if ($is_error) {
      $this->is_error = true;
    }
  }

  function setSyslog($value)
  {
    $this->_syslog[] = $value;
  }

  /**
   * Retourne le tableau brut
   */
  function get()
  {
    if ($this->displaySyslog) {
      return array_merge($this->_message, $this->_syslog);
    } else {
      return $this->_message;
    }
  }

  /**
   * Retourne le nombre de messages enregistres
   *
   * @return int
   */
  function getMessageNumber()
  {
    return (count($this->_message));
  }

  /**
   * Retourne le tableau formate avec saut de ligne entre
   * chaque message
   *
   * @return string
   */
  function getAsHtml()
  {
    $data = "";
    $i = 0;
    if ($this->displaySyslog) {
      $tableau = array_merge($this->_message, $this->_syslog);
    } else {
      $tableau = $this->_message;
    }
    return $this->gethtmlentities($tableau);
  }

  function gethtmlentities($tableau, $empty = true)
  {
    $data = "";
    foreach ($tableau as $value) {
      if (is_array($value)) {
        $data .= $this->gethtmlentities($value, $empty);
      } else {
        if (!$empty) {
          $data .= "<br>";
        }
        $empty = false;
        $data .= htmlentities($value);
      }
    }
    return $data;
  }

  /**
   * Envoie une trace des messages a Syslog
   *
   * @return mixed
   */
  function sendSyslog()
  {
    $dt = new DateTime();
    $date = $dt->format("D M d H:i:s.u Y");
    $pid = getmypid();
    if ($this->is_error) {
      $error = "err";
      $code_error = 4;
      $level = "warn";
    } else {
      $error = "info";
      $code_error = 6;
      $level = "info";
    }
    foreach ($this->_syslog as $value) {
      openlog("[$date] [" . $_SESSION["APPLI_code"] . ":$level] [pid $pid] $error", LOG_PERROR, LOG_LOCAL7);
      syslog($code_error, $value);
    }
  }
}

/**
 * Classe non instanciable de base pour l'ensemble des vues
 *
 * @author quinton
 *
 */
class Vue
{

  /**
   * Donnees a envoyer (cas hors html)
   *
   * @var string|array
   */
  protected $data;

  /**
   * Assigne une valeur
   *
   * @param $value
   * @param string $variable
   */
  function set($value, $variable = "")
  {
    if (!empty($variable)) {
      $this->data[$variable] = $value;
    } else {
      $this->data = $value;
    }
  }

  /**
   * Declenche l'affichage
   *
   * @param string $param
   */
  function send($param = "")
  {
  }

  /**
   * Return the content of a variable
   *
   * @param string $variable
   * @return string|array
   */
  function get($variable = "")
  {
    if (!empty($variable)) {
      return $this->data[$variable];
    } else {
      return $this->data;
    }
  }

  /**
   * Fonction recursive d'encodage html
   * des variables
   *
   * @param string|array $data
   * @return string
   */
  function encodehtml($data)
  {if (!is_object($data)) {
    if (is_array($data)) {
      foreach ($data as $key => $value) {

        $data[$key] = $this->encodehtml($value);
      }
    } else {
      $data = htmlspecialchars($data, ENT_QUOTES);
    }
  } else {
    $data = null;
  }
    return $data;
  }
}

/**
 * Classe encapsulant l'appel a Smarty
 *
 * @author quinton
 *
 */
class VueSmarty extends Vue
{

  /**
   * instance smarty
   *
   * @var Smarty
   */
  private $smarty;

  /**
   * Tableau des variables ne devant pas etre encodees
   * avant envoi au navigateur
   *
   * @var array
   */
  public $htmlVars = array(
    "menu",
    "LANG",
    "message",
    "texteNews",
    "doc",
    "phpinfo",
    "markdownContent"
  );

  private $templateMain = "main.htm";

  /**
   * Constructeur
   *
   * @param array $param
   *            : liste des parametres specifiques d'implementation
   * @param array $var
   *            : liste des variables assignees systematiquement
   */
  function __construct($param, $var)
  {
    /*
         * Parametrage de la classe smarty
         */
    $this->smarty = new Smarty();
    $this->smarty->template_dir = $param["templates"];
    $this->smarty->compile_dir = $param["templates_c"];
    $this->smarty->cache_dir = $param["cache_dir"];
    $this->smarty->caching = $param["cache"];
    if (isset($param["template_main"])) {
      $this->templateMain = $param["template_main"];
    }
    /*
         * Traitement des assignations de variables standard
         */
    foreach ($var as $key => $value) {
      $this->set($value, $key);
    }
  }

  /**
   *
   * {@inheritdoc}
   *
   * @see Vue::set()
   */
  function set($value, $variable = "")
  {
    $this->smarty->assign($variable, $value);
  }

  /**
   *
   * {@inheritdoc}
   *
   * @see Vue::send()
   */
  function send($param = "")
  {
    global $message;
    /*
         * Encodage des donnees avant envoi vers le navigateur
         */
    foreach ($this->smarty->getTemplateVars() as $key => $value) {
      if (!in_array($key, $this->htmlVars)) {
        $this->smarty->assign($key, $this->encodehtml($value));
      }
    }

    /*
         * Rrecuperation des messages
         */
    $this->smarty->assign("message", $message->getAsHtml());
    /*
         * Declenchement de l'affichage
         */
    try {
      $this->smarty->display($this->templateMain);
    } catch (Exception $e) {
      printr(_("Une erreur a été détectée lors de la création de l'écran. Si le problème persiste, contactez l'administrateur de l'application."));
      global $message;
      $message->setSyslog($e->getMessage());
    }
  }


  /**
   * Return the content of a variable
   *
   * @param string $variable
   * @return string|array
   */
  function get($variable = "")
  {
    return $this->smarty->getTemplateVars($variable);
  }
}

/**
 * Classe permettant l'envoi d'un fichier Json au navigateur,
 * en protocole Ajax
 *
 * @author quinton
 *
 */
class VueAjaxJson extends Vue
{

  private $json = "";

  private $is_json = false;

  /**
   * affecte une valeur directement au format json
   * (resultat d'une programmation manuelle, p.
   * e.)
   *
   * @param string $json
   */
  function setJson($json)
  {
    $this->json = $json;
    $this->is_json = true;
  }

  /**
   *
   * {@inheritdoc}
   *
   * @see Vue::send()
   */
  function send($param = "")
  {
    /*
         * Encodage des donnees
         */
    if ($this->is_json) {
      $json = $this->json;
    } else {
      $data = array();
      foreach ($this->data as $key => $value) {
        $data[$key] = $this->encodehtml($value);
      }
      $json = json_encode($data);
    }
    /*
         * Envoi au navigateur
         */
    ob_clean();
    echo $json;
    ob_flush();
  }
}

/**
 * Export de donnees au format csv
 *
 * @author quinton
 *
 */
class VueCsv extends Vue
{

  private $filename = "";

  private $delimiter = ";";

  private $header = array();

  /**
   * Reecriture pour traiter le cas où l'info est mono-enregistrement
   *
   * @param array $value
   * @param string $variable
   * @return void
   */
  function set($value, $variable = "")
  {
    if (is_array($value[0])) {
      $this->data = $value;
    } else {
      $this->data[] = $value;
    }
  }

  /**
   * Declenche la creation du fichier csv
   *
   * @param string $filename
   * @param string $delimiter
   * @return void
   */
  function send($filename = "", $delimiter = "")
  {
    if (!empty($this->data)) {
      if (empty($filename)) {
        $filename = $this->filename;
      }
      if (empty($filename)) {
        $filename = "export-" . date('Y-m-d-His') . ".csv";
      }
      if (empty($delimiter)) {
        $delimiter = $this->delimiter;
      }
      /*
             * Preparation du fichier
             */
      ob_clean();
      header('Content-Type: text/csv');
      header('Content-Disposition: attachment;filename=' . $filename);
      $fp = fopen('php://output', 'w');
      /*
             * Traitement de l'entete
             */
      fputcsv($fp, array_keys($this->data[0]), $delimiter);
      /**
       * Traitement des lignes
       */
      foreach ($this->data as $value) {
        fputcsv($fp, $value, $delimiter);
      }
      fclose($fp);
      ob_flush();
    }
  }

  /**
   * Fonction parcourant le tableau de donnees, pour extraire l'ensemble des colonnes
   * et recreer un tableau utilisable en export csv avec toutes les colonnes possibles
   */
  function regenerateHeader()
  {
    /*
         * Recherche toutes les entetes de colonnes
         */
    foreach ($this->data as $row) {
      foreach ($row as $key => $value) {
        if (!in_array($key, $this->header)) {
          $this->header[] = $key;
        }
      }
    }
    /*
         * Reformate le tableau pour integrer l'ensemble des colonnes disponibles
         */
    $data = $this->data;
    $this->data = array();
    foreach ($data as $row) {
      $newline = array();
      foreach ($this->header as $key) {
        $newline[$key] = $row[$key];
      }
      $this->data[] = $newline;
    }
  }

  /**
   * Affecte le nom du fichier d'export
   *
   * @param string $filename
   */
  function setFilename($filename)
  {
    $this->filename = $filename;
  }

  /**
   * Affecte le separateur de champ
   *
   * @param string $delimiter
   */
  function setDelimiter($delimiter)
  {
    if ($delimiter == "tab") {
      $delimiter = "\t";
    }
    $this->delimiter = $delimiter;
  }
}

/**
 * Envoi d'un fichier au format PDF vers le navigateur
 *
 * Le fichier doit être fourni soit sous forme de référence
 * soit en indiquant son chemin dans l'arborescence du serveur.
 */
class VuePdf extends Vue
{

  private $filename;

  private $reference;

  private $disposition = "attachment";

  /**
   * $disposition : attachment|inline
   *
   * {@inheritdoc}
   *
   * @see Vue::send()
   */
  function send($param = "")
  {
    if (!is_null($this->reference)) {
      header("Content-Type: application/pdf");
      if (!empty($this->filename)) {
        $filename = $this->filename;
      } else {
        $filename = $_SESSION["APPLI_code"] . '-' . date('y-m-d') . ".pdf";
      }
      header('Content-Disposition: ' . $this->disposition . '; filename="' . $filename . '"');
      echo $this->reference;
      if (!rewind($this->reference)) {
        throw new VueException('Impossible to rewind resource');
      }
      if (!fpassthru($this->reference)) {
        throw new VueException('Impossible to send file');
      }
    } elseif (file_exists($this->filename)) {
      /*
             * Recuperation du content-type
             */
      $finfo = finfo_open(FILEINFO_MIME_TYPE);
      header('Content-Type: ' . finfo_file($finfo, $this->filename));
      finfo_close($finfo);

      /*
             * Mise a disposition
             */
      header('Content-Disposition: ' . $this->disposition . '; filename="' . basename($this->filename) . '"');

      /*
             * Desactivation du cache
             */
      header('Expires: 0');
      header('Cache-Control: must-revalidate');
      header('Pragma: public');
      header('Content-Length: ' . filesize($this->filename));

      ob_clean();
      flush();
      if (!empty($this->filename)) {
        readfile($this->filename);
      } else {
        throw new VueException("File can't be sent");
      }
    } else {
      throw new VueException("Nothing to send");
    }
  }

  /**
   * Affecte le nom du fichier d'export
   *
   * @param string $filename
   */
  function setFilename($filename)
  {
    $this->filename = $filename;
  }

  function setFileReference($ref)
  {
    $this->reference = $ref;
  }

  /**
   * Affecte la disposition du fichier dans le navigateur
   *
   * @param string $disp
   */
  function setDisposition($disp = "attachment")
  {
    $this->disposition = $disp;
  }
}

/**
 * Classe permettant d'envoyer un fichier au navigateur, quel que soit son type
 *
 * @author quinton
 *
 */
class VueBinaire extends Vue
{

  private $param = array(
    "filename" => "", /* nom du fichier tel qu'il apparaitra dans le navigateur */
    "disposition" => "attachment", /* attachment : le fichier est telecharge, inline : le fichier est affiche */
    "tmp_name" => "", /* emplacement du fichier dans le serveur */
    "content_type" => "", /* type mime */
    "is_reference" => false, /* if true, tmp_name contains the handle of the opened file */
    "handle" => 0

  );

  /**
   *
   * Envoi du fichier au navigateur
   *
   * {@inheritdoc}
   *
   * @see Vue::send()
   */
  function send($param = "")
  {
    //printr($this->param);

    !empty($this->param["tmp_name"]) ? $isReference = false : $isReference = true;
    /*
             * Recuperation du content-type s'il n'a pas ete fourni
             */
    if (empty($this->param["content_type"])) {
      $finfo = new finfo(FILEINFO_MIME_TYPE);
      if (!$finfo) {
        throw new FrameworkException(_("Problème rencontré lors de l'ouverture de finfo"));
      }
      $this->param["content_type"] = $finfo->file($this->param["tmp_name"]);
    }
    header('Content-Type: ' . $this->param["content_type"]);
    header('Content-Transfer-Encoding: binary');
    if ($this->param["disposition"] == "attachment" && !empty($this->param["filename"])) {
      header('Content-Disposition: attachment; filename="' . basename($this->param["filename"]) . '"');
    } else {
      header('Content-Disposition: inline');
    }
    if (!$isReference) {
      header('Content-Length: ' . filesize($this->param["tmp_name"]));
    }
    /**
     * Ajout des entetes de cache
     */
    header('Expires: 0');
    header('Cache-Control: must-revalidate');
    header('Pragma: no-cache');
    /*
             * Envoi au navigateur
             */
    ob_clean();
    flush();
    if (!$isReference) {
      readfile($this->param["tmp_name"]);
    } else {
      fpassthru($this->param["handle"]);
    }
  }

  /**
   * Met a jour les parametres necessaires pour l'export
   *
   * @param array $param
   */
  function setParam(?array $param)
  {
    if (is_array($param)) {
      foreach ($param as $key => $value) {
        $this->param[$key] = $value;
      }
    }
  }
}
/**
 * Generate a file with an undetermined contain
 */
class VueFile extends Vue
{
  private $param = array(
    "filename" => "export.txt", /* nom du fichier tel qu'il apparaitra dans le navigateur */
    "disposition" => "attachment", /* attachment : le fichier est telecharge, inline : le fichier est affiche */
    "content_type" => "",/* type mime */
    "tmp_name" => "", /* Name of the file to send */
  );

  /**
   * Met a jour les parametres necessaires pour l'export
   *
   * @param array $param
   */
  function setParam(?array $param)
  {
    if (is_array($param)) {
      foreach ($param as $key => $value) {
        $this->param[$key] = $value;
      }
    }
  }
  /**
   * rewrite send for generate the file
   *
   * @param array $param: list of parameters of file
   * @return void
   */
  function send($param = array())
  {
    if (count($param) > 0) {
      $this->setParam($param);
    }
    if (empty($this->param["content_type"])) {
      $finfo = new finfo(FILEINFO_MIME_TYPE);
      $this->param["content_type"] = $finfo->file($this->param["tmp_name"]);
    }
    if (empty($this->data)) {
      $this->data = file_get_contents($this->param["tmp_name"]);
    }
    ob_clean();
    header('Content-Type: ' . $this->param["content_type"]);
    header('Content-Transfer-Encoding: binary');
    if ($this->param["disposition"] == "attachment" && !empty($this->param["filename"])) {
      header('Content-Disposition: attachment; filename="' . basename($this->param["filename"]) . '"');
    } else {
      header('Content-Disposition: inline');
    }
    /*
         * Ajout des entetes de cache
         */
    header('Expires: 0');
    header('Cache-Control: must-revalidate');
    header('Pragma: no-cache');
    /*
         * Envoi au navigateur
         */
    $fp = fopen('php://output', 'w');
    fwrite($fp, $this->data);
    fclose($fp);
    ob_flush();
  }
}
