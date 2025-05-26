<?php

namespace App\Libraries;

use App\Models\Collection;
use App\Models\Document;
use App\Models\ObjectClass;
use Ppci\Libraries\Locale;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;

class DocumentWs extends PpciLibrary
{
    public $document;
    public $objectClass;
    private $errors = array(
        500 => "Internal Server Error",
        400 => "Bad request",
        401 => "Unauthorized",
        403 => "Forbidden",
        520 => "Unknown error",
        404 => "Not Found"
    );
    function __construct()
    {
        parent::__construct();
        $this->document = new Document;
        if (isset($_REQUEST["locale"])) {
            $localeLib = new Locale();
            $localeLib->setLocale($_REQUEST["locale"]);
        }
        $this->objectClass = new ObjectClass;
    }

    /**
     * Get the parent object
     *
     * @return array
     */
    function getObject()
    {
        if (empty($_REQUEST["uid"] || empty($_REQUEST["uuid"]) || empty($_REQUEST["identifier"]))) {
            throw new PpciException(_("Aucun objet n'a été indiqué"), 400);
        }
        /**
         * Search the type and the collection
         */
        if (!empty($_REQUEST["uid"])) {
            $field = "uid";
        } elseif (!empty($_REQUEST["uuid"])) {
            $field = "uuid";
        } else {
            $field = "identifier";
        }
        $dobject = $this->objectClass->readWithType($_REQUEST[$field], $field);
        if (empty($dobject)) {
            throw new PpciException(_("Aucun objet ne correspond à l'identifiant fourni"), 404);
        }
        return $dobject;
    }
    /**
     * Get the list of documents attached to an object
     *
     * @return array
     */
    function getListFromObject()
    {
        try {
            $data = [];
            $dcollection = [];
            $dobject = $this->getObject();
            if (!empty($dobject["collection_id"])) {
                $collection = new Collection;
                $dcollection = $collection->read($dobject["collection_id"]);
                /**
                 * Verify if the collection is allowed for the user
                 */
                if (!collectionVerify($dobject["collection_id"]) && $dcollection["public_collection"] != "t") {
                    throw new PpciException(_("Vous ne disposez pas des droits nécessaires sur la collection"), 401);
                }
                /**
                 * Verify if the collection is allowed to obtain documents
                 */
                if ($dcollection["allowed_export_flow"] != "t") {
                    throw new PpciException(_("L'accès à la collection par API n'est pas autorisé"), 403);
                }
            }
            /**
             * Verify if the user as rights to perform action
             */
            if ($_SESSION["userRights"]["consult"] == 1 || $dcollection["public_collection"] == 't') {
                $data = $this->document->getListFromUid($dobject["uid"]);
            } else {
                throw new PpciException(_("Droits insuffisants"), 401);
            }
        } catch (PpciException $e) {
            $error_code = $e->getCode();
            if ($error_code == 0) {
                $error_code = 520;
            }
            $data = array(
                "error_code" => $error_code,
                "error_message" => $this->errors[$error_code] . " - " . $e->getMessage()
            );
            $this->message->setSyslog($e->getMessage(), true);
        } finally {
            return $data;
        }
    }
    /**
     * Attach a document to an object
     *
     * @return array
     */
    function documentSet()
    {
        try {
            $data = [];
            $dcollection = [];
            $dobject = $this->getObject();
            if (empty($dobject["collection_id"])) {
                throw new PpciException(_("L'objet n'est pas rattaché à une collection, l'ajout de document n'est pas possible par API"), 403);
            }
            $collection = new Collection;
            $dcollection = $collection->read($dobject["collection_id"]);
            /**
             * Verify if the collection is allowed for the user
             */
            if (!collectionVerify($dobject["collection_id"])) {
                throw new PpciException(_("Vous ne disposez pas des droits nécessaires sur la collection"), 401);
            }
            /**
             * Verify if the collection is allowed to obtain documents
             */
            if ($dcollection["allowed_import_flow"] != "t") {
                throw new PpciException(_("L'écriture dans la collection par API n'est pas autorisé"), 403);
            }
            if (!empty($_POST["external_storage_path"])) {
                /**
                 * Treatment of external file
                 */
                $id = $this->document->writeExternal($dobject["collection_id"], [
                    "uid" => $dobject["uid"],
                    "external_storage_path" => $_POST["external_storage_path"],
                    "document_description" => $_POST["document_description"],
                    "document_creation_date" => $_POST["document_creation_date"]
                ]);

            } else {
                /**
                 * Get the file(s)
                 */
                $files = [];
                foreach ($_FILES as $file) {
                    if (is_array($file["name"])) {
                        for ($i = 0; $i < count($file['name']); ++$i) {
                            $files[] = array(
                                'name' => $file['name'][$i],
                                'type' => $file['type'][$i],
                                'tmp_name' => $file['tmp_name'][$i],
                                'error' => $file['error'][$i],
                                'size' => $file['size'][$i]
                            );
                        }
                    } else {
                        $files[] = $file;
                    }
                }
                /**
                 * Verify the file
                 */
                foreach ($files as $file) {
                    if ($file["error"] != 0) {
                        throw new PpciException(_("Le fichier n'a pas pu être téléchargé"), 520);
                    }
                    $id = $this->document->documentWrite($file, "uid", $dobject["uid"],$_POST["document_description"], $_POST["document_creation_date"]);
                }
            }
            $data["document_id"] = $id;
        } catch (PpciException $e) {
            $error_code = $e->getCode();
            if ($error_code == 0) {
                $error_code = 520;
            }
            $data = array(
                "error_code" => $error_code,
                "error_message" => $this->errors[$error_code] . " - " . $e->getMessage()
            );
            $this->message->setSyslog($e->getMessage(), true);
        } finally {
            return $data;
        }
    }
}
