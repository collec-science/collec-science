<?php

namespace Ppci\Models;

use Config\App;
use CodeIgniter\Cookie\Cookie;
use Ppci\Libraries\PpciException;
use Jumbojett\OpenIDConnectClient;

class Login
{
    public LoginGestion $loginGestion;
    public Log $log;
    public Acllogin $acllogin;
    public Aclgroup $aclgroup;
    public $message;
    private array $dacllogin;
    public string $identificationMode;
    public App $paramApp;
    public $identificationConfig;

    function __construct()
    {
        /**
         * @var App
         */
        $this->paramApp = config("App");
        $this->loginGestion = new LoginGestion();
        $this->loginGestion->setKeys($this->paramApp->privateKey, $this->paramApp->pubKey);
        $this->acllogin = new Acllogin();
        $this->aclgroup = new Aclgroup();
        $this->log = service("Log");
        $this->message = service("MessagePpci");
        $this->identificationConfig = service("IdentificationConfig");
        $this->identificationMode = $this->identificationConfig->identificationMode;
    }

    function getLogin(string $type_authentification): ?string
    {
        $tauth = "";
        if ($type_authentification == "CAS-BDD") {
            $type_authentification = "CAS";
        } elseif ($type_authentification == "OIDC-BDD") {
            $type_authentification = "OIDC";
        }
        $this->loginGestion->attemptdelay = $this->identificationConfig->CONNECTION_blocking_duration;
        $this->loginGestion->nbattempts = $this->identificationConfig->CONNECTION_max_attempts;
        /**
         * web service
         */
        if ($type_authentification == "ws") {
            $tauth = "swtoken";
            if ($this->loginGestion->getLoginFromTokenWS($_REQUEST["login"], $_REQUEST["token"])) {
                $login = $_REQUEST["login"];
                $_SESSION["realIdentificationMode"] = "ws";
            }
        } elseif ($type_authentification == "HEADER") {
            $tauth = "header";
            $login = $this->getLoginFromHeader();
            $_SESSION["realIdentificationMode"] = "HEADER";
        } elseif (isset($_COOKIE["tokenIdentity"])) {
            $tauth = "token";
            /**
             * Token identification
             */
            try {

                $gaclTotp = new Gacltotp($this->paramApp->privateKey, $this->paramApp->pubKey);
                $token = json_decode($gaclTotp->decode($_COOKIE["tokenIdentity"], "pub"), true);
                if ($token["exp"] > time()) {
                    $login = $token["uid"];
                    $_SESSION["isLogged"] = 1;
                } else {
                    throw new PpciException(_("Le jeton fourni n'est pas valide"));
                }
            } catch (PpciException $e) {
                $_SESSION["filterMessages"][] = _("L'identification par jeton n'a pas abouti");
                if ($_ENV["CI_ENVIRONMENT"] == "development") {
                    $_SESSION["filterMessages"][] = $e->getMessage();
                }
                //$this->message->set(_("L'identification par jeton n'a pas abouti"), true);
                $this->message->setSyslog($e->getMessage());
                /**
                 * Destroy the token
                 */
                helper('cookie');
                setcookie('tokenIdentity', "", time() - 36000);
            }
        } elseif ($type_authentification == "CAS") {
            $tauth = "cas";
            if (isset($_SESSION["phpCAS"])) {
                $login = $_SESSION["phpCAS"]["user"];
            } else {
                $login = $this->getLoginCas();
            }
            $_SESSION["realIdentificationMode"] = "CAS";
        } elseif ($type_authentification == "OIDC") {
            $tauth = "oidc";
            $login = $this->getOidc();
        } elseif ($type_authentification == "LDAP" || $type_authentification == "LDAP-BDD") {
            $tauth = "ldap";
            $login = $this->getLoginLdap($_POST["login"], $_POST["password"]);
            $_SESSION["realIdentificationMode"] = "LDAP";
            if (empty($login) && $type_authentification == "LDAP-BDD") {
                $tauth = "db";
                $login = $this->getLoginBDD($_POST["login"], $_POST["password"]);
                $_SESSION["realIdentificationMode"] = "BDD";
            }
        } elseif ($type_authentification == "BDD" || $type_authentification == "CAS-BDD" || $type_authentification == "OIDC-BDD") {
            $tauth = "db";
            $login = $this->getLoginBDD($_POST["login"], $_POST["password"]);
            $_SESSION["realIdentificationMode"] = "BDD";
        }
        if (!empty($login)) {
            $_SESSION["realIdentificationMode"] = $tauth;
            $this->log->setlog($login, "connection-" . $tauth, "ok");
        } else {
            isset($_POST["login"]) ? $loginRequired = $_POST["login"] : $loginRequired = "unknown";
            $this->log->setlog($loginRequired, "connection-" . $tauth, "ko");
            $this->message->set(_("L'identification n'a pas abouti. Vérifiez votre login et votre mot de passe"), true);
        }
        return $login;
    }

