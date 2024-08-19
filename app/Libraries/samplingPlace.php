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

/**
 * Created : 2 févr. 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
require_once 'modules/classes/samplingPlace.class.php';
$this->dataclass = new SamplingPlace();
$this->keyName = "sampling_place_id";
$this->id = $_REQUEST[$this->keyName];


    function list(){
$this->vue=service('Smarty');
        /*
         * Display the list of all records of the table
         */
        $this->vue->set($this->dataclass->getListFromCollection(0, false), "data");
        $this->vue->set("param/samplingPlaceList.tpl", "corps");
        $this->vue->set($_SESSION["collections"], "collections");
        }
    function change(){
$this->vue=service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->dataRead( $this->id, "param/samplingPlaceChange.tpl");
        include 'modules/gestion/mapInit.php';
        $this->vue->set($_SESSION["collections"], "collections");
        include "modules/classes/country.class.php";
        $country = new Country();
        $this->vue->set($country->getListe(2), "countries");
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
    function import() {
        if (file_exists($_FILES['upfile']['tmp_name'])) {
            require_once 'modules/classes/import.class.php';
            $i = 0;
            try {
                $bdd->beginTransaction();
                $import = new Import($_FILES['upfile']['tmp_name'], $_POST["separator"], false, array(
                    "name",
                    "code",
                    "x",
                    "y",
                    "country_code"
                ));
                $rows = $import->getContentAsArray();
                include_once "modules/classes/country.class.php";
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
                $bdd->commit();
                $this->message->set(sprintf(_("%d lieu(x) importé(s)"), $i));
                $module_coderetour = 1;
            } catch (ImportException|Exception $e) {
                $this->message->set(_("Impossible d'importer les lieux de prélèvement"));
                $this->message->set($e->getMessage());
                $module_coderetour = -1;
                $bdd->rollback();
            }
        } else {
            $this->message->set(_("Impossible de charger le fichier à importer"));
            $module_coderetour = -1;
        }
        }
    function getFromCollection() {
        $this->vue->set($this->dataclass->getListFromCollection($_REQUEST["collection_id"]));
        }
    function getCoordinate() {
        $this->vue->set($this->dataclass->getCoordinates($_REQUEST["sampling_place_id"]));
        }
}
?>
