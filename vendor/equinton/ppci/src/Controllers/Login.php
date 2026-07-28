<?php

namespace Ppci\Controllers;

use Ppci\Libraries\Login as LibrariesLogin;

class Login extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesLogin();
    }
    function index()
    {
        $idConfig = service("IdentificationConfig");
        if (isset($_COOKIE["tokenIdentity"])) {
            return $this->defaultReturn($this->lib->getLogin());
        }
        if ($idConfig->identificationMode == "MIXED") {
            return $this->lib->displayMixed();
        } else if (in_array($idConfig->identificationMode, ["BDD", "LDAP", "LDAP-BDD", "CAS-BDD", "OIDC-BDD"])) {
            return ($this->lib->display());
        } else {
            /**
             * Identification HEADER
             */
            if (!$_SESSION["isLogged"] && $idConfig->identificationMode == "HEADER") {
                $retour = $this->lib->getLogin();
                if (empty($retour) && !$_SESSION["isLogged"]) {
                    $_SESSION["filterMessages"][] = _("Identification refusée");
                }
                return $this->defaultReturn($retour);
            } else {
                if ($idConfig->identificationMode == "CAS") {
                    return $this->defaultReturn("loginCasExec");
                } else if ($idConfig->identificationMode == "OIDC") {
                    return $this->defaultReturn("oidcExec");
                }
            }
            $_SESSION["filterMessages"][] = _("Le mode d'identification dans l'application ne vous permet pas d'accéder à la page de connexion");
            return defaultPage();
        }
    }
    public function loginExec()
    {
        $config = service("IdentificationConfig");
        if (!in_array($config->identificationMode, ["BDD", "LDAP", "CAS", "LDAP-BDD", "CAS-BDD", "OIDC-BDD"])) {
            return defaultPage();
        } else {
            return $this->defaultReturn($this->lib->getLogin());
        }
    }
    public function loginMixedExec()
    {
        $config = service("IdentificationConfig");
        if ($config->identificationMode == "MIXED" && in_array($_POST["identificationType"], ["BDD", "LDAP", "LDAP-BDD"])) {
            return $this->defaultReturn($this->lib->getLogin($_POST["identificationType"]));
        } else {
            return defaultPage();
        }
    }
    public function loginExternalExec()
    {
        /**
         * Search if it's cas or oidc
         */
        unset($_SESSION["CasParams"]);
        unset($_SESSION["OidcParam"]);
        $cas = service("Cas");
        $found = false;
        $type = "MIXED";
        if (!empty($cas->servers)) {
            $cass = explode(",", $cas->servers);
            if (in_array($_POST["provider"], $cass)) {
                $provider = $_POST["provider"];
                $_SESSION["CasParam"] = $cas->$provider;
                $type = "CAS";
                $found = true;
            }
        }
        if (!$found) {
            $oidc = service("Oidc");
            $oidcs = explode(",", $oidc->servers);
            if (in_array($_POST["provider"], $oidcs)) {
                $provider = $_POST["provider"];
                $_SESSION["OidcParam"] = $oidc->$provider;
                $type = "OIDC";
                $found = true;
            }
        }
        if ($found) {
            return $this->defaultReturn($this->lib->getLogin($type));
        }
        return defaultPage();
    }
    public function loginCasExec()
    {
        $config = service("IdentificationConfig");
        $ident_type = $config->identificationMode;
        if ($ident_type == "CAS-BDD" && $_REQUEST["identificationType"] == "CAS") {
            $ident_type = "CAS";
        }
        if ($ident_type == "CAS") {
            return $this->defaultReturn($this->lib->getLogin());
        } else {
            return $this->defaultReturn();
        }
    }
    public function oidcExec()
        {
        $config = service("IdentificationConfig");
        $ident_type = $config->identificationMode;
        if ($ident_type == "OIDC-BDD" && $_REQUEST["identificationType"] != "BDD") {
            $ident_type = "OIDC";
        }
        if ($ident_type == "OIDC" || !empty($_SESSION["OidcParam"])) { 
            return $this->defaultReturn($this->lib->getLogin("OIDC"));
        } else {
            return $this->defaultReturn();
        }
    }
    public function oidc()
    {
        return $this->defaultReturn($this->lib->getLogin("OIDC"));
    }
    public function cas() {
        return $this->defaultReturn($this->lib->getLogin("CAS"));
    }
    public function getLogo()
    {
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
        $this->lib->disconnect();
        $_SESSION["filterMessages"][] = (_("Vous avez été déconnecté"));
        return $this->defaultReturn();
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
            return redirect($retour, "refresh");
        }
    }
}
