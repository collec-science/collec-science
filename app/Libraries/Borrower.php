<?php

namespace App\Libraries;

use App\Models\Borrower as ModelsBorrower;
use App\Models\Subsample;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Borrower extends PpciLibrary
{
    /**
     * @var ModelsBorrower
     */
    protected PpciModel $dataclass;

    

function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsBorrower();
        $this->keyName = "borrower_id";
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
        $this->vue->set("param/borrowerList.tpl", "corps");
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->lire($this->id), "data");
        $this->vue->set($this->dataclass->getBorrowings($this->id), "borrowings");
        $this->vue->set("param/borrowerDisplay.tpl", "corps");
        /**
         * Get the list of borrows of subsamples
         */
        $subsample = new Subsample();
        $this->vue->set($subsample->getListFromBorrower($this->id), "subsamples");
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
        $this->dataRead($this->id, "param/borrowerChange.tpl");
        return $this->vue->send();
    }
    function write()
    {
        /*
         * write record in database
         */
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
