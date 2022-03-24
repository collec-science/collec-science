<?php

/**
 * Created : 11 déc. 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
require_once 'modules/request/request.class.php';
$dataClass = new request($bdd, $ObjetBDDParam);
$keyName = "request_id";
$id = $_REQUEST[$keyName];
$requestForm = "request/requestChange.tpl";
switch ($t_module["param"]) {
    case "list":
        /*
         * Display the list of all records of the table
         */
        if ($_SESSION["droits"]["param"] == 1) {
            $vue->set($dataClass->getListe(2), "data");
        } else if ($_SESSION["droits"]["gestion"] == 1) {
            $vue->set($dataClass->getListFromCollections($_SESSION["collections"]), "data");
        }

        $vue->set("request/requestList.tpl", "corps");
        break;
    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        dataRead($dataClass, $id, $requestForm);
        $vue->set($_SESSION["collections"], "collections");
        break;
    case "execList":
    case "exec":
        $requestItem = $dataClass->lire($id);
        $vue->set($requestForm, "corps");
        $execOk = true;
        if ($_SESSION["droits"]["param"] != 1) {
            /**
             * Verify the rights of execution
             */
            if (empty($requestItem["collection_id"]) || !collectionVerify($requestItem["collection_id"])) {
                $vue->set("request/requestList.tpl", "corps");
                $message->set(_("Vous ne disposez pas des droits requis pour exécuter la requête"), true);
                $execOk = false;
            }
        }
        if ($execOk) {
            $vue->set($requestItem, "data");
            try {
                $vue->set($dataClass->exec($id), "result");
            } catch (Exception $e) {
                $message->set($e->getMessage());
            }
        }
        break;
    case "write":
        /*
         * write record in database
         */
        try {
            $id = $dataClass->ecrire( $_REQUEST);
            if ($id > 0) {
                $_REQUEST[$keyName] = $id;
                $module_coderetour = 1;
            }
        } catch (ObjetBDDException $oe) {
            $message->set($oe->getMessage(), true);
            $module_coderetour = -1;
        }
        break;
    case "delete":
        /*
         * delete record
         */
        dataDelete($dataClass, $id);
        break;
    case "copy":
        $data = dataRead($dataClass, 0, $requestForm);
        if ($id > 0) {
            $dinit = $dataClass->lire($id);
            if ($dinit["request_id"] > 0) {
                $data["body"] = $dinit["body"];
                $data["datefields"] = $dinit["datefields"];
                $vue->set($data, "data");
            }
        }
        break;
    default:
}
