<?php
namespace Ppci\Libraries;

class Aclappli extends PpciLibrary
{
    function __construct()
    {
        parent::__construct();
        $this->dataClass = new \Ppci\Models\Aclappli();
        $keyName = "aclappli_id";
        if (isset($_REQUEST[$keyName])) {
            $this->id = $_REQUEST[$keyName];
        }
        
    }
    function list()
    {
        $vue = service("Smarty");
        $vue->set($this->dataClass->getListe(2), "data");
        $vue->set("ppci/droits/appliList.tpl", "corps");
        return $vue->send();
    }
    function display()
    {
        $vue = service("Smarty");
        $vue->set($this->dataClass->lire($this->id), "data");
        $vue->set("ppci/droits/appliDisplay.tpl", "corps");
        $aclAco = new \Ppci\Models\Aclaco();
        $vue->set($aclAco->getListFromParent($this->id, 3), "dataAco");
        $this->appConfig->GACL_disable_new_right == 1 ? $vue->set(0, "newRightEnabled") : $vue->set(1, "newRightEnabled");
        return $vue->send();
    }
    function change()
    {
        $vue = service("Smarty");
        $this->dataRead( $this->id, "ppci/droits/appliChange.tpl");
        return $vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite( $_REQUEST);
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
