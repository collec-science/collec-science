<?php
/**
 * Created : 7 août 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
require_once 'framework/identification/passwordlost.class.php';
$dataClass = new Passwordlost($bdd_gacl, $ObjetBDDParam);
$keyName = "passwordlost_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "isLost":
        if ($APPLI_lostPassword == 1) {
            $vue->set("ident/identMailInput.tpl", "corps");
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
                        "subject" => $LANG["login"][54],
                        "contents" => $LANG["login"][53]
                    );
                    $loginGestion = new LoginGestion($bdd_gacl, $ObjetBDDParam);
                    $dl = $loginGestion->lire($data["id"]);
                    if (strlen($dl["mail"]) > 0) {
                        require_once 'framework/identification/mail.class.php';
                        $mail = new Mail($param);
                        if ($mail->sendMail($dl["mail"], array(
                            ":nom" => $dl["nom"],
                            ":prenom" => $dl["prenom"],
                            ":expiration" => $data["expiration"],
                            ":appli" => $APPLI_name,
                            ":adresse" => $APPLI_address . "/index.php?module=passwordlostReinitchange&token=" . $data["token"]
                        ))) {
                            $log->setLog("unknown", "passwordlostSendmail", "email send to " . $dl["mail"]);
                            $message->set($LANG["login"][55]);
                        } else {
                            $log->setLog("unknown", "passwordlostSendmail-ko", $dl["mail"]);
                            $message->set($LANG["login"][56]);
                            $message->setSyslog('passwordlost : send mail aborted to' . $dl["mail"]);
                        }
                    } else {
                        $log->setLog("unknown", "passwordlostSendmail-ko", "recipient empty");
                        $message->set($LANG["login"][56]);
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
                    $vue->set("ident/loginChangePassword.tpl", "corps");
                    $vue->set("1", "passwordLost");
                    $vue->set($_REQUEST["token"], "token");
                } else {
                    $vue->set("main.tpl", "corps");
                    $message->set($LANG["login"][18]);
                }
            } catch (Exception $e) {
                $message->set($LANG["login"][52]);
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
                    $message->set($LANG["login"][18]);
                }
            } catch (Exception $e) {
                $message->set($e->getMessage());
                $message->setSyslog($e->getMessage());
            }
        } else {
            $module_coderetour = 1;
        }
        
        break;
}
?>