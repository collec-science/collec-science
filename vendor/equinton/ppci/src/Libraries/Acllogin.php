<?php

namespace Ppci\Libraries;

use Ppci\Models\Aclgroup;

class Acllogin extends PpciLibrary
{
    function __construct()
    {
        parent::__construct();
        $this->dataclass = new \Ppci\Models\Acllogin();
        $this->keyName = "acllogin_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function list()
    {
        $vue = service("Smarty");
        $vue->set($this->dataclass->getListLogins(), "data");
        $vue->set("ppci/droits/loginList.tpl", "corps");
        return $vue->send();
    }
    function change()
    {
        $vue = service("Smarty");
        $data = $this->dataRead($this->id, "ppci/droits/loginChange.tpl");
        if (!empty($data["login"])) {
            $conf = service("IdentificationConfig");
            $vue->set($this->dataclass->getListDroits($data["login"], $this->appConfig->GACL_aco, $conf->LDAP), "loginDroits");
        }
        return $vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
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
