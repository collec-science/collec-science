<?php

namespace App\Libraries;

use App\Models\ContainerFamily;
use App\Models\ContainerType as ModelsContainerType;
use App\Models\Label;
use App\Models\StorageCondition;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class ContainerType extends PpciLibrary
{
    /**
     * @var ModelsContainerType
     */
    protected PpciModel $dataclass;

    private $keyName;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsContainerType();
        $this->keyName = "container_type_id";
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
        $this->vue->set($this->dataclass->getListe("container_type_name"), "data");
        $this->vue->set("param/containerTypeList.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->dataRead($this->id, "param/containerTypeChange.tpl");
        /*
         * Lecture des tables associees pour les select
         */
        $containerFamily = new ContainerFamily();
        $storageCondition = new StorageCondition();
        $label = new Label();
        $this->vue->set($storageCondition->getListe(2), "storageCondition");
        $this->vue->set($containerFamily->getListe(2), "containerFamily");
        $this->vue->set($label->getListe(2), "labels");
        return $this->vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return $this->list();
            } else {
                return $this->change();
            }
        } catch (PpciException) {
            return $this->change();
        }
    }

    function delete()
    {
        /*
         * delete record
         */
        try {
            $this->dataDelete($this->id);
            return $this->list();
        } catch (PpciException $e) {
            return $this->change();
        }
    }
    function getFromFamily()
    {
        /*
         * Recherche la liste a partir de la famille
         */
        $this->vue = service("AjaxView");
        $this->vue->set($this->dataclass->getListFromParent($_REQUEST["container_family_id"], 2));
        return $this->vue->send();
    }
    function listAjax()
    {
        $this->vue = service("AjaxView");
        $this->vue->set($this->dataclass->getListe("container_type_name"));
        return $this->vue->send();
    }
}
