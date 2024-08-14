<?php
namespace Ppci\Libraries;

use \Ppci\Models\LoginGestion;
use \Ppci\Models\Acllogin;

class LoginGestionLib extends PpciLibrary
{
    function __construct()
    {
        parent::__construct();
        $this->dataClass = new LoginGestion();
    }

    function index()
    {
        $vue = service("Smarty");
        $data = $this->dataClass->getlist();
        $vue->set($data, "data");
        $vue->set("ppci/ident/loginliste.tpl", "corps");
        return $vue->send();
    }
    function change()
    {
        try {
            $data = $this->dataRead($_REQUEST["id"], "ppci/ident/loginsaisie.tpl");
            $vue = service("Smarty");
            $vue->set($this->appConfig->APP_passwordMinLength, "passwordMinLength");
            unset($data["password"]);
            /**
             * Add dbconnect_provisional_nb
             */
            if (!empty($data["login"])) {
                $data["dbconnect_provisional_nb"] = $this->dataClass->getDbconnectProvisionalNb($data["login"]);
            }
            $vue->set($data, "data");
            return $vue->send();
        } catch (\Exception $e) {
            $this->message->set($e->getMessage(), true);
            return $this->index();
        }
    }
    function write()
    {
        try {
            $id = $this->dataClass->write($_REQUEST);
            if ($id > 0) {
                /*
                 * Ecriture du compte dans la table acllogin
                 */

                $acllogin = new Acllogin();
                if (!empty($_REQUEST["nom"])) {
                    $nom = $_REQUEST["nom"] . " " . $_REQUEST["prenom"];
                } else {
                    $nom = $_REQUEST["login"];
                }
                $acllogin->addLoginByLoginAndName($_REQUEST["login"], $nom, $_REQUEST["mail"]);
                return $this->index();
            }
        } catch (\Exception $e) {
            $this->message->set(_("Problème rencontré lors de l'enregistrement"), true);
            $this->message->setSyslog($e->getMessage());
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->dataDelete($this->id)) {
            return $this->index();
        } else {
            return $this->change();
        }
    }

    function changePassword()
    {
        if ($this->log->getLastConnexionType($_SESSION["login"]) == "db") {
            $vue = service("Smarty");
            $vue->set("ppci/ident/loginChangePassword.tpl", "corps");
            $vue->set($this->appConfig->APP_passwordMinLength, "passwordMinLength");
            return ($vue->send());
        } else {
            $this->message->set(_("Le mode d'identification utilisé pour votre compte n'autorise pas la modification du mot de passe depuis cette application"), true);
            defaultPage();
        }
    }
    function changePasswordExec()
    {
        try {
            $this->dataClass->changePassword($_REQUEST["oldPassword"], $_REQUEST["pass1"], $_REQUEST["pass2"]);
            /**
             * Send mail to the user
             */
            $data = $this->dataClass->lireByLogin($_SESSION["login"]);
            if (!empty($data["mail"]) && $this->appConfig->MAIL_enabled) {
                $dbparam = service("Dbparam");
                $subject = sprintf(_("%s - changement de mot de passe"), $dbparam->getParam("APPLI_title"));
                $mail = new Mail($this->appConfig->MAIL_param);
                $data["APPLI_address"] = $this->appConfig->baseURL;
                $data["applicationName"] = $_SESSION["APPLI_title"];
                if ($mail->SendMailSmarty( $data["mail"], $subject, "ppci/mail/passwordChanged.tpl", $data)) {
                    $this->log->setLog($_SESSION["login"], "password mail confirm", "ok");
                } else {
                    $this->log->setLog($_SESSION["login"], "password mail confirm", "ko");
                }
            }
            $this->message->set(_("La modification du mot de passe a été enregistrée"));
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(),true);
        } finally {
            defaultPage();
        }
    }
}