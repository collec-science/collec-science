<?php

/**
 * Controleur de l'application (modele MVC)
 * Fichier modifie le 21 mars 2013 par Eric Quinton
 *
 */
class FrameworkException extends Exception
{
}

try {
  /**
   * Lecture des parametres
   */
  require_once "framework/common.inc.php";
  /**
   * Verification des donnees entrantes.
   * Codage UTF-8
   */
  if (!check_encoding($_REQUEST)) {
    $message->set(_("Problème dans les données fournies : l'encodage des caractères n'est pas celui attendu"), true);
    $_REQUEST["module"] = "default";
    unset($_REQUEST["moduleBase"]);
    unset($_REQUEST["action"]);
  }
  /**
   * Verification de la version de la base de donnees
   */
  if (!isset($_SESSION["dbversion"])) {
    include_once "framework/dbversion/dbversion.class.php";
    try {
      $dbversion = new DbVersion($bdd, $ObjetBDDParam);
      if ($dbversion->verifyVersion($APPLI_dbversion)) {
        $_SESSION["dbversion"] = $APPLI_dbversion;
      } else {
        if ($APPLI_modeDeveloppement) {
          unset($_SESSION["dbversion"]);
        }
        // traduction: bien conserver inchangées les chaînes %1$s, %2$s
        $message->set(sprintf(_('La base de données n\'est pas dans la version attendue (%1$s). Version actuelle : %2$s'), $APPLI_dbversion, $dbversion->getLastVersion()["dbversion_number"]), true);
        $_REQUEST["module"] = "default";
        unset($_REQUEST["moduleBase"]);
        unset($_REQUEST["action"]);
      }
    } catch (Exception $e) {
      $message->set(
        _("Problème rencontré lors de la vérification de la version de la base de données"),
        true
      );
      $message->setSyslog($e->getMessage());
    }
  }

  /**
   * purge des logs
   */
  if (!$_SESSION["log_purged"]) {
    $log->purge($LOG_duree);
    $_SESSION["log_purged"] = true;
  }
  /**
   * Decodage des variables html
   */
  $_REQUEST = htmlDecode($_REQUEST);
  /**
   * Lecture des donnees canoniques
   * La configuration de l'hote virtuel doit contenir ceci :
   * <Directory /var/www/html/collec>
   * RewriteEngine On
   * RewriteBase /
   * RewriteCond "/%{REQUEST_FILENAME}" !-f
   * RewriteCond "/%{REQUEST_FILENAME}" !-d
   * RewriteRule "(.*)" "/index.php?$1" [PT,QSA]
   * </Directory>
   *
   * par defaut, les liens canoniques doivent etre de la forme :
   * /famille/version/modulerecherche/id
   * La transformation est realisee ainsi :
   * familleversionmodulerecherche, puis :
   * si id n'est pas renseigne : List
   * si id est renseigne :
   * * la variable $requestId est affectee avec la valeur id
   * * si method=get : Display
   * * si method=post : Write
   * * si method=put : Replace
   * * si method=delete : Delete
   */
  if (!isset($_REQUEST["module"])) {
    if (isset($_REQUEST["moduleBase"]) && isset($_REQUEST["action"])) {
      $_REQUEST["module"] = $_REQUEST["moduleBase"] . $_REQUEST["action"];
    } else {
      $request_uri = $_SERVER["REQUEST_URI"];
      if (substr($request_uri, 0, 2) == "//") {
        $request_uri = substr($request_uri, 1);
      }
      $uri = explode("/", $request_uri);
      if (count($uri) > 2 && $uri[1] != "display") {
        /**
         * Extraction le cas echeant des variables GET
         */
        $uri3 = explode("?", $uri[3]);
        if (count($uri3) == 2) {
          $uri[3] = $uri3[0];
        }
        $_REQUEST["module"] = $uri[1] . $uri[2] . $uri[3];
        /**
         * On recherche si le quatrieme element existe
         */
        if (empty($uri[4])) {
          $_REQUEST["module"] .= "List";
        } else {
          $uri4 = explode("?", $uri[4]);
          $requestId = $uri4[0];
          /**
           * Prepositionnement par defaut de la valeur uid (la plus frequente)
           */
          if (!isset($_REQUEST["uid"])) {
            $_REQUEST["uid"] = $uri[4];
          }
          switch ($_SERVER["REQUEST_METHOD"]) {
            case "GET":
              $_REQUEST["module"] .= "Display";
              break;
            case "POST":
              $_REQUEST["module"] .= "Write";
              break;
            case "PUT":
              $_REQUEST["module"] .= "Replace";
              break;
            case "DELETE":
              $_REQUEST["module"] .= "Delete";
              break;
            default:
              $_REQUEST["module"] = "default";
              break;
          }
        }
      }
    }
  }
  /**
   * page par defaut
   */
  if (empty($_REQUEST["module"])) {
    $_REQUEST["module"] = "default";
  }
  /**
   * Recuperation du module
   */
  unset($module);
  /**
   * Generation du module a partir de moduleBase et action
   */
  $module = $_REQUEST["module"];
  $moduleRequested = $module;
  /**
   * Gestion des modules
   */
  $isHtml = false;
  $isAjax = false;
  if ($APPLI_modeDeveloppement) {
    unset($_SESSION["menu"]);
  }
  while (isset($module)) {
    /**
     * Recuperation du tableau contenant les attributs du module
     */
    $t_module = $navigation->getModule($module);
    if (empty($t_module)) {
      // traduction: conserver inchangée la chaîne %s
      $message->set(sprintf(_('Le module demandé n\'existe pas (%s)'), $module), true);
      $t_module = $navigation->getModule("default");
    }
    /**
     * Si la variable demandee n'existe pas, retour vers la page par defaut
     */
    if (isset($t_module["requiredVar"])) {
      $rv = false;
      $requiredVars = explode(",", $t_module["requiredVar"]);
      foreach ($requiredVars as $requiredVar) {
        if (isset($_REQUEST[$requiredVar]) || isset($_COOKIE[$requiredVar])) {
          $rv = true;
          break;
        }
      }
      if (!$rv) {
        $t_module = $navigation->getModule("default");
      }
    }

    /**
     * Extraction des droits necessaires
     */
    $droits_array = explode(",", $t_module["droits"]);
    /**
     * Forcage de l'identification si identification en mode HEADER
     */
    if ($ident_type == "HEADER") {
      $t_module["loginrequis"] = 1;
    }
    /**
     * Preparation de la vue
     */
    if (!isset($vue) && isset($t_module["type"])) {
      switch ($t_module["type"]) {
        case "ajax":
        case "json":
        case "ws":
          $vue = new VueAjaxJson();
          $isAjax = true;
          break;
        case "csv":
          $vue = new VueCsv();
          $isAjax = true;
          break;
        case "pdf":
          $vue = new VuePdf();
          $isAjax = true;
          break;
        case "binaire":
          $vue = new VueBinaire();
          $isAjax = true;
          break;
        case "file":
          $vue = new VueFile();
          $isAjax = true;
          break;
        case "smarty":
        case "html":
        default:
          $isHtml = true;
          $vue = new VueSmarty($SMARTY_param, $SMARTY_variables);
      }
    }

    /**
     * Verification si le login est requis
     */
    if ($_SESSION["cas_required"] == 1) {
      $t_module["loginrequis"] = 1;
      $_REQUEST["cas_required"] = 1;
    }
    if ((!empty($_REQUEST["login"]) || !empty($t_module["droits"]) || $t_module["loginrequis"] == 1) && !$_SESSION["is_authenticated"]) {
      /**
       * Affichage de l'ecran de saisie du login si necessaire
       */
      if (
        in_array($ident_type, array("BDD", "LDAP", "LDAP-BDD", "CAS-BDD"))
        && empty($_REQUEST["login"])
        && empty($_SESSION["login"])
        && empty($_COOKIE["tokenIdentity"])
        && empty($_REQUEST["cas_required"])
      ) {
        /**
         * Gestion de la saisie du login
         */
        if (!$vue) {
          throw new FrameworkException(_("Message technique : la vue n'a pas été initialisée lors de la création de la page de login"));
        }
        $vue->set("framework/ident/login.tpl", "corps");
        $vue->set($tokenIdentityValidity, "tokenIdentityValidity");
        $vue->set($APPLI_lostPassword, "lostPassword");
        if ($ident_type == "CAS-BDD") {
          $vue->set(1, "CAS_enabled");
        }
        $loginForm = true;
        if ($t_module["retourlogin"] == 1) {
          $vue->set($_REQUEST["module"], "moduleCalled");
        }
        $message->set(_("Veuillez utiliser le login qui vous a été fourni pour vous identifier"));
      } else {
        /**
         * Verify the login
         */
        if (empty($_SESSION["login"])) {
          require_once "framework/identification/login.class.php";
          $login = new Login($bdd_gacl, $ObjetBDDParam);
          if (!empty($_REQUEST["token"]) && !empty($_REQUEST["login"])) {
            $ident_type = "ws";
          }
          /**
           * For CAS-BDD
           */
          if ($_REQUEST["cas_required"] == 1 || !empty($_REQUEST["ticket"])) {
            $ident_type = "CAS";
            $_SESSION["cas_required"] = 1;
          }
          $_SESSION["login"] = strtolower($login->getLogin($ident_type, false));
        }
        if (!empty($_SESSION["login"])) {
          unset($_SESSION["cas_required"]);
          /**
           * Verify if the double authentication is mandatory
           */
          require_once "framework/droits/acllogin.class.php";
          $acllogin = new Acllogin($bdd_gacl, $ObjetBDDParam);
          if ($acllogin->isTotp() && $t_module["type"] != "ws" && !isset($_COOKIE["tokenIdentity"])) {
            if (isset($_POST["otpcode"])) {
              include_once "framework/identification/totp.class.php";
              $totp = new Gacltotp($privateKey, $pubKey);
              try {
                if ($totp->verifyOtp($totp->decodeTotpKey($acllogin->getTotpKey($_SESSION["login"])), $_POST["otpcode"])) {
                  $_SESSION["is_authenticated"] = true;
                  $log->setlog($_SESSION["login"], "totpVerifyExec", "ok");
                } else {
                  $log->setlog($_SESSION["login"], "totpVerifyExec", "ko");
                }
              } catch (TOTPException $te) {
                $message->setSyslog($te->getMessage());
                $message->set($te->getMessage(), true);
              }
            } else {
              /**
               * Display the form to entry the TOTP code
               */
              if (!isset($vue)) {
                $isHtml = true;
                $vue = new VueSmarty($SMARTY_param, $SMARTY_variables);
              }
              $vue->set("framework/ident/totp.tpl", "corps");
              if ($t_module["retourlogin"] == 1) {
                $vue->set($_REQUEST["module"], "module");
              } else {
                if (!empty($_POST["moduleCalled"])) {
                  $vue->set($_POST["moduleCalled"], "moduleCalled");
                }
              }
            }
          } else {
            /**
             * Verify that the login used as admin is the same as login
             */
            if (isset($_POST["loginAdmin"]) && $_POST["login"] != $_SESSION["login"]) {
              $log->setLog($_SESSION["login"], "admin-reauthenticate", "Error: the used account (" . $_POST["login"] . ") is not the same of the current account");
              $login->disconnect();
            } else {
              $_SESSION["is_authenticated"] = true;
            }
          }
        } else {
          if ($ident_type == "ws") {
            http_response_code(401);
            $vue->set(array("error_code" => 401, "error_message" => _("Identification refusée")));
          } else {
            if (!isset($vue)) {
              $isHtml = true;
              $vue = new VueSmarty($SMARTY_param, $SMARTY_variables);
            }
            $vue->set("framework/ident/login.tpl", "corps");
            $vue->set($tokenIdentityValidity, "tokenIdentityValidity");
            $vue->set($APPLI_lostPassword, "lostPassword");
            if ($ident_type == "CAS-BDD") {
              $vue->set(1, "CAS_enabled");
            }
          }
        }
      }
      if ($_SESSION["is_authenticated"]) {
        /**
         * Treatment of all operations after authentication
         */
        $_SESSION["last_activity_admin"] = time();
        if ($t_module["type"] == "ws" && file_exists("modules/postLoginWS.php")) {
          include 'modules/postLoginWS.php';
        }
        unset($_SESSION["menu"]);
        $message->set(_("Identification réussie !"));
        /**
         * Regeneration de l'identifiant de session
         */
        //session_regenerate_id(true);
        /**
         * Recuperation des connexions recentes
         */
        $connections = $log->getLastConnections($APPLI_absolute_session);
        $nbConnection = count($connections);
        if ($nbConnection > 1) {
          $message->set(_("Connexions précédentes récentes :"));
          for ($i = 1; $i < $nbConnection; $i++) {
            $connection = $connections[$i];
            $message->set($connection["log_date"] . " - IP: " . $connection["ipaddress"]);
          }
        } else {
          /**
           * Recuperation de la derniere connexion et affichage a l'ecran
           */
          $lastConnect = $log->getLastConnexion();
          if (isset($lastConnect["log_date"])) {
            // traduction: bien conserver inchangées les chaînes %1$s, %2$s...
            $texte = _('Dernière connexion le %1$s depuis l\'adresse IP %2$s. Si ce n\'était pas vous, modifiez votre mot de passe ou contactez l\'administrateur de l\'application.');
            $message->set(sprintf($texte, $lastConnect["log_date"], $lastConnect["ipaddress"]));
          }
        }
        $message->setSyslog("connexion ok for " . $_SESSION["login"] . " from " . getIPClientAddress());
        /**
         * Recuperation des cookies le cas echeant
         */
        include 'modules/cookies.inc.php';
        /**
         * Calcul des droits
         */
        include_once 'framework/droits/droits.class.php';
        try {
          $_SESSION["droits"] = $acllogin->getListDroits($_SESSION["login"], $GACL_aco, $LDAP);
        } catch (Exception $e) {
          if ($APPLI_modeDeveloppement) {
            $message->set($e->getMessage());
          } else {
            $message->setSyslog($e->getMessage());
          }
        }
        /**
         * Preparation de l'identification par token
         */
        if ($_POST["loginByTokenRequested"] == 1) {
          include_once 'framework/identification/token.class.php';
          $tokenClass = new Token($privateKey, $pubKey);
          try {
            $token = $tokenClass->createToken($_SESSION["login"], $tokenIdentityValidity);
            /**
             * Ecriture du cookie
             */
            $cookieParam = session_get_cookie_params();
            $cookieParam["lifetime"] = $tokenIdentityValidity;
            $cookieParam["secure"] = true;
            $cookieParam["httponly"] = true;
            setcookie('tokenIdentity', $token, time() + $tokenIdentityValidity, $cookieParam["path"], $cookieParam["domain"], $cookieParam["secure"], $cookieParam["httponly"]);
          } catch (Exception $e) {
            $message->set($e->getMessage(), true);
          }
        }
        /**
         * Integration des commandes post login
         */
        include "modules/postLogin.php";
      }
    }
    /**
     * Controles complementaires
     */
    $resident = 1;
    $motifErreur = "ok";
    /**
     * Verification des droits
     */
    if (!empty($t_module["droits"])) {
      if (!isset($_SESSION["login"])) {
        $resident = 0;
        $motifErreur = "nologin";
      } else {

        $resident = 0;
        foreach ($droits_array as $key => $value) {
          if ($_SESSION["droits"][$value] == 1) {
            $resident = 1;
          }
        }
        if ($resident == 0) {
          $motifErreur = "droitko";
        }
      }
    }
    /**
     * Verification que le module soit bien appele apres le module qui doit le preceder
     * La recherche peut contenir plusieurs noms de modules, separes par le caractere |
     */
    if (!empty($t_module["modulebefore"])) {
      $before = explode(",", $t_module["modulebefore"]);
      $beforeok = false;
      foreach ($before as $value) {
        if ($_SESSION["moduleBefore"] == $value) {
          $beforeok = true;
        }
      }
      if (!$beforeok) {
        $resident = 0;
        if ($APPLI_modeDeveloppement) {
          // traduction: conserver inchangée la chaîne %s
          $message->set(sprintf(_('Module précédent enregistré : %s'), $_SESSION["moduleBefore"]));
        }
        $motifErreur = "errorbefore";
      }
    }

    /**
     * Count all calls to the module
     */
    if (
      $t_module["maxCountByHour"] > 0
      && !$log->getCallsToModule($module, $t_module["maxCountByHour"], $APPLI_hour_duration)
    ) {
      $resident = 0;
      $motifErreur = "callsReached";
    }
    if (
      $t_module["maxCountByDay"] > 0
      && !$log->getCallsToModule($module, $t_module["maxCountByDay"], $APPLI_day_duration)
    ) {
      $resident = 0;
      $motifErreur = "callsReached";
    }

    /**
     * Verification s'il s'agit d'un module d'administration
     */
    $moduleAdmin = false;
    if (in_array("admin", $droits_array)) {
      $moduleAdmin = true;
      /*
         * Verification si la duree de connexion en mode admin est depassee
         */
      if (isset($_SESSION["last_activity_admin"]) && (time() - $_SESSION["last_activity_admin"]) < $APPLI_admin_ttl) {
        /**
         * L'acces est dans le laps de temps autorise
         */
        $_SESSION["last_activity_admin"] = time();
      } else {
        $_SESSION["is_authenticated"] = false;
        /**
         * Verify if the account is TOTP
         */

        if (!isset($acllogin)) {
          include_once "framework/droits/acllogin.class.php";
          $acllogin = new Acllogin($bdd_gacl, $ObjetBDDParam);
        }
        if ($module != "totpVerifyExec" && $module != "loginExec") {
          $resident = 0;
          $vue->set($_REQUEST["module"], "moduleCalled");
        } else {
          if (isset($_POST["moduleCalled"])) {
            $vue->set($_POST["moduleCalled"], "moduleCalled");
          }
        }
        if ($acllogin->isTotp() && !empty($_SESSION["login"])) {
          $vue->set("framework/ident/totp.tpl", "corps");
        } else if (in_array($ident_type, array("BDD", "LDAP", "LDAP-BDD"))) {
          /**
           * saisie du login en mode admin
           */
          $vue->set("framework/ident/loginAdmin.tpl", "corps");
          $resident = 0;
          if ($t_module["retourlogin"] == 1) {
            $vue->set($module, "moduleCalled");
          }
          $message->set(_("L'accès au module demandé nécessite une ré-identification. Veuillez saisir votre login et votre mot de passe"));
        }
      }
    }
    /**
     * fin d'analyse du module
     */
    /**
     * Enregistrement de l'acces au module
     */
    try {
      isset($_SESSION["login"]) ? $logLogin = $_SESSION["login"] : $logLogin = "";
      $log->setLog($logLogin, $module, $motifErreur);
    } catch (Exception $e) {
      if ($OBJETBDD_debugmode > 0) {
        $message->set($log->getErrorData(1), true);
      } else {
        $message->set(_("Erreur d'écriture dans le fichier de traces"));
      }
      $message->setSyslog($e->getMessage());
    }

    unset($module_coderetour);
    /**
     * Execution du module
     */
    if ($resident == 1) {
      /**
       * Mise a niveau de la variable stockant le module precedemment appele
       */
      if (!$isAjax && $module != "default") {
        $_SESSION["moduleBefore"] = $module;
      }
      if (!empty($t_module["action"])) {
        include $t_module["action"];
      }

      if ($module == "loginExec" || $module == "totpVerifyExec") {
        if ($_SESSION["is_authenticated"]) {
          $module_coderetour = 1;
          empty($_POST["moduleCalled"]) ? $t_module["retourok"] = "default" : $t_module["retourok"] = $_POST["moduleCalled"];
        } elseif ($module != "loginExec") {
          $module_coderetour = -1;
          $t_module["retourko"] = "default";
        }
      }
      unset($module);
      /**
       * Recuperation du code de retour et affectation du nom du nouveau module
       */
      if (isset($module_coderetour)) {
        switch ($module_coderetour) {
          case -1:
            unset($vue);
            $module = $t_module["retourko"];
            break;
          case 0:
          case 1:
          case 2:
          case 3:
          default:
            if (isset($t_module["retourok"])) {
              $module = $t_module["retourok"];
            }
            break;
        }
      }
    } else {
      /**
       * Traitement des erreurs
       */
      switch ($motifErreur) {
        case "droitko":
          if (!$acllogin->isTotp() || !$moduleAdmin) {
            /**
             * Send mail to administrators
             */
            $subject = "SECURITY REPORTING - " . $GACL_aco . " - The user " . $_SESSION["login"] . "  has attempted to access an unauthorized module";
            $log->sendMailToAdmin(
              $subject,
              "framework/mail/noRights.tpl",
              array(
                "login" => $_SESSION["login"],
                "module" => $module,
                "date" => $date,
                "APPLI_address" => $APPLI_address
              ),
              $module,
              $login
            );
          }
          if (!empty($t_module["droitko"])) {
            $module = $t_module["droitko"];
          } else {
            $module = $APPLI_moduleDroitKO;
          }
          break;
        case "nologin":
          $module = $APPLI_moduleErrorLogin;
          break;
        case "errorbefore":
          $module = $APPLI_moduleErrorBefore;
          break;
        case "adminko":
          $module = $APPLI_moduleAdminLogin;
          break;
        case "callsReached":
          $module = "default";
          break;
        default:
          unset($module);
      }
    }
  }
  /**
   * Traitement de l'affichage vers le navigateur
   */
  if ($isHtml) {
    /*
     * Affichage du menu
     */
    $vue->set($_SESSION["APPLI_title"], "APPLI_title");
    if (!isset($_SESSION["menu"])) {
      include_once 'framework/navigation/menu.class.php';
      $menu = new Menu($APPLI_menufile);
      $_SESSION["menu"] = $menu->generateMenu();
    }

    $vue->set($_SESSION["menu"], "menu");
    if (isset($_SESSION["login"])) {
      $vue->set(1, "isConnected");
      $vue->set($_SESSION["login"], "login");
    }
    /**
     * Passage en parametre du nom du module courant
     */
    $vue->set($_SESSION["moduleBefore"], "lastModule");
    /**
     * Traitement des messages d'erreur - changement de classe d'affichage
     */
    if ($message->is_error) {
      $vue->set(1, "messageError");
    }
    /**
     * Gestion de l'internationalisation
     */
    $vue->set($_SESSION["FORMATDATE"], "language");
    /**
     * Affichage de la page
     */
    /**
     * Alerte Mode developpement
     */
    if ($APPLI_modeDeveloppement) {
      // traduction: bien conserver inchangées les chaînes %1$s, %2$s
      $texteDeveloppement = sprintf(_('Mode développement - base de données : %1$s - schema : %2$s'), $BDD_dsn, $BDD_schema);
      $vue->set($texteDeveloppement, "developpementMode");
    }
    $vue->set($_SESSION["moduleListe"], "moduleListe");
    /**
     * execution du code generique avant affichage
     */
    include 'modules/beforeDisplay.php';

    /**
     * Envoi des droits
     */
    $vue->set($_SESSION["droits"], "droits");
  }
  /**
   * Declenchement de l'envoi vers le navigateur
   */
  if (isset($vue)) {
    try {
      if (!isset($paramSend)) {
        $paramSend = array();
      }
      $vue->send($paramSend);
    } catch (Exception $e) {
      $message->setSyslog($e->getMessage());
    }
  }

  /**
   * Generation des messages d'erreur pour Syslog
   */
  $message->sendSyslog();
} catch (Exception $e) {
  /**
   * General exception
   */
  echo _("Une erreur indéterminée s'est produite pendant le traitement de la requête. Si le problème persiste, consultez l'administrateur de l'application");
  $message->setSyslog($e->getMessage());
  if ($APPLI_modeDeveloppement) {
    echo "<br>" . $e->getMessage();
  }
}
/**
 * Fin de traitement
 */
