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
include_once 'modules/exportmodel/exportmodel.class.php';
$this->dataclass = new ExportModel();
$this->keyName = "export_model_id";
$this->id = $_REQUEST[$this->keyName];


    function list(){
$this->vue=service('Smarty');
        $this->vue->set($this->dataclass->getListe("export_model_name"), "data");
        $this->vue->set("exportmodel/exportModelList.tpl", "corps");
        }
    function display(){
$this->vue=service('Smarty');
        $data = $this->dataclass->lire($this->id);
        $this->vue->set($data, "data");
        $this->vue->set(json_decode($data["pattern"], true), "pattern");
        $this->vue->set("exportmodel/exportModelDisplay.tpl", "corps");
        }
    function change(){
$this->vue=service('Smarty');
        $this->dataRead( $this->id, "exportmodel/exportModelChange.tpl");
        }
    function duplicate() {
        $data = $this->dataclass->lire($this->id);
        $data["export_model_id"] = 0;
        $data["export_model_name"] .= " - copy";
        $this->vue->set($data, "data");
        $this->vue->set("param/exportModelChange.tpl", "corps");
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
        $this->id = $this->dataWrite( $_REQUEST);
        if ($this->id > 0) {
            $_REQUEST[$this->keyName] = $this->id;
        }
        }
    function delete(){
         try {
            $this->dataDelete($this->id);
            return $this->list();
        } catch (PpciException $e) {
            return $this->change();
        }
        }
}
