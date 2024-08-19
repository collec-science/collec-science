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
 * Created : 30 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/sampleType.class.php';
$this->dataclass = new SampleType();
$this->keyName = "sample_type_id";
$this->id = $_REQUEST[$this->keyName];

    function list(){
$this->vue=service('Smarty');
        /*
         * Display the list of all records of the table
         */
        $this->vue->set($this->dataclass->getListe(2), "data");
        $this->vue->set("param/sampleTypeList.tpl", "corps");
        }
    function change(){
$this->vue=service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->dataRead( $this->id, "param/sampleTypeChange.tpl");
        require_once 'modules/classes/containerType.class.php';
        $containerType = new ContainerType();
        $this->vue->set($containerType->getListe("container_type_name"), "container_type");
        require_once 'modules/classes/operation.class.php';
        $operation = new Operation();
        $this->vue->set($operation->getListe(), "operation");
        require_once 'modules/classes/multipleType.class.php';
        $multipleType = new MultipleType();
        $this->vue->set($multipleType->getListe(1), "multiple_type");
        require_once 'modules/classes/metadata.class.php';
        $metadata = new Metadata();
        $this->vue->set($metadata->getListe(2), "metadata");
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
    function metadata() {
        $this->vue->setJson($this->dataclass->getMetadataForm($this->id));
        }
    function metadataSearchable() {
        if (!empty($this->id)) {
            $this->vue->set($this->dataclass->getMetadataSearchable($this->id));
        } else {
            include_once "modules/classes/metadata.class.php";
            $metadata = new Metadata();
            $this->vue->set($metadata->getListSearchable());
        }
        }
    function generator() {
        $this->vue->setJson($this->dataclass->getIdentifierJs($this->id));
        }
    function getListAjax() {
        $this->vue->set($this->dataclass->getListFromCollection($_REQUEST["collection_id"]));
        }
}
