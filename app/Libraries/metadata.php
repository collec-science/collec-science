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
 * Created : 8 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/metadata.class.php';
$this->dataclass = new Metadata();
$this->keyName = "metadata_id";
$this->id = $_REQUEST[$this->keyName];


    function list(){
$this->vue=service('Smarty');
        /*
         * Display the list of all records of the table
         */
        try {
            $this->vue->set($this->dataclass->getListe(2), "data");
            $this->vue->set("param/metadataList.tpl", "corps");
        } catch (Exception $e) {
            $this->message->set($e->getMessage());
        }
        }
    function display(){
$this->vue=service('Smarty');
        $data = $this->dataclass->lire($this->id);
        $this->vue->set($data, "data");
        $this->vue->set(json_decode($data["metadata_schema"], true), "metadata");
        $this->vue->set("param/metadataDisplay.tpl", "corps");
        }

    function change(){
$this->vue=service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->dataRead( $this->id, "param/metadataChange.tpl");
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
        $_REQUEST["metadata_schema"] = hex2bin($_REQUEST["metadata_schema"]);
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
    function copy() {
        /*
         * Duplication d'une etiquette
         */
        $data = $this->dataclass->lire($this->id);
        $data["metadata_id"] = 0;
        $data["metadata_name"] .= " - new version";
        $this->vue->set($data, "data");
        $this->vue->set("param/metadataChange.tpl", "corps");
        }
    function getSchema() {
        $data = $this->dataclass->lire($this->id);
        $this->vue->setJson($data["metadata_schema"]);
        }
    function export() {

        $this->vue->set($this->dataclass->getListFromIds($_POST["metadata_id"]));
        }
    function import() {
        if (file_exists($_FILES['upfile']['tmp_name'])) {
            require_once 'modules/classes/import.class.php';
            try {
                $import = new Import($_FILES['upfile']['tmp_name'], ";", false, array(
                    "metadata_name",
                    "metadata_schema",
                    "metadata_id"
                ));
                $rows = $import->getContentAsArray();
                foreach ($rows as $row) {
                    $data = array(
                        "metadata_name" => $row["metadata_name"],
                        "metadata_schema" => $row["metadata_schema"],
                        "metadata_id" => 0
                    );
                    $this->dataclass->ecrire($data);
                }
                $this->message->set(_("Métadonnée(s) importée(s)"));
                $module_coderetour = 1;
            } catch (Exception $e) {
                $this->message->set(_("Impossible d'importer les métadonnées"));
                $this->message->set($e->getMessage());
                $module_coderetour = -1;
            }
        } else {
            $this->message->set(_("Impossible de charger le fichier à importer"));
            $module_coderetour = -1;
        }
        }
}
