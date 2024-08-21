<?php

namespace App\Libraries;

use App\Models\Printer as ModelsPrinter;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Printer extends PpciLibrary
{
    /**
     * @var ModelsPrinter
     */
    protected PpciModel $dataclass;

    private $keyName;

    function __construct()
    {
        parent::__construct();
        $this->dataClass = new ModelsPrinter();
        $this->keyName = "printer_id";
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
        $this->vue->set($this->dataclass->getListe(), "data");
        $this->vue->set("param/printerList.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "param/printerChange.tpl");
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
        } catch (PpciException) {
            return $this->change();
        }
    }
}
