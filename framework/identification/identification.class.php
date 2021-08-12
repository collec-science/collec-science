<?php

/** Fichier cree le 4 mai 07 par quinton
 *
 *UTF-8
 *
 * Classe maîtrisant les aspects identification.
 */
class IdentificationException extends Exception
{
}

/**
 * @class Identification
 * Gestion de l'identification - recuperation du login en fonction du type d'acces
 *
 * @author Eric Quinton -quinton.eric@gmail.com
 *
 */
class Identification
{

    public $ident_type = null;

    public $CAS_address;

    public $CAS_port;

    public $CAS_uri;

    public $CAS_debug = false;

    public $CAS_CApath;

    public $password;

    public $login;

    public $gacl;

    public $aco;

    public $aro;

    public $pagelogin;

    public $identification_mode;

    public function setpageloginBDD($page)
    {
        $this->pagelogin = $page;
    }

    /**
     *
     * @param $ident_type string
     */
    public function setidenttype($ident_type)
    {
        $this->ident_type = $ident_type;
    }

    /**
     * Initialisation si utilisation d'un CAS
     *
     * @param String $cas_address : adresse du CAS
     * @param int    $CAS_port    : port du CAS
     *
     * @return null
     */
    public function init_CAS($cas_address, $CAS_port, $CAS_uri, $CAS_debug = false, $CAS_CApath = "")
    {
        $this->CAS_address = $cas_address;
        $this->CAS_port = $CAS_port;
        $this->CAS_uri = $CAS_uri;
        $this->CAS_debug = $CAS_debug;
        $this->CAS_CApath = $CAS_CApath;
    }

    /**
     * Initialisation du test de connexion ldap
     *
     * @param array $LDAP: all parameters
     */
    public function init_LDAP($LDAP)
    {
        $this->LDAP = $LDAP;
    }

    /**
     * Gestion de la connexion en mode CAS
     */
    public function getLoginCas($modeAdmin = false)
    {
        if ($this->CAS_debug) {
            phpCAS::setDebug();
            phpCAS::setVerbose(true);
        }
        phpCAS::client(CAS_VERSION_2_0, $this->CAS_address, $this->CAS_port, $this->CAS_uri);
        if (strlen($this->CAS_CApath) > 0) {
            phpCAS::setCasServerCACert($this->CAS_CApath);
        } else {
            phpCAS::setNoCasServerValidation();
        }
        if ($modeAdmin) {
            phpCAS::renewAuthentication();
        } else {
            phpCAS::forceAuthentication();
        }

        return phpCAS::getUser();
    }

