<?php


require_once 'modules/classes/referent.class.php';
$dataClass = new Referent($bdd, $ObjetBDDParam);
$keyName = "referent_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        /*
         * Display the list of all records of the table
         */
        $vue->set($dataClass->getListe(3), "data");
        $vue->set("param/referentList.tpl", "corps");
        break;
    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        dataRead($dataClass, $id, "param/referentChange.tpl");
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
    case "getFromName":
        /* 
         * Recherche un referent a partir de son nom,
         * et retourne le tableau sous forme Ajax
         */
        $vue->set($dataClass->getFromName($_REQUEST["referent_name"]));
        break;
        case "copy":
        $data = $dataClass->lire($id);
        $data["referent_id"] = 0;
        $data["referent_name"] = "";
        $vue->set($data, "data");
        $vue->set("param/referentChange.tpl", "corps");
        break;

}
?>