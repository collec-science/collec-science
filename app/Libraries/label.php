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
require_once 'modules/classes/label.class.php';
$this->dataclass = new Label();
$this->keyName = "label_id";
$this->id = $_REQUEST[$this->keyName];


    function list(){
$this->vue=service('Smarty');
        /*
         * Display the list of all records of the table
         */
        try {
            $this->vue->set($this->dataclass->getListe(2), "data");
            $this->vue->set("param/labelList.tpl", "corps");
        } catch (Exception $e) {
            $this->message->set($e->getMessage());
        }
        }
    function change(){
$this->vue=service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $data = $this->dataRead( $this->id, "param/labelChange.tpl");
        require_once 'modules/classes/metadata.class.php';
        $metadata = new metadata();
        require_once "modules/classes/barcode.class.php";
        $barcode = new Barcode();
        $this->vue->set ($barcode->getListe(1),"barcodes");
        $this->vue->set($metadata->getListe(), "metadata");
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
        $_REQUEST["label_xsl"] = hex2bin($_REQUEST["label_xsl"]);
        $this->id = $this->dataWrite( $_REQUEST);
        if ($this->id > 0) {
            $_REQUEST[$this->keyName] = $this->id;
        }
        }
    function delete(){
        /*
         * delete record
         */
        /**
         * Search if the label is referenced into a model of container
         */
        $containers = $this->dataclass->getReferencedContainers($this->id);
        if (!empty($containers)) {
            foreach ($containers as $row) {
                $this->message->set(
                    sprintf(
                        _("La suppression du modèle d'étiquette n'est pas possible, il est référencé par le type de contenant %s"), 
                        $row["container_type_name"]), 
                    true);
            }
            $module_coderetour = -1;
        } else {
             try {
            $this->dataDelete($this->id);
            return $this->list();
        } catch (PpciException $e) {
            return $this->change();
        }
        }
        }
    function copy() {
        /*
         * Duplication d'une etiquette
         */
        $data = $this->dataclass->lire($this->id);
        $data["label_id"] = 0;
        $data["label_name"] = "";
        $this->vue->set($data, "data");
        $this->vue->set("param/labelChange.tpl", "corps");
        require_once 'modules/classes/metadata.class.php';
        $metadata = new Metadata();
        $this->vue->set($metadata->getListe(), "metadata");
        require_once "modules/classes/barcode.class.php";
        $barcode = new Barcode();
        $this->vue->set ($barcode->getListe(1),"barcodes");
        }
}
?>
