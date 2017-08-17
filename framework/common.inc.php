<?php
/** Fichier cree le 4 mai 07 par quinton
 * Modifie le 9/8/11 : mise en session de la classe smarty
 *
 *UTF-8
 *
 * inclusions de base, ouverture de session
 *
 */

/**
 * Lecture des parametres de l'application
 */
include_once ("param/param.default.inc.php");
include_once ("param/param.inc.php");

/**
 * Protection contre les IFRAMES
 */
header ( "X-Frame-Options: SAMEORIGIN" );

/*
 * protection de la session
 */
ini_set ( "session.use_strict_mode", true );
ini_set ( 'session.gc_probability', 1 );
ini_set ( 'session.gc_maxlifetime', $APPLI_session_ttl );

/**
 * Integration de SMARTY
 */
include_once ("vendor/smarty/smarty/libs/Smarty.class.php");
/**
 * integration de la classe ObjetBDD et des scripts associes
 */
include_once ('plugins/objetBDD-3.2/ObjetBDD.php');
include_once ('plugins/objetBDD-3.2/ObjetBDD_functions.php');
if ($APPLI_utf8 == true)
	$ObjetBDDParam ["UTF8"] = true;
$ObjetBDDParam ["codageHtml"] = false;
/**
 * Integration de la classe gerant la navigation dans les modules
 */
include_once ("framework/navigation/navigation.class.php");

/**
 * Preparation de l'identification
 */
require_once "framework/identification/identification.class.php";

/**
 * Initialisation des parametres generaux
 */
ini_set ( "register_globals", false );
ini_set ( "magic_quotes_gpc", true );
error_reporting ( $ERROR_level );
ini_set ( "display_errors", $ERROR_display );
/*
 * Appel des initialisations specifiques de l'application
 */
include_once "modules/beforesession.inc.php";
/**
 * Demarrage de la session
 */
@session_start ();
/*
 * Verification du cookie de session, et destruction le cas echeant
 */
if (isset ( $_SESSION ['LAST_ACTIVITY'] ) && (time () - $_SESSION ['LAST_ACTIVITY'] > $APPLI_session_ttl)) {
	// last request was more than 30 minutes ago
	session_unset (); // unset $_SESSION variable for the run-time
	session_destroy (); // destroy session data in storage
}
$_SESSION ['LAST_ACTIVITY'] = time (); // update last activity time stamp
if (! isset ( $_SESSION ['CREATED'] )) {
	$_SESSION ['CREATED'] = time ();
	$_SESSION['ABSOLUTE_START'] = time();
} else if (time () - $_SESSION ['CREATED'] > $APPLI_session_ttl) {
	/*
	 * La session a demarre depuis plus du temps de la session : cookie regenere
	 */
	session_regenerate_id ( true ); // change session ID for the current session and invalidate old session ID
	$_SESSION ['CREATED'] = time (); // update creation time
}
/*
 * Regeneration du cookie de session
 */
$cookieParam = session_get_cookie_params ();
$cookieParam ["lifetime"] = $APPLI_session_ttl;
if ($APPLI_modeDeveloppement == false)
	$cookieParam ["secure"] = true;
$cookieParam ["httponly"] = true;
setcookie ( session_name (), session_id (), time () + $APPLI_session_ttl, $cookieParam ["path"], $cookieParam ["domain"], $cookieParam ["secure"], $cookieParam ["httponly"] );

/*
 * Recuperation des parametres de l'application definis dans un fichier ini
 */
if (is_file ( $paramIniFile )) {
	$paramAppli = parse_ini_file ( $paramIniFile );
	foreach ( $paramAppli as $key => $value )
		$$key = $value;
}
/**
 * Integration des classes de gestion des vues et des messages
 * instanciation des messages
 */
require_once 'framework/vue.class.php';
$ERROR_display == 1 ? $displaySyslog = true : $displaySyslog = false;
$message = new Message ($displaySyslog);
/*
 * Lancement de l'identification
 */

$identification = new Identification ();

$identification->setidenttype ( $ident_type );
if ($ident_type == "CAS") {
    require_once "vendor/jasig/phpcas/CAS.php";
	$identification->init_CAS ( $CAS_address, $CAS_port, $APPLI_address );
} elseif ($ident_type == "LDAP" || $ident_type == "LDAP-BDD") {
	$identification->init_LDAP ( $LDAP["address"], $LDAP["port"], $LDAP["basedn"], $LDAP["user_attrib"], $LDAP["v3"], $LDAP["tls"] );
}
/*
 * Chargement des fonction generiques
 */
