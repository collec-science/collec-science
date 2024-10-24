<?php

namespace App\Libraries;

use App\Models\Import;
use App\Models\Metadata as ModelsMetadata;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Metadata extends PpciLibrary
{
    /**
     * @var ModelsMetadata
     */
    protected PpciModel $dataclass;

    

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsMetadata();
        $this->keyName = "metadata_id";
        if (isset($_REQUEST[$this->keyName])&&!is_array($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function list()
    {
        $this->vue = service('Smarty');
        /*
         * Display the list of all records of the table
         */
        try {
            $this->vue->set($this->dataclass->getListe(2), "data");
            $this->vue->set("param/metadataList.tpl", "corps");
        } catch (PpciException $e) {
            $this->message->set($e->getMessage());
        }
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        $data = $this->dataclass->lire($this->id);
        $this->vue->set($data, "data");
        $this->vue->set(json_decode($data["metadata_schema"], true), "metadata");
        $this->vue->set("param/metadataDisplay.tpl", "corps");
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
        $this->dataRead($this->id, "param/metadataChange.tpl");
        return $this->vue->send();
    }
    function write()
    {
        try {
            $_REQUEST["metadata_schema"] = hex2bin($_REQUEST["metadata_schema"]);
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
    function copy()
    {
        $this->vue = service('Smarty');
        /*
         * Duplication d'une etiquette
         */
        $data = $this->dataclass->lire($this->id);
        $data["metadata_id"] = 0;
        $data["metadata_name"] .= " - new version";
        $this->vue->set($data, "data");
        $this->vue->set("param/metadataChange.tpl", "corps");
        return $this->vue->send();
    }
    function getSchema()
    {
        $this->vue = service("AjaxView");
        $data = $this->dataclass->lire($this->id);
        $this->vue->setJson($data["metadata_schema"]);
        return $this->vue->send();
    }
    function export()
    {
        $this->vue = service('CsvView');
        $this->vue->set($this->dataclass->getListFromIds($_POST["metadata_id"]));
        return $this->vue->send();
    }
    function import()
    {
        if (file_exists($_FILES['upfile']['tmp_name'])) {
            try {
                $import = new Import($_FILES['upfile']['tmp_name'], ";", false, array(
                    "metadata_name",
                    "metadata_schema",
                    "metadata_id"
                ));
                $rows = $import->getContentAsArray();
                foreach ($rows as $row) {
                    $data = array(
                        "metadata_name" => $row["metadata_name"],
                        "metadata_schema" => $row["metadata_schema"],
                        "metadata_id" => 0
                    );
                    $this->dataclass->ecrire($data);
                }
                $this->message->set(_("Métadonnée(s) importée(s)"));
            } catch (PpciException $e) {
                $this->message->set(_("Impossible d'importer les métadonnées"));
                $this->message->set($e->getMessage());
            }
        } else {
            $this->message->set(_("Impossible de charger le fichier à importer"));
        }
    }
}
