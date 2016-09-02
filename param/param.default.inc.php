<?php
/** Fichier cree le 4 mai 07 par quinton
*
*UTF-8
* 
* Parametres par defaut de l'application
*/
$APPLI_version = "0.4";
$APPLI_versiondate = "02/09/2016";
$language = "fr";
$DEFAULT_formatdate = "fr";
/*
 * Navigation a partir du fichier xml
 */
$navigationxml = "param/actions.xml";
/*
 * Duree de la session par defaut
 * @var unknown_type
 */
// 4 heures
$APPLI_session_ttl = 14400;
// 3 mois
$APPLI_cookie_ttl = 7776000; 
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
 */
$ident_type = "BDD";
//$CAS_plugin="plugins/phpcas-simple/phpcas.php";
$CAS_plugin = 'plugins/CAS-1.3.3/CAS.php';
$CAS_address = "http://localhost/CAS";
$CAS_port = 443;
$LDAP = array(
		"address"=>"localhost",
		"port" => 389,
		"rdn" => "cn=manager,dc=example,dc=com",
		"basedn" => "ou=people,ou=example,o=societe,c=fr",
		"user_attrib" => "uid",
		"v3" => true,
		"tls" => false,
		"groupSupport"=>true,
		"groupAttrib"=>"supannentiteaffectation",
		"commonNameAttrib"=>"displayname",
		"mailAttrib"=>"mail",
		'attributgroupname' => "cn",
		'attributloginname' => "memberuid",
		'basedngroup' => 'ou=example,o=societe,c=fr'
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
$SMARTY_param = array("templates"=> 'display/templates',
		"templates_c"=>'display/templates_c',
		"cache"=>false,
		"cache_dir"=>'display/smarty_cache',
		"template_main"=>"main.htm"
);

/*$SMARTY_template ='display/templates';
$SMARTY_template_c = 'display/templates_c';
$SMARTY_config = 'param/configs_smarty';
$SMARTY_cache_dir = 'display/smarty_cache';
$SMARTY_cache = FALSE;
$SMARTY_entete = "entete.tpl";
$SMARTY_enpied = "enpied.tpl";
$SMARTY_principal = "main.htm";
$SMARTY_corps = "main.tpl";
*/
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
$APPLI_nomDossierStockagePhotoTemp = "temp";
$APPLI_titre = "Gestion des échantillons";

/*
 * Variables systematiques pour SMARTY
 */
$SMARTY_variables = array(
		"entete"=>"entete.tpl",
		"enpied"=>"enpied.tpl",
		"corps"=>"main.tpl",
		"melappli"=>$APPLI_mail,
		"ident_type"=>$ident_type
);
/*
 * Variables liees a GACL et l'identification via base de donnees
 */
$GACL_dblogin = "proto";
$GACL_dbpasswd = "proto";
$GACL_aco = "col";
$GACL_dsn = "pgsql:host=localhost;dbname=proto";
$GACL_schema = "gacl";

/*
 * Gestion des erreurs
 */
$ERROR_level=E_ERROR;
/*
 * Pour le developpement :
 * $ERROR_level = E_ALL & ~E_NOTICE & E_STRICT 
 * En production :
 * $ERROR_level = E_ERROR ;
 */ 
$ERROR_display=0;
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
?>
