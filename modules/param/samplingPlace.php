<?php

/**
 * Created : 2 févr. 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
require_once 'modules/classes/samplingPlace.class.php';
$dataClass = new SamplingPlace($bdd, $ObjetBDDParam);
$keyName = "sampling_place_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        /*
         * Display the list of all records of the table
         */
        $vue->set($dataClass->getListFromCollection(0, false), "data");
        $vue->set("param/samplingPlaceList.tpl", "corps");
        $vue->set($_SESSION["collections"], "collections");
        break;
    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        dataRead($dataClass, $id, "param/samplingPlaceChange.tpl");
        include 'modules/gestion/mapInit.php';
        $vue->set($_SESSION["collections"], "collections");
        include "modules/classes/country.class.php";
        $country = new Country($bdd, $ObjetBDDParam);
        $vue->set($country->getListe(2), "countries");
        break;
    case "write":
        /*
         * write record in database
         */
        $id = dataWrite($dataClass, $_REQUEST);
        if ($id > 0) {
            $_REQUEST[$keyName] = $id;
        }
        break;
    case "delete":
        /*
         * delete record
         */
        dataDelete($dataClass, $id);
        break;
    case "import":
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
                $country = new Country($bdd, $ObjetBDDParam);
                foreach ($rows as $row) {
                    if (strlen($row["name"]) > 0) {
                        /*
                         * Ecriture en base, en mode ajout ou modification
                         */
                        $data = array(
                            "sampling_place_name" => $row["name"],
                            "collection_id" => $_POST["collection_id"],
                            "sampling_place_code" => $row["code"],
                            "sampling_place_x" => $row["x"],
                            "sampling_place_y" => $row["y"],
                            "sampling_place_id" => $dataClass->getIdFromName($row["name"]),
                            "country_id" => $country->getIdFromCode($row["country_code"])
                        );
                        $dataClass->ecrire($data);
                        $i++;
                    }
                }
                $bdd->commit();
                $message->set(sprintf(_("%d lieu(x) importé(s)"), $i));
                $module_coderetour = 1;
            } catch (ImportException|Exception $e) {
                $message->set(_("Impossible d'importer les lieux de prélèvement"));
                $message->set($e->getMessage());
                $module_coderetour = -1;
                $bdd->rollback();
            }
        } else {
            $message->set(_("Impossible de charger le fichier à importer"));
            $module_coderetour = -1;
        }
        break;
    case "getFromCollection":
        $vue->set($dataClass->getListFromCollection($_REQUEST["collection_id"]));
        break;
    case "getCoordinate":
        $vue->set($dataClass->getCoordinates($_REQUEST["sampling_place_id"]));
        break;
}
?>
