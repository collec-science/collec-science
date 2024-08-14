<?php

namespace Ppci\Libraries;

use Ppci\Models\Aclgroup;

class Acllogin extends PpciLibrary
{
    function __construct()
    {
        parent::__construct();
        $this->dataClass = new \Ppci\Models\Acllogin();
        $keyName = "acllogin_id";
        if (isset($_REQUEST[$keyName])) {
            $this->id = $_REQUEST[$keyName];
        }
    }
    function list()
    {
        $vue = service("Smarty");
        $vue->set($this->dataClass->getListLogins(), "data");
        $vue->set("ppci/droits/loginList.tpl", "corps");
        return $vue->send();
    }
    function change()
    {
        $vue = service("Smarty");
        $data = $this->dataRead($this->id, "ppci/droits/loginChange.tpl");
        if (!empty($data["login"])) {
            $conf = service("IdentificationConfig");
            $vue->set($this->dataClass->getListDroits($data["login"], $this->appConfig->GACL_aco, $conf->LDAP), "loginDroits");
        }
        return $vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
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
