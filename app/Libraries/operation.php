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
 * Created : 14 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/operation.class.php';
$this->dataclass = new Operation();
$this->keyName = "operation_id";
$this->id = $_REQUEST[$this->keyName];

    function list(){
$this->vue=service('Smarty');
        $this->vue->set($this->dataclass->getListe(), "data");
        $this->vue->set("param/operationList.tpl", "corps");
        }
    function change(){
$this->vue=service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->dataRead( $this->id, "param/operationChange.tpl", $_REQUEST["protocol_id"]);
        /*
         * Recuperation de la liste des protocoles
         */
        require_once 'modules/classes/protocol.class.php';
        $protocol = new Protocol();
        $this->vue->set($protocol->getListe("protocol_year desc, protocol_name, protocol_version desc"), "protocol");
        /*
         * Vérification si échantillons existants pour cette opération
         */
        $this->vue->set($this->dataclass->getNbSample($this->id), "nbSample");
        /*
         * Recuperation de toutes les opérations
         */
        $this->vue->set($this->dataclass->getListe(1), "operations");
        /*
         * Recuperation de l'opération père
         */
        $this->vue->set($_REQUEST["operation_pere_id"], "operation_pere_id");
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
    function copy() {
        /*
         * Duplique une operation
         */
        $data = $this->dataclass->lire($this->id);
        $data["operation_id"] = 0;
        $data["operation_version"] = "";
        $this->vue->set($data, "data");
        $this->vue->set("param/operationChange.tpl", "corps");
        /*
         * Recuperation de la liste des protocoles
         */
        require_once 'modules/classes/protocol.class.php';
        $protocol = new Protocol();
        $this->vue->set($protocol->getListe("protocol_year desc, protocol_name, protocol_version desc"), "protocol");
        }

}

?>