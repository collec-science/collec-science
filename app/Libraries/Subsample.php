<?php

namespace App\Libraries;

use App\Models\Borrower;
use App\Models\ObjectClass;
use App\Models\Subsample as ModelsSubsample;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Subsample extends PpciLibrary
{
    /**
     * @var ModelsSubsample
     */
    protected PpciModel $dataclass;

    private $keyName;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsSubsample();
        $this->keyName = "subsample_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function change()
    {
        $this->vue = service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->dataRead($this->id, "gestion/subsampleChange.tpl", $_REQUEST["sample_id"]);
        $this->vue->set($_SESSION["moduleParent"], "moduleParent");
        /*
         * Lecture de l'object concerne
         */
        $object = new ObjectClass();
        $this->vue->set($object->lire($_REQUEST["uid"]), "object");
        /**
         * Get the list of borrowers
         */
        $borrower = new Borrower();
        $this->vue->set($borrower->getListe(), "borrowers");
        return $this->vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                $sample = new Sample;
                return $sample->display();
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
            $sample = new Sample;
            return $sample->display();
        } catch (PpciException $e) {
            return $this->change();
        }
    }
}
