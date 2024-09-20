<?php
namespace Ppci\Libraries;

use Ppci\Libraries\Mail;
use Ppci\Models\LoginGestion;
use Ppci\Models\Passwordlost as ModelsPasswordlost;

class PasswordLost extends PpciLibrary {
    private bool $isAvailable = true;
    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsPasswordlost();
        if (!$this->appConfig->MAIL_enabled) {
            $this->isAvailable =false;
        }
    }
    function isLost() {
        $vue = service("Smarty");
        $vue->set("ppci/ident/identMailInput.tpl", "corps");
        $vue->send();
    }
    function sendMail() {
        if ($this->isAvailable && isset($_REQUEST["mail"])) {
            try {
                $data = $this->dataclass->createTokenFromMail($_REQUEST["mail"]);
                if ($data["id"] > 0) {    
                    $loginGestion = new LoginGestion();
                    $dl = $loginGestion->lire($data["id"]);
                    if (!empty($dl["mail"])) {
    
                        $mail = new Mail($this->appConfig->MAIL_param);
                        if ($mail->SendMailSmarty(
                            $dl["mail"],
                            $_SESSION["APPLI_title"] . " - " . _("Réinitialisation du mot de passe"),
                            "ppci/mail/passwordLost.tpl",
                            array(
                                "nom" => $dl["nom"],
                                "prenom" => $dl["prenom"],
                                "expiration" => $data["expiration"],
                                ":adresse" => $this->appConfig->baseURL . "/passwordlostReinitchange&token=" . $data["token"]
                            )
                        )) {
                            $this->log->setLog("unknown", "passwordlostSendmail", "email send to " . $dl["mail"]);
                            $this->message->set(_("Un mail vient de vous être envoyé. Veuillez copier le lien transmis dans votre navigateur pour pouvoir créer un nouveau mot de passe"), true);
                        } else {
                            $this->log->setLog("unknown", "passwordlostSendmail-ko", $dl["mail"]);
                            $this->message->set(_("Impossible d'envoyer le mail"), true);
                            $this->message->setSyslog('passwordlost : send mail aborted to ' . $dl["mail"]);
                        }
                    } else {
                        $this->log->setLog("unknown", "passwordlostSendmail-ko", "recipient empty");
                        $this->message->set(_("Impossible d'envoyer le mail"), true);
                    }
                }
            } catch (PpciException $e) {
                $this->log->setLog("unknown", "passwordlostSendmail-ko", $dl["mail"]);
                $this->message->setSyslog($e->getMessage());
                $this->message->set(_("La réinitialisation du mot de passe n'est pas possible, contactez le cas échéant l'administrateur de l'application"), true);
            }
        } else {
            $this->message->set(_("La réinitialisation du mot de passe n'est pas activée pour cette application"));
        }
        defaultPage();
    }
    function reinitChange() {
        if (isset($_REQUEST["token"]) && $this->isAvailable) {
            /*
             * Verification de la validite du token
             */
            try {
                $data = $this->dataclass->verifyToken($_REQUEST["token"]);
                /*
                 * Verification que la derniere connexion soit une connexion de type db
                 */
                if ($this->log->getLastConnexionType($data["login"]) == "db") {
                    $vue = service ("Smarty");
                    $vue->set("ppci/ident/loginChangePassword.tpl", "corps");
                    $vue->set("1", "passwordLost");
                    $vue->set($_REQUEST["token"], "token");
                } else {  
                    $this->message->set(_("Le mode d'identification utilisé pour votre compte n'autorise pas la modification du mot de passe depuis cette application"));
                    defaultPage();
                }
            } catch (PpciException $e) {
                $this->message->set(_("Le jeton fourni n'est pas valide"));
                $this->message->setSyslog("token " . $_REQUEST["token"] . " not valid. " . $e->getMessage());
                defaultPage();
            }
        } else {
            $this->message->set(_("La réinitialisation du mot de passe n'est pas activée pour cette application, ou le jeton n'a pas été fourni"));
            defaultPage();
        }
    }
    function reinitWrite() {
        try {
            $data = $this->dataclass->verifyToken($_REQUEST["token"]);
            /*
             * Verification que la derniere connexion soit une connexion de type db
             */
            if ($this->log->getLastConnexionType($data["login"]) == "db") {
                $loginGestion = new LoginGestion();
                if ($loginGestion->changePasswordAfterLost($data["login"], $_REQUEST["pass1"], $_REQUEST["pass2"]) == 1) {
                    $this->dataclass->disableToken($_REQUEST["token"]);
                }
            } else {
                $this->message->set(_("Le mode d'identification utilisé pour votre compte n'autorise pas la modification du mot de passe depuis cette application"), true);
            }
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            $this->message->setSyslog($e->getMessage());
        } finally {
            defaultPage();
        }
    }
}

