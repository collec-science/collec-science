<?php

namespace Ppci\Libraries;

use Ppci\Models\Request as RequestModel;

class Request extends PpciLibrary
{
    function __construct()
    {
        parent::__construct();
        $this->dataclass = new RequestModel();
        $this->keyName = "request_id";
        if (!empty($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        } else {
            $this->id = 0;
        }
    }
    function list()
    {
        $vue = service("Smarty");
        $vue->set($this->dataclass->getList(2), "data");
        $vue->set("ppci/request/requestList.tpl", "corps");
        return $vue->send();
    }
    function change()
    {
        $vue = service("Smarty");
        $this->dataRead($this->id, "ppci/request/requestChange.tpl");
        return $vue->send();
    }
    function execList()
    {
        return $this->exec();
    }
    function exec()
    {
        $vue = service("Smarty");
        $vue->set($this->dataclass->lire($this->id), "data");
        $vue->set("ppci/request/requestChange.tpl", "corps");
        try {
            $vue->set($this->dataclass->exec($this->id), "result");
            return $vue->send();
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(),true);
            return $this->change();
        }
    }
    function execCsv() {
        $this->vue = service('CsvView');
        $this->vue->set($this->dataclass->exec($this->id));
        return $this->vue->send($_SESSION["dbparams"]["APPLI_code"]."-".date("Y-m-d-Hi"), "\t");
    }    
    function write()
    {
        try {
            $_REQUEST["body"] = hex2bin($_REQUEST["body"]);
            $this->id = $this->dataWrite($_REQUEST);
            return true;
        } catch (PpciException) {
            return false;
        }
    }
    function delete()
    {
        if ($this->dataDelete($this->id)) {
            return true;
        } else {
            return false;
        }
    }
    function copy() {
        $data = $this->dataRead(0, "ppci/request/requestChange.tpl");
        if ($this->id > 0) {
            $dinit = $this->dataclass->lire($this->id);
            if ($dinit["request_id"] > 0) {
                $data["body"] = $dinit["body"];
                $data["datefields"] = $dinit["datefields"];
                $vue = service ("Smarty");
                $vue->set($data, "data");
            }
        }
        return $vue->send();
    }
}
