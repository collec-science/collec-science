<?php

namespace App\Libraries;

use App\Models\Referent as ModelsReferent;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Referent extends PpciLibrary
{
    /**
     * @var ModelsReferent
     */
    protected PpciModel $dataclass;

    

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsReferent();
        $this->keyName = "referent_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function list()
    {
        $this->vue = service('Smarty');
        /*
         * Display the list of all records of the table
         */
        $this->vue->set($this->dataclass->getListe(3), "data");
        $this->vue->set("param/referentList.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "param/referentChange.tpl");
        return $this->vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return true;
            } else {
                return false;
            }
        } catch (PpciException) {
            return false;
        }
    }
    function delete()
    {
        /*
         * delete record
         */
        try {
            $this->dataDelete($this->id);
            return true;
        } catch (PpciException $e) {
            return false;
        }
    }
    function getFromName()
    {
        /*
         * Recherche un referent a partir de son nom,
         * et retourne le tableau sous forme Ajax
         */
        $this->vue = service("AjaxView");
        $this->vue->set($this->dataclass->getFromName($_REQUEST["referent_name"]));
        return $this->vue->send();
    }
    function getFromId()
    {
        $this->vue = service("AjaxView");
        $this->vue->set($this->dataclass->lire($_REQUEST["referent_id"]));
        return $this->vue->send();
    }
    function copy()
    {
        $data = $this->dataclass->lire($this->id);
        $data["referent_id"] = 0;
        $data["referent_name"] = "";
        $this->vue = service('Smarty');
        $this->vue->set($data, "data");
        $this->vue->set("param/referentChange.tpl", "corps");
        return $this->vue->send();
    }
}
