<?php

require_once 'modules/classes/samplews.class.php';
require_once "modules/classes/export/datasetTemplate.class.php";
$samplews = new Samplews($bdd, $ObjetBDDParam);
$datasetTemplate = new DatasetTemplate($bdd, $ObjetBDDParam);

$errors = array(
    500 => "Internal Server Error",
    400 => "Bad request",
    401 => "Unauthorized",
    403 => "Forbidden",
    520 => "Unknown error",
    404 => "Not Found"
);
if (isset($_REQUEST["locale"])) {
    setlanguage($_REQUEST["locale"]);
}

switch ($t_module["param"]) {
    case "write":
        $searchOrder = "";
        try {
            $dataSent = $_POST;
            //$dataSent = $_GET;
            if (!empty($_POST["template"])) {
                /**
                 * Format the data with the dataset template
                 */
                $dataset = $datasetTemplate->getTemplateFromName($_POST["template"]);
                $dataSent = $datasetTemplate->formatDataForImport($dataset["dataset_template_id"], $dataSent);
                $searchOrder = $datasetTemplate->getSearchOrder($dataset["dataset_template_id"]);
            }
            if (empty($searchOrder)) {
                $searchOrder = array("uid", "uuid", "identifier");
            }
            $uid = $samplews->write($dataSent, $searchOrder);
            $retour = array(
                "error_code" => 200,
                "uid" => $uid,
                "error_message" => "processed"
            );
            http_response_code(200);
        } catch (Exception $e) {
            $error_code = $e->getCode();
            if (!isset($errors[$error_code])) {
                $error_code = 520;
            }
            $retour = array(
                "error_code" => $error_code,
                "error_message" => $errors[$error_code],
                "error_detail" => $e->getMessage()
            );
            http_response_code($error_code);
            $message->setSyslog($e->getMessage());
        } finally {
            $vue->setJson(json_encode($retour));
        }
        break;
    case "detail":
        /**
         * Get all data for a sample in raw format
         */
        try {
            if (strlen($_REQUEST["uuid"]) == 36) {
                $id = $_REQUEST["uuid"];
            } else {
                $id = $_REQUEST["uid"];
            }
            if (empty($id)) {
                throw new SampleException(sprintf(_("uid %s not valid"), $id), 404);
            }
            $withContainer = true;
            $withEvent = true;
            $withTemplate = false;
            if (isset($_REQUEST["template_name"])) {
                require_once "modules/classes/export/datasetTemplate.class.php";
                $datasetTemplate = new DatasetTemplate($bdd, $ObjetBDDParam);
                try {
                    $ddataset = $datasetTemplate->getTemplateFromName($_REQUEST["template_name"]);
                    $withTemplate = true;
                } catch (DatasetTemplateException $dte) {
                    throw new SampleException($dte->getMessage());
                }
            }
            require_once "modules/classes/sample.class.php";
            $sample = new Sample($bdd, $ObjetBDDParam);
            $data = $sample->getRawDetail($id, $withContainer, $withEvent);
            if (count($data) == 0) {
                throw new SampleException(sprintf(_("Échantillon %s not trouvé"), $id), 404);
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
                    throw new SampleException(sprintf(_("Droits insuffisants pour %s"), $id), 401);
                }
            } else {
                /**
                 * Verify if the collection is public
                 */
                require_once "modules/classes/collection.class.php";
                $collection = new Collection($bdd, $ObjetBDDParam);
                $dcollection = $collection->lire($data["collection_id"]);
                if (!$dcollection["public_collection"]) {
                    throw new SampleException(sprintf(_("La collection n'est pas publique pour "), $id), 401);
                }
                if (!$withTemplate) {
                    throw new SampleException(_("Le nom du modèle d'export n'est pas indiqué dans la requête"), 400);
                }
            }
            /**
             * Format the data, if required
             */
            if ($withTemplate) {
                $data = $datasetTemplate->formatData(array(0 => $data))[0];
            }
        } catch (Exception $e) {
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
            $message->setSyslog($e->getMessage());
        } finally {
            $vue->setJson(json_encode($data));
        }
        break;
    case "getListUIDS":
        try {
            if (empty($_REQUEST["collection_id"])) {
                throw new SampleException(_("Le numéro de la collection est obligatoire"),400);
            }
            if (!collectionVerify($_REQUEST["collection_id"])) {
                throw new SampleException(sprintf(_("Droits insuffisants pour la collection n° %s"),$_REQUEST["collection_id"] ), 401);
            }
            require_once "modules/classes/collection.class.php";
            $collection = new Collection($bdd, $ObjetBDDParam);
            $dcollection = $collection->lire($_REQUEST["collection_id"]);
            if (!collectionVerify($dcollection["collection_id"])) {
                throw new SampleException(sprintf(_("Droits insuffisants pour la collection %s"),$dcollection["collection_name"] ), 401);
            }
            if (!$dcollection["allowed_export_flow"]) {
                throw new SampleException(sprintf(_("Les flux d'interrogation ne sont pas autorisés pour la collection %s"), $d_collection["collection_name"]),401);
            }
            $_SESSION["searchSample"]->setParam($_REQUEST);
            $data = $samplews->sample->getListUIDS($_SESSION["searchSample"]->getParam());
        } catch (Exception $e) {
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
            $message->setSyslog($e->getMessage());
        } finally {
            $vue->setJson(json_encode($data));
        }
        break;

}
