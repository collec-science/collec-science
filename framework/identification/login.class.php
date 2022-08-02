<?php
class Login
{
  public LoginGestion $loginGestion;
  public Log $log;
  public Acllogin $acllogin;
  public Message $message;
  function __construct($bdd, $param = array())
  {
    include_once "framework/identification/loginGestion.class.php";
    global $privateKey, $pubKey;
    $this->loginGestion = new LoginGestion($bdd, $param);
    $this->loginGestion->setKeys($privateKey, $pubKey);
    include_once "framework/droits/acllogin.class.php";
    $this->aclogin = new Acllogin($bdd, $param);
    global $log, $message;
    $this->log = $log;
    $this->message = $message;
  }

  function getLogin(string $type_authentification, $modeAdmin = false): ?string
  {
    global $APPLI_modeDeveloppement, $privateKey, $pubKey, $CONNEXION_blocking_duration, $CONNEXION_max_attempts;
    $tauth = "";
    /**
     * web service
     */
    if ($type_authentification == "ws") {
      $tauth = "swtoken";
      if ($this->loginGestion->getLoginFromTokenWS($_REQUEST["login"], $_REQUEST["token"])) {
        $login = $_REQUEST["login"];
      }
    } elseif (isset($_COOKIE["tokenIdentity"])) {
      $tauth = "token";
      /**
       * Token identification
       */
      try {
        include_once 'framework/identification/token.class.php';
        $token = new Token($privateKey, $pubKey);
        $login = $token->openToken($_COOKIE["tokenIdentity"]);
      } catch (Exception $e) {
        $message->set(_("L'identification par jeton n'a pas abouti"));
        $message->setSyslog($e->getMessage());
        /**
         * Destroy the token
         */
        $cookieParam = session_get_cookie_params();
        $cookieParam["lifetime"] = time() - 3600;
        $cookieParam["secure"] = true;
        $cookieParam["httponly"] = true;
        setcookie('tokenIdentity', "", $cookieParam["lifetime"], $cookieParam["path"], $cookieParam["domain"], $cookieParam["secure"], $cookieParam["httponly"]);
      }
    } elseif ($type_authentification == "HEADER") {
      $tauth = "header";
      $login = $this->getLoginFromHeader();
    } elseif ($type_authentification == "CAS") {
      $tauth = "cas";
      $login = $this->getLoginCas($modeAdmin);
    } elseif ($type_authentification == "LDAP" || $type_authentification == "LDAP-BDD") {
      $tauth = "ldap";
      $login = $this->getLoginLdap($_POST["login"], $_POST["password"]);
      if (empty($login) && $type_authentification == "LDAP-BDD") {
        $tauth = "db";
        $login = $this->getLoginBDD($_POST["login"], $_POST["password"]);
      }
    } elseif ($type_authentification == "BDD" || $type_authentification == "CAS-BDD") {
      $tauth = "db";
      $login = $this->getLoginBDD($_POST["login"], $_POST["password"]);
    }
    if (!empty($login)) {
      if (!$this->log->isAccountBlocked($login, $CONNEXION_blocking_duration, $CONNEXION_max_attempts)) {
        $this->log->setlog($login, "connection-" . $tauth, "ok");
      } else {
        $this->log->setLog($login, "connectionBlocking", "account blocked");
        $login = null;
      }
    } else {
      isset($_POST["login"]) ? $loginRequired = $_POST["login"] : $loginRequired = "unknown";
      $this->log->setlog($loginRequired, "connection-" . $tauth, "ko");
      $this->message->set(_("L'identification n'a pas abouti. Vérifiez votre login et votre mot de passe"), true);
    }
    return $login;
  }

