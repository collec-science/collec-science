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
include_once 'modules/classes/export/datasetTemplate.class.php';
$this->dataclass = new DatasetTemplate();
$this->keyName = "dataset_template_id";
$this->id = $_REQUEST[$this->keyName];


  function list(){
$this->vue=service('Smarty');
    /*
		 * Display the list of all records of the table
		 */
    $this->vue->set($this->dataclass->getListe(2), "data");
    $this->vue->set("export/datasetTemplateList.tpl", "corps");
    }
  function display(){
$this->vue=service('Smarty');
    /*
		 * Display the detail of the record
		 */
    $this->vue->set($this->dataclass->getDetail($this->id), "data");
    $this->vue->set("export/datasetTemplateDisplay.tpl", "corps");
    include_once "modules/classes/export/datasetColumn.class.php";
    $dc = new DatasetColumn();
    $this->vue->set($dc->getListFromParent($this->id), "columns");
    }
  function change(){
$this->vue=service('Smarty');
    /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record 
		 */
    $this->dataRead( $this->id, "export/datasetTemplateChange.tpl");
    require_once "modules/classes/export/datasetType.class.php";
    require_once "modules/classes/export/exportFormat.class.php";
    $dt = new DatasetType();
    $this->vue->set($dt->getListe(1), "datasetTypes");
    $ef = new ExportFormat();
    $this->vue->set($ef->getListe(1), "exportFormats");
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
    if ($this->id > 0) {
      $_REQUEST[$this->keyName] = $this->id;
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
    }
  function duplicate() {
    try {
      $bdd->beginTransaction();
      $_REQUEST[$this->keyName] = $this->dataclass->duplicate($this->id);
      $module_coderetour = 1;
      $bdd->commit();
    } catch (Exception $e) {
      $module_coderetour = -1;
      $this->message->set($e->getMessage(), true);
      $bdd->rollback();
    }
}
