<?php 
namespace App\Models;

use Ppci\Libraries\PpciException;
use Ppci\Models\PpciModel;




/**
 * Orm de gestion de la table document :
 * Stockage des pièces jointes
 *
 * @author quinton
 *
 */
class Document extends PpciModel
{

  public $temp = "temp";
  public Mimetype $mimeType;
  public Event $event;

  // Chemin de stockage des images générées à la volée
  /**
   * Constructeur de la classe
   *
   * @param PDO $bdd
   * @param array $param
   */
  function __construct()
  {
    global $APPLI_temp;
    if (!empty($APPLI_temp)) {
      $this->temp = $APPLI_temp;
    }
    $this->table = "document";
    $this->fields = array(
      "document_id" => array(
        "type" => 1,
        "key" => 1,
        "requis" => 1,
        "defaultValue" => 0
      ),
      "uid" => array(
        "type" => 1,
        "parentAttrib" => 1
      ),
      "campaign_id" => array("type" => 1),
      "mime_type_id" => array(
        "type" => 1,
        "requis" => 1
      ),
      "document_import_date" => array(
        "type" => 2,
        "requis" => 1,
        "defaultValue" => "getDateJour"
      ),
      "document_name" => array(
        "type" => 0,
        "requis" => 1
      ),
      "document_description" => array(
        "type" => 0
      ),
      "data" => array(
        "type" => 0
      ),
      "thumbnail" => array(
        "type" => 0
      ),
      "size" => array(
        "type" => 1,
        "defaultValue" => 0
      ),
      "document_creation_date" => array(
        "type" => 2,
        "defaultValue" => "getDateJour"
      ),
      "uuid" => array("type" => 0, "default" => "getUUID"),
      "external_storage" => array("type" => 1),
      "external_storage_path" => array("type" => 0),
      "event_id" => array("type" => 1)
    );
    parent::__construct();
  }
  /**
   * Get the list of documents associated with an other table
   *
   * @param string $fieldName: name of the parent field
   * @param int $id: key of the parent
   * @return ?array
   */
  function getListFromField($fieldName, $id /*, $isExternal = false*/): ?array
  {
    $fields = array("uid", "campaign_id", "uuid", "event_id");
    if (in_array($fieldName, $fields)) {
      if ($fieldName == "uid") {
        $fieldName = "d.uid";
      }
      //$isExternal ? $external = "true" : $external = "false";
      $sql = "select document_id, d.uid, campaign_id, mime_type_id,
          document_import_date, document_name, document_description, size, document_creation_date, d.uuid
          ,external_storage, external_storage_path, event_id, event_date, event_type_name, due_date
          from document d
          left outer join event using (event_id)
          left outer join event_type using (event_type_id)
          where $fieldName = :id:";
      //and external_storage = $external";
      $this->fields["event_date"] = array("type"=>2);
      $this->fields["due_date"] = array("type"=>2);
      return $this->getListeParamAsPrepared($sql, array("id" => $id));
    }
  }
  /**
   * Get the max Upload size of a document, in Mb
   *
   * @return integer
   */
  function getMaxUploadSize(): int
  {
    $max_upload = (int) (ini_get('upload_max_filesize'));
    $max_post = (int) (ini_get('post_max_size'));
    $memory_limit = (int) (ini_get('memory_limit'));
    return (min($max_upload, $max_post, $memory_limit));
  }

