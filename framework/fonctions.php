<?php

class FileException extends Exception {}
/**
 * Ensemble de fonctions utilisees pour la gestion des fiches
 */

/**
 * Lit un enregistrement dans la base de donnees, affecte le tableau a Smarty,
 * et declenche l'affichage de la page associee
 *
 * @param ObjetBDD $dataClass
 * @param int $id
 * @param string $smartyPage
 * @param int $idParent
 *
 * @return array
 */
/**
 * Lit un enregistrement dans la base de donnees, affecte le tableau a Smarty,
 * et declenche l'affichage de la page associee
 *
 * @param ObjetBDD $dataClass  : instance de la classe
 * @param mixed    $id         : identifiant
 * @param string   $smartyPage : nom du template Smarty a utiliser
 * @param int      $idParent   : identifiant du parent
 *
 * @return mixed
 */
function dataRead($dataClass, $id, $smartyPage, $idParent = null)
{
  global $vue, $OBJETBDD_debugmode, $message;
  if (isset($vue)) {
    if (is_numeric($id)) {

      try {
        $data = $dataClass->lire($id, true, $idParent);
      } catch (FrameworkException | ObjetBDDException | PDOException $e) {
        if ($OBJETBDD_debugmode > 0) {
          foreach ($dataClass->getErrorData(1) as $messageError) {
            $message->set($messageError, true);
          }
        } else {
          $message->set(_("Erreur de lecture des informations dans la base de données"), true);
        }
        $message->setSyslog($e->getMessage());
      }
    }
    /*
         * Affectation des donnees a smarty
         */
    $vue->set($data, "data");
    $vue->set($smartyPage, "corps");
    return $data;
  } else {
    global $module;
    // traduction: conserver inchangée la chaîne %s
    $message->set(sprintf(_('Erreur: type d\'affichage non défini pour le module demandé : %s'), $module), true);
  }
}

/**
 * Ecrit un enregistrement en base de donnees
 *
 * @param ObjetBDD $dataClass           : instance de la classe
 * @param array    $data                : donnees a enregistrer
 * @param boolean  $isPartOfTransaction : si true, requete faisant partie d'une transaction
 *
 * @return int
 */
function dataWrite($dataClass, $data, $isPartOfTransaction = false)
{
  global $message, $module_coderetour, $log, $OBJETBDD_debugmode;
  try {
    $id = $dataClass->ecrire($data);
    if ($id > 0) {
      if (!$isPartOfTransaction) {
        $message->set(_("Enregistrement effectué"));
        $module_coderetour = 1;
        $log->setLog($_SESSION["login"], get_class($dataClass) . "-write", $id);
      }
    } else {
      $message->set(_("Un problème est survenu lors de l'enregistrement. Si le problème persiste, contactez votre support"), true);
      $message->setSyslog(_("La clé n'a pas été retournée lors de l'enregistrement dans ") . get_class($dataClass));
      $module_coderetour = -1;
    }
  } catch (PDOException | ObjetBDDException $e) {
    if (strpos($e->getMessage(), "nique violation") !== false) {
      $message->set(_("Un enregistrement portant déjà ce nom existe déjà dans la base de données."), true);
    } else {
      $message->set($e->getMessage(), true);
    }
    if ($OBJETBDD_debugmode > 0) {
      foreach ($dataClass->getErrorData(1) as $messageError) {
        $message->set($messageError, true);
      }
    } else {
      $message->set(_("Problème lors de l'enregistrement..."), true);
    }
    $message->setSyslog($e->getMessage());
    $module_coderetour = -1;
  }
  return ($id);
}

/**
 * Supprime un enregistrement en base de donnees
 *
 * @param ObjetBDD $dataClass : instance de la classe
 * @param int      $id        : identifiant
 *
 * @return int
 */
