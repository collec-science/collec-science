<?php

namespace Ppci\Libraries;

use Ppci\Models\Request as RequestModel;

class Request extends PpciLibrary
{
    function __construct()
    {
        parent::__construct();
        $this->dataClass = new RequestModel();
        $keyName = "request_id";
        if (!empty($_REQUEST[$keyName])) {
            $this->id = $_REQUEST[$keyName];
        } else {
            $this->id = 0;
        }
    }
    function list()
    {
        $vue = service("Smarty");
        $vue->set($this->dataClass->getList(2), "data");
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
        $vue->set($this->dataClass->lire($this->id), "data");
        $vue->set("ppci/request/requestChange.tpl", "corps");
        try {
            $vue->set($this->dataClass->exec($this->id), "result");
            return $vue->send();
        } catch (\Exception $e) {
            $this->message->set($e->getMessage());
            return $this->change();
        }
    }
    function write()
    {
        try {
            $_REQUEST["body"] = hex2bin($_REQUEST["body"]);
            $this->id = $this->dataWrite($_REQUEST);
            return $this->change();
        } catch (\Exception $e) {
            return $this->change();
        }
    }
    function writeExec()
    {
        try {
            $_REQUEST["body"] = hex2bin($_REQUEST["body"]);
            $this->id = $this->dataWrite($_REQUEST);
            return $this->exec();
        } catch (\Exception $e) {
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->dataDelete($this->id)) {
            return $this->list();
        } else {
            return $this->change();
        }
    }
    function copy() {
        $data = $this->dataRead(0, "ppci/request/requestChange.tpl");
        if ($this->id > 0) {
            $dinit = $this->dataClass->lire($this->id);
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
