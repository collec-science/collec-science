<?php

/**
 *
 * Gestion de la saisie, de la modification d'un login
 * Gestion du changement du mot de passe (en mode BDD)
 */
require_once 'framework/identification/loginGestion.class.php';
$dataClass = new LoginGestion($bdd_gacl, $ObjetBDDParam);
$dataClass->setKeys($privateKey, $pubKey);
$id = $_REQUEST["id"];
if (!$APPLI_passwordMinLength > 0) {
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
        try {
            $data = $dataClass->lire($id);
            $vue->set("framework/ident/loginsaisie.tpl", "corps");
            $vue->set($APPLI_passwordMinLength, "passwordMinLength");
            unset($data["password"]);
            /**
             * Add dbconnect_provisional_nb
             */
            if (!empty($data["login"])) {
                $data["dbconnect_provisional_nb"] = $dataClass->getDbconnectProvisionalNb($data["login"]);
            }
            $vue->set($data, "data");
        } catch (FrameworkException | ObjetBDDException | PDOException $e) {
            $message->set($e->getMessage(), true);
            $module_coderetour = -1;
        }
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
                include_once "framework/droits/acllogin.class.php";
                $acllogin = new Acllogin($bdd_gacl, $ObjetBDDParam);
                if (!empty($_REQUEST["nom"])) {
                    $nom = $_REQUEST["nom"] . " " . $_REQUEST["prenom"];
                } else {
                    $nom = $_REQUEST["login"];
                }
                $acllogin->addLoginByLoginAndName($_REQUEST["login"], $nom);
            } catch (FrameworkException | ObjetBDDException | PDOException $e) {
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
            $vue->set($APPLI_passwordMinLength, "passwordMinLength");
        } else {
            $message->set(_("Le mode d'identification utilisé pour votre compte n'autorise pas la modification du mot de passe depuis cette application"), true);
            $vue->set("main.tpl");
        }
        break;
    case 'changePasswordExec':
        if (!$dataClass->changePassword($_REQUEST["oldPassword"], $_REQUEST["pass1"], $_REQUEST["pass2"])) {
            $module_coderetour = -1;
            foreach ($dataClass->getErrorData(1) as $messageError) {
                $message->set($messageError, true);
            }
        } else {
            $module_coderetour = 1;
            /**
             * Send mail to the user
             */
            $data = $dataClass->lireByLogin($_SESSION["login"]);
            if (!empty($data["mail"]) && $MAIL_enabled == 1) {

                require_once "framework/utils/mail.class.php";
                $mail = new Mail($MAIL_param);
                $data["APPLI_address"] = $APPLI_address;
                $data["applicationName"] = $_SESSION["APPLI_title"];
                if ($mail->SendMailSmarty($SMARTY_param, $data["mail"], $subject, "framework/mail/passwordChanged.tpl", $data)) {
                    $log->setLog($_SESSION["login"], "password mail confirm", "ok");
                } else {
                    $log->setLog($_SESSION["login"], "password mail confirm", "ko");
                }
            }
        }
        break;
}