function dataDelete($dataClass, $id, $isPartOfTransaction = false)
{
  global $message, $module_coderetour, $log, $OBJETBDD_debugmode;
  $module_coderetour = -1;
  $ok = true;
  if (is_array($id)) {
    foreach ($id as $value) {
      if (!(is_numeric($value) && $value > 0)) {
        $ok = false;
      }
    }
  } else {
    if (!(is_numeric($id) && $id > 0)) {
      $ok = false;
    }
  }
  if ($ok) {
    try {
      $ret = $dataClass->supprimer($id);
      if (!$isPartOfTransaction) {
        $message->set(_("Suppression effectuée"));
        $module_coderetour = 1;
      }
      $log->setLog($_SESSION["login"], get_class($dataClass) . "-delete", $id);
    }
    catch (ObjetBDDException $eo) {
      $message->set($eo->getMessage(), true);
    }
    catch (PDOException $e) {
      foreach ($dataClass->getErrorData(1) as $messageError) {
        $message->setSyslog($messageError);
      }
      /**
       * recherche des erreurs liees a une violation de cle etrangere
       */
      if (strpos($e->getMessage(), "[23503]") !== false) {
        $message->set(_("La suppression n'est pas possible : des informations sont référencées par cet enregistrement"), true);
      }
      if ($message->getMessageNumber() == 0) {
        $message->set(_("Problème lors de la suppression"), true);
      }
      $message->setSyslog($e->getMessage());
      if ($isPartOfTransaction) {
        throw new FrameworkException(sprintf("Suppression impossible de l'enregistrement %s"), $id);
      }
      $ret = -1;
    }
  } else {
    $message->set(_("Suppression impossible : la clé n'est pas numérique ou n'a pas été fournie"));
    $ret = -1;
  }
  return ($ret);
}

/**
 * Modifie la langue utilisee dans l'application
 *
 * @param string $langue : code du langage
 */
function setlanguage($langue)
{
  global $language, $LANG, $APPLI_cookie_ttl, $APPLI_menufile, $menu, $ObjetBDDParam;

  /*
     * Initialisation des parametres pour gettext
     */
  initGettext($langue);

  /*
     * Chargement de la langue par defaut
     */
  include 'locales/' . $language . ".php";
  /*
     * On gere le cas ou la langue selectionnee n'est pas la langue par defaut
     */
  if ($language != $langue) {
    $LANGORI = $LANG;
    /*
         * Test de l'existence du fichier locales selectionne
         */
    if (file_exists('locales/' . $langue . '.php')) {
      include 'locales/' . $langue . '.php';
      $LANGDIFF = $LANG;
      /*
             * Fusion des deux tableaux
             */
      $LANG = array();
      $LANG = array_replace_recursive($LANGORI, $LANGDIFF);
    }
  }
  $ObjetBDDParam["formatDate"] = $_SESSION["FORMATDATE"];
  $_SESSION["ObjetBDDParam"] = $ObjetBDDParam;
  /*
     * Mise en session de la langue
     */
  $_SESSION['LANG'] = $LANG;
  /*
     * Regeneration du menu
     */
  include_once 'framework/navigation/menu.class.php';
  $menu = new Menu($APPLI_menufile);
  $_SESSION["menu"] = $menu->generateMenu();
  /*
     * Appel des fonctions specifiques de l'application
     */
  include "modules/afterChangeLanguage.php";
  /*
     * Ecriture du cookie
     */
  $cookieParam = session_get_cookie_params();
  $cookieParam["lifetime"] = $APPLI_cookie_ttl;
  if (!$APPLI_modeDeveloppement) {
    $cookieParam["secure"] = true;
  }
  $cookieParam["httponly"] = true;

  setcookie('langue', $langue, time() + $APPLI_cookie_ttl, $cookieParam["path"], $cookieParam["domain"], $cookieParam["secure"], $cookieParam["httponly"]);
}

/**
 * Initialisation de la langue pour gettext
 *
 * @param mixed $langue : code du langage
 *
 * @return mixed
 */
