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
include_once 'modules/classes/export/translator.class.php';
$this->dataclass = new Translator();
$this->keyName = "translator_id";
$this->id = $_REQUEST[$this->keyName];


  function list(){
$this->vue=service('Smarty');
    /*
		 * Display the list of all records of the table
		 */
    $this->vue->set($this->dataclass->getListe(2), "data");
    $this->vue->set("export/translatorList.tpl", "corps");
    }
  function display(){
$this->vue=service('Smarty');
    /*
		 * Display the detail of the record
		 */
    $this->vue->set($this->dataclass->lire($this->id), "data");
    $this->vue->set("export/translatorDisplay.tpl", "corps");
    }
  function change(){
$this->vue=service('Smarty');
    /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record 
		 */
    $data = $this->dataRead( $this->id, "export/translatorChange.tpl");
    /**
     * Generate an array from translator_data
     */
    $td = json_decode($data["translator_data"], true);
    $items = array();
    foreach ($td as $row) {
      foreach ($row as $k => $v) {
        $items[] = array("name" => $k, "value" => $v);
      }
    }
    $this->vue->set($items, "items");
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
    /**
     * Regenerate json data from items
     */
    $nb = count($_POST["name"]);
    $items = array();
    for ($i = 0; $i < $nb; $i++) {
      if (strlen($_POST["name"][$i]) > 0) {
        $items[][$_POST["name"][$i]] = htmlspecialchars_decode($_POST["value"][$i]);
      }
    }
    $data = $_REQUEST;
    $data["translator_data"] = json_encode($items);
    $this->id = $this->dataWrite( $data);
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
}
