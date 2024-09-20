<?php

namespace App\Libraries;

use App\Models\Translator as ModelsTranslator;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Translator extends PpciLibrary
{
    /**
     * @var ModelsTranslator
     */
    protected PpciModel $dataclass;

    private $keyName;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsTranslator();
        $this->keyName = "translator_id";
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
        $this->vue->set("export/translatorList.tpl", "corps");
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        /*
		 * Display the detail of the record
		 */
        $this->vue->set($this->dataclass->lire($this->id), "data");
        $this->vue->set("export/translatorDisplay.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $data = $this->dataRead($this->id, "export/translatorChange.tpl");
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
        return $this->vue->send();
    }
    function write()
    {
        try {
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
            $this->id = $this->dataWrite($data);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return $this->change();
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
        } catch (PpciException) {
            return $this->change();
        }
    }
}
