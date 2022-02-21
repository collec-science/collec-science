<?php
/**
 * Created : 15 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/subsample.class.php';
$dataClass = new Subsample($bdd,$ObjetBDDParam);
$keyName = "subsample_id";
$id = $_REQUEST[$keyName];
switch ($t_module["param"]) {
    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        dataRead($dataClass, $id, "gestion/subsampleChange.tpl", $_REQUEST["sample_id"]);
        $vue->set($_SESSION["moduleParent"],"moduleParent");
        /*
         * Lecture de l'object concerne
         */
        require_once 'modules/classes/object.class.php';
        $object = new ObjectClass($bdd, $ObjetBDDParam);
        $vue->set($object->lire($_REQUEST["uid"]) , "object");
        /**
         * Get the list of borrowers
         */
        require_once "modules/classes/borrower.class.php";
        $borrower = new Borrower($bdd, $ObjetBDDParam);
        $vue->set($borrower->getListe(), "borrowers");
        break;
    case "write":
        /*
         * write record in database
         */
        //$dataClass->debug_mode = 2;
        $id = dataWrite($dataClass, $_REQUEST, false);
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
}