  /**
   * Ecriture d'un document
   *
   * @param array $file
   *            : tableau contenant les informations sur le fichier importé
   * @param
   *            string description : description du contenu du document
   * @return int
   */
  function documentWrite($file, $parentKeyName, $parentKeyValue, $description = NULL, $document_creation_date = NULL)
  {
    if ($file["error"] == 0 && $file["size"] > 0 && is_numeric($parentKeyValue) && $parentKeyValue > 0) {
      global $log, $message;
      /**
       * Recuperation de l'extension
       */
      $extension = $this->encodeData(substr($file["name"], strrpos($file["name"], ".") + 1));
      $mimeType = new MimeType;
      $mime_type_id = $mimeType->getTypeMime($extension);
      if ($mime_type_id > 0) {
        $data = array();
        $data["document_name"] = $file["name"];
        $data["size"] = $file["size"];
        $data["mime_type_id"] = $mime_type_id;
        $data["document_description"] = $description;
        $data["document_import_date"] = date($_SESSION["date"]["maskdate"]);
        $data[$parentKeyName] = $parentKeyValue;
        if (!is_null($document_creation_date)) {
          $data["document_creation_date"] = $document_creation_date;
        }
        $dataDoc = array();
        /**
         * Get the uid if event_id
         */
        if ($parentKeyName == "event_id") {
          if (!isset($this->event)) {
            $this->event = $this->classInstanciate("Event", "event.class.php");
          }
          $devent=$this->event->lire($parentKeyValue);
          if ($devent["uid"] > 0) {
            $data["uid"] = $devent["uid"];
          }
        }
        /**
         * Recherche pour savoir s'il s'agit d'une image ou d'un pdf pour créer une vignette
         */
        $extension = strtolower($extension);
        /**
         * Ecriture du document
         */

        $dataBinaire = fread(fopen($file["tmp_name"], "r"), $file["size"]);

        $dataDoc["data"] = pg_escape_bytea($dataBinaire);
        if ($extension == "pdf" || $extension == "png" || $extension == "jpg") {
          $image = new Imagick();
          $image->readImageBlob($dataBinaire);
          $image->setiteratorindex(0);
          $image->resizeimage(200, 200, imagick::FILTER_LANCZOS, 1, true);
          $image->setformat("png");
          $dataDoc["thumbnail"] = pg_escape_bytea($image->getimageblob());
        }
        /**
         *  suppression du stockage temporaire
         */
        unset($file["tmp_name"]);
        /**
         * Ecriture dans la base de données
         */
        $id = parent::write($data);
        if ($id > 0) {
          $sql = "update " . $this->table . " set data = '" . $dataDoc["data"] . "', thumbnail = '" . $dataDoc["thumbnail"] . "' where document_id = " . $id;
          $this->executeSQL($sql);
        }
        return $id;
      }
    }
  }

  /**
   * Recupere les informations d'un document
   *
   * @param int $id
   * @return array
   */
  function getData(int $id)
  {
    if ($id > 0) {
      $sql = "select document_id, document_name, content_type, mime_type_id, extension,
					document_import_date, document_creation_date, uuid
          ,external_storage, external_storage_path
				from document
				join mime_type using (mime_type_id)
				where document_id = :document_id";

      return $this->lireParamAsPrepared(
        $sql,
        array(
          "document_id" => $id
        )
      );
    }
  }

  /**
   * Envoie un fichier au navigateur, pour affichage
   *
   * @param int $id
   *            : cle de la photo
   * @param int $phototype
   *            : 0 - photo originale, 1 - resolution fournie, 2 - vignette
   * @param boolean $attached
   * @param int $resolution
   *            : resolution pour les photos redimensionnees
   */
  function prepareDocument($id, $phototype = 0, $resolution = 800)
  {
    $id = $this->encodeData($id);
    $filename = $this->generateFileName($id, $phototype, $resolution);
    if (!empty($filename) && is_numeric($id) && $id > 0) {
      if (!file_exists($filename)) {
        $this->writeFileImage($id, $phototype, $resolution);
      }
    }
    if (file_exists($filename)) {
      return $filename;
    }
  }

