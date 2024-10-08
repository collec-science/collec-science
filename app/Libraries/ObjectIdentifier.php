<?php

namespace App\Libraries;

use App\Models\IdentifierType;
use App\Models\ObjectClass;
use App\Models\ObjectIdentifier as ModelsObjectIdentifier;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class ObjectIdentifier extends PpciLibrary
{
    /**
     * @var ModelsObjectIdentifier
     */
    protected PpciModel $dataclass;

    

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsObjectIdentifier;
        $this->keyName = "object_identifier_id";
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
        $this->dataRead($this->id, "gestion/objectIdentifierChange.tpl", $_REQUEST["uid"]);
        $this->vue->set($_SESSION["moduleParent"], "moduleParent");
        $this->vue->set("tab-id", "activeTab");
        /*
         * Recherche des types 
         */
        $identifierType = new IdentifierType();
        $this->vue->set($identifierType->getListe("identifier_type_code"), "identifierType");
        /*
         * Lecture de l'object concerne
         */
        $object = new ObjectClass();
        $this->vue->set($object->lire($_REQUEST["uid"]), "object");
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