function initGettext($langue)
{
  /*
     * Pour smarty-gettext (gettext)
     */

  /*
     * Attention :
     * gettext fonctionne avec setlocale. Le problème est que setlocale dépend des locales installées sur le serveur.
     * Par exemple, si en_GB n'est pas installé alors setlocale(LC_ALL, "en_GB") ne va rien faire.
     * L'astuce utilisée ici est de ne pas compter sur setlocale (forcé à C, la localisation portable par défaut)
     * mais de détourner l'usage du domaine pour préciser la langue !
     * Va donc chercher par exemple dans locales/C/LC_MESSAGES/en.mo et non locales/en/LC_MESSAGES/mydomain.mo
     * Permet non seulement d'éviter des problèmes liés à l'environnement
     * mais en plus rend l'arborescence plus simple en mettant toutes les langues dans le même répertoire
     * sans avoir à gérer le domaine, souvent superflu et source possible d'erreur.
     * (il sera toujours possible de rétablir le domaine si besoin, avec un domaine de la forme $domaine_$langue
     */
  /*
     * Attention au cache :
     * le cache de gettext est coriace et peut amener à l'apparition d'ancienne traduction
     * lors d'une modification d'un fichier de traduction .mo il est recommander de relancer le serveur :
     * sudo service apache2 reload
     */
  // var_dump($langue); // aide à la traduction lors du développement
  setlocale(LC_ALL, "C.UTF-8", "C"); // setlocale pour linux // C = localisation portable par défaut
  // Attention : La valeur retournée par setlocale() dépend du système sur lequel PHP est installé. setlocale() retourne exactement ce que la fonction système setlocale retourne.
  // $path = realpath("./locales") . "/C/LC_MESSAGES/$langue.mo";
  // var_dump( $path, file_exists( $path ) );
  putenv("LANG=C.UTF-8"); // putenv pour windows // non testé
  if (empty($langue)) {
    $langue = "en";
  }
  bindtextdomain($langue, realpath("./locales"));
  bind_textdomain_codeset($langue, "UTF-8");
  textdomain($langue);
}

/**
 * Fonction testant si la donnee fournie est de type UTF-8 ou non
 *
 * @param array|string $data : tableau a tester
 *
 * @return boolean
 */
function check_encoding($data)
{
  $result = true;
  if (is_array($data)) {
    foreach ($data as $value) {
      if (!check_encoding($value)) {
        $result = false;
      }
    }
  } else {
    if (!empty($data) && !mb_check_encoding($data, "UTF-8")) {
      $result = false;
    }
  }
  return $result;
}

/**
 * Retourne l'adresse IP du client, en tenant compte le cas echeant du reverse-proxy
 *
 * @return string
 */
function getIPClientAddress()
{
  /*
     * Recherche si le serveur est accessible derriere un reverse-proxy
     */
  if (isset($_SERVER["HTTP_X_FORWARDED_FOR"])) {
    return $_SERVER["HTTP_X_FORWARDED_FOR"];
  } else if (isset($_SERVER["REMOTE_ADDR"])) {
    /*
         * Cas classique
         */
    return $_SERVER["REMOTE_ADDR"];
  } else {
    return -1;
  }
}

/**
 * Fonction recursive decodant le html en retour de navigateur
 *
 * @param array|string $data : tableau de valeurs
 *
 * @return array|string
 */
function htmlDecode($data)
{
  if (is_array($data)) {
    foreach ($data as $key => $value) {
      $data[$key] = htmlDecode($value);
    }
  } else {
    $data = htmlspecialchars_decode($data, ENT_QUOTES);
  }
  return $data;
}

/**
 * Retourne la liste des entetes transmises
 *
 * @return mixed
 */
