<?php

/**
 * Created : 7 août 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
require_once 'framework/identification/passwordlost.class.php';
require_once 'framework/identification/loginGestion.class.php';
$dataClass = new Passwordlost($bdd_gacl, $ObjetBDDParam);
$keyName = "passwordlost_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "isLost":
        if ($APPLI_lostPassword == 1) {
            $vue->set("framework/ident/identMailInput.tpl", "corps");
        }
        break;
    case "sendMail":
        $module_coderetour = 1;
        if (isset($_REQUEST["mail"]) && $APPLI_lostPassword == 1) {
            try {
                $data = $dataClass->createTokenFromMail($_REQUEST["mail"]);
                if ($data["id"] > 0) {
                    require_once 'framework/utils/mail.class.php';

                    $param = array(
                        "from" => $APPLI_mail
                    );
                    $loginGestion = new LoginGestion($bdd_gacl, $ObjetBDDParam);
                    $dl = $loginGestion->lire($data["id"]);
                    if (!empty($dl["mail"])) {

                        $mail = new Mail($param);
                        if ($mail->SendMailSmarty(
                            $SMARTY_param,
                            $dl["mail"],
                            $_SESSION["APPLI_title"] . " - " . _("Réinitialisation du mot de passe"),
                            "framework/mail/passwordLost.tpl",
                            array(
                                "nom" => $dl["nom"],
                                "prenom" => $dl["prenom"],
                                "expiration" => $data["expiration"],
                                ":adresse" => $APPLI_address . "/index.php?module=passwordlostReinitchange&token=" . $data["token"]
                            )
                        )) {
                            $log->setLog("unknown", "passwordlostSendmail", "email send to " . $dl["mail"]);
                            $message->set(_("Un mail vient de vous être envoyé. Veuillez copier le lien transmis dans votre navigateur pour pouvoir créer un nouveau mot de passe"), true);
                        } else {
                            $log->setLog("unknown", "passwordlostSendmail-ko", $dl["mail"]);
                            $message->set(_("Impossible d'envoyer le mail"), true);
                            $message->setSyslog('passwordlost : send mail aborted to ' . $dl["mail"]);
                        }
                    } else {
                        $log->setLog("unknown", "passwordlostSendmail-ko", "recipient empty");
                        $message->set(_("Impossible d'envoyer le mail"), true);
                    }
                }
            } catch (Exception $e) {
                $log->setLog("unknown", "passwordlostSendmail-ko", $dl["mail"]);
                $message->setSyslog($e->getMessage());
                $message->set(_("La réinitialisation du mot de passe n'est pas possible, contactez le cas échéant l'administrateur de l'application"), true);
            }
        }

        break;
    case "reinitChange":
        if (isset($_REQUEST["token"]) && $APPLI_lostPassword == 1) {
            /*
             * Verification de la validite du token
             */
            try {
                $data = $dataClass->verifyToken($_REQUEST["token"]);
                /*
                 * Verification que la derniere connexion soit une connexion de type db
                 */
                if ($log->getLastConnexionType($data["login"]) == "db") {
                    $vue->set("framework/ident/loginChangePassword.tpl", "corps");
                    $vue->set("1", "passwordLost");
                    $vue->set($_REQUEST["token"], "token");
                } else {
                    $vue->set("main.tpl", "corps");
                    $message->set(_("Le mode d'identification utilisé pour votre compte n'autorise pas la modification du mot de passe depuis cette application"));
                }
            } catch (Exception $e) {
                $message->set(_("Le jeton fourni n'est pas valide"));
                $message->setSyslog("token " . $_REQUEST["token"] . " not valid. " . $e->getMessage());
                $vue->set("main.tpl", "corps");
            }
        }
        break;
    case "reinitWrite":
        /*
         * Verification de la validite du token
         */
        $module_coderetour = -1;
        if ($APPLI_lostPassword == 1) {
            try {
                $data = $dataClass->verifyToken($_REQUEST["token"]);
                /*
                 * Verification que la derniere connexion soit une connexion de type db
                 */
                if ($log->getLastConnexionType($data["login"]) == "db") {
                    $loginGestion = new LoginGestion($bdd_gacl, $ObjetBDDParam);
                    if ($loginGestion->changePasswordAfterLost($data["login"], $_REQUEST["pass1"], $_REQUEST["pass2"]) == 1) {
                        $dataClass->disableToken($_REQUEST["token"]);
                        $module_coderetour = 1;
                    }
                } else {
                    $message->set(_("Le mode d'identification utilisé pour votre compte n'autorise pas la modification du mot de passe depuis cette application"), true);
                }
            } catch (Exception $e) {
                $message->set($e->getMessage(), true);
                $message->setSyslog($e->getMessage());
            }
        } else {
            $module_coderetour = 1;
        }

        break;
}