    /**
     * Teste le login et le mot de passe sur un annuaire ldap
     *
     * @param string $login
     * @param string $password
     *
     * @return string $password |int -1
     */
    public function testLoginLdap($login, $password)
    {
        $loginOk = "";
        global $log;
        if (strlen($login) > 0 && strlen($password) > 0) {
            $login = str_replace(
                array(
                    '\\',
                    '*',
                    '(',
                    ')',
                ),
                array(
                    '\5c',
                    '\2a',
                    '\28',
                    '\29',
                ),
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
            $ldap = @ldap_connect($this->LDAP["address"], $this->LDAP["port"]);
            /**
             * Set options
             */
            ldap_set_option($ldap, LDAP_OPT_NETWORK_TIMEOUT, $this->LDAP["timeout"]);
            ldap_set_option($ldap, LDAP_OPT_TIMELIMIT, $this->LDAP["timeout"]);
            ldap_set_option($ldap, LDAP_OPT_TIMEOUT, $this->LDAP["timeout"]);
            if (!$ldap) {
                throw new LdapException("Impossible de se connecter au serveur LDAP.");
            }
            if ($this->LDAP["v3"]) {
                ldap_set_option($ldap, LDAP_OPT_PROTOCOL_VERSION, 3);
            }
            if ($this->LDAP["tls"]) {
                ldap_start_tls($ldap);
            }

            /*
             * Pour OpenLDAP et Active Directory, "bind rdn" de la forme : user_attrib=login,basedn
             *     avec généralement user_attrib=uid pour OpenLDAP,
             *                    et user_attrib=cn pour Active Directory
             * Pour Active Directory aussi, "bind rdn" de la forme : login@upn_suffix
             * D'où un "bind rdn" de la forme générique suivante :
             *     (user_attrib=)login(@upn_suffix)(,basedn)
             */
            $user_attrib_part = !empty($this->LDAP["user_attrib"]) ? $this->LDAP["user_attrib"] . "=" : "";
            $upn_suffix_part = !empty($this->LDAP["upn_suffix"]) ? "@" . $this->LDAP["upn_suffix"] : "";
            $basedn_part = !empty($this->LDAP["basedn"]) ? "," . $this->LDAP["basedn"] : "";
            //     (user_attrib=)login(@upn_suffix)(,basedn)
            $dn = $user_attrib_part . $login . $upn_suffix_part . $basedn_part;
            $rep = ldap_bind($ldap, $dn, $password);
            if ($rep == 1) {
                $loginOk = $login;
                $log->setLog($login, "connexion", "ldap-ok");
            } else {
                /*
                 * Purge des anciens enregistrements dans log
                 */
                $log->setLog($login, "connexion", "ldap-ko");
            }
        }
        return $loginOk;
    }

    /**
     * Déconnexion de l'application
     *
     * @return 0:1
     */
    public function disconnect($adresse_retour = "")
    {
        if (!isset($this->ident_type)) {
            return 0;
        }
        // Détruit toutes les variables de session
        $_SESSION = array();

        // Si vous voulez détruire complètement la session, effacez également
        // le cookie de session.
        // Note : cela détruira la session et pas seulement les données de session !
        if (isset($_COOKIE[session_name()])) {
            setcookie(session_name(), '', time() - 42000, "/");
        }
        /*
         * Suppression du cookie d'identification
         */
        if (isset($_COOKIE["tokenIdentity"])) {
            setcookie("tokenIdentity", '', time() - 42000, "/");
        }
        // Finalement, on détruit la session.
        session_destroy();
        if ($this->ident_type == "CAS") {
            phpCAS::client(CAS_VERSION_2_0, $this->CAS_address, $this->CAS_port, $this->CAS_uri);
            if (strlen($this->CAS_CApath) > 0) {
                phpCAS::setCasServerCACert($this->CAS_CApath);
            } else {
                phpCAS::setNoCasServerValidation();
            }
            if (!empty($adresse_retour)) {
                phpCAS::logout(array("url" => $adresse_retour));
            } else {
                phpCAS::logout();
            }
        }
        if ($this->ident_type == "HEADER") {
            /*
             * Envoi vers la deconnexion du serveur fournissant le HEADER d'identification
             * En principe, l'url de deconnexion du CAS
             */
            global $ident_header_logout_address;
            if (strlen($ident_header_logout_address) > 0) {
                header('Location: ' . $ident_header_logout_address);
                flush();
            }
        }
        return 1;
    }


    /**
     * Verifie l'identification
     *
     * @return string
     */
    public function verifyLogin($loginEntered = "", $password = "", $modeAdmin = false)
    {
        global $log, $CONNEXION_blocking_duration, $CONNEXION_max_attempts, $message;
        $login = "";
        $verify = false;
        $ident_type = $this->ident_type;

        /*
         * Un cookie d'identification est-il fourni ?
         */
        if (isset($_COOKIE["tokenIdentity"]) && !$modeAdmin) {
            include_once 'framework/identification/token.class.php';
            $tokenClass = new Token();
            try {
                $login = $tokenClass->openTokenFromJson($_COOKIE["tokenIdentity"]);
                if (!empty($login)  && !$log->isAccountBlocked($login, $CONNEXION_blocking_duration, $CONNEXION_max_attempts)) {
                    $verify = true;
                    $log->setLog($login, $module . "-connexion", "token-ok");
                }
            } catch (FrameworkException $e) {
                $log->setLog($login, $module . "-connexion", "token-ko");
                $message->set($e->getMessage(), true);
            }
        } elseif ($ident_type == "HEADER") {
            /*
             * Identification via les headers fournis par le serveur web
             * dans le cas d'une identification derriere un proxy comme LemonLdap
             */
            global $ident_header_vars;
            $headers = getHeaders($ident_header_vars["radical"]);
            $login = strtolower($headers[$ident_header_vars["login"]]);
            if (strlen($login) > 0 && !empty($headers)) {
                /**
                 * Verify if the login exists
                 */
                include_once "framework/identification/loginGestion.class.php";
                global $bdd_gacl, $ObjetBDDParam;
                $loginGestion = new LoginGestion($bdd_gacl, $ObjetBDDParam);
                $dlogin = $loginGestion->getFromLogin($login);
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
                    if ($ident_header_vars["createUser"]) {
                        /**
                         * Verify if the structure is authorized
                         */
                        $createUser = true;
                        if (count($ident_header_vars["organizationGranted"]) > 0 && !in_array($headers[$ident_header_vars["organization"]], $ident_header_vars["organizationGranted"])) {
                            $createUser = false;
                            $log->setLog($login, "connexion", "HEADER-ko. The " . $headers[$ident_header_vars["organization"]] . " is not authorized to connect to this application");
                        }
                        if ($createUser) {
                            $dlogin = array(
                                "login" => $login,
                                "nom" => $headers[$ident_header_vars["cn"]],
                                "mail" => $headers[$ident_header_vars["mail"]],
                                "actif" => 0
                            );
                            $login_id = $loginGestion->ecrire($dlogin);
                            if ($login_id > 0) {
                                /**
                                 * Create the record in gacllogin
                                 */
                                include_once "framework/droits/droits.class.php";
                                $aclogin = new Acllogin($bdd_gacl);
                                $aclogin->addLoginByLoginAndName($login, $headers[$ident_header_vars["cn"]]);
                                /**
                                 * Send mail to administrators
                                 */
                                global $APPLI_nom, $APPLI_mail;
                                $subject = $APPLI_nom . " " . _("Nouvel utilisateur");
                                $contents = "<html><body>" . sprintf(_("%1$s a créé son compte avec le login %2$s dans l'application %3$s.
                                <br>Il est rattaché à l'organisation %5$s.
                                <br>Le compte est inactif jusqu'à ce que vous l'activiez.
                                <br>Pour activer le compte, connectez-vous à l'application
                                    <a href='%4$s'>%4$s</a>
                                <br>Ne répondez pas à ce mail, qui est généré automatiquement") . "</body></html>", $login, $headers[$ident_header_vars["cn"]], $APPLI_nom, $APPLI_mail, $headers[$ident_header_vars["organization"]]);

                                $log->sendMailToAdmin($subject, $contents, "loginCreateByHeader", $login);
                                $message->set(_("Votre compte a été créé, mais est inactif. Un mail a été adressé aux administrateurs pour son activation"));
                            }
                        }
                    }
                }
                /*
                 * Verification si le nombre de tentatives de connexion n'a pas ete atteint
                 */
                if (!$log->isAccountBlocked($login, $CONNEXION_blocking_duration, $CONNEXION_max_attempts)) {
                    $log->setLog($login, "connexion", "HEADER-ok");
                } else {
                    $verify = false;
                }
            }
            if (!$verify) {
                $log->setLog($login, "connexion", "HEADER-ko");
            }
        } elseif ($ident_type == "CAS") {
            if (!$log->isAccountBlocked($login, $CONNEXION_blocking_duration, $CONNEXION_max_attempts)) {

                /*
                 * Verification du login aupres du serveur CAS
                 */
                $login = $this->getLoginCas($modeAdmin);
                if (strlen($login) > 0) {
                    $verify = true;
                }
            }
        } else {
            /*
             * On verifie si on est en retour de validation du login
             */
            if (strlen($loginEntered) > 0 && !$log->isAccountBlocked($loginEntered, $CONNEXION_blocking_duration, $CONNEXION_max_attempts)) {
                $verify = true;
                /*
                     * Verification de l'identification aupres du serveur LDAP, ou LDAP puis BDD
                     */
                if ($ident_type == "LDAP" || $ident_type == "LDAP-BDD") {

                    try {
                        $login = $this->testLoginLdap($loginEntered, $password);
                        if (strlen($login) == 0 && $ident_type == "LDAP-BDD") {
                            /*
                                 * L'identification en annuaire LDAP a echoue : verification en base de donnees
                                 */
                            $login = $this->testBdd($loginEntered, $password);
                        }
                    } catch (Exception $e) {
                        $message->setSyslog($e->getMessage());
                    }
                } elseif ($ident_type == "BDD") {
                    /*
                         * Verification de l'identification uniquement en base de donnees
                         */

                    $login = $this->testBdd($loginEntered, $password);
                }
            }
        }

        /*
         * Si le nombre total d'essais a ete atteint, le login est refuse
         */
        if (!$verify) {
            $login = "";
        }
        return strtolower($login);
    }

    /**
     * Teste la connexion via la base de donnees
     */
    public function testBdd($loginEntered, $password)
    {
        require_once 'framework/identification/loginGestion.class.php';
        global $bdd_gacl, $message;
        $login = "";
        $loginGestion = new LoginGestion($bdd_gacl);
        try {
            $res = $loginGestion->controlLogin($loginEntered, $password);
            if ($res) {
                $login = $loginEntered;
            }
        } catch (Exception $e) {
            $message->setSyslog($e->getMessage());
        }
        return $login;
    }
}
