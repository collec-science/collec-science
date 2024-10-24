<?php

namespace App\Libraries;

use App\Models\Country;
use App\Models\Import;
use App\Models\SamplingPlace as ModelsSamplingPlace;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class SamplingPlace extends PpciLibrary
{
    /**
     * @var ModelsSamplingPlace
     */
    protected PpciModel $dataclass;

    

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsSamplingPlace();
        $this->keyName = "sampling_place_id";
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
        $this->vue->set($this->dataclass->getListFromCollection(0, false), "data");
        $this->vue->set("param/samplingPlaceList.tpl", "corps");
        $this->vue->set($_SESSION["collections"], "collections");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "param/samplingPlaceChange.tpl");
        MapInit::setDefault($this->vue);
        $this->vue->set($_SESSION["collections"], "collections");
        $country = new Country();
        $this->vue->set($country->getListe(2), "countries");
        $this->vue->set(1,"mapIsChange");
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
    function import()
    {
        if (file_exists($_FILES['upfile']['tmp_name'])) {
            $i = 0;
            try {
                $db = $this->dataclass->db;
                $db->transBegin();
                $import = new Import($_FILES['upfile']['tmp_name'], $_POST["separator"], false, array(
                    "name",
                    "code",
                    "x",
                    "y",
                    "country_code"
                ));
                $rows = $import->getContentAsArray();
                $country = new Country();
                foreach ($rows as $row) {
                    if (!empty($row["name"])) {
                        /*
                         * Ecriture en base, en mode ajout ou modification
                         */
                        $data = array(
                            "sampling_place_name" => $row["name"],
                            "collection_id" => $_POST["collection_id"],
                            "sampling_place_code" => $row["code"],
                            "sampling_place_x" => $row["x"],
                            "sampling_place_y" => $row["y"],
                            "sampling_place_id" => $this->dataclass->getIdFromName($row["name"])
                        );
                        if (!empty($row["country_code"])) {
                            $data["country_id"] = $country->getIdFromCode($row["country_code"]);
                        }
                        $this->dataclass->ecrire($data);
                        $i++;
                    }
                }
                $db->transCommit();
                $this->message->set(sprintf(_("%d lieu(x) importé(s)"), $i));
            } catch (PpciException $e) {
                $this->message->set(_("Impossible d'importer les lieux de prélèvement"),true);
                $this->message->set($e->getMessage());
                if ($db->transEnabled) {
                    $db->transRollback();
                }
            }
        } else {
            $this->message->set(_("Impossible de charger le fichier à importer"));
        }
    }
    function getFromCollection()
    {
        $this->vue = service("AjaxView");
        $this->vue->set($this->dataclass->getListFromCollection($_REQUEST["collection_id"]));
        return $this->vue->send();
    }
    function getCoordinate()
    {
        $this->vue = service("AjaxView");
        $this->vue->set($this->dataclass->getCoordinates($_REQUEST["sampling_place_id"]));
        return $this->vue->send();
    }
}