include_once 'framework/fonctions.php';

/*
 * Gestion de la langue a afficher
 */
if (isset ( $_SESSION ["LANG"] ) && $APPLI_modeDeveloppement == false) {
	$LANG = $_SESSION["LANG"];
} else {
	/*
	 * Recuperation le cas echeant du cookie
	 */
	if (isset ( $_COOKIE ["langue"] )) {
		$langue = $_COOKIE ["langue"];
	} else {
		/*
		 * Recuperation de la langue du navigateur
		 */
		$langue = explode ( ';', $_SERVER ['HTTP_ACCEPT_LANGUAGE'] );
		$langue = substr ( $langue [0], 0, 2 );
	}
	/*
	 * Mise a niveau du langage
	 */
	setlanguage ( $langue );
}

$SMARTY_variables["LANG"] = $_SESSION ["LANG"];
/*
 * Connexion a la base de donnees
 */
if (! isset ( $bdd )) {
	$etaconn = true;
	try {
		$bdd = new PDO ( $BDD_dsn, $BDD_login, $BDD_passwd );
	} catch ( PDOException $e ) {
		if ($APPLI_modeDeveloppement == true) {
			$message->set ( $e->getMessage () );
		} else 
			$message->setSyslog($e->getMessage());
		$etaconn = false;
	}
	if ($etaconn == true) {
		/*
		 * Mise en place du schema par defaut
		 */
		if (strlen ( $BDD_schema ) > 0) {
			$bdd->exec ( "set search_path = " . $BDD_schema );
		}
		/*
		 * Connexion a la base de gestion des droits
		 */
		try {
			$bdd_gacl = new PDO ( $GACL_dsn, $GACL_dblogin, $GACL_dbpasswd );
		} catch ( PDOException $e ) {
			if ($APPLI_modeDeveloppement == true) {
				$message->set ( $e->getMessage () );
			} else 
				$message->setSyslog($e->getMessage());
			$etaconn = false;
		}
		if ($etaconn == true) {
			/*
			 * Mise en place du schema par defaut
			 */
			if (strlen ( $GACL_schema ) > 0)
				$bdd_gacl->exec ( "set search_path = " . $GACL_schema );
		} else {
			$message->set ( $LANG ["message"] [29] );
		}
	} else
		$message->set ( $LANG ["message"] [22] );
}
/*
 * Activation de la classe d'enregistrement des traces
 */
$log = new Log ( $bdd_gacl, $ObjetBDDParam );

/*
 * Verification de la duree maxi de la session
 */
if (time () - $_SESSION ['ABSOLUTE_START'] > $APPLI_absolute_session) {
	$log->setLog($_SESSION["login"], "disconnect-absolute-time");
	$identification->disconnect ( $APPLI_address );
	$message->set($LANG["message"][44]);
	/*
	 * Desactivation du cookie d'identification deja charge le cas echeant
	 */
	unset($_COOKIE ["tokenIdentity"]);
}
/**
 * Verification du couple session/adresse IP
 */
$ipaddress = getIPClientAddress ();
if (isset ( $_SESSION ["remoteIP"] )) {
	if ($_SESSION ["remoteIP"] != $ipaddress) {
		// Tentative d'usurpation de session - on ferme la session
		$log->setLog($_SESSION["login"], "disconnect-ipaddress-changed", "old:".$_SESSION["remoteIP"]."-new:".$ipaddress);
		if ($identification->disconnect ( $APPLI_address ) == 1) {
			$message->set ( $LANG ["message"] [7] );
		} else {
			$message->set ( $LANG ["message"] [8] );
		}
	}
} else
	$_SESSION ["remoteIP"] = $ipaddress;

/*
 * Preparation du module de gestion de la navigation
 */
if (isset ( $_SESSION ["navigation"] ) && $APPLI_modeDeveloppement == false) {
	$navigation = $_SESSION ['navigation'];
} else {
	$navigation = new Navigation ( $navigationxml );
	$_SESSION ['navigation'] = $navigation;
}

/*
 * Chargement des fonctions specifiques
 */
include_once 'modules/fonctions.php';

include_once 'framework/functionsDebug.php';
/*
 * Preparation du menu
 */
/*if (! isset ( $_SESSION ["menu"] ) || $APPLI_modeDeveloppement == true) {
	include_once 'framework/navigation/menu.class.php';
	$menu = new Menu ( $APPLI_menufile, $LANG );
	$_SESSION ["menu"] = $menu->generateMenu ();
}*/
/*
 * Chargement des traitements communs specifiques a l'application
 */
include_once ("modules/common.inc.php");

?>
