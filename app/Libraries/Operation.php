<?php

namespace App\Libraries;

use App\Models\Operation as ModelsOperation;
use App\Models\Protocol;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Operation extends PpciLibrary
{
    /**
     * @var ModelsOperation
     */
    protected PpciModel $dataclass;

    private $keyName;

    function __construct()
    {
        parent::__construct();
        $this->dataClass = new ModelsOperation();
        $this->keyName = "operation_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function list()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->getListe(), "data");
        $this->vue->set("param/operationList.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "param/operationChange.tpl", $_REQUEST["protocol_id"]);
        /*
         * Recuperation de la liste des protocoles
         */
        $protocol = new Protocol();
        $this->vue->set($protocol->getListe("protocol_year desc, protocol_name, protocol_version desc"), "protocol");
        /*
         * Vérification si échantillons existants pour cette opération
         */
        $this->vue->set($this->dataclass->getNbSample($this->id), "nbSample");
        /*
         * Recuperation de toutes les opérations
         */
        $this->vue->set($this->dataclass->getListe(1), "operations");
        /*
         * Recuperation de l'opération père
         */
        $this->vue->set($_REQUEST["operation_pere_id"], "operation_pere_id");
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
    function copy()
    {
        $this->vue = service('Smarty');
        /*
         * Duplique une operation
         */
        $data = $this->dataclass->lire($this->id);
        $data["operation_id"] = 0;
        $data["operation_version"] = "";
        $this->vue->set($data, "data");
        $this->vue->set("param/operationChange.tpl", "corps");
        /*
         * Recuperation de la liste des protocoles
         */
        $protocol = new Protocol();
        $this->vue->set($protocol->getListe("protocol_year desc, protocol_name, protocol_version desc"), "protocol");
        return $this->vue->send();
    }
}
