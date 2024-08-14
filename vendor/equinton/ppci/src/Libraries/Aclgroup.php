<?php
namespace Ppci\Libraries;

class Aclgroup extends PpciLibrary
{
    function __construct()
    {
        parent::__construct();
        $this->dataClass = new \Ppci\Models\Aclgroup();
        $keyName = "aclgroup_id";
        if (isset($_REQUEST[$keyName])) {
            $this->id = $_REQUEST[$keyName];
        }
        
    }
    function list()
    {
        $vue = service("Smarty");
        $vue->set($this->dataClass->getGroups(), "data");
		$vue->set("ppci/droits/groupList.tpl", "corps");
        return $vue->send();
    }
    function display() {
        $vue = service("Smarty");
        $vue->set($this->dataClass->lire($this->id), "data");
		$vue->set("ppci/droits/groupDisplay.tpl", "corps");
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
		$vue->set($this->dataClass->getGroups(), "groups");
        return $vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite( $_REQUEST);
            return $this->list();
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
