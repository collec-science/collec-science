<?php

namespace Ppci\Libraries;

use App\Libraries\PostLogin;
use Ppci\Models\Gacltotp;
use CodeIgniter\Cookie\Cookie;

class Login extends PpciLibrary
{
    protected $datalogin;
    public $identificationConfig;
    protected $acllogin;
    protected $gacltotp;
    function __construct()
    {
        parent::__construct();
        $this->datalogin = new \Ppci\Models\Login();
        $this->identificationConfig = service('IdentificationConfig');
        $this->acllogin = new \Ppci\Models\Acllogin();
        $this->gacltotp = new Gacltotp($this->appConfig->privateKey, $this->appConfig->pubKey);
    }
    /**
     * Perform authentication
     *
     * @return ?string
     */
    function getLogin()
    {
        try {
            if (!empty($_REQUEST["token"]) && !empty($_REQUEST["login"])) {
                $ident_type = "ws";
                $_SESSION["login"] = strtolower($this->datalogin->getLogin($ident_type));
                if (!empty($_SESSION["login"])) {
                    $this->postLogin($ident_type);
                }
                return;
            } else {
                $ident_type = $this->identificationConfig->identificationMode;
            }
            if (in_array($ident_type, ["BDD", "CAS", "CAS-BDD", "OIDC", "OIDC-BDD"]) && in_array($_REQUEST["identificationType"], ["CAS", "BDD", "OIDC"])) {
                $ident_type = $_REQUEST["identificationType"];
            }
            if (
                in_array($ident_type, ["BDD", "LDAP", "LDAP-BDD", "CAS-BDD", "OIDC-BDD"])
                && empty($_POST["login"])
                && empty($_SESSION["login"])
                && empty($_COOKIE["tokenIdentity"])
                && empty($_REQUEST["cas_required"])
                && empty($_GET["ticket"])
                && !isset($_SESSION["phpCAS"])
                && !isset($_SESSION["openid_connect_nonce"])
            ) {
                return "login";
            } else {
                /**
                 * Verify the login
                 */
                if (empty($_SESSION["login"])) {

                    $_SESSION["login"] = strtolower($this->datalogin->getLogin($ident_type));
                }
            }
            if (!empty($_SESSION["login"])) {
                /**
                 * Verify if the double authentication is mandatory
                 */
                if ($this->acllogin->isTotp() && !isset($_COOKIE["tokenIdentity"]) && !isset($_POST["otpcode"])) {
                    /**
                     * Verify if the cookie totpTrustBrowser is present and valid
                     */
                    $totpNecessary = true;
                    if (isset($_COOKIE["totpTrustBrowser"])) {
                        $content = json_decode($this->gacltotp->decode($_COOKIE["totpTrustBrowser"], "pub"), true);
                        if ($content["uid"] == $_SESSION["login"] && $content["exp"] > time()) {
                            $totpNecessary = false;
                            $_SESSION["isLogged"] = true;
                        }
                    }
                    /**
                     * Display the form to entry the TOTP code
                     */
                    if ($totpNecessary) {
                        return "totp";
                    }
                } else {
                    $_SESSION["isLogged"] = true;
                }
            } else {
                if ($ident_type == "ws") {
                    /*http_response_code(401);
                    $vue->set(array("error_code" => 401, "error_message" => _("Identification refusée")));*/
                } else {
                    return "login";
                }
            }
        } catch (\Exception $e) {
            $message = service("MessagePpci");
            $message->set($e->getMessage(), true);
        }
        if ($_SESSION["isLogged"]) {
            $this->postLogin($ident_type);
        }
        unset($_SESSION["menu"]);
    }

    public function display()
    {
        $vue = service('Smarty');
        $vue->set("ppci/ident/login.tpl", "corps");
        $CAS_enabled = 0;
        if ($this->identificationConfig->identificationMode == "CAS-BDD") {
            $CAS_enabled = 1;
            $vue->set($this->identificationConfig->identificationLogo, "getLogo");
        }
        if ($this->identificationConfig->identificationMode == "OIDC-BDD") {
            $OIDC_enabled = 1;
            $vue->set($this->identificationConfig->identificationLogo, "getLogo");
        }
        $vue->set($CAS_enabled, "CAS_enabled");
        $vue->set($OIDC_enabled, "OIDC_enabled");
        $vue->set($this->identificationConfig->tokenIdentityValidity, "tokenIdentityValidity");
        $vue->set($this->identificationConfig->APPLI_lostPassword, "lostPassword");
        $vue->set("", "moduleCalled");
        return $vue->send();
    }
    function postLogin($ident_type)
    {
        /**
         * Generate rights
         */
        $_SESSION["userRights"] = $this->acllogin->generateRights(
            $_SESSION["login"],
            $this->appConfig->GACL_aco,
            $this->identificationConfig->LDAP
        );
        if ($ident_type != "ws") {
            $this->log->setMessageLastConnections();
        }
        if ($_POST["loginByTokenRequested"] == 1) {
            helper('cookie');
            $maxAge = $this->identificationConfig->tokenIdentityValidity;
            $content = json_encode([
                "uid" => $_SESSION["login"],
                "exp" => time() + $maxAge
            ]);
            $encoded = $this->gacltotp->encode($content, "priv");
            $cookie = new Cookie(
                'tokenIdentity',
                $encoded,
                [
                    'max-age' => $maxAge,
                    'secure'   => true,
                    'httponly' => true,
                ]
            );
            set_cookie($cookie);
        }
        /**
         * call to postLogin App
         */
        PostLogin::index();
    }
}
