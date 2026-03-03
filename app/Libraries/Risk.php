<?php

namespace App\Libraries;

use App\Models\Risk as ModelsRisk;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Risk extends PpciLibrary
{
    /**
     * @var ModelsRisk
     */
    protected PpciModel $dataclass;

    

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsRisk();
        $this->keyName = "risk_id";
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
        $this->vue->set("param/riskList.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "param/riskChange.tpl");
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
}
