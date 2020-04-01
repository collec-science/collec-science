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
                    require_once 'framework/identification/mail.class.php';

                    $param = array(
                        "replyTo" => $APPLI_mail,
                        "from" => $APPLI_mail,
                        // traduction: conserver inchangées les chaînes :keyword"
                        "subject" => _(":appli - réinitialisation du mot de passe"),
                        // traduction: conserver inchangés les chaînes :keyword et les balises <tag>"
                        "contents" => "<html><body>"._(":prenom :nom,<br>
                            <br>Vous avez demandé à réinitialiser votre mot de passe pour l'application :appli. Si ce n'était pas le cas, contactez l'administrateur de l'application.
                            <br>Pour réinitaliser votre mot de passe, recopiez le lien suivant dans votre navigateur :<br><a href=':adresse'>Réinitialisez votre mot de passe</a>
                            <br>Ne répondez pas à ce mail, qui est généré automatiquement")."</body></html>"
                    );
                    $loginGestion = new LoginGestion($bdd_gacl, $ObjetBDDParam);
                    $dl = $loginGestion->lire($data["id"]);
                    if (strlen($dl["mail"]) > 0) {

                        $mail = new Mail($param);
                        if ($mail->sendMail($dl["mail"], array(
                            ":nom" => $dl["nom"],
                            ":prenom" => $dl["prenom"],
                            ":expiration" => $data["expiration"],
                            ":appli" => $_SESSION["APPLI_title"],
                            ":adresse" => $APPLI_address . "/index.php?module=passwordlostReinitchange&token=" . $data["token"]
                        ))) {
                            $log->setLog("unknown", "passwordlostSendmail", "email send to " . $dl["mail"]);
                            $message->set(_("Un mail vient de vous être envoyé. Veuillez copier le lien transmis dans votre navigateur pour pouvoir créer un nouveau mot de passe"), true);
                        } else {
                            $log->setLog("unknown", "passwordlostSendmail-ko", $dl["mail"]);
                            $message->set(_("Impossible d'envoyer le mail"), true);
                            $message->setSyslog('passwordlost : send mail aborted to' . $dl["mail"]);
                        }
                    } else {
                        $log->setLog("unknown", "passwordlostSendmail-ko", "recipient empty");
                        $message->set(_("Impossible d'envoyer le mail"), true);
                    }
                }
            } catch (Exception $e) {
                $log->setLog("unknown", "passwordlostSendmail-ko", "$mail");
                $message->setSyslog($e->getMessage());
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
        $module_coderetour = - 1;
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
?>
