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
 * Created : 11 déc. 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
require_once 'modules/request/request.class.php';
$this->dataclass = new request();
$this->keyName = "request_id";
$this->id = $_REQUEST[$this->keyName];
$requestForm = "request/requestChange.tpl";

    function list(){
$this->vue=service('Smarty');
        /*
         * Display the list of all records of the table
         */
        if ($_SESSION["droits"]["param"] == 1) {
            $this->vue->set($this->dataclass->getListe(2), "data");
        } else if ($_SESSION["droits"]["gestion"] == 1) {
            $this->vue->set($this->dataclass->getListFromCollections($_SESSION["collections"]), "data");
        }

        $this->vue->set("request/requestList.tpl", "corps");
        }
    function change(){
$this->vue=service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        if (empty($this->id)) {
            $this->id = 0;
        }
        $this->dataRead( $this->id, $requestForm);
        $this->vue->set($_SESSION["collections"], "collections");
        }
    function execList() {
    function exec() {
        $requestItem = $this->dataclass->lire($this->id);
        $this->vue->set($requestForm, "corps");
        $execOk = true;
        if ($_SESSION["droits"]["param"] != 1) {
            /**
             * Verify the rights of execution
             */
            if (empty($requestItem["collection_id"]) || !collectionVerify($requestItem["collection_id"])) {
                $this->vue->set("request/requestList.tpl", "corps");
                $this->message->set(_("Vous ne disposez pas des droits requis pour exécuter la requête"), true);
                $execOk = false;
            }
        }
        if ($execOk) {
            $this->vue->set($requestItem, "data");
            try {
                $this->vue->set($this->dataclass->exec($this->id), "result");
            } catch (Exception $e) {
                $this->message->set($e->getMessage());
            }
        }
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
            $_REQUEST["body"] = hex2bin($_REQUEST["body"]);
            $this->id = $this->dataclass->ecrire( $_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                $module_coderetour = 1;
            }
        } catch (ObjetBDDException $oe) {
            $this->message->set($oe->getMessage(), true);
            $module_coderetour = -1;
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
        $data = $this->dataRead( 0, $requestForm);
        if ($this->id > 0) {
            $dinit = $this->dataclass->lire($this->id);
            if ($dinit["request_id"] > 0) {
                $data["body"] = $dinit["body"];
                $data["datefields"] = $dinit["datefields"];
                $this->vue->set($data, "data");
            }
        }
        }
    default:
}