function getHeaders($radical = "")
{
  $header = array();
  $radicalLength = strlen($radical);
  foreach ($_SERVER as $key => $value) {
    if (substr($key, 0, $radicalLength) == $radical) {
      $header[$key] = $value;
    }
  }
  return $header;

  /*
     * Fonction equivalente pour NGINX
     */
  /*
     * function apache_request_headers($radical = "") {
     * foreach($_SERVER as $key=>$value) {
     * if (substr($key,0,5)=="HTTP_") {
     * $key=str_replace(" ","-",ucwords(strtolower(str_replace("_"," ",substr($key,5)))));
     * $out[$key]=$value;
     * }else{
     * $out[$key]=$value;
     * }
     * }
     * return $out;
     * }
     * }
     * printr($_SERVER);
     * return apache_request_headers();
     */
}

/**
 * Check if the script is executed from a web server or a client
 *
 * @return boolean
 */
function is_cli()
{
  if (defined('STDIN')) {
    return true;
  }
  if (empty($_SERVER['REMOTE_ADDR']) && !isset($_SERVER['HTTP_USER_AGENT']) && count($_SERVER['argv']) > 0) {
    return true;
  }
  return false;
}
/**
 * Get the linefeed adapted to the execution mode
 *
 * @return string
 */
function getLineFeed()
{
  if (is_cli()) {
    return PHP_EOL;
  } else {
    return "<br>";
  }
}
/**
 * Generate a line return with <br> or PHP_EOL
 *
 * @return void
 */
function phpeol()
{
  return getLineFeed();
  /*
  if (PHP_SAPI == "cli") {
    return PHP_EOL;
  } else {
    return "<br>";
  }
  */
}
class ApiCurlException extends Exception
{
};
/**
 * call a api with curl
 * code from
 * @param string $method
 * @param string $url
 * @param array $data
 * @return void
 */
function apiCall($method, $url, $certificate_path = "", $data = array(), $modeDebug = false)
{
  $curl = curl_init();
  if (!$curl) {
    throw new ApiCurlException(_("Impossible d'initialiser le composant curl"));
  }
  switch ($method) {
    case "POST":
      curl_setopt($curl, CURLOPT_POST, true);
      if (!empty($data)) {
        curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
      }
      break;
    case "PUT":
      curl_setopt($curl, CURLOPT_CUSTOMREQUEST, "PUT");
      if (!empty($data)) {
        curl_setopt($curl, CURLOPT_POSTFIELDS, $data);
      }
      break;
    default:
      if (!empty($data)) {
        $url = sprintf("%s?%s", $url, http_build_query($data));
      }
  }
  /**
   * Set options
   */
  curl_setopt($curl, CURLOPT_URL, $url);
  curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
  //curl_setopt($curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
  if (!empty($certificate_path)) {
    curl_setopt($curl, CURLOPT_SSLCERT, $certificate_path);
  }
  if ($modeDebug) {
    curl_setopt($curl, CURLOPT_SSL_VERIFYSTATUS, false);
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 0);
    curl_setopt($curl, CURLOPT_VERBOSE, true);
  }
  /**
   * Execute request
   */
  $res = curl_exec($curl);
  if (!$res) {
    throw new ApiCurlException(sprintf(_("Une erreur est survenue lors de l'exécution de la requête vers le serveur distant. Code d'erreur CURL : %s"), curl_error($curl)));
  }
  curl_close($curl);
  return $res;
}

/**
 * Fonction permettant de reorganiser les donnees des fichiers telecharges,
 * pour une utilisation directe en tableau
 * @return multitype:multitype:NULL  unknown
 */
function formatFiles($attributName = "documentName")
{
    global $_FILES;
    $files = array();
    $fdata = $_FILES[$attributName];
    if (is_array($fdata['name'])) {
        for ($i = 0; $i < count($fdata['name']); ++$i) {
            $files[] = array(
                'name'    => $fdata['name'][$i],
                'type'  => $fdata['type'][$i],
                'tmp_name' => $fdata['tmp_name'][$i],
                'error' => $fdata['error'][$i],
                'size'  => $fdata['size'][$i]
            );
        }
    } else $files[] = $fdata;
    return $files;
}
