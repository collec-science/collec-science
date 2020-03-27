<?php

/**
 * 
 * Gestion de la saisie, de la modification d'un login
 * Gestion du changement du mot de passe (en mode BDD)
 */
require_once 'framework/identification/loginGestion.class.php';
$dataClass = new LoginGestion($bdd_gacl, $ObjetBDDParam);
$id = $_REQUEST["id"];
if (! $APPLI_passwordMinLength > 0) {
    $APPLI_passwordMinLength = 12;
}
switch ($t_module["param"]) {
    case "list":
		/*
         * Display the list of all records of the table
         */
        $vue->set($dataClass->getListeTriee(), "liste");
        $vue->set("framework/ident/loginliste.tpl", "corps");
        break;
    case "change":
		/*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $data = dataRead($dataClass, $id, "framework/ident/loginsaisie.tpl", 0);
        $vue->set($APPLI_passwordMinLength, "passwordMinLength");
        unset($data["password"]);
        /**
         * Add dbconnect_provisional_nb
         */
        if (strlen($data["login"])>0) {
            $data["dbconnect_provisional_nb"] = $dataClass->getDbconnectProvisionalNb($data["login"]);
        }
        $vue->set($data, "data");
        break;
    case "write":
		/*
         * write record in database
         */
        $id = dataWrite($dataClass, $_REQUEST);
        if ($id > 0) {
            /*
             * Ecriture du compte dans la table acllogin
             */
            try {
                require_once 'framework/droits/droits.class.php';
                $acllogin = new Acllogin($bdd_gacl, $ObjetBDDParam);
                if (strlen($_REQUEST["nom"]) > 0) {
                    $nom = $_REQUEST["nom"] . " " . $_REQUEST["prenom"];
                } else {
                    $nom = $_REQUEST["login"];
                }
                $acllogin->addLoginByLoginAndName($_REQUEST["login"], $nom);
            } catch (Exception $e) {
                $message->set(_("Problème rencontré lors de l'écriture du login pour la gestion des droits"), true);
                $message->setSyslog($e->getMessage());
            }
        } 
        break;
    case "delete":
		/*
         * delete record
         */
        dataDelete($dataClass, $id);
        break;
    case "changePassword":
        if ($log->getLastConnexionType($_SESSION["login"]) == "db") {
            $vue->set("framework/ident/loginChangePassword.tpl", "corps");
            $vue->set($APPLI_passwordMinLength,"passwordMinLength");
        } else {
            $message->set(_("Le mode d'identification utilisé pour votre compte n'autorise pas la modification du mot de passe depuis cette application"), true);
            $vue->set("main.tpl");
        }
        break;
    case 'changePasswordExec':
        $ret = $dataClass->changePassword($_REQUEST["oldPassword"], $_REQUEST["pass1"], $_REQUEST["pass2"]);
        $ret < 1 ? $module_coderetour = -1 : $module_coderetour = 1;
        foreach ($dataClass->getErrorData(1) as $messageError) {
            $message->set($messageError, true);
        }
        break;
}
