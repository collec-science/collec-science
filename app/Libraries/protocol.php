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
 * Created : 13 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/protocol.class.php';
$this->dataclass = new Protocol();
$this->keyName = "protocol_id";
$this->id = $_REQUEST[$this->keyName];


    function list(){
$this->vue=service('Smarty');

        $this->vue->set($this->dataclass->getListe(), "data");
        $this->vue->set("param/protocolList.tpl", "corps");
        }
    function change(){
$this->vue=service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->dataRead( $this->id, "param/protocolChange.tpl");
        require_once 'modules/classes/collection.class.php';
        $collection = new Collection();
        $this->vue->set($collection->getListe(2), "collections");
        $this->vue->set($APPLI_max_file_size, "maxFileSize");
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
            $bdd->beginTransaction();
            $this->id = $this->dataWrite( $_POST, true);
            if ($this->id > 0) {
                if ($_FILES["protocol_file"]["error"] == 1) {
                    throw new FileException(_("Problème rencontré pendant le téléchargement du fichier joint"), true);
                }
                /*
                 * Traitement du fichier eventuellement joint
                 */
                if ($_FILES["protocol_file"]["size"] > 0) {
                    try {
                        $this->dataclass->ecrire_document($this->id, $_FILES["protocol_file"]);
                    } catch (FileException $fe) {
                        throw new FileException($fe->getMessage());
                    } catch (Exception $e) {
                        $this->message->setSyslog($e->getMessage());
                        throw new FileException(_("impossible d'enregistrer la pièce jointe"));
                    }
                }
                if ($_POST["documentDelete"] == 1) {
                    $this->dataclass->documentDelete($this->id);
                }
                $_REQUEST[$this->keyName] = $this->id;
                $module_coderetour = 1;
                $bdd->commit();
                $this->message->set(_("Enregistrement effectué"));
            }
        } catch (Exception $e) {
            $bdd->rollback();
            $module_coderetour = -1;
            $this->message->set($e->getMessage(), true);
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
    function file() {
        try {
            $ref = $this->dataclass->getProtocolFile($this->id);
            //$this->vue->setDisposition("inline");
            $this->vue->setFileReference($ref);
        } catch (Exception $e) {
            $module_coderetour = -1;
            $this->message->set($e->getMessage(), true);
            unset($this->vue);
        }
        }
}
?>