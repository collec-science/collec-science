<?php

/**
 * Created : 28 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/movement.class.php';
$dataClass = new Movement($bdd, $ObjetBDDParam);
$keyName = "movement_id";
$id = $_REQUEST[$keyName];
switch ($t_module["param"]) {
    case "input":
        $data = dataRead($dataClass, $id, "gestion/movementChange.tpl", $_REQUEST["uid"], false);
        $data["movement_type_id"] = 1;
        require_once 'modules/classes/containerFamily.class.php';
        $containerFamily = new ContainerFamily($bdd, $ObjetBDDParam);
        $vue->set($containerFamily->getListe(2), "containerFamily");
        $vue->set($data, "data");
        $vue->set($_SESSION["moduleParent"], "moduleParent");
        $vue->set("tab-movement", "activeTab");

        /*
         * Recherche de l'objet
         */
        require_once 'modules/classes/object.class.php';
        $object = new ObjectClass($bdd, $ObjetBDDParam);
        $vue->set($object->lire($_REQUEST["uid"]), "object");
        $vue->set($data, "data");
        break;

    case "output":
        $data = dataRead($dataClass, $id, "gestion/movementChange.tpl", $_REQUEST["uid"], false);
        $data["movement_type_id"] = 2;
        /*
         * Recherche de l'objet
         */
        require_once 'modules/classes/object.class.php';
        $object = new ObjectClass($bdd, $ObjetBDDParam);
        $vue->set($object->lire($_REQUEST["uid"]), "object");
        $vue->set($data, "data");
        $vue->set($_SESSION["moduleParent"], "moduleParent");
        $vue->set("tab-movement", "activeTab");
        /*
         * Recherche des motifs de sortie
         */
        require_once 'modules/classes/movementReason.class.php';
        $movementReason = new MovementReason($bdd, $ObjetBDDParam);
        $vue->set($movementReason->getListe(2), "movementReason");
        break;
    case "write":
        /*
         * write record in database
         */
        try {
            $bdd->beginTransaction();
            $dataClass->addMovement($_REQUEST["uid"], $_REQUEST["movement_date"], $_REQUEST["movement_type_id"], $_REQUEST["container_uid"], $_SESSION["login"], $_REQUEST["storage_location"], $_REQUEST["movement_comment"], $_REQUEST["movement_reason_id"], $_REQUEST["column_number"], $_REQUEST["line_number"]);
            $bdd->commit();
            $module_coderetour = 1;
            $message->set(_("Mouvement généré"));
        } catch (MovementException $me) {
            $module_coderetour = -1;
            $message->set(_("Erreur lors de la génération du mouvement"), true);
            $message->set($me->getMessage());
            $module_coderetour = -1;
            $bdd->rollback();
        } catch (Exception $e) {
            $module_coderetour = -1;
            $message->setSyslog($e->getMessage());
            $bdd->rollback();
        }
        break;
    case "delete":
        /*
         * delete record
         */
        dataDelete($dataClass, $id);
        break;
    case "fastInputChange":
        if (isset($_REQUEST["container_uid"]) && is_numeric($_REQUEST["container_uid"])) {
            $vue->set($_REQUEST["container_uid"], "container_uid");
        }
        $vue->set($dataClass->getDefaultValue(), "data");
        $vue->set("gestion/fastInputChange.tpl", "corps");
        if (isset($_REQUEST["read_optical"])) {
            $vue->set($_REQUEST["read_optical"], "read_optical");
        }
        /*
         * Assignation du nom de la base
         */
        $vue->set($_SESSION["APPLI_code"], "db");

        break;
    case "fastInputWrite":
        try {
            $dataClass->addMovement($_REQUEST["object_uid"], $_REQUEST["movement_date"], 1, $_REQUEST["container_uid"], $_SESSION["login"], $_REQUEST["storage_location"], $_REQUEST["movement_comment"], null, $_REQUEST["column_number"], $_REQUEST["line_number"]);
            $message->set(_("Enregistrement effectué"));
            $module_coderetour = 1;
        } catch (Exception $e) {
            $message->set($e->getMessage(), true);
            $module_coderetour = -1;
        }
        break;
    case "fastOutputChange":
        $vue->set($dataClass->getDefaultValue(), "data");
        $vue->set("gestion/fastOutputChange.tpl", "corps");
        if (isset($_REQUEST["read_optical"])) {
            $vue->set($_REQUEST["read_optical"], "read_optical");
        }
        /*
         * Assignation du nom de la base
         */
        $vue->set($_SESSION["APPLI_code"], "db");
        /*
         * Recherche des motifs de sortie
         */
        require_once 'modules/classes/movementReason.class.php';
        $movementReason = new MovementReason($bdd, $ObjetBDDParam);
        $vue->set($movementReason->getListe(2), "movementReason");

        break;
    case "fastOutputWrite":
        try {
            $dataClass->addMovement($_REQUEST["object_uid"], $_REQUEST["movement_date"], 2, 0, $_SESSION["login"], $_REQUEST["storage_location"], $_REQUEST["movement_comment"], $_REQUEST["movement_reason_id"]);
            $message->set(_("Enregistrement effectué"));
            $module_coderetour = 1;
        } catch (Exception $e) {
            $message->setSyslog($e->getMessage());
            $message->set(_("Impossible d'enregistrer le mouvement"), true);
            $module_coderetour = -1;
        }
        break;
    case "batchOpen":
        $vue->set("gestion/movementBatchRead.tpl", "corps");
        break;
    case "batchRead":
        require_once 'modules/classes/object.class.php';
        $object = new ObjectClass($bdd, $ObjetBDDParam);
        $vue->set($object->batchRead($_REQUEST["reads"]), "data");
        $vue->set("gestion/movementBatchConfirm.tpl", "corps");
        /*
         * Recherche des motifs de sortie
         */
        require_once 'modules/classes/movementReason.class.php';
        $movementReason = new MovementReason($bdd, $ObjetBDDParam);
        $vue->set($movementReason->getListe(2), "movementReason");
        break;
    case "batchWrite":
        /*
         * Preparation des donnees
         */
        $uid_container = 0;
        $date = date($_SESSION["MASKDATELONG"]);
        $nb = 0;
        try {
            foreach ($_REQUEST as $key => $sens) {
                if (substr($key, 0, 3) == "mvt") {
                    $akey = explode(":", $key);
                    $uid = $akey[1];
                    $position = substr($akey[0], 3);
                    /*
                     * teste s'il s'agit d'un container pour une entree
                     */
                    if ($_REQUEST["container" . $position . ":" . $uid] == 1) {
                        $uid_container = $uid;
                    }
                    if (($sens == 1 && $uid_container > 0) || $sens == 2) {
                        $sens == 1 ? $uic = $uid_container : $uic = "";
                        $dataClass->addMovement($uid, $date, $sens, $uic, $_SESSION["login"], null, null, $_REQUEST["movement_reason_id"], $_REQUEST["column" . $uid], $_REQUEST["line" . $uid]);
                        $nb++;
                    }
                }
            }
            $message->set(sprintf(_("%d mouvement(s) généré(s)"), $nb));
            $module_coderetour = 1;
        } catch (Exception $e) {
            $message->set(_("Erreur lors de la génération des mouvements"));
            $message->setSyslog($e->getMessage(), true);
            $module_coderetour = -1;
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
        /*
         * Recherche des motifs de sortie
         */
        require_once 'modules/classes/movementReason.class.php';
        $movementReason = new MovementReason($bdd, $ObjetBDDParam);
        $vue->set($movementReason->getListe(2), "movementReason");
        $vue->set($_POST["movement_reason_id"], "movement_reason_id");
        break;

    case "smallMovementWrite":
        try {
            $dataClass->addMovement($_POST["object_uid"], null, $_POST["movement_type_id"], $_POST["container_uid"], null, null, null, $_POST["movement_reason_id"], $_POST["column_number"], $_POST["line_number"]);
            $module_coderetour = 1;
            $message->set(_("Mouvement enregistré"));
        } catch (Exception $e) {
            $message->setSyslog($e->getMessage());
            $message->set(_("Impossible d'enregistrer le mouvement"), true);
            $module_coderetour = -1;
        }
        break;
}
