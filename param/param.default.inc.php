<?php

/** Fichier cree le 4 mai 07 par quinton
 *
 *UTF-8
 *
 * Parametres par defaut de l'application
 * Si des modifications doivent etre apportees, faites-les dans le fichier param.inc.php
 */
$APPLI_version = "2.8.0b";
$APPLI_dbversion = "2.8";
$APPLI_versiondate = _("14/09/2022");
$language = "fr";
$DEFAULT_formatdate = "fr";
/*
 * Navigation a partir du fichier xml
 */
$navigationxml = array("framework/actions.xml", "param/actions.xml");
/*
 * Duree de la session par defaut
 * @var unknown_type
 */
// 4 heures
$APPLI_session_ttl = 14400;
// 3 mois
$APPLI_cookie_ttl = 7776000;
// 10 heures
$APPLI_absolute_session = 36000;
/*
 *
 * Nom du chemin de stockage des sessions
 * @var unknown_type
 */
$APPLI_path_stockage_session = "prototypephp";
/*
 * Duree de conservation des traces (en jours) dans la table log
 */
$LOG_duree = 365;
/*
 * Type d'identification
 *
 * BDD : mot de passe en base de donnees
 * CAS : utilisation d'un serveur CAS
 * LDAP : utilisation d'un serveur LDAP
 * LDAP-BDD : test d'abord aupres du serveur LDAP, puis du serveur BDD
 * HEADER : l'identification est fournie dans une variable HEADER (derriere un proxy comme
 * LemonLdap, par exemple)
 */
$ident_header_vars = array(
	"radical" => "MELLON",
	"login" => "MELLON_MAIL",
	"mail" => "MELLON_MAIL",
	"cn" => "MELLON_CN",
	"organization" => "MELLON_SHACHOMEORGANIZATION",
	"organizationGranted" => array(),
	"createUser" => true
);
$ident_header_logout_address = "";
$ident_type = "BDD";
$CAS_address = "localhost";
$CAS_uri = "/cas";
$CAS_port = 443;
$CAS_debug = false;
$CAS_CApath = "";
$CAS_get_groups = 1;
$CAS_group_attribute = "supannEntiteAffectation";
$LDAP = array(
	"address" => "localhost",
	"port" => 389,
	"rdn" => "cn=manager,dc=example,dc=com",
	"basedn" => "ou=people,ou=example,o=societe,c=fr",
	"user_attrib" => "uid",
	"v3" => true,
	"tls" => false,
	"upn_suffix" => "", //pour Active Directory
	"groupSupport" => false,
	"groupAttrib" => "supannentiteaffectation",
	"commonNameAttrib" => "displayname",
	"mailAttrib" => "mail",
	'attributgroupname' => "cn",
	'attributloginname' => "memberuid",
	'basedngroup' => 'ou=example,o=societe,c=fr',
	"timeout" => 2,
	"ldapnoanonymous" => false,
	"ldaplogin" => "",
	"ldappassword" => ""
);

/*
 * Parametres concernant la base de donnees
 */
$BDD_login = "proto";
$BDD_passwd = "proto";
$BDD_dsn = "pgsq:host=localhost;dbname=proto";
$BDD_schema = "public";
/*
 * Parametres concernant SMARTY
 */
$SMARTY_param = array(
	"templates" => "display/templates",
	"templates_c" => "display/templates_c",
	"cache" => false,
	"cache_dir" => "display/smarty_cache",
	"template_main" => "main.htm"
);

/*
 * Variables de base de l'application
 */
$APPLI_mail = "proto@proto.com";
$APPLI_nom = "Prototype d'application";
$APPLI_code = 'proto';
$APPLI_fds = "display/CSS/blue.css";
$APPLI_address = "http://localhost/proto";
$APPLI_modeDeveloppement = false;
$APPLI_modeDeveloppementDroit = false;
$APPLI_utf8 = true;
$APPLI_menufile = "param/menu.xml";
$APPLI_temp = "temp";
$APPLI_titre = "Collec-Science";
$APPLI_assist_address = "https://github.com/collec-science/collec-science/issues/new";
$APPLI_isFullDns = false;
/*
 * Impression directe vers une imprimante a etiquettes
 * connectee au serveur
 * lpr|lp
 */
$APPLI_print_direct_command = "lpr";
/*
 * Emplacement de fop, programme externe utilise pour generer
 * les etiquettes au format PDF
 */
$APPLI_fop = "/usr/bin/fop";
/*
 * Variables systematiques pour SMARTY
 */
$SMARTY_variables = array(
	"entete" => "entete.tpl",
	"enpied" => "enpied.tpl",
	"corps" => "main.tpl",
	"melappli" => $APPLI_mail,
	"ident_type" => $ident_type,
	"appliAssist" => $APPLI_assist_address,
	"display" => "/display",
	"favicon" => "/favicon.png"
);
/*
 * Variables liees a GACL et l'identification via base de donnees
 */
$GACL_dblogin = "proto";
$GACL_dbpasswd = "proto";
$GACL_aco = "col";
$GACL_dsn = "pgsql:host=localhost;dbname=proto";
$GACL_schema = "gacl";
$GACL_disable_new_right = 1;

/*
 * Gestion des erreurs
 */
$ERROR_level = E_ERROR;
/*
 * Pour le developpement :
 * $ERROR_level = E_ALL & ~E_NOTICE & E_STRICT
 * En production :
 * $ERROR_level = E_ERROR ;
 */
$ERROR_display = 0;
$ADODB_debugmode = 0;
$OBJETBDD_debugmode = 1;
/*
 * Modules de traitement des erreurs
 */
$APPLI_moduleDroitKO = "droitko";
$APPLI_moduleErrorBefore = "errorbefore";
$APPLI_moduleNoLogin = "errorlogin";
$APPLI_notSSL = false;
/*
 * Cles privee et publique utilisees
 * pour la generation des jetons
 */
$privateKey = "/etc/ssl/private/ssl-cert-snakeoil.key";
$pubKey = "/etc/ssl/certs/ssl-cert-snakeoil.pem";
/*
 * Duree de validite du token d'identification
 */
$tokenIdentityValidity = 36000; // 10 heures

/*
 * Affichage par defaut des cartes Openstreetmap
 */
$mapDefaultX = -0.70;
$mapDefaultY = 44.77;
$mapDefaultZoom = 7;
$MAIL_enabled = 0;
/*
 * Nombre maximum d'essais de connexion
 */
$CONNEXION_max_attempts = 5;
/*
 * Duree de blocage du compte (duree reinitialisee a chaque tentative)
 */
$CONNEXION_blocking_duration = 600;
/*
 * Laps de temps avant de renvoyer un mail a l'administrateur en cas de blocage de compte
 */
$APPLI_mailToAdminPeriod = 7200;
$APPLI_admin_ttl = 600; // Duree maxi d'inactivite pour acceder a un module d'administration
$APPLI_lostPassword = 0; // Autorise la recuperation d'un nouveau mot de passe en cas de perte
$APPLI_max_file_size = 10; // Size in Mb

$APPLI_passwordMinLength = 12;
$APPLI_hour_duration = 3600; // Duration of an hour for count all calls to a module
$APPLI_day_duration = 36000; //Duration of a day for count all calls to a module
$APPLI_external_document_path = "/dev/null";
