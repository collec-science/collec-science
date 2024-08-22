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
        $this->dataclass = new XXX();
        $this->keyName = "xxx_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

/**
 * Created : 28 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/objectIdentifier.class.php';
$this->dataclass = new ObjectIdentifier();
$this->keyName = "object_identifier_id";
$this->id = $_REQUEST[$this->keyName];

    function change(){
$this->vue=service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->dataRead( $this->id, "gestion/objectIdentifierChange.tpl", $_REQUEST["uid"]);
        $this->vue->set($_SESSION["moduleParent"], "moduleParent");
        $this->vue->set("tab-id", "activeTab");
        /*
         * Recherche des types 
         */
        require_once 'modules/classes/identifierType.class.php';
        $this->identifierType = new IdentifierType();
        $this->vue->set($this->identifierType->getListe("identifier_type_code"), "identifierType");
        /*
         * Lecture de l'object concerne
         */
        require_once 'modules/classes/object.class.php';
        $object = new ObjectClass();
        $this->vue->set($object->lire($_REQUEST["uid"]), "object");

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
?>