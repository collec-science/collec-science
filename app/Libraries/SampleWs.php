<?php

namespace App\Libraries;

use App\Models\Collection;
use App\Models\Container;
use App\Models\DatasetTemplate;
use App\Models\Movement;
use App\Models\ObjectIdentifier;
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
    /**
     *
     * @var Container
     */
    private $container;
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
        $retour = [];
        $uids = [];
        try {
            $dataSent = $_POST;
            $this->container = new Container();
            $db = $this->container->db;
            $dataset = [];
            if (!empty($_POST["template_name"])) {
                /**
                 * Format the data with the dataset template
                 */
                $dataset = $this->datasetTemplate->getTemplateFromName($_POST["template_name"]);
                //$dataSent = $this->datasetTemplate->formatDataForImport($dataset["dataset_template_id"], $dataSent);
                $searchOrder = $this->datasetTemplate->getSearchOrder($dataset["dataset_template_id"]);
            }
            if (!empty($dataSent["search_order"])) {
                $searchOrder = explode(",", $dataSent["search_order"]);
            }
            if (empty($searchOrder)) {
                $searchOrder = array("uid", "uuid", "identifier");
            }
            $db->transBegin();
            if (!empty($_POST["samples"])) {
                /**
                 * Treatment of a list of samples
                 */
                $samples = json_decode($_POST["samples"], true);
                if (!$samples) {
                    throw new PpciException(_("La liste des échantillons à traiter n'a pas pu être lue correctement"), 520);
                }
                foreach ($samples as $sample) {
                    $uids[] = $this->writeUniqueSample($sample, $searchOrder, $dataset);
                }
            } else {
                $uids[] = $this->writeUniqueSample($dataSent, $searchOrder, $dataset);
            }


            $db->transCommit();
            $retour = array(
                "error_code" => 200,
                "error_message" => "processed"
            );
            if (count($uids) > 1) {
                $retour["uid"] = $uids;
            } else {
                $retour["uid"] = $uids[0];
            }
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
        } /*finally {
            $this->vue = service("AjaxView");
            $this->vue->setJson(json_encode($retour));
            return $this->vue->send();
        }*/
        return $retour;
    }
    /**
     * Write the sample
     *
     * @param array $dataSent
     * @param array $searchOrder
     * @param array $dataset
     * @return integer
     */
    function writeUniqueSample(array $dataSent, $searchOrder, $dataset = []) :int
    {
        if (!empty($dataset)) {
            $dataSent = $this->datasetTemplate->formatDataForImport($dataset["dataset_template_id"], $dataSent);
        }
        $uid = $this->samplews->write($dataSent, $searchOrder);
        /**
         * Add or update a secondary identifier
         */
        if (!empty($dataSent["identifiers"])) {
            $identifier = new ObjectIdentifier;
            $dataIdentifier = ["uid" => $uid];
            $identifiers = explode(",", $dataSent["identifiers"]);
            foreach ($identifiers as $v) {
                $i = explode(":", $v);
                $dataIdentifier["identifier_type_code"] = $i[0];
                $dataIdentifier["object_identifier_value"] = $i[1];
                $identifier->writeOrReplace($dataIdentifier);
            }
        }
        /* check for the creation of a movement */
        $cuid = 0;
        if (!empty($dataSent["container_name"])) {
            $cuid = $this->container->getUidFromIdentifier($dataSent["container_name"]);
        }
        if ($cuid ==  0 && !empty($dataSent["container_uid"])) {
            $cuid = $dataSent["container_uid"];
        }
        if ($cuid > 0) {
            $cn = 1;
            $ln = 1;
            if (!empty($dataSent["column_number"])) {
                $cn = $dataSent["column_number"];
            }
            if (!empty($dataSent["line_number"])) {
                $ln = $dataSent["line_number"];
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
        return $uid;
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
            $collection = new Collection();
            $dcollection = $collection->lire($_REQUEST["collection_id"]);
            if (!collectionVerify($dcollection["collection_id"])) {
                throw new PpciException(sprintf(_("Droits insuffisants pour la collection %s"), $dcollection["collection_name"]), 401);
            }
            if (!$dcollection["allowed_export_flow"]) {
                throw new PpciException(sprintf(_("Les flux d'interrogation ne sont pas autorisés pour la collection %s"), $dcollection["collection_name"]), 401);
            }
            $_SESSION["searchSample"]->setParam($_REQUEST);
            $data = $this->samplews->sample->getListUIDS($_SESSION["searchSample"]->getParam());
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
            return $data;
        }
    }
    function getList()
    {
        try {
            if (empty($_REQUEST["collection_id"])) {
                throw new PpciException(_("Le numéro de la collection est obligatoire"), 400);
            }
            $collection = new Collection();
            $dcollection = $collection->lire($_REQUEST["collection_id"]);
            if (!collectionVerify($dcollection["collection_id"])) {
                throw new PpciException(sprintf(_("Droits insuffisants pour la collection %s"), $dcollection["collection_name"]), 401);
            }
            if (!$dcollection["allowed_export_flow"]) {
                throw new PpciException(sprintf(_("Les flux d'interrogation ne sont pas autorisés pour la collection %s"), $dcollection["collection_name"]), 401);
            }
            $_SESSION["searchSample"]->setParam($_REQUEST);
            $data = $this->samplews->sample->getListFromParam($_SESSION["searchSample"]->getParam());
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
                "error_message" => $this->errors[$error_code] . " - " . $e->getMessage()
            );
            $this->message->setSyslog($e->getMessage());
        } finally {
            if ($_REQUEST["nullAsEmpty"] == 1) {
                array_walk_recursive($data, function (&$item, $key) {
                    if ($item == null)
                        $item = "";
                });
            }
            return $data;
        }
    }
    function delete()
    {
        try {
            $uid = $_POST["uid"];
            $db = $this->samplews->sample->db;
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
            $collection = new Collection();
            $dcollection = $collection->lire($data["collection_id"]);
            if (!collectionVerify($dcollection["collection_id"])) {
                throw new PpciException(sprintf(_("Droits insuffisants pour la collection %s"), $dcollection["collection_name"]), 401);
            }
            if (!$dcollection["allowed_import_flow"]) {
                throw new PpciException(sprintf(_("Les flux de mise à jour ne sont pas autorisés pour la collection %s"), $dcollection["collection_name"]), 401);
            }
            $this->samplews->sample->supprimer($uid);
            $db->transCommit();
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
            return $retour;
        }
    }
}
