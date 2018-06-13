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

    var $ident_type = NULL;

    var $CAS_address;

    var $CAS_port;

    var $CAS_uri;

    var $LDAP_address;

    var $LDAP_port;

    var $LDAP_rdn;

    var $LDAP_basedn;

    var $LDAP_user_attrib;

    var $LDAP_v3;

    var $LDAP_tls;

    var $LDAP_upn_suffix; // User Principal Name (UPN) Suffix pour Active Directory

    var $password;

    var $login;

    var $gacl;

    var $aco;

    var $aro;

    var $pagelogin;

    public $identification_mode;

    function setpageloginBDD($page)
    {
        $this->pagelogin = $page;
    }

    /**
     *
     * @param $ident_type string
     */
    function setidenttype($ident_type)
    {
        $this->ident_type = $ident_type;
    }

    /**
     * initialisation si utilisation d'un CAS
     *
     * @param String $cas_address
     *            : adresse
     *            du CAS
     * @param int $CAS_port
     *            : port
     *            du CAS
     * @return null
     */
    function init_CAS($cas_address, $CAS_port, $CAS_uri)
    {
        $this->CAS_address = $cas_address;
        $this->CAS_port = $CAS_port;
        $this->CAS_uri = $CAS_uri;
    }

    /**
     * Initialisation du test de connexion ldap
     *
     * @param String $LDAP_address
     * @param String $LDAP_port
     * @param String $LDAP_basedn
     * @param String $LDAP_user_attrib
     * @param String $LDAP_v3
     * @param String $LDAP_tls
     * @param String $LDAP_upn_suffix
     */
    function init_LDAP($LDAP_address, $LDAP_port, $LDAP_basedn, $LDAP_user_attrib, $LDAP_v3, $LDAP_tls, $LDAP_upn_suffix="" )
    {
        $this->LDAP_address = $LDAP_address;
        $this->LDAP_port = $LDAP_port;
        $this->LDAP_basedn = $LDAP_basedn;
        $this->LDAP_user_attrib = $LDAP_user_attrib;
        $this->LDAP_v3 = $LDAP_v3;
        $this->LDAP_tls = $LDAP_tls;
        $this->LDAP_upn_suffix = $LDAP_upn_suffix;
    }

    /**
     * Gestion de la connexion en mode CAS
     */
    function getLoginCas()
    {
        phpCAS::setDebug();
        phpCAS::setVerbose($true);
        phpCAS::client(CAS_VERSION_2_0, $this->CAS_address, $this->CAS_port, $this->CAS_uri);
        phpCAS::forceAuthentication();
        return phpCAS::getUser();
    }

    /**
     * Teste le login et le mot de passe sur un annuaire ldap
     *
     * @param string $login
     * @param string $password
     * @return string $password |int -1
     */
    function testLoginLdap($login, $password)
    {
        $loginOk = "";
        global $log, $LOG_duree, $message;
        if (strlen($login) > 0 && strlen($password) > 0) {
            $login = str_replace(array(
                '\\',
                '*',
                '(',
                ')'
            ), array(
                '\5c',
                '\2a',
                '\28',
                '\29'
            ), $login);
            for ($i = 0; $i < strlen($login); $i ++) {
                $char = substr($login, $i, 1);
                if (ord($char) < 32) {
                    $hex = dechex(ord($char));
                    if (strlen($hex) == 1) {
                        $hex = '0' . $hex;
                    }
                    $login = str_replace($char, '\\' . $hex, $login);
                }
            }
            $ldap = @ldap_connect($this->LDAP_address, $this->LDAP_port);
            if (! $ldap) {
                throw new LdapException("Impossible de se connecter au serveur LDAP.");
            }
            if ($this->LDAP_v3) {
                ldap_set_option($ldap, LDAP_OPT_PROTOCOL_VERSION, 3);
            }
            if ($this->LDAP_tls) {
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
            $user_attrib_part = !empty($this->LDAP_user_attrib) ? $this->LDAP_user_attrib . "=" : "";
            $upn_suffix_part = !empty($this->LDAP_upn_suffix) ? "@" . $this->LDAP_upn_suffix : "";
            $basedn_part = !empty($this->LDAP_basedn) ? "," . $this->LDAP_basedn : "";
            //     (user_attrib=)login(@upn_suffix)(,basedn) 
            $dn = $user_attrib_part . $login . $upn_suffix_part . $basedn_part;
            $rep = ldap_bind($ldap, $dn, $password);
            if ($rep == 1) {
                $loginOk = $login;
                $log->setLog($login, "connexion", "ldap-ok");
                /*
                 * Purge des anciens enregistrements dans log
                 */
            } else {
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
    function disconnect($adresse_retour)
    {
        if (! isset($this->ident_type)) {
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
            phpCAS::logout($adresse_retour);
        }
        if ($this->ident_type = "HEADER") {
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
     * Initialisation de la classe gacl
     *
     * @param $gacl :
     *            instance
     *            gacl
     * @param string $aco
     *            : nom
     *            de la catégorie de base contenant les objets à tester
     * @param string $aro
     *            : nom
     *            de la catégorie contenant les logins à tester
     */
    function setgacl(&$gacl, $aco, $aro)
    {
        $this->gacl = $gacl;
        $this->aco = $aco;
        $this->aro = $aro;
    }

    /**
     * Teste les droits
     *
     * @param string $aco
     *            : Categorie a tester
     * @return int : 0 | 1
     */
    function getgacl($aco)
    {
        $login = $this->getLogin();
        if ($login == - 1) {
            return - 1;
        }
        return $this->gacl->acl_check($this->aco, $aco, $this->aro, $login);
    }

    /**
     * Verifie l'identification
     *
     * @return string
     */
    function verifyLogin($loginEntered = "", $password = "", $modeAdmin = false)
    {
        global $log, $CONNEXION_blocking_duration, $CONNEXION_max_attempts, $message;
        $login = "";
        $verify = false;
        $ident_type = $this->ident_type;
        
        /*
         * Un cookie d'identification est-il fourni ?
         */
        if (isset($_COOKIE["tokenIdentity"]) && ! $modeAdmin) {
            require_once 'framework/identification/token.class.php';
            $tokenClass = new Token();
            try {
                $login = $tokenClass->openTokenFromJson($_COOKIE["tokenIdentity"]);
                if (strlen($login) > 0) {
                    /*
                     * Verification si le nombre de tentatives de connexion n'a pas ete atteint
                     */
                    if (! $log->isAccountBlocked($login, $CONNEXION_blocking_duration, $CONNEXION_max_attempts)) {
                        $verify = true;
                        $log->setLog($login, $module . "-connexion", "token-ok");
                    }
                }
            } catch (Exception $e) {
                $log->setLog($login, $module . "-connexion", "token-ko");
                $message->set($e->getMessage());
            }
        } elseif ($ident_type == "HEADER") {
            /*
             * Identification via les headers fournis par le serveur web
             * dans le cas d'une identification derriere un proxy comme LemonLdap
             */
            global $ident_header_login_var;
            $headers = getHeaders();
            $login = $headers[strtoupper($ident_header_login_var)];
            if (strlen($login) > 0) {
                /*
                 * Verification si le nombre de tentatives de connexion n'a pas ete atteint
                 */
                if (! $log->isAccountBlocked($login, $CONNEXION_blocking_duration, $CONNEXION_max_attempts)) {
                    $log->setLog($login, "connexion", "HEADER-ok");
                }
            } else {
                $log->setLog($login, "connexion", "HEADER-ko");
            }
        } elseif ($ident_type == "CAS") {
            if (! $log->isAccountBlocked($login, $CONNEXION_blocking_duration, $CONNEXION_max_attempts)) {
                
                /*
                 * Verification du login aupres du serveur CAS
                 */
                $login = $this->getLoginCas();
            }
        } else {
            /*
             * On verifie si on est en retour de validation du login
             */
            if (strlen($loginEntered) > 0) {
                /*
                 * Verification si le nombre de tentatives de connexion n'est pas atteint
                 */
                if (! $log->isAccountBlocked($loginEntered, $CONNEXION_blocking_duration, $CONNEXION_max_attempts)) {
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
                        
                        /*
                         * Verification de l'identification uniquement en base de donnees
                         */
                    } elseif ($ident_type == "BDD") {
                        $login = $this->testBdd($loginEntered, $password);
                    }
                }
            }
        }
        
        /*
         * Si le nombre total d'essais a ete atteint, le login est refuse
         */
        if (! $verify) {
            $login = "";
        }
        return $login;
    }

    /**
     * Teste la connexion via la base de donnees
     */
    function testBdd($loginEntered, $password)
    {
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

/**
 * Classe permettant de manipuler les logins stockés en base de données locale
 */
class LoginGestion extends ObjetBDD
{

    //
    function __construct($link, $param = array())
    {
        $this->table = "logingestion";
        $this->id_auto = 1;
        $this->colonnes = array(
            "id" => array(
                "type" => 1,
                "key" => 1
            ),
            "datemodif" => array(
                "type" => 2,
                "defaultValue" => "getDateJour"
            ),
            "mail" => array(
                "pattern" => "#^.+@.+\.[a-zA-Z]{2,6}$#"
            ),
            "login" => array(
                'requis' => 1
            ),
            "nom" => array(
                "type" => 0
            ),
            "prenom" => array(
                "type" => 0
            ),
            "actif" => array(
                'type' => 1,
                'defaultValue' => 1
            ),
            "password" => array(
                'type' => 0,
                'longueur' => 256
            ),
            "is_clientws" => array(
                "type" => 1,
                "defaultValue" => '0'
            ),
            "tokenws" => array(
                'type' => 0
            )
        );
        parent::__construct($link, $param);
    }

    /**
     * Vérification du login en mode base de données
     *
     * @param string $login
     * @param string $password
     * @return boolean
     */
    function controlLogin($login, $password)
    {
        global $log;
        $retour = false;
        if (strlen($login) > 0 && strlen($password) > 0) {
            $login = $this->encodeData($login);
            $password = hash("sha256", $password . $login);
            $sql = "select login from LoginGestion where login ='" . $login . "' and password = '" . $password . "' and actif = 1";
            $res = ObjetBDD::lireParam($sql);
            if ($res["login"] == $login) {
                $log->setLog($login, "connexion", "db-ok");
                $retour = true;
            } else {
                $log->setLog($login, "connexion", "db-ko");
            }
        }
        return $retour;
    }
    
    /**
     * Recupere le login a partir d'un jeton pour les services web
     *
     * @param String $token
     * @return array
     */
    function getLoginFromTokenWS($login, $token)
    {
        if (strlen($token) > 0 && strlen($login) > 0) {
            $sql = "select login from logingestion where is_clientws = '1' and actif = '1'
            and login = :login
            and tokenws = :tokenws";
            return $this->lireParamAsPrepared($sql, array(
                "login" => $login,
                "tokenws" => $token
            ));
        }
    }
    
    /**
     * Retourne la liste des logins existants, triee par nom-prenom
     *
     * @return array
     */
    function getListeTriee()
    {
        $sql = 'select id,login,nom,prenom,mail,actif from LoginGestion order by nom,prenom, login';
        return ObjetBDD::getListeParam($sql);
    }

    /**
     * Preparation de la mise en table, avec verification du motde passe
     * (non-PHPdoc)
     *
     * @see ObjetBDD::ecrire()
     */
    function ecrire($data)
    {
        if (strlen($data["pass1"]) > 0 && strlen($data["pass2"]) > 0 && $data["pass1"] == $data["pass2"]) {
            if ($this->controleComplexite($data["pass1"]) > 2 && strlen($data["pass1"]) > 9) {
                $data["password"] = hash("sha256", $data["pass1"] . $data["login"]);
            } else {
                throw new IdentificationException("Password not enough complex or too small");
            }
        }
        $data["datemodif"] = date($_SESSION["MASKDATELONG"]);
        /*
         * Traitement de la generation du token d'identification ws
         */
        if ($data["is_clientws"] == 1 && strlen($data["tokenws"]) == 0) {
            $data["tokenws"] = bin2hex(openssl_random_pseudo_bytes(32));
        } else {
            $data["is_clientws"] = 0;
        }
        $id  = parent::ecrire($data);
        if ($id > 0 && strlen($data["password"]) > 0) {
            $lgo = new LoginOldPassword($this->connection, $this->paramori);
            $lgo->setPassword($id, $data["password"]);
        }
        return $id;
    }

    /**
     * Surcharge de la fonction supprimer pour effacer les traces des anciens mots de passe
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::supprimer()
     */
    function supprimer($id)
    {
        /*
         * Suppression le cas echeant des anciens logins enregistres
         */
        $loginOP = new LoginOldPassword($this->connection, $this->paramori);
        $loginOP->supprimerChamp($id, "id");
        $data = $this->lire($id);
        if( parent::supprimer($id) > 0) {
            /*
             * Recherche si un enregistrement existe dans la gestion des droits
             */
            require_once 'framework/droits/droits.class.php';
            $acllogin = new Acllogin($this->connection, $this->paramori);
            $datalogin = $acllogin->getFromLogin($data["login"]);
            if ($datalogin["acllogin_id"] > 0) {
                $acllogin->supprimer($datalogin["acllogin_id"]);
            }
        }
    }
    
    function getFromLogin($login) {
        if (strlen($login) > 0) {
            $sql = "select * from ".$this->table." where login = :login";
            return $this->lireParamAsPrepared($sql, array("login"=>$login));
        }
    }

    /**
     * Fonction de validation de changement du mot de passe
     *
     * @param string $oldpassword
     * @param string $pass1
     * @param string $pass2
     * @return number
     */
    function changePassword($oldpassword, $pass1, $pass2)
    {
        global $log,$message;
        $retour = 0;
        if (isset($_SESSION["login"])) {
            $oldData = $this->lireByLogin($_SESSION["login"]);
            if ($log->getLastConnexionType($_SESSION["login"]) == "db") {
                $oldpassword_hash = $this->passwordHash($_SESSION["login"], $oldpassword);
                if ($oldpassword_hash == $oldData["password"]) {
                    /*
                     * Verifications de validite du mot de passe
                     */
                    if ($this->passwordVerify($_SESSION["login"], $pass1, $pass2)) {
                        $retour = $this->writeNewPassword($_SESSION["login"], $pass1);
                    } else {
                        $message->set(_("La modification du mot de passe a échoué"));
                    }
                } else {
                    $message->set(_("L'ancien mot de passe est incorrect"));
                }
            } else {
                $message->set(_("Le mode d'identification utilisé pour votre compte n'autorise pas la modification du mot de passe depuis cette application"));
            }
        }
        
        return $retour;
    }

    /**
     * Calcule le hash d'un mot de passe
     * 
     * @param string $login
     * @param string $password
     * @throws Exception
     * @return string
     */
    function passwordHash($login, $password)
    {
        if (strlen($login) == 0 || strlen($password) == 0) {
            throw new IdentificationException("password hashing not possible");
        } else {
            return hash("sha256", $password . $login);
        }
    }

    /**
     * Declenche le changement de mot de passe apres perte
     *
     * @param string $login
     * @param string $pass1
     * @param string $pass2
     * @return number
     */
    function changePasswordAfterLost($login, $pass1, $pass2)
    {
        $retour = 0;
        if (strlen($login) > 0) {
            if ($this->passwordVerify($login, $pass1, $pass2)) {
                $retour = $this->writeNewPassword($login, $pass1);
            }
        }
        return $retour;
    }

    /**
     * Ecrit le nouveau mot de passe en base de donnees
     *
     * @param string $login
     * @param string $pass
     * @return number
     */
    private function writeNewPassword($login, $pass)
    {
        global $log, $message;
        $retour = 0;
        $oldData = $this->lireByLogin($login);
        if ($log->getLastConnexionType($login) == "db") {
            $data = $oldData;
            $data["password"] = $this->passwordHash($login, $pass);
            $data["datemodif"] = date('d-m-y');
            if ($this->ecrire($data) > 0) {
                $retour = 1;
                $log->setLog($login, "password_change", "ip:" . $_SESSION["remoteIP"]);
                /*
                 * Ecriture du mot de passe dans la table des mots de passe deja utilises
                 */
                $loginOldPassword = new LoginOldPassword($this->connection, $this->paramori);
                $loginOldPassword->setPassword($data["id"], $data["password"]);
                
                $message->set(_("Le mot de passe a été modifié"));
            } else {
                $message->set(_("Echec de modification du mot de passe pour une raison inconnue. Si le problème persiste, contactez l'assistance"));
            }
        } else {
            $message->set(_("Le mode d'identification utilisé pour votre compte n'autorise pas la modification du mot de passe depuis cette application"));
        }
        return $retour;
    }

    /**
     * Fonction verifiant la validite du mot de passe fourni,
     * avant changement
     *
     * @param string $login
     * @param string $pass1
     * @param string $pass2
     * @return boolean
     */
    private function passwordVerify($login, $pass1, $pass2)
    {
        global $message;
        $ok = false;
        /*
         * Verification que le mot de passe soit identique
         */
        if ($pass1 == $pass2) {
            /*
             * Verification de la longueur - minimum : 10 caracteres
             */
            if (strlen($pass1) > 9) {
                /*
                 * Verification de la complexite du mot de passe
                 */
                if ($this->controleComplexite($pass1) >= 3) {
                    /*
                     * calcul du sha256 du mot de passe
                     */
                    $password_hash = $this->passwordHash($login, $pass1);
                    /*
                     * Verification que le mot de passe n'a pas deja ete employe
                     */
                    $loginOldPassword = new LoginOldPassword($this->connection, $this->paramori);
                    $nb = $loginOldPassword->testPassword($login, $password_hash);
                    if ($nb == 0) {
                        $ok = true;
                    } else {
                        $message->set(_("Le mot de passe a déjà été utilisé"));
                    }
                } else {
                    $message->set(_("Le mot de passe n'est pas assez complexe"));
                }
            } else {
                $message->set(_("Le mot de passe est trop court"));
            }
        } else {
            $message->set(_("Le mot de passe n'est pas identique dans les deux zones"));
        }
        return $ok;
    }

    /**
     * Fonction verifiant la complexite d'un mot de passe
     * Retourne le nombre de jeux de caracteres differents utilises
     *
     * @param string $password
     * @return number
     */
    function controleComplexite($password)
    {
        $long = strlen($password);
        $type = array(
            "min" => 0,
            "maj" => 0,
            "chiffre" => 0,
            "other" => 0
        );
        for ($i = 0; $i < $long; $i ++) {
            $car = substr($password, $i, 1);
            if ($type["min"] == 0) {
                $type["min"] = preg_match("/[a-z]/", $car);
            }
            if ($type["maj"] == 0) {
                $type["maj"] = preg_match("/[A-Z]/", $car);
            }
            if ($type["chiffre"] == 0) {
                $type["chiffre"] = preg_match("/[0-9]/", $car);
            }
            if ($type["other"] == 0) {
                $type["other"] = preg_match("/[^0-9a-zA-Z]/", $car);
            }
        }
        return $type["min"] + $type["maj"] + $type["chiffre"] + $type["other"];
    }

    /**
     * Retourne un enregistrement a partir du login
     *
     * @param string $login
     * @return array
     */
    function lireByLogin($login)
    {
        $login = $this->encodeData($login);
        $sql = "select * from " . $this->table . "
				where login = '" . $login . "'";
        return $this->lireParam($sql);
    }

    /**
     * Retourne un enregistrement a partir du mail
     *
     * @param string $mail
     * @return array
     */
    function getFromMail($mail)
    {
        $mail = $this->encodeData($mail);
        if (strlen($mail) > 0) {
            $sql = "select id, nom, prenom, login, mail, actif ";
            $sql .= " from " . $this->table;
            $sql .= " where lower(mail) = lower(:mail)";
            $sql .= " order by id desc limit 1";
            return $this->lireParamAsPrepared($sql, array(
                "mail" => $mail
            ));
        }
    }
}

/**
 * Classe permettant d'enregistrer toutes les operations effectuees dans la base
 *
 * @author quinton
 *        
 */
class Log extends ObjetBDD
{

    /**
     * Constructeur
     *
     * @param pdo $p_connection
     * @param array $param
     */
    function __construct($bdd, $param = NULL)
    {
        $this->table = "log";
        $this->colonnes = array(
            "log_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "login" => array(
                "type" => 0,
                "requis" => 0
            ),
            "nom_module" => array(
                "type" => 0
            ),
            "log_date" => array(
                "type" => 3,
                "requis" => 1
            ),
            "commentaire" => array(
                "type" => 0
            ),
            "ipaddress" => array(
                "type" => 0
            )
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Fonction enregistrant un evenement dans la table
     *
     * @param string $module
     * @param string $comment
     * @return integer
     */
    function setLog($login, $module, $commentaire = NULL)
    {
        global $GACL_aco;
        $data = array(
            "log_id" => 0,
            "commentaire" => $commentaire
        );
        if (is_null($login)) {
            if (! is_null($_SESSION["login"])) {
                $login = $_SESSION["login"];
            } else {
                $login = "unknown";
            }
        }
        $data["login"] = $login;
        if (is_null($module)) {
            $module = "unknown";
        }
        $data["nom_module"] = $GACL_aco . "-" . $module;
        $data["log_date"] = date($_SESSION["MASKDATELONG"]);
        $data["ipaddress"] = $this->getIPClientAddress();
        return $this->ecrire($data);
    }

    /**
     * Fonction de purge du fichier de traces
     *
     * @param int $nbJours
     *            : nombre de jours de conservation
     * @return int
     */
    function purge($nbJours)
    {
        if ($nbJours > 0) {
            $sql = "delete from " . $this->table . " 
					where log_date < current_date - interval '" . $nbJours . " day'";
            return $this->executeSQL($sql);
        }
    }

    /**
     * Recupere l'adresse IP de l'agent
     */
    function getIPClientAddress()
    {
        /*
         * Recherche si le serveur est accessible derriere un reverse-proxy
         */
        if (isset($_SERVER["HTTP_X_FORWARDED_FOR"])) {
            return $_SERVER["HTTP_X_FORWARDED_FOR"];
            /*
             * Cas classique
             */
        } else if (isset($_SERVER["REMOTE_ADDR"])) {
            return $_SERVER["REMOTE_ADDR"];
        } else {
            return - 1;
        }
    }

    /**
     * Renvoie les informations de derniere connexion
     *
     * @return array
     */
    function getLastConnexion()
    {
        if (isset($_SESSION["login"])) {
            $sql = "select log_date, ipaddress from log where login = :login and nom_module like '%connexion' and commentaire like '%ok'
order by log_id desc limit 2";
            $data = $this->getListeParamAsPrepared($sql, array(
                "login" => $_SESSION["login"]
            ));
            return $data[1];
        }
    }

    /**
     * Retourne le dernier type de connexion realisee pour un compte
     *
     * @param string $login
     * @return string
     */
    function getLastConnexionType($login)
    {
        if (strlen($login) > 0) {
            $sql = "select commentaire from log";
            $sql .= " where login = :login and nom_module like '%connexion' and commentaire like '%ok'";
            $sql .= "order by log_id desc limit 1";
            $data = $this->lireParamAsPrepared($sql, array(
                "login" => $login
            ));
            $commentaire = explode("-", $data["commentaire"]);
            return $commentaire[0];
        }
    }

    /**
     * Recherche si le compte a fait l'objet de trop de tentatives de connexion
     * Si c'est le cas, declenche le blocage du compte pour la duree indiquee
     * La duree de blocage est reinitialisee a chaque tentative pendant la periode
     * de contention
     *
     * @param string $login
     * @param number $maxtime
     * @param number $nbMax
     * @return boolean
     */
    function isAccountBlocked($login, $maxtime = 600, $nbMax = 10)
    {
        
        $is_blocked = true;
        /*
         * Verification si le compte est bloque, et depuis quand
         */
        $accountBlocking = false;
        $date = new DateTime(now);
        $date->sub(new DateInterval("PT" . $maxtime . "S"));
        $sql = "select log_id from log where login = :login " . " and nom_module = 'connexionBlocking'" . " and log_date > :blockingdate " . " order by log_id desc limit 1";
        $data = $this->lireParamAsPrepared($sql, array(
            "login" => $login,
            "blockingdate" => $date->format(DATELONGMASK)
        ));
        if ($data["log_id"] > 0) {
            $accountBlocking = true;
        }
        if (! $accountBlocking) {
            $sql = "select log_date, commentaire from log where login = :login 
                    and nom_module like '%connexion'
                    and log_date > :blockingdate
                order by log_id desc limit :nbmax";
            $data = $this->getListeParamAsPrepared($sql, array(
                "login" => $login,
                "nbmax" => $nbMax,
                "blockingdate" => $date->format(DATELONGMASK)
            ));
            $nb = 0;
            /*
             * Recherche si une connexion a reussi
             */
            foreach ($data as $value) {
                if (substr($value["commentaire"], - 2) == "ok") {
                    $is_blocked = false;
                    break;
                }
                $nb ++;
            }
            if ($nb >= $nbMax) {
                /*
                 * Verrouillage du compte
                 */
                $this->blockingAccount($login);
            } else {
                $is_blocked = false;
            }
        }
        return $is_blocked;
    }

    /**
     * Fonction de blocage d'un compte
     * - cree un enregistrement dans la table log
     * - envoie un mail aux administrateurs
     *
     * @param string $login
     */
    function blockingAccount($login)
    {
        $this->setLog($login, "connexionBlocking");
        global $message, $MAIL_enabled, $APPLI_mail, $APPLI_address, $APPLI_mailToAdminPeriod;
        $date = date("Y-m-d H:i:s");
        $message->setSyslog("connexionBlocking for login $login");
        if ($MAIL_enabled == 1) {
            require_once 'framework/identification/mail.class.php';
            require_once 'framework/droits/droits.class.php';
            $MAIL_param = array(
                "replyTo" => "$APPLI_mail",
                "subject" => "SECURITY REPORTING - ".$_SESSION["APPLI_code"]." - account blocked",
                "from" => "$APPLI_mail",
                "contents" => "<html><body>" . "The account <b>$login<b> was blocked at $date for too many connection attempts" . '<br>Software : <a href="' . $APPLI_address . '">' . $APPLI_address . "</a>" . '</body></html>'
            );
            /*
             * Recherche de la liste des administrateurs
             */
            $aclAco = new Aclaco($this->connection, $this->paramori);
            $logins = $aclAco->getLogins("admin");
            /*
             * Envoi des mails aux administrateurs
             */
            $lastDate = new DateTime(now);
            if (isset($APPLI_mailToAdminPeriod)) {
                $period = $APPLI_mailToAdminPeriod;
            } else {
                $period = 7200;
            }
            $interval = new DateInterval('PT' . $period . 'S');
            $lastDate->sub($interval);
            $mail = new Mail($MAIL_param);
            $loginGestion = new LoginGestion($this->connection, $this->paramori);
            foreach ($logins as $value) {
                $admin = $value["login"];
                $dataLogin = $loginGestion->lireByLogin($admin);
                if (strlen($dataLogin["mail"]) > 0) {
                    /*
                     * Recherche si un mail a deja ete adresse a l'administrateur pour ce blocage
                     */
                    $sql = 'select log_id, log_date from log' . " where nom_module like '%sendMailAdminForBlocking'" . ' and login = :login' . ' and commentaire = :admin' . ' and log_date > :lastdate' . ' order by log_id desc limit 1';
                    $logval = $this->lireParamAsPrepared($sql, array(
                        "admin" => $admin,
                        "login" => $login,
                        "lastdate" => $lastDate->format("Y-m-d H:i:s")
                    ));
                    if (! $logval["log_id"] > 0) {
                        if ($mail->sendMail($dataLogin["mail"], array())) {
                            $this->setLog($login, "sendMailAdminForBlocking", $value["login"]);
                        } else {
                            global $message;
                            $message->setSyslog("error_sendmail_to_admin:" . $dataLogin["mail"]);
                        }
                    }
                }
            }
        }
    }
}

/**
 * Classe de gestion de l'enregistrement des anciens mots de passe
 *
 * @author quinton
 *        
 */
class LoginOldPassword extends ObjetBDD
{

    /**
     * Constructeur
     *
     * @param pdo $bdd
     * @param array $ObjetBDDParam
     */
    function __construct($bdd, $param)
    {
        $this->table = "login_oldpassword";
        $this->colonnes = array(
            "login_oldpassword_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "id" => array(
                "type" => 1,
                "requis" => 1,
                "parentAttrib" => 1
            ),
            "password" => array(
                "type" => 0
            )
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Fonction retournant le nombre de mots de passe deja utilises pour le hash fourni
     *
     * @param string $login
     * @param string $password_hash
     * @return number
     */
    function testPassword($login, $password_hash)
    {
        $login = $this->encodeData($login);
        $sql = 'select count(o.login_oldpassword_id) as "nb" 
				from ' . $this->table . " o 
				join logingestion on logingestion.id = o.id
				where login = '" . $login . "'
					and o.password = '" . $password_hash . "'";
        $res = $this->lireParam($sql);
        return $res["nb"];
    }

    /**
     * Enregistre un mot de passe dans la base des anciens mots de passe utilises
     *
     * @param int $id
     * @param string $password_hash
     * @return int
     */
    function setPassword($id, $password_hash)
    {
        if ($id > 0) {
            $data = array(
                "id" => $id,
                "password" => $password_hash
            );
            return $this->ecrire($data);
        }
    }
}
?>