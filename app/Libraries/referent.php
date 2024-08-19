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


require_once 'modules/classes/referent.class.php';
$this->dataclass = new Referent();
$this->keyName = "referent_id";
$this->id = $_REQUEST[$this->keyName];


    function list(){
$this->vue=service('Smarty');
        /*
         * Display the list of all records of the table
         */
        $this->vue->set($this->dataclass->getListe(3), "data");
        $this->vue->set("param/referentList.tpl", "corps");
        }
    function change(){
$this->vue=service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->dataRead( $this->id, "param/referentChange.tpl");
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
    function getFromName() {
        /*
         * Recherche un referent a partir de son nom,
         * et retourne le tableau sous forme Ajax
         */
        $this->vue->set($this->dataclass->getFromName($_REQUEST["referent_name"]));
        }
    function getFromId() {
        $this->vue->set($this->dataclass->lire($_REQUEST["referent_id"]));
        }
    function copy() {
        $data = $this->dataclass->lire($this->id);
        $data["referent_id"] = 0;
        $data["referent_name"] = "";
        $this->vue->set($data, "data");
        $this->vue->set("param/referentChange.tpl", "corps");
        }
}
