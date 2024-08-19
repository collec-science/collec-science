<?php 
namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Xx extends PpciLibrary { 
    /**
     * @var xx
     */
    protected PpciModel $dataclass;

    private $keyName;

function __construct()
    {
        parent::__construct();
        $this->dataClass = new XXX();
        $this->keyName = "xxx_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

require_once 'modules/classes/samplews.class.php';
require_once "modules/classes/export/datasetTemplate.class.php";
$samplews = new Samplews();
$datasetTemplate = new DatasetTemplate();

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


        function write() {
    try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return $this->display();
            } else {
                return $this->change();
            }
        } catch (PpciException) {
            return $this->change();
        }
    }
        $searchOrder = "";
        try {
            $bdd->beginTransaction();
            $dataSent = $_POST;
            if (!empty($_POST["template_name"])) {
                /**
                 * Format the data with the dataset template
                 */
                $dataset = $datasetTemplate->getTemplateFromName($_POST["template_name"]);
                $dataSent = $datasetTemplate->formatDataForImport($dataset["dataset_template_id"], $dataSent);
                $searchOrder = $datasetTemplate->getSearchOrder($dataset["dataset_template_id"]);
            }
            if (!empty($dataSent["search_order"])) {
                $searchOrder = explode(",",$dataSent["search_order"]);
            }
            if (empty($searchOrder)) {
                $searchOrder = array("uid", "uuid", "identifier");
            }
            $uid = $samplews->write($dataSent, $searchOrder);
            /* check for the creation of a movement */
           $cuid = 0;
            if (!empty($_POST["container_name"])) {
                require_once "modules/classes/container.class.php";
                $container = new Container();
                $cuid = $container->getUidFromIdentifier($_POST["container_name"]);
            }
            if ($cuid ==  0 && !empty($_POST["container_uid"])) {
                $cuid = $_POST["container_uid"];
            }
            if ($cuid > 0) {
                require_once "modules/classes/movement.class.php";
                $cn = 1;
                $ln = 1;
                if (!empty ($_POST["column_number"])){
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
            $bdd->commit();
            $retour = array(
                "error_code" => 200,
                "uid" => $uid,
                "error_message" => "processed"
            );
            http_response_code(200);
        } catch (Exception $e) {
            $bdd->rollBack();
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
            $this->message->setSyslog($e->getMessage());
        } finally {
            $this->vue->setJson(json_encode($retour));
        }
        }
    function detail() {
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
                throw new SampleException(_("L'UID n'est pas fourni ou n'a pas été retrouvé à partir de l'UUID"), 404);
            }
            $withContainer = true;
            $withEvent = true;
            $withTemplate = false;
            if (isset($_REQUEST["template_name"])) {
                require_once "modules/classes/export/datasetTemplate.class.php";
                $datasetTemplate = new DatasetTemplate();
                try {
                    $ddataset = $datasetTemplate->getTemplateFromName($_REQUEST["template_name"]);
                    $withTemplate = true;
                } catch (DatasetTemplateException $dte) {
                    throw new SampleException($dte->getMessage());
                }
            }
            $data = $samplews->sample->getRawDetail($this->id, $withContainer, $withEvent);
            if (count($data) == 0) {
                throw new SampleException(sprintf(_("Échantillon %s not trouvé"), $this->id), 404);
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
                    throw new SampleException(sprintf(_("Droits insuffisants pour %s"), $this->id), 401);
                }
            } else {
                /**
                 * Verify if the collection is public
                 */
                require_once "modules/classes/collection.class.php";
                $collection = new Collection();
                $dcollection = $collection->lire($data["collection_id"]);
                if (!$dcollection["public_collection"]) {
                    throw new SampleException(sprintf(_("La collection n'est pas publique pour "), $this->id), 401);
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
            $this->message->setSyslog($e->getMessage());
        } finally {
            $this->vue->setJson(json_encode($data));
        }
        }
    function getListUIDS() {
        try {
            if (empty($_REQUEST["collection_id"])) {
                throw new SampleException(_("Le numéro de la collection est obligatoire"), 400);
            }
            require_once "modules/classes/collection.class.php";
            $collection = new Collection();
            $dcollection = $collection->lire($_REQUEST["collection_id"]);
            if (!collectionVerify($dcollection["collection_id"])) {
                throw new SampleException(sprintf(_("Droits insuffisants pour la collection %s"), $dcollection["collection_name"]), 401);
            }
            if (!$dcollection["allowed_export_flow"]) {
                throw new SampleException(sprintf(_("Les flux d'interrogation ne sont pas autorisés pour la collection %s"), $d_collection["collection_name"]), 401);
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
            $this->message->setSyslog($e->getMessage());
        } finally {
            $this->vue->setJson(json_encode($data));
        }
        }
    function getList() {
        try {
            if (empty($_REQUEST["collection_id"])) {
                throw new SampleException(_("Le numéro de la collection est obligatoire"), 400);
            }
            require_once "modules/classes/collection.class.php";
            $collection = new Collection();
            $dcollection = $collection->lire($_REQUEST["collection_id"]);
            if (!collectionVerify($dcollection["collection_id"])) {
                throw new SampleException(sprintf(_("Droits insuffisants pour la collection %s"), $dcollection["collection_name"]), 401);
            }
            if (!$dcollection["allowed_export_flow"]) {
                throw new SampleException(sprintf(_("Les flux d'interrogation ne sont pas autorisés pour la collection %s"), $d_collection["collection_name"]), 401);
            }
            $_SESSION["searchSample"]->setParam($_REQUEST);
            $data = $samplews->sample->getListFromParam($_SESSION["searchSample"]->getParam());
            if (isset($_REQUEST["template_name"])) {
                require_once "modules/classes/export/datasetTemplate.class.php";
                $datasetTemplate = new DatasetTemplate();
                try {
                    $ddataset = $datasetTemplate->getTemplateFromName($_REQUEST["template_name"]);
                    $withTemplate = true;
                } catch (DatasetTemplateException $dte) {
                    throw new SampleException($dte->getMessage());
                }
                $data = $datasetTemplate->formatData($data);
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
            $this->message->setSyslog($e->getMessage());
        } finally {
            if ($_REQUEST["nullAsEmpty"] == 1) {
                array_walk_recursive($data, function (&$item, $key) {
                    if ($item == null)
                        $item = "";
                });
            }
            $this->vue->setJson(json_encode($data));
        }
        }
        function delete(){
            $retour = array();
            try {
                $uid = $_POST["uid"];
                $bdd->beginTransaction();
            if (!empty($uid)) {
                $data = $samplews->sample->lire($uid);
                if (empty($data["sample_id"])) {
                    throw new SampleException(sprintf(_("L'UID %s ne correspond pas à un échantillon"), $uid));
                }
            } else {
                throw new SampleException(sprintf(_("L'UID %s n'a pas été trouvé"), $uid),400);
            }
            /* check the collection */
            require_once "modules/classes/collection.class.php";
            $collection = new Collection();
            $dcollection = $collection->lire($data["collection_id"]);
            if (!collectionVerify($dcollection["collection_id"])) {
                throw new SampleException(sprintf(_("Droits insuffisants pour la collection %s"), $dcollection["collection_name"]), 401);
            }
            if (!$dcollection["allowed_import_flow"]) {
                throw new SampleException(sprintf(_("Les flux de mise à jour ne sont pas autorisés pour la collection %s"), $d_collection["collection_name"]), 401);
            }
            $samplews->sample->supprimer($uid);
            $bdd->commit();
            $retour = array(
                "error_code" => 200,
                "error_message" => "processed"
            );
            http_response_code(200);
        } catch (Exception $e) {
            $bdd->rollBack();
            $error_code = $e->getCode();
            if ($error_code == 0) {
                $error_code = 520;
            }
            $this->message->setSyslog($e->getMessage());
            $retour = array(
                "error_code" => $error_code,
                "error_message" => $errors[$error_code],
                "error_detail" => $e->getMessage()
            );
            http_response_code($error_code);
            $this->message->setSyslog($e->getMessage());
        } finally {
            $this->vue->setJson(json_encode($retour));
        }
            }

}
