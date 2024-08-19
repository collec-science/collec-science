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
include_once 'modules/classes/export/lot.class.php';
require_once "modules/classes/export/export.class.php";
$this->dataclass = new Lot();
$this->keyName = "lot_id";
$this->id = $_REQUEST[$this->keyName];

    function list(){
$this->vue=service('Smarty');
        $_SESSION["moduleListe"] = "lotList";
        /**
         * Display the list of all records of the table
         */
        $collection_id = 0;
        if ($_GET["collection_id"] > 0) {
            $collection_id = $_GET["collection_id"];
        } elseif ($_COOKIE["collectionId"] > 0) {
            $collection_id = $_COOKIE["collectionId"];
        }
        if ($collection_id > 0) {
            $this->vue->set($this->dataclass->getLotsFromCollection($collection_id), "lots");
        }
        $this->vue->set($_SESSION["collections"], "collections");
        $this->vue->set("export/lotList.tpl", "corps");
        }
    function create() {
        /**
         * Verify if each uid is authorized
         */
        include_once "modules/classes/sample.class.php";
        $ok = false;
        $sample = new Sample();
        if (count($_POST["uids"]) > 0) {
            foreach ($_SESSION["collections"] as $value) {
                if ($_POST["collection_id"] == $value["collection_id"]) {
                    $ok = true;
                    }
                }
            }
            if ($ok) {
                try {
                    $db = $this->dataClass->db;
$db->transBegin();
                    $_REQUEST["lot_id"] = $this->dataclass->createLot($_POST["collection_id"], $_POST["uids"]);
                    
                    $this->message->set(_("Lot créé"));
                    $module_coderetour = 1;
                } catch (Exception $e) {
                    $this->message->set(_("Une erreur est survenue pendant la création du lot"), true);
                    $this->message->setSyslog($e->getMessage());
                    $module_coderetour = -1;
                    if ($db->transEnabled) {
    $db->transRollback();
}
                }
            } else {
                $this->message->set(_("Vous ne disposez pas des droits suffisants pour créer le lot"), true);
                $module_coderetour = -1;
            }
        } else {
            $this->message->set(_("Aucun échantillon n'a été sélectionné"), true);
            $module_coderetour = -1;
        }
        }
    function display(){
$this->vue=service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->vue->set("export/lotDisplay.tpl", "corps");
        $this->vue->set($this->dataclass->getDetail($this->id), "data");
        /**
         * Get the list of exports
         */
        require_once "modules/classes/export/export.class.php";
        $export = new Export();
        $this->vue->set($export->getListFromLot($this->id), "exports");
        /**
         * Get the list of samples
         */
        $this->vue->set($this->dataclass->getSamples($this->id), "samples");
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
        $this->id = $this->dataWrite( $_REQUEST);
        if ($this->id > 0) {
            $_REQUEST[$this->keyName] = $this->id;
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
    function deleteSamples() {
        try {
            $db = $this->dataClass->db;
$db->transBegin();
            if (empty($_POST["samples"])) {
                throw new ExportException(_("Aucun échantillon n'a été sélectionné"));
            }
            $this->dataclass->deleteSamples($this->id, $_POST["samples"]);
            
            $module_coderetour = 1;
            $this->message->set(_("Suppression des échantillons sélectionnés effectuée"));
        } catch (Exception $e) {
            $this->message->set($e->getMessage(), true);
            if ($db->transEnabled) {
    $db->transRollback();
}
            $module_coderetour = -1;
        }
        }
}
