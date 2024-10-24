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
        $this->dataclass = new \Ppci\Models\Aclaco();
        $this->keyName = "aclaco_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
        
    }
    function display()
    {
        $vue = service("Smarty");
        $vue->set($this->dataclass->lire($this->id), "data");
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
            return true;
        } catch (\Exception) {
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
}
