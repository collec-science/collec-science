<?php

namespace Ppci\Libraries;


class Template extends PpciLibrary
{
    function __construct()
    {
        parent::__construct();
        $this->dataclass = new \Ppci\Models\PpciModel();
        $this->keyName = "id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function list()
    {
        $vue = service("Smarty");
        $vue->set($this->dataclass->getList(), "data");
        $vue->set("templateList.tpl", "corps");
        return $vue->send();
    }
    function display()
    {
        $vue = service("Smarty");
        $vue->set($this->dataclass->lire($this->id), "data");
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
