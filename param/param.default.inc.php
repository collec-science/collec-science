<?php
/** Fichier cree le 4 mai 07 par quinton
*
*UTF-8
* 
* Parametres par defaut de l'application
*/
$APPLI_version = "0.1";
$APPLI_versiondate = "18/08/2016";
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
$LDAP_address = "localhost";
$LDAP_port = 389;
$LDAP_rdn = "cn=manager,dc=example,dc=com";
$LDAP_basedn = "ou=people,ou=example,o=societe,c=fr";
$LDAP_user_attrib = "uid";
$LDAPGROUP_port = 389;
$LDAP_v3 = true;
$LDAP_tls = false;
/*
 * Duree de validite du token d'identification
 */
$tokenIdentityValidity = 36000; // 10 heures
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
$SMARTY_template ='display/templates';
$SMARTY_template_c = 'display/templates_c';
$SMARTY_config = 'param/configs_smarty';
$SMARTY_cache_dir = 'display/smarty_cache';
$SMARTY_cache = FALSE;
$SMARTY_entete = "entete.tpl";
$SMARTY_enpied = "enpied.tpl";
$SMARTY_principal = "main.htm";
$SMARTY_corps = "main.tpl";
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
$APPLI_ldapGroupSupport = true;
$LDAP_groupAttrib = "supannentiteaffectation";
$LDAP_commonNameAttrib = "displayname";
$LDAP_mailAttrib = "mail";
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
?>
