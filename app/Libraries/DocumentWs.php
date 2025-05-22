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

    function getListFromObject()
    {
        try {
            $data = [];
            if (empty($_REQUEST["uid"] || empty($_REQUEST["uuid"]))) {
                throw new PpciException(_("Aucun objet n'a été fourni pour réaliser la recherche"), 400);
            }
            /**
             * Search the type and the collection
             */
            if (!empty($_REQUEST["uid"])) {
                $field = "uid";
            } else {
                $field = "uuid";
            }
            $dobject = $this->objectClass->readWithType($_REQUEST[$field], $field);
            if (empty($dobject)) {
                throw new PpciException(_("Aucun objet ne correspond à l'identifiant fourni"), 404);
            }
            $dcollection = [];
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
                throw new PpciException(_("Droits insuffisants"),401);
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
}
