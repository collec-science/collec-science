<?php
namespace Ppci\Libraries;

class Aclgroup extends PpciLibrary
{
    function __construct()
    {
        parent::__construct();
        $this->dataclass = new \Ppci\Models\Aclgroup();
        $this->keyName = "aclgroup_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
        
    }
    function list()
    {
        $vue = service("Smarty");
        $vue->set($this->dataclass->getGroups(), "data");
		$vue->set("ppci/droits/groupList.tpl", "corps");
        return $vue->send();
    }
    function change()
    {
        $vue = service("Smarty");
        empty($_REQUEST["aclgroup_id_parent"]) ? $parent_id = 0 : $parent_id = $_REQUEST["aclgroup_id_parent"];
        $this->dataRead( $this->id, "ppci/droits/groupChange.tpl", $parent_id);
        $acllogin = new \Ppci\Models\Acllogin();
		$vue->set($acllogin->getAllFromGroup($this->id), "logins");
		/**
		 * Get the list of the groups
		 */
		$vue->set($this->dataclass->getGroups(), "groups");
        return $vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite( $_REQUEST);
            return true;
        } catch (\Exception $e) {
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
