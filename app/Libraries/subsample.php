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
 * Created : 15 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/subsample.class.php';
$this->dataclass = new Subsample();
$this->keyName = "subsample_id";
$this->id = $_REQUEST[$this->keyName];

    function change(){
$this->vue=service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->dataRead( $this->id, "gestion/subsampleChange.tpl", $_REQUEST["sample_id"]);
        $this->vue->set($_SESSION["moduleParent"],"moduleParent");
        /*
         * Lecture de l'object concerne
         */
        require_once 'modules/classes/object.class.php';
        $object = new ObjectClass();
        $this->vue->set($object->lire($_REQUEST["uid"]) , "object");
        /**
         * Get the list of borrowers
         */
        require_once "modules/classes/borrower.class.php";
        $borrower = new Borrower();
        $this->vue->set($borrower->getListe(), "borrowers");
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
        //$this->dataclass->debug_mode = 2;
        $this->id = $this->dataWrite( $_REQUEST, false);
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
}
