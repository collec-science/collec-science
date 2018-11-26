<?php
/**
 * Fichier cree le 4 mai 07 par quinton
 * Modifie le 9/8/11 : mise en session de la classe smarty
 *
 * UTF-8
 *
 * inclusions de base, ouverture de session
 *
 */

/**
 * Lecture des parametres de l'application
 */
require_once "param/param.default.inc.php";
require_once "param/param.inc.php";

/**
 * Protection contre les IFRAMES
 */
header("X-Frame-Options: SAMEORIGIN");

/*
 * protection de la session
 */
ini_set("session.use_strict_mode", true);
ini_set('session.gc_probability', 1);
ini_set('session.gc_maxlifetime', $APPLI_session_ttl);

/**
 * Integration de SMARTY
 */
require_once "vendor/smarty/smarty/libs/Smarty.class.php";
/**
 * Integration de la classe ObjetBDD et des scripts associes
 */
require_once 'framework/objetbdd/ObjetBDD.php';
require_once 'framework/objetbdd/ObjetBDD_functions.php';
if ($APPLI_utf8) {
    $ObjetBDDParam["UTF8"] = true;
}
$ObjetBDDParam["codageHtml"] = false;
/**
 * Integration de la classe gerant la navigation dans les modules
 */
require_once "framework/navigation/navigation.class.php";

/**
 * Preparation de l'identification
 */
require_once "framework/identification/identification.class.php";

/**
 * Initialisation des parametres generaux
 */
ini_set("register_globals", false);
ini_set("magic_quotes_gpc", true);
error_reporting($ERROR_level);
ini_set("display_errors", $ERROR_display);
/*
 * Appel des initialisations specifiques de l'application
 */
require_once "modules/beforesession.inc.php";
/**
 * Demarrage de la session
 */
@session_start();
DEFINE("DATELONGMASK", "Y-m-d H:i:s");

/*
 * Verification du cookie de session, et destruction le cas echeant
 */
if (isset($_SESSION['LAST_ACTIVITY']) && (time() - $_SESSION['LAST_ACTIVITY'] > $APPLI_session_ttl)) {
    // last request was more than 30 minutes ago
    session_unset(); // unset $_SESSION variable for the run-time
    session_destroy(); // destroy session data in storage
}
$_SESSION['LAST_ACTIVITY'] = time(); // update last activity time stamp
if (!isset($_SESSION['CREATED'])) {
    $_SESSION['CREATED'] = time();
    $_SESSION['ABSOLUTE_START'] = time();
} else if (time() - $_SESSION['CREATED'] > $APPLI_session_ttl) {
    /*
     * La session a demarre depuis plus du temps de la session : cookie regenere
     */
    session_regenerate_id(true); // change session ID for the current session and invalidate old session ID
    $_SESSION['CREATED'] = time(); // update creation time
}
/*
 * Regeneration du cookie de session
 */
$cookieParam = session_get_cookie_params();
$cookieParam["lifetime"] = $APPLI_session_ttl;
if (!$APPLI_modeDeveloppement) {
    $cookieParam["secure"] = true;
}
$cookieParam["httponly"] = true;
setcookie(
    session_name(),
    session_id(),
    time() + $APPLI_session_ttl,
    $cookieParam["path"],
    $cookieParam["domain"],
    $cookieParam["secure"],
    $cookieParam["httponly"]
);

/*
 * Recuperation des parametres de l'application definis dans un fichier ini
 */
if (is_file($paramIniFile)) {
    $paramAppli = parse_ini_file($paramIniFile);
    foreach ($paramAppli as $key => $value) {
        $$key = $value;
    }
}
/*
 * Recuperation des parametres pour ObjetBDDParam
 */
if (isset($_SESSION["ObjetBDDParam"])) {
    $ObjetBDDParam = $_SESSION["ObjetBDDParam"];
} else {
    objetBDDparamInit();
}
/**
 * Integration des classes de gestion des vues et des messages
 * instanciation des messages
 */
require_once 'framework/vue.class.php';
$ERROR_display == 1 ? $displaySyslog = true : $displaySyslog = false;
$message = new Message($displaySyslog);
/*
 * Lancement de l'identification
 */

$identification = new Identification();

$identification->setidenttype($ident_type);
if ($ident_type == "CAS") {
    include_once "vendor/jasig/phpcas/CAS.php";
    $identification->init_CAS($CAS_address, $CAS_port, "", $CAS_debug, $CAS_CApath);
} elseif ($ident_type == "LDAP" || $ident_type == "LDAP-BDD") {
    $identification->init_LDAP(
        $LDAP["address"],
        $LDAP["port"],
        $LDAP["basedn"],
        $LDAP["user_attrib"],
        $LDAP["v3"],
        $LDAP["tls"],
        $LDAP["upn_suffix"]
    );
}
/*
 * Chargement des fonction generiques
 */
require_once 'framework/fonctions.php';

/*
 * Gestion de la langue a afficher
 */
