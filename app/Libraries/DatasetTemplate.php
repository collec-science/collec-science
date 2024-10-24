<?php

namespace App\Libraries;

use App\Models\DatasetColumn;
use App\Models\DatasetTemplate as ModelsDatasetTemplate;
use App\Models\DatasetType;
use App\Models\ExportFormat;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class DatasetTemplate extends PpciLibrary
{
    /**
     * @var ModelsDatasetTemplate
     */
    protected PpciModel $dataclass;

    

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsDatasetTemplate();
        $this->keyName = "dataset_template_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function list()
    {
        $this->vue = service('Smarty');
        /**
         * Display the list of all records of the table
         */
        $this->vue->set($this->dataclass->getListe(2), "data");
        $this->vue->set("export/datasetTemplateList.tpl", "corps");
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        /**
         * Display the detail of the record
         */
        $this->vue->set($this->dataclass->getDetail($this->id), "data");
        $this->vue->set("export/datasetTemplateDisplay.tpl", "corps");
        $dc = new DatasetColumn();
        $this->vue->set($dc->getListFromParent($this->id), "columns");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        /**
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record 
         */
        $this->dataRead($this->id, "export/datasetTemplateChange.tpl");
        $dt = new DatasetType();
        $this->vue->set($dt->getListe(1), "datasetTypes");
        $ef = new ExportFormat();
        $this->vue->set($ef->getListe(1), "exportFormats");
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
    function duplicate()
    {
        try {
            $db = $this->dataclass->db;
            $db->transBegin();
            $_REQUEST[$this->keyName] = $this->dataclass->duplicate($this->id);
            $db->transCommit();
            return false;
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            if ($db->transEnabled) {
                $db->transRollback();
            }
            return true;
        }
    }
}