    function getLoginFromHeader()
    {
        $headers = $this->identificationConfig->HEADER;
        if (!empty($this->identificationConfig->organizationGranted)) {
            $headers["organizationGranted"] = explode(",", $this->identificationConfig->organizationGranted);
        }
        if (!empty($this->identificationConfig->groupsGranted)) {
            $headers["groupsGranted"] = explode(",", $this->identificationConfig->groupsGranted);
        }
        $userparams = $this->getUserParams($headers, $_SERVER);
        $login = $userparams["login"];
        $verify = false;
        if (!empty($login)) {
            /**
             * Verify if the login exists
             */
            $dlogin = $this->loginGestion->getFromLogin($login);
            /**
             * Verify if the login is recorded
             */
            if ($dlogin["id"] > 0) {
                if ($dlogin["actif"] == 1) {
                    $verify = true;
                }
            } else {
                /**
                 * Create if authorized the login
                 */
                if ($headers["createUser"]) {
                    /**
                     * Verify if the structure is authorized
                     */
                    $createUser = true;
                    if (!empty($headers["organizationGranted"])) {
                        $createUser = false;
                        if (!is_array($userparams["organization"])) {
                            $userparams["organization"] = explode(",", $userparams["organization"]);
                        }
                        foreach ($userparams["organization"] as $org) {
                            if (in_array($org, $headers["organizationGranted"])) {
                                $createUser = true;
                                break;
                            }
                        }
                    }
                    if (!$createUser) {
                        $this->log->setLog($login, "connection-header", "ko. The " . $userparams["organization"] . " is not authorized to connect to this application or the code of organization is not furnished");
                    }
                    if ($createUser) {
                        $dlogin = array(
                            "id" => 0,
                            "login" => $login,
                            "actif" => 0
                        );
                        if (!empty($userparams["groups"]) && !empty($headers["groupsGranted"])) {
                            if (!is_array($userparams["groups"])) {
                                $userparams["groups"] = explode(",", $userparams["groups"]);
                            }
                            foreach ($userparams["groups"] as $group) {
                                if (in_array($group, $headers["groupsGranted"])) {
                                    $dlogin["actif"] = 1;
                                    $verify = true;
                                    break;
                                }
                            }
                        }
                        $login_id = $this->loginGestion->ecrire($dlogin);
                        if ($login_id > 0) {
                            $this->updateLoginFromIdentification($login, $userparams);
                            if (!$verify) {
                                /**
                                 * Send mail to administrators
                                 */
                                $APPLI_address = base_url();
                                $dbparam = $_SESSION["dbparams"];
                                $subject = $dbparam->params["APPLI_title"] . " - " . _("Nouvel utilisateur");
                                $template = "ppci/mail/newUser.tpl";
                                $data = array(
                                    "login" => $login,
                                    "name" => $this->dacllogin["logindetail"],
                                    "appName" => $dbparam->params["APPLI_title"],
                                    "organization" => $userparams["organization"],
                                    "link" => $APPLI_address
                                );
                                $this->log->sendMailToAdmin($subject, $template, $data, "loginCreateByHeader", $login);
                                $_SESSION["filterMessage"][] = _("Votre compte a été créé, mais est inactif. Un mail a été adressé aux administrateurs pour son activation");
                            }
                        } else {
                            $verify = false;
                        }
                    }
                }
            }
        } else {
            $this->log->setLog("unknown", "connection-header", "ko");
            throw new \Ppci\Libraries\PpciException(_("Aucun login n'a été fourni, identification refusée"));
        }
        if ($verify) {
            $_SESSION["userAttributes"] = $userparams;
            return $login;
        } else {
            return "";
        }
    }

