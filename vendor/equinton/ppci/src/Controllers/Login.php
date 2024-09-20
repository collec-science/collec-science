<?php

namespace Ppci\Controllers;

class Login extends PpciController
{
    function index()
    {
        $login = new \Ppci\Libraries\Login();
        $idConfig = service("IdentificationConfig");
        if (isset($_COOKIE["tokenIdentity"])) {
            return $this->defaultReturn($login->getLogin());
        }
        if (in_array($idConfig->identificationMode, ["BDD", "LDAP", "LDAP-BDD", "CAS-BDD", "OIDC-BDD"])) {
            return ($login->display());
        } else {
            /**
             * Identification HEADER
             */
            if (!$_SESSION["isLogged"] && $idConfig->identificationMode == "HEADER") {
                $retour = $login->getLogin();
                if (!empty($retour)) {
                    return redirect()->to($retour);
                } else {
                    if ($_SESSION["isLogged"]) {
                        return $this->defaultReturn();
                    } else {
                        $_SESSION["filterMessages"][] = _("Identification refusée");
                        return redirect()->to(site_url());
                    }
                }
            } else {
                if ($idConfig->identificationMode == "CAS") {
                    return redirect()->to("loginCasExec");
                } else if ($idConfig->identificationMode == "OIDC") {
                    return redirect()->to("oidcExec");
                }
            }
            $_SESSION["filterMessages"][] = _("Le mode d'identification dans l'application ne vous permet pas d'accéder à la page de connexion");
            defaultPage();
        }
    }
    public function loginExec()
    {
        $config = service("IdentificationConfig");
        if (!in_array($config->identificationMode, ["BDD", "LDAP", "CAS", "LDAP-BDD", "CAS-BDD", "OIDC-BDD"])) {
            return defaultPage();
        } else {
            $login = new \Ppci\Libraries\Login();
            return $this->defaultReturn($login->getLogin());
        }
    }
    public function loginCasExec()
    {
        $config = service("IdentificationConfig");
        $ident_type = $config->identificationMode;
        if ($ident_type == "CAS-BDD" && $_REQUEST["identificationType"] == "CAS") {
            $ident_type = "CAS";
        }
        if ($ident_type == "CAS") {
            $login = new \Ppci\Libraries\Login();
            return $this->defaultReturn($login->getLogin());
        } else {
            return redirect()->to(site_url());
        }
    }
    public function oidcExec () {
        $config = service("IdentificationConfig");
         $ident_type = $config->identificationMode;
        if ($ident_type == "OIDC-BDD" && $_REQUEST["identificationType"] != "BDD") {
            $ident_type = "OIDC";
        }
        if ($ident_type == "OIDC") {
            $login = new \Ppci\Libraries\Login();
            return $this->defaultReturn($login->getLogin());
        } else {
            return redirect()->to(site_url());
        }
    }
    public function getLogo() {
        $vue = service("BinaryView");
        $config = service("IdentificationConfig");

        $vue->setParam(
            array(
                "disposition" => "inline",
                "tmp_name" => $config->identificationLogo
            )
        );
        return $vue->send();
    }
    public function disconnect()
    {
        $login = new \Ppci\Models\Login();
        $login->disconnect();
        $_SESSION["filterMessages"][] = (_("Vous avez été déconnecté"));
        return redirect()->to(site_url());
    }
    protected function defaultReturn($retour = "")
    {
        if ($_SESSION["isLogged"]) {
            if (!empty($_SESSION["moduleRequired"])) {
                $retour = $_SESSION["moduleRequired"];
            } elseif ($retour == "login") {
                $retour = "";
            }
        }
        if (empty($retour)) {
           return defaultPage();
        } else {
            return redirect()->to($retour);
        }
    }
}
