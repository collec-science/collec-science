<?php

namespace App\Libraries;

use App\Models\ContainerFamily;
use App\Models\Movement as ModelsMovement;
use App\Models\MovementReason;
use App\Models\ObjectClass;
use App\Models\SearchMovement;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Movement extends PpciLibrary
{
    /**
     * @var ModelsMovement
     */
    protected PpciModel $dataclass;

    private $keyName;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsMovement();
        $this->keyName = "movement_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function input()
    {
        $this->vue = service('Smarty');
        $data = $this->dataRead($this->id, "gestion/movementChange.tpl", $_REQUEST["uid"]);
        $data["movement_type_id"] = 1;
        $containerFamily = new ContainerFamily();
        $this->vue->set($containerFamily->getListe(2), "containerFamily");
        $this->vue->set($data, "data");
        $this->vue->set($_SESSION["moduleParent"], "moduleParent");
        $this->vue->set("tab-movement", "activeTab");
        /*
         * Recherche de l'objet
         */
        $object = new ObjectClass();
        $this->vue->set($object->lire($_REQUEST["uid"]), "object");
        $this->vue->set($data, "data");
        return $this->vue->send();
    }

    function output()
    {
        $this->vue = service('Smarty');
        $data = $this->dataRead($this->id, "gestion/movementChange.tpl", $_REQUEST["uid"]);
        $data["movement_type_id"] = 2;
        /*
         * Recherche de l'objet
         */
        $object = new ObjectClass();
        $this->vue->set($object->lire($_REQUEST["uid"]), "object");
        $this->vue->set($data, "data");
        $this->vue->set($_SESSION["moduleParent"], "moduleParent");
        $this->vue->set("tab-movement", "activeTab");
        /*
         * Recherche des motifs de sortie
         */
        $movementReason = new MovementReason();
        $this->vue->set($movementReason->getListe(2), "movementReason");
        return $this->vue->send();
    }
    function write()
    {
        try {
            $db = $this->dataclass->db;
            $db->transBegin();
            $this->dataclass->addMovement($_REQUEST["uid"], $_REQUEST["movement_date"], $_REQUEST["movement_type_id"], $_REQUEST["container_uid"], $_SESSION["login"], $_REQUEST["storage_location"], $_REQUEST["movement_comment"], $_REQUEST["movement_reason_id"], $_REQUEST["column_number"], $_REQUEST["line_number"]);
            $db->transCommit();
            $this->message->set(_("Mouvement généré"));
        } catch (PpciException $me) {
            $this->message->set(_("Erreur lors de la génération du mouvement"), true);
            $this->message->set($me->getMessage());
            if ($db->transEnabled) {
                $db->transRollback();
            }
        } catch (PpciException $e) {
            $this->message->setSyslog($e->getMessage());
            if ($db->transEnabled) {
                $db->transRollback();
            }
        }
        return ZZZ;
    }

    function fastInputChange()
    {
        $this->vue=service('Smarty');
        if (isset($_REQUEST["container_uid"]) && is_numeric($_REQUEST["container_uid"])) {
            $this->vue->set($_REQUEST["container_uid"], "container_uid");
        }
        $this->vue->set($this->dataclass->getDefaultValues(), "data");
        $this->vue->set("gestion/fastInputChange.tpl", "corps");
        if (isset($_REQUEST["read_optical"])) {
            $this->vue->set($_REQUEST["read_optical"], "read_optical");
        }
        /*
         * Assignation du nom de la base
         */
        $this->vue->set($_SESSION["dbparams"]["APPLI_code"], "db");
        return $this->vue->send();
    }
    function fastInputWrite()
    {
        try {
            $this->dataclass->addMovement($_REQUEST["object_uid"], $_REQUEST["movement_date"], 1, $_REQUEST["container_uid"], $_SESSION["login"], $_REQUEST["storage_location"], $_REQUEST["movement_comment"], null, $_REQUEST["column_number"], $_REQUEST["line_number"]);
            $this->message->set(_("Enregistrement effectué"));
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
        }
        return $this->fastInputChange();
    }
    function fastOutputChange()
    {
        $this->vue=service('Smarty');
        $this->vue->set($this->dataclass->getDefaultValues(), "data");
        $this->vue->set("gestion/fastOutputChange.tpl", "corps");
        if (isset($_REQUEST["read_optical"])) {
            $this->vue->set($_REQUEST["read_optical"], "read_optical");
        }
        /*
         * Assignation du nom de la base
         */
        $this->vue->set($_SESSION["dbparams"]["APPLI_code"], "db");
        /*
         * Recherche des motifs de sortie
         */
        $movementReason = new MovementReason();
        $this->vue->set($movementReason->getListe(2), "movementReason");
        return $this->vue->send();
    }
    function fastOutputWrite()
    {
        try {
            $this->dataclass->addMovement($_REQUEST["object_uid"], $_REQUEST["movement_date"], 2, 0, $_SESSION["login"], $_REQUEST["storage_location"], $_REQUEST["movement_comment"], $_REQUEST["movement_reason_id"]);
            $this->message->set(_("Enregistrement effectué"));
        } catch (PpciException $e) {
            $this->message->setSyslog($e->getMessage());
            $this->message->set(_("Impossible d'enregistrer le mouvement"), true);
        }
        return $this->fastOutputChange();
    }
    function batchOpen()
    {
        $this->vue=service('Smarty');
        $this->vue->set("gestion/movementBatchRead.tpl", "corps");
        return $this->vue->send();
    }
    function batchRead()
    {
        $this->vue=service('Smarty');
        $object = new ObjectClass();
        $this->vue->set($object->batchRead($_REQUEST["reads"]), "data");
        $this->vue->set("gestion/movementBatchConfirm.tpl", "corps");
        /*
         * Recherche des motifs de sortie
         */
        require_once 'modules/classes/movementReason.class.php';
        $movementReason = new MovementReason();
        $this->vue->set($movementReason->getListe(2), "movementReason");
        return $this->vue->send();
    }
    function batchWrite()
    {
        /*
         * Preparation des donnees
         */
        $uid_container = 0;
        $date = date($_SESSION["MASKDATELONG"]);
        $nb = 0;
        try {
            foreach ($_REQUEST as $key => $sens) {
                if (substr($key, 0, 3) == "mvt") {
                    $akey = explode(":", $key);
                    $uid = $akey[1];
                    $position = substr($akey[0], 3);
                    /*
                     * teste s'il s'agit d'un container pour une entree
                     */
                    if ($_REQUEST["container" . $position . ":" . $uid] == 1) {
                        $uid_container = $uid;
                    }
                    if (($sens == 1 && $uid_container > 0) || $sens == 2) {
                        $sens == 1 ? $uic = $uid_container : $uic = "";
                        $this->dataclass->addMovement($uid, $date, $sens, $uic, $_SESSION["login"], null, null, $_REQUEST["movement_reason_id"], $_REQUEST["column" . $uid], $_REQUEST["line" . $uid]);
                        $nb++;
                    }
                }
            }
            $this->message->set(sprintf(_("%d mouvement(s) généré(s)"), $nb));
            return $this->batchOpen();
        } catch (PpciException $e) {
            $this->message->set(_("Erreur lors de la génération des mouvements"));
            $this->message->setSyslog($e->getMessage(), true);
            return $this->batchRead();
        }
    }
    function list()
    {
        $this->vue = service('Smarty');
        $_SESSION["moduleListe"] = "movementList";
        if (!isset($_SESSION["searchMovement"])){
            $_SESSION["searchMovement"] = new SearchMovement;
        }
        $_SESSION["searchMovement"]->setParam($_REQUEST);
        $dataSearch = $_SESSION["searchMovement"]->getParam();
        if ($_SESSION["searchMovement"]->isSearch() == 1) {
            $data = $this->dataclass->search($dataSearch);
            $this->vue->set($data, "data");
            $this->vue->set(1, "isSearch");
        }
        $this->vue->set($dataSearch, "movementSearch");
        $this->vue->set("gestion/movementList.tpl", "corps");
        return $this->vue->send();
    }

    function getLastEntry()
    {
        $this->vue=service('Smarty');
        $this->vue->set($this->dataclass->getLastEntry($_REQUEST["uid"]));
        return $this->vue->send();
    }

    function smallMovementChange()
    {
        $this->vue=service('Smarty');
        $this->vue->set("gestion/smallMovementChange.tpl", "corps");
        /*
         * Assignation du nom de la base
         */
        $this->vue->set($_SESSION["dbparams"]["APPLI_code"], "db");
        /*
         * Recherche des motifs de sortie
         */
        $movementReason = new MovementReason();
        $this->vue->set($movementReason->getListe(2), "movementReason");
        $this->vue->set($_POST["movement_reason_id"], "movement_reason_id");
        return $this->vue->send();
    }

    function smallMovementWrite()
    {
        try {
            $this->dataclass->addMovement($_POST["object_uid"], null, $_POST["movement_type_id"], $_POST["container_uid"], null, null, null, $_POST["movement_reason_id"], $_POST["column_number"], $_POST["line_number"]);
            $this->message->set(_("Mouvement enregistré"));
        } catch (PpciException $e) {
            $this->message->setSyslog($e->getMessage());
            $this->message->set(_("Impossible d'enregistrer le mouvement"), true);
        }
        return $this->smallMovementChange();
    }
    function smallMovementWriteAjax()
    {
        try {
            $this->dataclass->addMovement($_POST["object_uid"], null, $_POST["movement_type_id"], $_POST["container_uid"], null, null, null, $_POST["movement_reason_id"], $_POST["column_number"], $_POST["line_number"]);
            $data = array(
                "error_code" => 200,
                "error_message" => "processed"
            );
        } catch (PpciException $e) {
            $data = array(
                "error_code" => 500,
                "error_message" => $e->getMessage()
            );
        }
        $this->vue = service ("AjaxView");
        $this->vue->set($data);
        return $this->vue->send();
    }
}
