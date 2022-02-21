<?php
require_once 'modules/classes/borrower.class.php';
$dataClass = new borrower($bdd, $ObjetBDDParam);
$keyName = "borrower_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        /*
         * Display the list of all records of the table
         */
        $vue->set($dataClass->getListe(2), "data");
        $vue->set("param/borrowerList.tpl", "corps");
        break;
    case "display":
        $vue->set($dataClass->lire($id), "data");
        $vue->set($dataClass->getBorrowings($id), "borrowings");
        $vue->set("param/borrowerDisplay.tpl", "corps");
        /**
         * Get the list of borrows of subsamples
         */
        include_once "modules/classes/subsample.class.php";
        $subsample = new Subsample($bdd, $ObjetBDDParam);
        $vue->set ($subsample->getListFromBorrower($id), "subsamples");
        break;
    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        dataRead($dataClass, $id, "param/borrowerChange.tpl");
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
}