    function getUserParams(array $attributes, array $provider = array()): array
    {
        $params = array();
        foreach ($attributes as $k => $v) {
            if (!empty($v) && isset($provider[$v])) {
                $params[$k] = $provider[$v];
            }
        }
        return $params;
    }
    /**
     * Update records of identification with data provided by the authentificator
     *
     * @param string $login
     * @param array $params
     * @return void
     */
    function updateLoginFromIdentification(string $login, array $params)
    {
        if (!empty($params["email"])) {
            $params["mail"] = $params["email"];
        }
        /**
         * Update logingestion
         */
        $dlogin = $this->loginGestion->getFromLogin($login);
        if ($dlogin["id"] > 0) {
            if (!empty($params["lastname"])) {
                $dlogin["nom"] = ucwords(strtolower($params["lastname"]));
                $dlogin["prenom"] = ucwords(strtolower($params["firstname"]));
            } else if (!empty($params["name"])) {
                $dlogin["nom"] = ucwords(strtolower($params["name"]));
            }
            if (!empty($params["mail"])) {
                $dlogin["mail"] = strtolower($params["mail"]);
            }
            $this->loginGestion->ecrire($dlogin);
        }
        /**
         * Update or create acllogin
         */
        $dacllogin = $this->acllogin->getFromLogin($login);
        if (empty($dacllogin["acllogin_id"])) {
            $dacllogin["acllogin_id"] = 0;
            $dacllogin["login"] = $login;
            $id = 0;
        } else {
            $id = $dacllogin["acllogin_id"];
        }
        if (!empty($params["lastname"]) && !empty($params["firstname"])) {
            $dacllogin["logindetail"] = ucwords(strtolower($params["lastname"] . " " . $params["firstname"]));
        } else if (!empty($params["name"])) {
            $dacllogin["logindetail"] = ucwords(strtolower($params["name"]));
        } else if (empty($dacllogin["logindetail"])) {
            $dacllogin["logindetail"] = $login;
        }
        if (!empty(trim($params["mail"]))) {
            $dacllogin["email"] = trim($params["mail"]);
        }
        $id = $this->acllogin->ecrire($dacllogin);
        $this->dacllogin = $dacllogin;
        /**
         * Add acllogin to the main group, if exists
         */
        if (!empty($params["groupeAttribute"])) {
            if (!is_array($params["groupeAttribute"])) {
                $params["groupeAttribute"] = array($params["groupeAttribute"]);
            }
            foreach ($params["groupeAttribute"] as $group) {
                $dgroups = $this->aclgroup->getGroupFromName($group);
                foreach ($dgroups as $dgroup) {
                    $this->aclgroup->addLoginToGroup($dgroup["aclgroup_id"], $id);
                }
            }
        }
    }

