<?php

namespace App\Libraries;

use App\Models\DatasetType as ModelsDatasetType;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class DatasetType extends PpciLibrary
{
    /**
     * @var ModelsDatasetType
     */
    protected PpciModel $dataclass;

    private $keyName;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsDatasetType();
        $this->keyName = "dataset_type_id";
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
        $this->vue->set("export/datasetTypeList.tpl", "corps");
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
        $this->dataRead($this->id, "export/datasetTypeChange.tpl", $_REQUEST["idParent"]);
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
