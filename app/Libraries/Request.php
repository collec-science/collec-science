<?php

namespace App\Libraries;

use App\Models\Request as ModelsRequest;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Request extends PpciLibrary
{
    /**
     * @var ModelsRequest
     */
    protected PpciModel $dataclass;

    
    private $requestForm = "request/requestChange.tpl";

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsRequest;
        $this->keyName = "request_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function list()
    {
        $this->vue = service('Smarty');
        /*
         * Display the list of all records of the table
         */
        if ($_SESSION["userRights"]["param"] == 1) {
            $this->vue->set($this->dataclass->getListe(2), "data");
        } else if ($_SESSION["userRights"]["manage"] == 1) {
            $this->vue->set($this->dataclass->getListFromCollections($_SESSION["collections"]), "data");
        }
        $this->vue->set("request/requestList.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        if (empty($this->id)) {
            $this->id = 0;
        }
        $this->dataRead($this->id, $this->requestForm);
        $this->vue->set($_SESSION["collections"], "collections");
        return $this->vue->send();
    }
    function execList()
    {
        return $this->exec();
    }
    function exec()
    {
        $this->vue = service('Smarty');
        $requestItem = $this->dataclass->lire($this->id);
        $this->vue->set($this->requestForm, "corps");
        $execOk = true;
        if ($_SESSION["userRights"]["param"] != 1) {
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
            } catch (PpciException $e) {
                $this->message->set($e->getMessage(),true);
            }
        }
        return $this->vue->send();
    }
    function execCsv() {
        $this->vue = service('CsvView');
        $requestItem = $this->dataclass->lire($this->id);
        if ($_SESSION["userRights"]["param"] != 1) {
            /**
             * Verify the rights of execution
             */
            if (empty($requestItem["collection_id"]) || !collectionVerify($requestItem["collection_id"])) {
                throw new PpciException (_("Vous ne disposez pas des droits requis pour exécuter la requête"));
            }
        }
        $this->vue->set($this->dataclass->exec($this->id));
        return $this->vue->send($_SESSION["dbparams"]["APPLI_code"]."-".date("Y-m-d-Hi"), "\t");
    }
    function write()
    {
        try {
            $_REQUEST["body"] = hex2bin($_REQUEST["body"]);
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
            }
            return true;
        } catch (PpciException) {
            return false;
        }
        //return false;
    }
    function delete()
    {
        /*
         * delete record
         */
        try {
            $this->dataDelete($this->id);
            return true;
        } catch (PpciException) {
            return false;
        }
    }
    function copy()
    {
        $data = $this->dataRead(0, $this->requestForm);
        if ($this->id > 0) {
            $dinit = $this->dataclass->lire($this->id);
            if ($dinit["request_id"] > 0) {
                $data["body"] = $dinit["body"];
                $data["datefields"] = $dinit["datefields"];
                $this->vue->set($data, "data");
            }
        }
        return $this->vue->send();
    }
}
