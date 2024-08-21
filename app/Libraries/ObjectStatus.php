<?php

namespace App\Libraries;

use App\Models\ObjectStatus as ModelsObjectStatus;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class ObjectStatus extends PpciLibrary
{
    /**
     * @var ModelsObjectStatus
     */
    protected PpciModel $dataclass;

    private $keyName;

    function __construct()
    {
        parent::__construct();
        $this->dataClass = new ModelsObjectStatus();
        $this->keyName = "object_status_id";
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
        $this->vue->set($this->dataclass->getListe(2), "data");
        $this->vue->set("param/objectStatusList.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        if ($this->id > 0) {
            $this->dataRead($this->id, "param/objectStatusChange.tpl");
        } else {
            $this->message->set(_("La création d'un nouveau statut est interdite"), true);
        }
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
}
