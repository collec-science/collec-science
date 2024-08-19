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

/**
 * Created : 28 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/movement.class.php';
$this->dataclass = new Movement();
$this->keyName = "movement_id";
$this->id = $_REQUEST[$this->keyName];

    function input() {
        $data = $this->dataRead( $this->id, "gestion/movementChange.tpl", $_REQUEST["uid"]);
        $data["movement_type_id"] = 1;
        require_once 'modules/classes/containerFamily.class.php';
        $containerFamily = new ContainerFamily();
        $this->vue->set($containerFamily->getListe(2), "containerFamily");
        $this->vue->set($data, "data");
        $this->vue->set($_SESSION["moduleParent"], "moduleParent");
        $this->vue->set("tab-movement", "activeTab");

        /*
         * Recherche de l'objet
         */
        require_once 'modules/classes/object.class.php';
        $object = new ObjectClass();
        $this->vue->set($object->lire($_REQUEST["uid"]), "object");
        $this->vue->set($data, "data");
        }

    function output() {
        $data = $this->dataRead( $this->id, "gestion/movementChange.tpl", $_REQUEST["uid"]);
        $data["movement_type_id"] = 2;
        /*
         * Recherche de l'objet
         */
        require_once 'modules/classes/object.class.php';
        $object = new ObjectClass();
        $this->vue->set($object->lire($_REQUEST["uid"]), "object");
        $this->vue->set($data, "data");
        $this->vue->set($_SESSION["moduleParent"], "moduleParent");
        $this->vue->set("tab-movement", "activeTab");
        /*
         * Recherche des motifs de sortie
         */
        require_once 'modules/classes/movementReason.class.php';
        $movementReason = new MovementReason();
        $this->vue->set($movementReason->getListe(2), "movementReason");
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
        /*
         * write record in database
         */
        try {
            $db = $this->dataClass->db;
$db->transBegin();
            $this->dataclass->addMovement($_REQUEST["uid"], $_REQUEST["movement_date"], $_REQUEST["movement_type_id"], $_REQUEST["container_uid"], $_SESSION["login"], $_REQUEST["storage_location"], $_REQUEST["movement_comment"], $_REQUEST["movement_reason_id"], $_REQUEST["column_number"], $_REQUEST["line_number"]);
            
            $module_coderetour = 1;
            $this->message->set(_("Mouvement généré"));
        } catch (MovementException $me) {
            $module_coderetour = -1;
            $this->message->set(_("Erreur lors de la génération du mouvement"), true);
            $this->message->set($me->getMessage());
            $module_coderetour = -1;
            if ($db->transEnabled) {
    $db->transRollback();
}
        } catch (Exception $e) {
            $module_coderetour = -1;
            $this->message->setSyslog($e->getMessage());
            if ($db->transEnabled) {
    $db->transRollback();
}
        }
        }
    function delete(){
        /*
         * delete record
         */
         try {
            $this->dataDelete($this->id);
            return $this->list();
        } catch (PpciException $e) {
            return $this->change();
        }
        }
    function fastInputChange() {
        if (isset($_REQUEST["container_uid"]) && is_numeric($_REQUEST["container_uid"])) {
            $this->vue->set($_REQUEST["container_uid"], "container_uid");
        }
        $this->vue->set($this->dataclass->getDefaultValue(), "data");
        $this->vue->set("gestion/fastInputChange.tpl", "corps");
        if (isset($_REQUEST["read_optical"])) {
            $this->vue->set($_REQUEST["read_optical"], "read_optical");
        }
        /*
         * Assignation du nom de la base
         */
        $this->vue->set($_SESSION["dbparams"]["APPLI_code"], "db");

        }
    function fastInputWrite() {
        try {
            $this->dataclass->addMovement($_REQUEST["object_uid"], $_REQUEST["movement_date"], 1, $_REQUEST["container_uid"], $_SESSION["login"], $_REQUEST["storage_location"], $_REQUEST["movement_comment"], null, $_REQUEST["column_number"], $_REQUEST["line_number"]);
            $this->message->set(_("Enregistrement effectué"));
            $module_coderetour = 1;
        } catch (Exception $e) {
            $this->message->set($e->getMessage(), true);
            $module_coderetour = -1;
        }
        }
    function fastOutputChange() {
        $this->vue->set($this->dataclass->getDefaultValue(), "data");
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
        require_once 'modules/classes/movementReason.class.php';
        $movementReason = new MovementReason();
        $this->vue->set($movementReason->getListe(2), "movementReason");

        }
    function fastOutputWrite() {
        try {
            $this->dataclass->addMovement($_REQUEST["object_uid"], $_REQUEST["movement_date"], 2, 0, $_SESSION["login"], $_REQUEST["storage_location"], $_REQUEST["movement_comment"], $_REQUEST["movement_reason_id"]);
            $this->message->set(_("Enregistrement effectué"));
            $module_coderetour = 1;
        } catch (Exception $e) {
            $this->message->setSyslog($e->getMessage());
            $this->message->set(_("Impossible d'enregistrer le mouvement"), true);
            $module_coderetour = -1;
        }
        }
    function batchOpen() {
        $this->vue->set("gestion/movementBatchRead.tpl", "corps");
        }
    function batchRead() {
        require_once 'modules/classes/object.class.php';
        $object = new ObjectClass();
        $this->vue->set($object->batchRead($_REQUEST["reads"]), "data");
        $this->vue->set("gestion/movementBatchConfirm.tpl", "corps");
        /*
         * Recherche des motifs de sortie
         */
        require_once 'modules/classes/movementReason.class.php';
        $movementReason = new MovementReason();
        $this->vue->set($movementReason->getListe(2), "movementReason");
        }
    function batchWrite() {
        /*
         * Preparation des donnees
         */
        $uid_container = 0;
        $date = date($_SESSION["MASKDATELONG"]);
        $nb = 0;
        try {
            foreach ($_REQUEST as $key => $sens) {
                if (substr($key, 0, 3) == "mvt") {
                    $akey = explode(() {", $key);
                    $uid = $akey[1];
                    $position = substr($akey[0], 3);
                    /*
                     * teste s'il s'agit d'un container pour une entree
                     */
                    if ($_REQUEST["container" . $position . () {" . $uid] == 1) {
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
            $module_coderetour = 1;
        } catch (Exception $e) {
            $this->message->set(_("Erreur lors de la génération des mouvements"));
            $this->message->setSyslog($e->getMessage(), true);
            $module_coderetour = -1;
        }
        }
    function list(){
$this->vue=service('Smarty');
    $_SESSION["moduleListe"] = "movementList";
        $_SESSION["searchMovement"]->setParam($_REQUEST);
        $dataSearch = $_SESSION["searchMovement"]->getParam();
        if ($_SESSION["searchMovement"]->isSearch() == 1) {
            $data = $this->dataclass->search($dataSearch);
            $this->vue->set($data, "data");
            $this->vue->set(1, "isSearch");
        }
        $this->vue->set($dataSearch, "movementSearch");
        $this->vue->set("gestion/movementList.tpl", "corps");
        }

    function getLastEntry() {
        $this->vue->set($this->dataclass->getLastEntry($_REQUEST["uid"]));
        }

    function smallMovementChange() {
        $this->vue->set("gestion/smallMovementChange.tpl", "corps");
        /*
         * Assignation du nom de la base
         */
        $this->vue->set($_SESSION["dbparams"]["APPLI_code"], "db");
        /*
         * Recherche des motifs de sortie
         */
        require_once 'modules/classes/movementReason.class.php';
        $movementReason = new MovementReason();
        $this->vue->set($movementReason->getListe(2), "movementReason");
        $this->vue->set($_POST["movement_reason_id"], "movement_reason_id");
        }

    function smallMovementWrite() {
        try {
            $this->dataclass->addMovement($_POST["object_uid"], null, $_POST["movement_type_id"], $_POST["container_uid"], null, null, null, $_POST["movement_reason_id"], $_POST["column_number"], $_POST["line_number"]);
            $module_coderetour = 1;
            $this->message->set(_("Mouvement enregistré"));
        } catch (Exception $e) {
            $this->message->setSyslog($e->getMessage());
            $this->message->set(_("Impossible d'enregistrer le mouvement"), true);
            $module_coderetour = -1;
        }
        }
        function smallMovementWriteAjax() {
            try {
                $this->dataclass->addMovement($_POST["object_uid"], null, $_POST["movement_type_id"], $_POST["container_uid"], null, null, null, $_POST["movement_reason_id"], $_POST["column_number"], $_POST["line_number"]);
                $data=array(
                    "error_code" => 200,
                    "error_message" => "processed"
                  );
            } catch (Exception $e) {
                $data=array(
                    "error_code" => 500,
                    "error_message" => $e->getMessage()
                  );
            }
            $this->vue->set($data);
            }
}
