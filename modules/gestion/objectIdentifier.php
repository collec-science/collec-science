<?php

/**
 * Created : 28 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/objectIdentifier.class.php';
$dataClass = new ObjectIdentifier($bdd, $ObjetBDDParam);
$keyName = "object_identifier_id";
$id = $_REQUEST[$keyName];
switch ($t_module["param"]) {
    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        dataRead($dataClass, $id, "gestion/objectIdentifierChange.tpl", $_REQUEST["uid"]);
        $vue->set($_SESSION["moduleParent"], "moduleParent");
        $vue->set("tab-id", "activeTab");
        /*
         * Recherche des types 
         */
        require_once 'modules/classes/identifierType.class.php';
        $identifierType = new IdentifierType($bdd, $ObjetBDDParam);
        $vue->set($identifierType->getListe("identifier_type_code"), "identifierType");
        /*
         * Lecture de l'object concerne
         */
        require_once 'modules/classes/object.class.php';
        $object = new ObjectClass($bdd, $ObjetBDDParam);
        $vue->set($object->lire($_REQUEST["uid"]), "object");

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
?>