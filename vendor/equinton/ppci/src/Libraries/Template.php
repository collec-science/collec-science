<?php

namespace Ppci\Libraries;


class Template extends PpciLibrary
{
    function __construct()
    {
        parent::__construct();
        $this->dataClass = new \Ppci\Models\PpciModel();
        $keyName = "id";
        if (isset($_REQUEST[$keyName])) {
            $this->id = $_REQUEST[$keyName];
        }
    }
    function list()
    {
        $vue = service("Smarty");
        $vue->set($this->dataClass->getList(), "data");
        $vue->set("templateList.tpl", "corps");
        return $vue->send();
    }
    function display()
    {
        $vue = service("Smarty");
        $vue->set($this->dataClass->lire($this->id), "data");
        $vue->set("templateDisplay.tpl", "corps");
    }
    function change()
    {
        $vue = service("Smarty");
        $this->dataRead($this->id, "templateChange.tpl", $_REQUEST["parent_id"]);
        return $vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
            return $this->display();
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
}
