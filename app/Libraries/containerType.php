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
 * Created : 3 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/containerType.class.php';
$this->dataclass = new ContainerType();
$this->keyName = "container_type_id";
$this->id = $_REQUEST[$this->keyName];


    function list(){
$this->vue=service('Smarty');
        /*
         * Display the list of all records of the table
         */
        $this->vue->set($this->dataclass->getListe("container_type_name"), "data");
        $this->vue->set("param/containerTypeList.tpl", "corps");
        }
    function change(){
$this->vue=service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->dataRead( $this->id, "param/containerTypeChange.tpl");
        /*
         * Lecture des tables associees pour les select
         */
        require_once 'modules/classes/containerFamily.class.php';
        require_once 'modules/classes/storageCondition.class.php';
        require_once 'modules/classes/containerType.class.php';
        require_once 'modules/classes/label.class.php';
        $containerFamily = new ContainerFamily();
        $storageCondition = new StorageCondition();
        $label = new Label();
        $this->vue->set($storageCondition->getListe(2), "storageCondition");
        $this->vue->set($containerFamily->getListe(2), "containerFamily");
        $this->vue->set($label->getListe(2), "labels");
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
    function getFromFamily() {
        /*
         * Recherche la liste a partir de la famille
         */
        $this->vue->set($this->dataclass->getListFromParent($_REQUEST["container_family_id"], 2));
        }
    function listAjax() {
        $this->vue->set($this->dataclass->getListe("container_type_name"));
        }
}
