<?php
/**
 * Created : 28 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/storage.class.php';
$dataClass = new Storage($bdd, $ObjetBDDParam);
$keyName = "storage_id";
$id = $_REQUEST[$keyName];
switch ($t_module["param"]) {
    case "input":
        $data = dataRead($dataClass, $id, "gestion/storageChange.tpl", $_REQUEST["uid"], false);
        $data["movement_type_id"] = 1;
        require_once 'modules/classes/containerFamily.class.php';
        $containerFamily = new ContainerFamily($bdd, $ObjetBDDParam);
        $vue->set($containerFamily->getListe(2), "containerFamily");
        $vue->set($data, "data");
        $vue->set($_SESSION["moduleParent"], "moduleParent");
        
        /*
         * Recherche de l'objet
         */
        require_once 'modules/classes/object.class.php';
        $object = new Object($bdd, $ObjetBDDParam);
        $vue->set($object->lire($_REQUEST["uid"]), "object");
        $vue->set($data, "data");
        break;
    
    case "output":
        $data = dataRead($dataClass, $id, "gestion/storageChange.tpl", $_REQUEST["uid"], false);
        $data["movement_type_id"] = 2;
        /*
         * Recherche de l'objet
         */
        require_once 'modules/classes/object.class.php';
        $object = new Object($bdd, $ObjetBDDParam);
        $vue->set($object->lire($_REQUEST["uid"]), "object");
        $vue->set($data, "data");
        $vue->set($_SESSION["moduleParent"], "moduleParent");
        /*
         * Recherche des motifs de sortie
         */
        require_once 'modules/classes/storageReason.class.php';
        $storageReason = new StorageReason($bdd, $ObjetBDDParam);
        $vue->set($storageReason->getListe(2), "storageReason");
        break;
    case "write":
		/*
		 * write record in database
		 */
		/*
		 * Recherche de storage_id si uid renseigne
		 */
		if (strlen($_REQUEST["container_id"]) == 0 && strlen($_REQUEST["container_uid"]) > 0) {
            require_once 'modules/classes/container.class.php';
            $container = new Container($bdd, $ObjetBDDParam);
            $_REQUEST["container_id"] = $container->getIdFromUid($_REQUEST["container_uid"]);
        }
        /*
         * Verification de l'existence de container_id si entree
         */
        $error = false;
        if ($_REQUEST["movement_type_id"] == 1) {
            if ($_REQUEST["uid"] == $_REQUEST["container_uid"])
                $error = true;
            if (strlen($_REQUEST["container_id"]) == 0)
                $error = true;
        }
        if ($error) {
            $message->set($LANG["appli"][3]);
            $module_coderetour = - 1;
        } else {
            $id = dataWrite($dataClass, $_REQUEST);
            if ($id > 0) {
                $_REQUEST[$keyName] = $id;
            }
        }
        break;
    case "delete":
		/*
		 * delete record
		 */
		dataDelete($dataClass, $id);
        break;
    case "fastInputChange":
        if (isset($_REQUEST["container_uid"]) && is_numeric($_REQUEST["container_uid"]))
            $vue->set($_REQUEST["container_uid"], "container_uid");
        $vue->set($dataClass->getDefaultValue(), "data");
        $vue->set("gestion/fastInputChange.tpl", "corps");
        if (isset($_REQUEST["read_optical"]))
            $vue->set($_REQUEST["read_optical"], "read_optical");
        /*
         * Assignation du nom de la base
         */
        $vue->set($_SESSION["APPLI_code"], "db");
        
        break;
    case "fastInputWrite":
        try {
            $dataClass->addMovement($_REQUEST["object_uid"], $_REQUEST["storage_date"], 1, $_REQUEST["container_uid"], $_SESSION["login"], $_REQUEST["storage_location"], $_REQUEST["storage_comment"], null, $_REQUEST["column_number"], $_REQUEST["line_number"]);
            $message->set($LANG["message"][5]);
            $module_coderetour = 1;
        } catch (Exception $e) {
            $message->set($e->getMessage());
            $module_coderetour = - 1;
        }
        break;
    case "fastOutputChange":
        $vue->set($dataClass->getDefaultValue(), "data");
        $vue->set("gestion/fastOutputChange.tpl", "corps");
        if (isset($_REQUEST["read_optical"]))
            $vue->set($_REQUEST["read_optical"], "read_optical");
        /*
         * Assignation du nom de la base
         */
        $vue->set($_SESSION["APPLI_code"], "db");
        /*
         * Recherche des motifs de sortie
         */
        require_once 'modules/classes/storageReason.class.php';
        $storageReason = new StorageReason($bdd, $ObjetBDDParam);
        $vue->set($storageReason->getListe(2), "storageReason");
        
        break;
    case "fastOutputWrite":
        try {
            $dataClass->addMovement($_REQUEST["object_uid"], $_REQUEST["storage_date"], 2, 0, $_SESSION["login"], $_REQUEST["storage_location"], $_REQUEST["storage_comment"], $_REQUEST["storage_reason_id"]);
            $message->set($LANG["message"][5]);
            $module_coderetour = 1;
        } catch (Exception $e) {
            $message->setSyslog($e->getMessage());
            $message->set($LANG["appli"][6]);
            $module_coderetour = - 1;
        }
        break;
    case "batchOpen":
        $vue->set("gestion/storageBatchRead.tpl", "corps");
        break;
    case "batchRead":
        require_once 'modules/classes/object.class.php';
        $object = new Object($bdd, $ObjetBDDParam);
        $vue->set($object->batchRead($_REQUEST["reads"]), "data");
        $vue->set("gestion/storageBatchConfirm.tpl", "corps");
        /*
         * Recherche des motifs de sortie
         */
        require_once 'modules/classes/storageReason.class.php';
        $storageReason = new StorageReason($bdd, $ObjetBDDParam);
        $vue->set($storageReason->getListe(2), "storageReason");
        break;
    case "batchWrite":
		/*
		 * Preparation des donnees
		 */
		$uid_container = 0;
        $date = date("d/m/Y H:i:s");
        $nb = 0;
        try {
            foreach ($_REQUEST["uid"] as $uid) {
                $sens = $_REQUEST["mvt" . $uid];
                /*
                 * teste s'il s'agit d'un container pour une entree
                 */
                if ($_REQUEST["container" . $uid] == 1) {
                    $uid_container = $uid;
                }
                if (($sens == 1 && $uid_container > 0) || $sens == 2) {
                    $sens == 1 ? $uic = $uid_container : $uic = "";
                    $dataClass->addMovement($uid, $date, $sens, $uic, $_SESSION["login"], null, null, $_REQUEST["storage_reason_id"], $_REQUEST["column" . $uid], $_REQUEST["line" . $uid]);
                    $nb ++;
                }
            }
            $message->set($nb . " mouvements générés");
            $module_coderetour = 1;
        } catch (Exception $e) {
            $message->set("Erreur lors de la génération des mouvements");
            $message->setSyslog($e->getMessage());
            $module_coderetour = - 1;
        }
        break;
    case "list":
        $_SESSION["searchMovement"]->setParam($_REQUEST);
        $dataSearch = $_SESSION["searchMovement"]->getParam();
        if ($_SESSION["searchMovement"]->isSearch() == 1) {
            $data = $dataClass->search($dataSearch);
            $vue->set($data, "data");
            $vue->set(1, "isSearch");
        }
        $vue->set($dataSearch, "movementSearch");
        $vue->set("gestion/movementList.tpl", "corps");
        break;
    
    case "getLastEntry":
        $vue->set($dataClass->getLastEntry($_REQUEST["uid"]));
        break;
    
    case "smallMovementChange":
        $vue->set("gestion/smallMovementChange.tpl", "corps");
        /*
         * Assignation du nom de la base
         */
        $vue->set($_SESSION["APPLI_code"], "db");
        break;
    
    case "smallMovementWrite":
        try {
            $dataClass->addMovement($_POST["object_uid"], null, $_POST["movement_type_id"], $_POST["container_uid"], null, null, null, null, $_POST["column_number"], $_POST["line_number"]);
            $module_coderetour = 1;
            $message->set($LANG["appli"][7]);
        } catch (Exception $e) {
            $message->setSyslog($e->getMessage());
            $message->set($LANG["appli"][6]);
            $module_coderetour = - 1;
        }
        break;
}
?>