    /**
     * Get login from CAS server
     *
     * @return string|null
     */
    public function getLoginCas()
    {
        $CAS = $this->identificationConfig->CAS;
        if ($CAS["debug"]) {
            \phpCAS::setDebug(WRITEPATH . "logs/cas.log");
            \phpCAS::setVerbose(true);
        }
        \phpCAS::client(
            CAS_VERSION_2_0,
            $CAS["address"],
            $CAS["port"],
            $CAS["uri"],
            "https://" . $_SERVER["HTTP_HOST"],
            false
        );
        if (!empty($CAS["CApath"])) {
            \phpCAS::setCasServerCACert($CAS["CApath"]);
        } else {
            \phpCAS::setNoCasServerValidation();
        }
        $user = "";
        \phpCAS::forceAuthentication();
        $user = \phpCAS::getUser();
        $_SESSION["login"] = $user;
        if (!empty($user)) {
            $attributes = \phpCAS::getAttributes();
            if (!is_array($attributes)) {
                $attributes = array($attributes);
            }
            if (!empty($attributes)) {
                $attrs = ["name", "email", "group", "firstname", "lastname"];
                $params = $this->getUserParams($attrs, $attributes);
                $this->updateLoginFromIdentification($user, $params);
                $_SESSION["userAttributes"] = $params;
            }
        }
        return $user;
    }

    public function getLoginLdap($login, $password)
    {
        $LDAP = $this->identificationConfig->LDAP;
        $loginOk = "";
        if (!empty($login) && !empty($password)) {
            $login = str_replace(
                array('\\', '*', '(', ')',),
                array('\5c', '\2a', '\28', '\29',),
                $login
            );
            for ($i = 0; $i < strlen($login); $i++) {
                $char = substr($login, $i, 1);
                if (ord($char) < 32) {
                    $hex = dechex(ord($char));
                    if (strlen($hex) == 1) {
                        $hex = '0' . $hex;
                    }
                    $login = str_replace($char, '\\' . $hex, $login);
                }
            }
            $ldap = @ldap_connect($LDAP["address"], $LDAP["port"]);
            /**
             * Set options
             */
            if (!isset($LDAP["timeout"])) {
                $LDAP["timeout"] = 2;
            }
            ldap_set_option($ldap, LDAP_OPT_NETWORK_TIMEOUT, $LDAP["timeout"]);
            ldap_set_option($ldap, LDAP_OPT_TIMELIMIT, $LDAP["timeout"]);
            ldap_set_option($ldap, LDAP_OPT_TIMEOUT, $LDAP["timeout"]);
            if (!$ldap) {
                throw new \Ppci\Libraries\PpciException(_("Impossible de se connecter au serveur LDAP"));
            }
            if ($LDAP["v3"]) {
                ldap_set_option($ldap, LDAP_OPT_PROTOCOL_VERSION, 3);
            }
            if ($LDAP["tls"]) {
                ldap_start_tls($ldap);
            }

            /**
             * Pour OpenLDAP et Active Directory, "bind rdn" de la forme : user_attrib=login,basedn
             *     avec généralement user_attrib=uid pour OpenLDAP,
             *                    et user_attrib=cn pour Active Directory
             * Pour Active Directory aussi, "bind rdn" de la forme : login@upn_suffix
             * D'où un "bind rdn" de la forme générique suivante :
             *     (user_attrib=)login(@upn_suffix)(,basedn)
             */
            $user_attrib_part = !empty($LDAP["user_attrib"]) ? $LDAP["user_attrib"] . "=" : "";
            $upn_suffix_part = !empty($LDAP["upn_suffix"]) ? "@" . $LDAP["upn_suffix"] : "";
            $basedn_part = !empty($LDAP["basedn"]) ? "," . $LDAP["basedn"] : "";
            //     (user_attrib=)login(@upn_suffix)(,basedn)
            $dn = $user_attrib_part . $login . $upn_suffix_part . $basedn_part;
            if (@ldap_bind($ldap, $dn, $password)) {
                $loginOk = $login;
            } else {
                $this->log->setLog($login, "connection-ldap", "ko");
                throw new \Ppci\Libraries\PpciException(sprintf(_("La connexion auprès de l'annuaire LDAP pour l'utilisateur %s a échoué"), $login));
            }
        }
        return $loginOk;
    }

