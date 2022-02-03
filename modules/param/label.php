<?php

/**
 * Created : 8 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/label.class.php';
$dataClass = new Label($bdd, $ObjetBDDParam);
$keyName = "label_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        /*
         * Display the list of all records of the table
         */
        try {
            $vue->set($dataClass->getListe(2), "data");
            $vue->set("param/labelList.tpl", "corps");
        } catch (Exception $e) {
            $message->set($e->getMessage());
        }
        break;
    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $data = dataRead($dataClass, $id, "param/labelChange.tpl");
        require_once 'modules/classes/metadata.class.php';
        $metadata = new metadata($bdd, $ObjetBDDParam);
        require_once "modules/classes/barcode.class.php";
        $barcode = new Barcode($bdd, $ObjetBDDParam);
        $vue->set ($barcode->getListe(1),"barcodes");
        $vue->set($metadata->getListe(), "metadata");
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
    case "copy":
        /*
         * Duplication d'une etiquette
         */
        $data = $dataClass->lire($id);
        $data["label_id"] = 0;
        $data["label_name"] = "";
        $vue->set($data, "data");
        $vue->set("param/labelChange.tpl", "corps");
        require_once 'modules/classes/metadata.class.php';
        $metadata = new Metadata($bdd, $ObjetBDDParam);
        $vue->set($metadata->getListe(), "metadata");
        break;
}
?>
