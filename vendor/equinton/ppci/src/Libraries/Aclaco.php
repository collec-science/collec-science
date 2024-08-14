<?php
namespace Ppci\Libraries;

use Ppci\Libraries\Aclappli as LibrariesAclappli;
use Ppci\Models\Aclappli;
use Ppci\Models\Aclgroup;

class Aclaco extends PpciLibrary
{
    function __construct()
    {
        parent::__construct();
        $this->dataClass = new \Ppci\Models\Aclaco();
        $keyName = "aclaco_id";
        if (isset($_REQUEST[$keyName])) {
            $this->id = $_REQUEST[$keyName];
        }
        
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
        $data = $this->dataRead($this->id, "ppci/droits/acoChange.tpl", $_REQUEST["aclappli_id"]);
		$aclAppli = new Aclappli();
		$vue->set($aclAppli->lire($data["aclappli_id"]), "dataAppli");
		$aclgroup = new Aclgroup();
		$vue->set($aclgroup->getGroupsFromAco($this->id), "groupes");
        $this->appConfig->GACL_disable_new_right == 1 ? $vue->set(0, "newRightEnabled") : $vue->set(1, "newRightEnabled");
        return $vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite( $_POST);
            $appli = new LibrariesAclappli();
            return $appli->display();
        } catch (\Exception) {
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->dataDelete($this->id)) {
            return $this->display();
        } else {
            return $this->change();
        }
    }
}
