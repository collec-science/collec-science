<?php

namespace App\Libraries;

use App\Models\DatasetColumn as ModelsDatasetColumn;
use App\Models\DatasetTemplate;
use App\Models\Translator;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class DatasetColumn extends PpciLibrary
{
    /**
     * @var ModelsDatasetColumn
     */
    protected PpciModel $dataclass;

    
    private $parentId;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsDatasetColumn();
        $this->keyName = "dataset_column_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
        $this->parentId = $_REQUEST["dataset_template_id"];
    }

    function change()
    {
        $this->vue = service('Smarty');
        /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
        $this->dataRead($this->id, "export/datasetColumnChange.tpl", $this->parentId);
        /**
         * Get the list of all columns
         */
        $this->vue->set($this->dataclass->getListFromParent($this->parentId), "columns");
        /**
         * Get the template record
         */
        $datasetTemplate = new DatasetTemplate();
        $this->vue->set($dt = $datasetTemplate->getDetail($this->parentId), "template");
        $fields = json_decode($dt["fields"], true);
        asort($fields);
        $this->vue->set($fields, "fields");
        /**
         * Get the translators
         */
        $translator = new Translator();
        $this->vue->set($translator->getListe(2), "translators");
        return $this->vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
            }
        } catch (PpciException) {
            return false;
        }
        return false;
    }

    function delete()
    {
        /*
		 * delete record
		 */
        try {
            $this->dataDelete($this->id);
            $_REQUEST[$this->keyName] = 0;
        } catch (PpciException) {
        }
        return false;
    }
}