  /**
   * Calcule le nom de la photo
   *
   * @param int $id
   * @param int $phototype
   *            : type de la photo - 0 : original, 1 : photo reduite, 2 : vignette
   * @param number $resolution
   * @return string
   */
  function generateFileName($id, $phototype = 0, $resolution = 800)
  {
    /**
     * Preparation du nom de la photo
     */
    switch ($phototype) {
      case 0:
        if (is_numeric($id)) {
          $data = $this->getData($id);
        }
        $filename = $this->temp . '/' . $id . "-" . $data["document_name"];
        break;
      case 1:
        $filename = $this->temp . '/' . $id . "x" . $resolution . ".png";
        break;
      case 2:
        $filename = $this->temp . '/' . $id . '_vignette.png';
        break;
      default:
        throw new PpciException("Picture type not correctly defined");
    }
    return $filename;
  }

  /**
   * Ecrit une photo dans un dossier temporaire, pour lien depuis navigateur
   *
   * @param int $id
   * @param $phototype :
   *            0 - photo originale, 1 - photo a la resolution fournie, 2 - vignette
   * @param binary $document
   * @return string
   */
  function writeFileImage($id, $phototype = 0, $resolution = 800)
  {
    if ($id > 0 && is_numeric($id) && is_numeric($phototype) && is_numeric($resolution)) {
      $data = $this->getData($id);
      $okgenerate = false;
      $redim = false;
      /**
       * Recherche si la photo doit etre generee (en fonction du phototype ou du mimetype)
       */
      switch ($phototype) {
        case 0:
          $okgenerate = true;
          break;
        case 2:
          if (
            in_array(
              $data["mime_type_id"],
              array(
                1,
                4,
                5,
                6
              )
            )
          ) {
            $okgenerate = true;
          }
          $redim = true;
          break;
        case 1:
          if (
            in_array(
              $data["mime_type_id"],
              array(
                4,
                5,
                6
              )
            )
          ) {
            $okgenerate = true;
          }
          $redim = true;
          break;
      }
      if ($okgenerate) {
        $writeOk = false;
        /**
         * Selection de la colonne contenant la photo
         */
        $phototype == 2 ? $colonne = "thumbnail" : $colonne = "data";
        $filename = $this->generateFileName($id, $phototype, $resolution);
        if (!empty($filename) && !file_exists($filename)) {
          /*
           * Recuperation des donnees concernant la photo
           */
          $docRef = $this->getBlobReference($id, $colonne);
          if (
            in_array(
              $data["mime_type_id"],
              array(
                4,
                5,
                6
              )
            ) && $docRef != NULL
          ) {
            try {
              $image = new Imagick();
              $image->readImageFile($docRef);
              if ($redim) {
                /**
                 *  Redimensionnement de l'image
                 */
                $resize = 0;
                $geo = $image->getimagegeometry();
                if ($geo["width"] > $resolution || $geo["height"] > $resolution) {
                  $resize = 1;
                  /**
                   * Calcul de la résolution dans les deux sens
                   */
                  if ($geo["width"] > $resolution) {
                    $resx = $resolution;
                    $resy = $geo["height"] * ($resolution / $geo["width"]);
                  } else {
                    $resy = $resolution;
                    $resx = $geo["width"] * ($resolution / $geo["height"]);
                  }
                }
                if ($resize == 1) {
                  $image->resizeImage($resx, $resy, imagick::FILTER_LANCZOS, 1);
                }
              }
              $document = $image->getimageblob();
              $writeOk = true;
            } catch (\Exception $e) {
              /**
               * Desactivation de la gestion de l'exception
               */
            }
          } else {
            /**
             * Autres types de documents : ecriture directe du contenu
             */
            if (($data["mime_type_id"] == 1 && $phototype == 2) || $phototype == 0) {
              $writeOk = true;
              $document = stream_get_contents($docRef);
              if (!$document) {
                throw new PpciException("Erreur de lecture" . $docRef);
              }
            }
          }
          /**
           * Ecriture du document dans le dossier temporaire
           */
          if ($writeOk) {
            $handle = fopen($filename, 'wb');
            fwrite($handle, $document);
            fclose($handle);
          }
        }
      }
    }
    return $filename;
  }