if (isset($_SESSION["LANG"]) && !$APPLI_modeDeveloppement) {
    $LANG = $_SESSION["LANG"];
    initGettext($LANG["date"]["locale"]);
} else {
    /*
     * Recuperation le cas echeant du cookie
     */
    if (isset($_COOKIE["langue"])) {
        $langue = $_COOKIE["langue"];
    } else {
        /*
         * Recuperation de la langue du navigateur
         */
        $langue = explode(';', $_SERVER['HTTP_ACCEPT_LANGUAGE']);
        $langue = substr($langue[0], 0, 2);
    }
    /*
     * Mise a niveau du langage
     */
    setlanguage($langue);
}

$SMARTY_variables["LANG"] = $_SESSION["LANG"];
/*
 * Connexion a la base de donnees
 */
if (!isset($bdd)) {
    $etaconn = true;
    try {
        $bdd = new PDO($BDD_dsn, $BDD_login, $BDD_passwd);
    } catch (PDOException $e) {
        if ($APPLI_modeDeveloppement) {
            $message->set($e->getMessage());
        } else {
            $message->setSyslog($e->getMessage());
        }
        $etaconn = false;
    }
    if ($etaconn) {
        /*
         * Mise en place du schema par defaut
         */
        if (strlen($BDD_schema) > 0) {
            $bdd->exec("set search_path = " . $BDD_schema);
            /*
             * Positionnement des messages dans la langue courante
             */
            switch ($LANG["date"]["locale"]) {
                case "en":
                    $bdd->exec("set lc_messages to 'en_US.UTF-8'");
                    break;
                case "fr":
                default:
                    $bdd->exec("set lc_messages to 'fr_FR.UTF-8'");
                    break;
            }
        }
        /*
         * Connexion a la base de gestion des droits
         */
        try {
            $bdd_gacl = new PDO($GACL_dsn, $GACL_dblogin, $GACL_dbpasswd);
        } catch (PDOException $e) {
            if ($APPLI_modeDeveloppement) {
                $message->set($e->getMessage());
            } else {
                $message->setSyslog($e->getMessage());
            }
            $etaconn = false;
        }
        if ($etaconn) {
            /*
             * Mise en place du schema par defaut
             */
            if (strlen($GACL_schema) > 0) {
                $bdd_gacl->exec("set search_path = " . $GACL_schema);
            }
            /*
             * Positionnement des messages dans la langue courante
             */
            switch ($LANG["date"]["locale"]) {
                case "en":
                    $bdd_gacl->exec("set lc_messages to 'en_US.UTF-8'");
                    break;
                case "fr":
                default:
                    $bdd_gacl->exec("set lc_messages to 'fr_FR.UTF-8'");
                    break;
            }
        } else {
            $message->set(_("Echec de connexion à la base de données de gestion des droits (GACL)"));
        }
    } else {
        $message->set(_("Echec de connexion à la base de données principale"));
    }
}
/*
 * Activation de la classe d'enregistrement des traces
 */
$log = new Log($bdd_gacl, $ObjetBDDParam);

/*
 * Verification de la duree maxi de la session
 */
if (time() - $_SESSION['ABSOLUTE_START'] > $APPLI_absolute_session) {
    $log->setLog($_SESSION["login"], "disconnect-absolute-time");
    $identification->disconnect($APPLI_address);
    $message->set(_("Vous avez été déconnecté, votre session était ouverte depuis trop longtemps"));
    /*
     * Desactivation du cookie d'identification deja charge le cas echeant
     */
    unset($_COOKIE["tokenIdentity"]);
}
/**
 * Verification du couple session/adresse IP
 */
$ipaddress = getIPClientAddress();
if (isset($_SESSION["remoteIP"])) {
    if ($_SESSION["remoteIP"] != $ipaddress) {
        // Tentative d'usurpation de session - on ferme la session
        $log->setLog(
            $_SESSION["login"], "disconnect-ipaddress-changed",
            "old:" . $_SESSION["remoteIP"] . "-new:" . $ipaddress
        );
        if ($identification->disconnect($APPLI_address) == 1) {
            $message->set(_("Vous êtes maintenant déconnecté"));
        } else {
            $message->set(_("Connexion"));
        }
    }
} else {
    $_SESSION["remoteIP"] = $ipaddress;
}

/*
 * Preparation du module de gestion de la navigation
 */
if (isset($_SESSION["navigation"]) && !$APPLI_modeDeveloppement) {
    $navigation = $_SESSION['navigation'];
} else {
    $navigation = new Navigation($navigationxml);
    unset($_SESSION["menu"]);
    $_SESSION['navigation'] = $navigation;
}

/*
 * Traitement des parametres stockes en
 * base de donnees
 */
/*
 * Traitement des parametres stockes dans la base de donnees
 */
if (!$_SESSION["dbparamok"]) {
    include_once 'framework/dbparam/dbparam.class.php';
    try {
        $dbparam = new DbParam($bdd, $ObjetBDDParam);
        $dbparam->sessionSet();
    } catch (Exception $e) {
        $message->set(
            _("Problème rencontré lors de la lecture de la table des paramètres"),
            true
        );
        $message->setSyslog($e->getMessage());
    }
}
/*
 * Chargement des fonctions specifiques
 */
require_once 'modules/fonctions.php';

require_once 'framework/functionsDebug.php';

/*
 * Chargement des traitements communs specifiques a l'application
 */
require "modules/common.inc.php";
