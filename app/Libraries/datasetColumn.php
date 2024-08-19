<?php 
namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Xx extends PpciLibrary { 
    /**
     * @var xx
     */
    protected PpciModel $dataclass;

    private $keyName;

function __construct()
    {
        parent::__construct();
        $this->dataClass = new XXX();
        $this->keyName = "xxx_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
include_once 'modules/classes/export/datasetColumn.class.php';
$this->dataclass = new DatasetColumn();
$this->keyName = "dataset_column_id";
$this->id = $_REQUEST[$this->keyName];
$parentId = $_REQUEST["dataset_template_id"];

  function change(){
$this->vue=service('Smarty');
    /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
    $this->dataRead( $this->id, "export/datasetColumnChange.tpl", $parentId);
    /**
     * Get the list of all columns
     */
    $this->vue->set($this->dataclass->getListFromParent($parentId), "columns");
    /**
     * Get the template record
     */
    include_once "modules/classes/export/datasetTemplate.class.php";
    $datasetTemplate = new DatasetTemplate();
    $this->vue->set($dt = $datasetTemplate->getDetail($parentId), "template");
    $fields = json_decode($dt["fields"],true);
    asort($fields);
    $this->vue->set($fields,"fields");
    /**
     * Get the translators
     */
    include_once "modules/classes/export/translator.class.php";
    $translator = new Translator();
    $this->vue->set($translator->getListe(2), "translators");
    }
      function write() {
    try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return $this->display();
            } else {
                return $this->change();
            }
        } catch (PpciException) {
            return $this->change();
        }
    }
    /*
		 * write record in database
		 */
    $this->id = $this->dataWrite( $_REQUEST);
    /**
     * Reset to 0 to create a new column
     */
    if ($module_coderetour == 1) {
      $_REQUEST[$this->keyName] = 0;
    }
    }
  function delete(){
    /*
		 * delete record
		 */
     try {
            $this->dataDelete($this->id);
            return $this->list();
        } catch (PpciException $e) {
            return $this->change();
        }
    if ($module_coderetour == 1) {
      $_REQUEST[$this->keyName] = 0;
    }
    }
}