  /**
   * Get the collection of a document
   *
   * @param string $uuid
   * @return void|int
   */
  function getCollection($uuid)
  {
    $sql = "select collection_id from document
            join sample using (uid)
            where uuid = :uuid";
    $data = $this->lireParamAsPrepared($sql, array("uuid" => $uuid));
    return ($data["collection_id"]);
  }

  /**
   * Get the reference of the binary document, to send it
   *
   * @param integer $id
   * @return int|void
   */
  function getDocument(string $id)
  {
    return $this->getBlobReference($id, "data");
  }

  /**
   * Get the list of documents attached to an object
   *
   * @param string $uids
   * @param boolean $onlyLast
   * @return array|null
   */
  function getDocumentsFromUid(string $uids, bool $onlyLast = false): ?array
  {
    $sql = "SELECT d.document_id, d.uid, d.uuid as document_uuid, d.uuid,
            document_name, identifier, content_type, extension, size, document_creation_date
            ,o.uuid as sample_uuid
            ,external_storage_path, external_storage
            FROM col.document d
            join object o using (uid)
            join mime_type using (mime_type_id)
            WHERE d.uid in ($uids)";
    if ($onlyLast) {
      $sql .= " AND (d.document_id = (
        SELECT d1.document_id
        FROM col.document d1
        WHERE (d.uid = d1.uid) ORDER BY d1.document_creation_date DESC, d1.document_import_date DESC, d1.document_id DESC
         LIMIT 1)
    )";
    }
    $sql .= " ORDER BY d.uid";
    return $this->getListeParam($sql);
  }
  /**
   * Get some informations from a document
   *
   * @param string $key
   * @return array|null
   */
  function getDetail(string $key, $field = "document_id"): ?array
  {
    if (in_array($field, array("uuid", "uid", "campaign_id", "document_id"))) {
      $sql = "SELECT document_id, d.uuid, content_type, size, collection_id, document_name
            ,external_storage, external_storage_path
            from document d
            left outer join mime_type using (mime_type_id)
            left outer join sample using (uid)
            where d.$field = :key:";
      return $this->lireParamAsPrepared($sql, array("key" => $key));
    } else {
      return array();
    }
  }


  /**
   * Write the record for a file stored out of the database
   *
   * @param integer $collection_id
   * @param array $data
   * @return integer|null
   */
  function writeExternal(int $collection_id, array $data): ?int
  {
    /**
     * Verify the collection
     */
    $retour = null;
    $collection = $_SESSION["collections"][$collection_id];
    if ($collection["external_storage_enabled"]) {
      global $APPLI_external_document_path;
      $path = $APPLI_external_document_path . "/" . $collection["external_storage_root"] . "/" . $data["external_storage_path"];
      /**
       * Search for the file to associate
       */
      if (file_exists($path)) {
        if (!$data["size"] = filesize($path)) {
          throw new PpciException(_("Le fichier ne peut pas être lu"));
        }
      }
      if (empty($data["document_import_date"])) {
        $data["document_import_date"] = date($_SESSION["MASKDATELONG"]);
      }
      /**
       * get the mimetype
       */
      if (!isset($this->mimeType)) {
        $this->mimeType = new MimeType($this->connection);
      }
      $pathinfo = pathinfo($path);
      $data["mime_type_id"] = $this->mimeType->getTypeMime($pathinfo["extension"]);
      if (empty($data["document_name"])) {
        $data["document_name"] = $pathinfo["filename"];
      }
      $data["external_storage"] = 1;
      /**
       * Verify if the file is not recorded
       */
      $sql = "select document_id from document where uid = :uid and external_storage_path = :esp";
      $verif = $this->lireParamAsPrepared($sql, array("uid" => $data["uid"], "esp" => $data["external_storage_path"]));
      if ($verif["document_id"] > 0) {
        $data["document_id"] = $verif["document_id"];
      }
      $retour = parent::write($data);
    } else {
      throw new PpciException(_("La collection n'est pas paramétrée pour accepter des fichiers externes"));
    }
    return $retour;
  }
}