  function getLoginFromHeader()
  {
    global $ident_header_vars;
    $headers = getHeaders($ident_header_vars["radical"]);
    $login = $headers[$ident_header_vars["login"]];
    $verify = false;
    if (!empty($login) && count($headers) > 0) {
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
        if ($ident_header_vars["createUser"]) {
          /**
           * Verify if the structure is authorized
           */
          $createUser = true;
          if (count($ident_header_vars["organizationGranted"]) > 0 && !in_array($headers[$ident_header_vars["organization"]], $ident_header_vars["organizationGranted"])) {
            $createUser = false;
            $this->log->setLog($login, "connection-header", "ko. The " . $headers[$ident_header_vars["organization"]] . " is not authorized to connect to this application");
          }
          if ($createUser) {
            $dlogin = array(
              "login" => $login,
              "nom" => $headers[$ident_header_vars["cn"]],
              "mail" => $headers[$ident_header_vars["mail"]],
              "actif" => 0
            );
            $login_id = $this->loginGestion->ecrire($dlogin);
            if ($login_id > 0) {
              /**
               * Create the record in gacllogin
               */
              $this->aclogin->addLoginByLoginAndName($login, $headers[$ident_header_vars["cn"]]);
              /**
               * Send mail to administrators
               */
              global $APPLI_nom, $APPLI_mail;
              $subject = $APPLI_nom . " " . _("Nouvel utilisateur");
              $contents = "<html><body>" . sprintf(_('%1$s a créé son compte avec le login %2$s dans l\'application %3$s.
                          <br>Il est rattaché à l\'organisation %5$s.
                          <br>Le compte est inactif jusqu\'à ce que vous l\'activiez.
                          <br>Pour activer le compte, connectez-vous à l\'application
                              <a href="%4$s">%4$s</a>
                          <br>Ne répondez pas à ce mail, qui est généré automatiquement') . "</body></html>", $login, $headers[$ident_header_vars["cn"]], $APPLI_nom, $APPLI_mail, $headers[$ident_header_vars["organization"]]);

              $this->log->sendMailToAdmin($subject, $contents, "loginCreateByHeader", $login);
              $this->message->set(_("Votre compte a été créé, mais est inactif. Un mail a été adressé aux administrateurs pour son activation"));
            }
          }
        }
      }
    }
    if ($verify) {
      return $login;
    }
  }

  /**
   * Get login from CAS server
   *
   * @param boolean $modeAdmin
   * @return string|null
   */
  public function getLoginCas($modeAdmin = false)
  {
    include_once "vendor/jasig/phpcas/CAS.php";
    global $CAS_address, $CAS_port, $CAS_address, $CAS_CApath, $CAS_debug, $CAS_uri;
    if ($CAS_debug) {
      phpCAS::setDebug("temp/cas.log");
      phpCAS::setVerbose(true);
    }
    phpCAS::client(CAS_VERSION_2_0, $CAS_address, $CAS_port, $CAS_uri, false);
    if (!empty($CAS_CApath)) {
      phpCAS::setCasServerCACert($CAS_CApath);
    } else {
      phpCAS::setNoCasServerValidation();
    }
    if ($modeAdmin) {
      phpCAS::renewAuthentication();
    } else {
      phpCAS::forceAuthentication();
    }

    $user = phpCAS::getUser();
    if (!empty($user)) {
      $_SESSION["CAS_attributes"] = phpCAS::getAttributes();
    }
    return $user;
  }

  public function getLoginLdap($login, $password)
  {
    global $LDAP;
    $loginOk = "";
    if (strlen($login) > 0 && strlen($password) > 0) {
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
        throw new LdapException("Impossible de se connecter au serveur LDAP.");
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
      global $CAS_address, $CAS_port, $CAS_uri, $CAS_CApath;
      phpCAS::client(CAS_VERSION_2_0, $CAS_address, $CAS_port, $CAS_uri);
      if (!empty($CAS_CApath)) {
        phpCAS::setCasServerCACert($CAS_CApath);
      } else {
        phpCAS::setNoCasServerValidation();
      }
      if (!empty($adresse_retour)) {
        phpCAS::logout(array("url" => $adresse_retour));
      } else {
        phpCAS::logout();
      }
    }
  }
}