    /**
     * Verify the login from the database
     *
     * @param string $login
     * @param string $password
     * @return string|null
     */
    function getLoginBDD($login, $password)
    {
        if ($this->loginGestion->controlLogin($login, $password)) {
            return strtolower($login);
        }
    }

    /**
     * Disconnect the user
     *
     * @param string $adresse_retour
     * @return void
     */
    public function disconnect($adresse_retour = "")
    {
        $identificationMode = $_SESSION["realIdentificationMode"];
        // Si vous voulez détruire complètement la session, effacez également
        // le cookie de session.
        // Note : cela détruira la session et pas seulement les données de session !
        if (isset($_COOKIE[session_name()])) {
            setcookie(session_name(), "", [
                'expires' => time() - 42000,
                'secure'   => true,
                'httponly' => true,
            ]);
        }
        /*
         * Suppression du cookie d'identification
         */
        if (isset($_COOKIE["tokenIdentity"])) {
            setcookie(
                "tokenIdentity",
                "",
                [
                    'expires' => time() - 42000,
                    'secure'   => true,
                    'httponly' => true,
                ]
            );
        }
        $vars = ["login", "userRights", "menu", "isLogged"];
        foreach ($vars as $var) {
            unset($_SESSION[$var]);
        }
        $oidcIdtoken = $_SESSION["oidcIdToken"];
        // Finalement, on détruit la session.
        session()->destroy();
        //session_unset();
        session_regenerate_id();
        if ($identificationMode == "cas") {
            $CAS = $this->identificationConfig->CAS;
            \phpCAS::client(
                CAS_VERSION_2_0,
                $CAS["CAS_address"],
                $CAS["CAS_port"],
                $CAS["CAS_uri"],
                "https://" . $_SERVER["HTTP_HOST"]
            );
            if (!empty($CAS["CAS_CApath"])) {
                \phpCAS::setCasServerCACert($CAS["CAS_CApath"]);
            } else {
                \phpCAS::setNoCasServerValidation();
            }
            \phpCAS::logout(array("url" => "https://" . $_SERVER["HTTP_HOST"]));
        } else if ($identificationMode == "oidc") {
            $oidc = new OpenIDConnectClient(
                $this->identificationConfig->OIDC["provider"],
                $this->identificationConfig->OIDC["clientId"],
                $this->identificationConfig->OIDC["clientSecret"]
            );
            $redirect = $this->paramApp->baseURL;
            $oidc->signOut($oidcIdtoken, $redirect);
        }
    }
    /**
     * Identification with OIDC server
     *
     * @return string
     */
    function getOidc(): string
    {
        $oidc = new OpenIDConnectClient(
            $this->identificationConfig->OIDC["provider"],
            $this->identificationConfig->OIDC["clientId"],
            $this->identificationConfig->OIDC["clientSecret"]
        );

        //$oidc->addScope($attributes);
        $oidc->addScope(["profile", "email"]);
        if (!empty($this->identificationConfig->OIDC["scopeGroup"])) {
            $oidc->addScope([$this->identificationConfig->OIDC["scopeGroup"]]);
        }
        $oidc->authenticate();
        /**
         * login
         */
        $login = $oidc->getVerifiedClaims('sub');
        /**
         * Get attributes
         */
        $userInfo = $oidc->requestUserInfo();
        $keys = ["name", "email", "firstname", "lastname", "group"];
        $oidcAttrs = [];
        foreach ($keys as $k) {
            $attr = $this->identificationConfig->OIDC[$k];
            $oidcAttrs[$k] = $userInfo->$attr;
        }
        $_SESSION["userAttributes"] = $oidcAttrs;
        /**
         * Used for disconnect
         */
        $_SESSION["oidcIdToken"] = $oidc->getIdToken();
        /**
         * Upgrade or create acllogin
         */
        $this->updateLoginFromIdentification($login, $oidcAttrs);
        return $login;
    }
}
