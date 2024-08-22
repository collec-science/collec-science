<?php

namespace App\Libraries;

use App\Models\Collection;
use App\Models\Container;
use App\Models\DatasetTemplate;
use App\Models\Movement;
use App\Models\Samplews as ModelsSamplews;
use Ppci\Libraries\Locale;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class SampleWs extends PpciLibrary
{

    private $datasetTemplate;
    private $errors = array(
        500 => "Internal Server Error",
        400 => "Bad request",
        401 => "Unauthorized",
        403 => "Forbidden",
        520 => "Unknown error",
        404 => "Not Found"
    );
    private $samplews;
    function __construct()
    {
        parent::__construct();
        $this->samplews = new ModelsSamplews();
        $this->datasetTemplate = new DatasetTemplate();
        if (isset($_REQUEST["locale"])) {
            $localeLib = new Locale();
            $localeLib->setLocale($_REQUEST["locale"]);
        }
    }

    function write()
    {
        $searchOrder = "";
        try {
            $db = $this->dataclass->db;
            $db->transBegin();
            $dataSent = $_POST;
            if (!empty($_POST["template_name"])) {
                /**
                 * Format the data with the dataset template
                 */
                $dataset = $this->datasetTemplate->getTemplateFromName($_POST["template_name"]);
                $dataSent = $this->datasetTemplate->formatDataForImport($dataset["dataset_template_id"], $dataSent);
                $searchOrder = $this->datasetTemplate->getSearchOrder($dataset["dataset_template_id"]);
            }
            if (!empty($dataSent["search_order"])) {
                $searchOrder = explode(",", $dataSent["search_order"]);
            }
            if (empty($searchOrder)) {
                $searchOrder = array("uid", "uuid", "identifier");
            }
            $uid = $this->samplews->write($dataSent, $searchOrder);
            /* check for the creation of a movement */
            $cuid = 0;
            if (!empty($_POST["container_name"])) {
                $container = new Container();
                $cuid = $container->getUidFromIdentifier($_POST["container_name"]);
            }
            if ($cuid ==  0 && !empty($_POST["container_uid"])) {
                $cuid = $_POST["container_uid"];
            }
            if ($cuid > 0) {
                $cn = 1;
                $ln = 1;
                if (!empty($_POST["column_number"])) {
                    $cn = $_POST["column_number"];
                }
                if (!empty($_POST["line_number"])) {
                    $ln = $_POST["line_number"];
                }
                $movement = new Movement();
                $movement->addMovement(
                    $uid,
                    null,
                    1,
                    $cuid,
                    null,
                    null,
                    null,
                    null,
                    $cn,
                    $ln
                );
            }

            $retour = array(
                "error_code" => 200,
                "uid" => $uid,
                "error_message" => "processed"
            );
            http_response_code(200);
        } catch (PpciException $e) {
            if ($db->transEnabled) {
                $db->transRollback();
            }
            $error_code = $e->getCode();
            if (!isset($errors[$error_code])) {
                $error_code = 520;
            }
            $retour = array(
                "error_code" => $error_code,
                "error_message" => $this->errors[$error_code],
                "error_detail" => $e->getMessage()
            );
            http_response_code($error_code);
            $this->message->setSyslog($e->getMessage());
        } finally {
            $this->vue = service("AjaxView");
            $this->vue->setJson(json_encode($retour));
            return $this->vue->send();
        }
    }
    function detail()
    {
        /**
         * Get all data for a sample in raw format
         */
        try {
            if (strlen($_REQUEST["uuid"]) == 36) {
                $this->id = $_REQUEST["uuid"];
            } else {
                $this->id = $_REQUEST["uid"];
            }
            if (empty($this->id)) {
                throw new PpciException(_("L'UID n'est pas fourni ou n'a pas été retrouvé à partir de l'UUID"), 404);
            }
            $withContainer = true;
            $withEvent = true;
            $withTemplate = false;
            if (isset($_REQUEST["template_name"])) {
                $datasetTemplate = new DatasetTemplate();
                $ddataset = $datasetTemplate->getTemplateFromName($_REQUEST["template_name"]);
                $withTemplate = true;
            }
            $data = $this->samplews->sample->getRawDetail($this->id, $withContainer, $withEvent);
            if (count($data) == 0) {
                throw new PpciException(sprintf(_("Échantillon %s not trouvé"), $this->id), 404);
            }
            /**
             * purge the technical fields
             */
            $fields = array("sample_id", "sample_type_id", "campaign_id", "parent_sample_id", "multiple_type_id", "multiple_type_name", "country_id", "object_status_id", "operation_id", "operation_order", "document_id", "movement_type_id", "sampling_place_id", "real_referent_id", "borrower_id", "country_origin_id");
            foreach ($fields as $field) {
                unset($data[$field]);
            }
            /**
             * Search for collection
             */
            if (isset($_SESSION["login"])) {
                if (!collectionVerify($data["collection_id"])) {
                    throw new PpciException(sprintf(_("Droits insuffisants pour %s"), $this->id), 401);
                }
            } else {
                /**
                 * Verify if the collection is public
                 */
                $collection = new Collection();
                $dcollection = $collection->lire($data["collection_id"]);
                if (!$dcollection["public_collection"]) {
                    throw new PpciException(sprintf(_("La collection n'est pas publique pour "), $this->id), 401);
                }
                if (!$withTemplate) {
                    throw new PpciException(_("Le nom du modèle d'export n'est pas indiqué dans la requête"), 400);
                }
            }
            /**
             * Format the data, if required
             */
            if ($withTemplate) {
                $data = $datasetTemplate->formatData(array(0 => $data))[0];
            }
        } catch (PpciException $e) {
            $error_code = $e->getCode();
            if ($error_code == 0) {
                $error_code = 520;
            }
            $data = array(
                "error_code" => $error_code,
                "error_message" => $this->errors[$error_code]
            );
            if (env("CI_ENVIRONMENT") == "development") {
                $data["error_content"] = $e->getMessage();
            }
            $this->message->setSyslog($e->getMessage());
        } finally {
            $this->vue = service("AjaxView");
            $this->vue->setJson(json_encode($data));
            return $this->vue->send();
        }
    }
    function getListUIDS()
    {
        try {
            if (empty($_REQUEST["collection_id"])) {
                throw new PpciException(_("Le numéro de la collection est obligatoire"), 400);
            }
            require_once "modules/classes/collection.class.php";
            $collection = new Collection();
            $dcollection = $collection->lire($_REQUEST["collection_id"]);
            if (!collectionVerify($dcollection["collection_id"])) {
                throw new PpciException(sprintf(_("Droits insuffisants pour la collection %s"), $dcollection["collection_name"]), 401);
            }
            if (!$dcollection["allowed_export_flow"]) {
                throw new PpciException(sprintf(_("Les flux d'interrogation ne sont pas autorisés pour la collection %s"), $d_collection["collection_name"]), 401);
            }
            $_SESSION["searchSample"]->setParam($_REQUEST);
            $data = $samplews->sample->getListUIDS($_SESSION["searchSample"]->getParam());
        } catch (PpciException $e) {
            $error_code = $e->getCode();
            if ($error_code == 0) {
                $error_code = 520;
            }
            $data = array(
                "error_code" => $error_code,
                "error_message" => $this->errors[$error_code]
            );
            if (env("CI_ENVIRONMENT") == "development") {
                $data["error_content"] = $e->getMessage();
            }
            $this->message->setSyslog($e->getMessage());
        } finally {
            $this->vue = service("AjaxView");
            $this->vue->setJson(json_encode($data));
            return $this->vue->send();
        }
    }
    function getList()
    {
        try {
            if (empty($_REQUEST["collection_id"])) {
                throw new PpciException(_("Le numéro de la collection est obligatoire"), 400);
            }
            require_once "modules/classes/collection.class.php";
            $collection = new Collection();
            $dcollection = $collection->lire($_REQUEST["collection_id"]);
            if (!collectionVerify($dcollection["collection_id"])) {
                throw new PpciException(sprintf(_("Droits insuffisants pour la collection %s"), $dcollection["collection_name"]), 401);
            }
            if (!$dcollection["allowed_export_flow"]) {
                throw new PpciException(sprintf(_("Les flux d'interrogation ne sont pas autorisés pour la collection %s"), $d_collection["collection_name"]), 401);
            }
            $_SESSION["searchSample"]->setParam($_REQUEST);
            $data = $samplews->sample->getListFromParam($_SESSION["searchSample"]->getParam());
            if (isset($_REQUEST["template_name"])) {
                $datasetTemplate = new DatasetTemplate();
                $ddataset = $datasetTemplate->getTemplateFromName($_REQUEST["template_name"]);
                $withTemplate = true;
                $data = $datasetTemplate->formatData($data);
            }
        } catch (PpciException $e) {
            $error_code = $e->getCode();
            if ($error_code == 0) {
                $error_code = 520;
            }
            $data = array(
                "error_code" => $error_code,
                "error_message" => $errors[$error_code]
            );
            if ($APPLI_modeDeveloppement) {
                $data["error_content"] = $e->getMessage();
            }
            $this->message->setSyslog($e->getMessage());
        } finally {
            if ($_REQUEST["nullAsEmpty"] == 1) {
                array_walk_recursive($data, function (&$item, $key) {
                    if ($item == null)
                        $item = "";
                });
            }
            $this->vue = service("AjaxView");
            $this->vue->setJson(json_encode($data));
            return $this->vue->send();
        }
    }
    function delete()
    {
        $retour = array();
        try {
            $uid = $_POST["uid"];
            $db = $this->dataclass->db;
            $db->transBegin();
            if (!empty($uid)) {
                $data = $this->samplews->sample->lire($uid);
                if (empty($data["sample_id"])) {
                    throw new PpciException(sprintf(_("L'UID %s ne correspond pas à un échantillon"), $uid));
                }
            } else {
                throw new PpciException(sprintf(_("L'UID %s n'a pas été trouvé"), $uid), 400);
            }
            /* check the collection */
            require_once "modules/classes/collection.class.php";
            $collection = new Collection();
            $dcollection = $collection->lire($data["collection_id"]);
            if (!collectionVerify($dcollection["collection_id"])) {
                throw new PpciException(sprintf(_("Droits insuffisants pour la collection %s"), $dcollection["collection_name"]), 401);
            }
            if (!$dcollection["allowed_import_flow"]) {
                throw new PpciException(sprintf(_("Les flux de mise à jour ne sont pas autorisés pour la collection %s"), $d_collection["collection_name"]), 401);
            }
            $samplews->sample->supprimer($uid);

            $retour = array(
                "error_code" => 200,
                "error_message" => "processed"
            );
            http_response_code(200);
        } catch (PpciException $e) {
            if ($db->transEnabled) {
                $db->transRollback();
            }
            $error_code = $e->getCode();
            if ($error_code == 0) {
                $error_code = 520;
            }
            $this->message->setSyslog($e->getMessage());
            $retour = array(
                "error_code" => $error_code,
                "error_message" => $this->errors[$error_code],
                "error_detail" => $e->getMessage()
            );
            http_response_code($error_code);
            $this->message->setSyslog($e->getMessage());
        } finally {
            $this->vue = service("AjaxView");
            $this->vue->setJson(json_encode($data));
            return $this->vue->send();
        }
    }
}
