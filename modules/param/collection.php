<?php

/****
 * Created : 30 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/collection.class.php';
$dataClass = new Collection($bdd, $ObjetBDDParam);
$keyName = "collection_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        /***
         * Display the list of all records of the table
         */
        try {
            $vue->set($dataClass->getListe(2), "data");
            $vue->set("param/collectionList.tpl", "corps");
        } catch (Exception $e) {
            $message->set($e->getMessage(), true);
        }
        break;
    case "change":
        /***
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        dataRead($dataClass, $id, "param/collectionChange.tpl");
        /**
         * Recuperation des groupes
         */
        $vue->set($dataClass->getAllGroupsFromCollection($id), "groupes");
        /**
         * Recuperation des referents
         */
        require_once 'modules/classes/referent.class.php';
        $referent = new Referent($bdd, $ObjetBDDParam);
        $vue->set($referent->getListe(2), "referents");
        require_once 'modules/classes/license.class.php';
        $license = new License($bdd, $ObjetBDDParam);
        $vue->set($license->getListe(2), "licenses");
        break;
    case "write":
        /**
         * write record in database
         */
        $id = dataWrite($dataClass, $_REQUEST);
        if ($id > 0) {
            $_REQUEST[$keyName] = $id;
            /**
             * Rechargement eventuel des collections autorises pour l'utilisateur courant
             */
            try {
                $dataClass->initCollections();
            } catch (Exception $e) {
                if ($APPLI_modeDeveloppement) {
                    $message->set($e->getMessage(), true);
                }
            }
        }
        break;
    case "delete":
        /**
         * delete record
         */
        dataDelete($dataClass, $id);
        break;
    case "getAjax":
        $vue->set($dataClass->lire($_REQUEST["collection_id"]));
        break;
}
