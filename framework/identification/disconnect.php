<?php


$message->setSyslog("Deconnexion from " . $_SESSION["login"] . " - address " . getIPClientAddress());
require_once "framework/identification/login.class.php";
$login = new Login($bdd_gacl, $ObjetBDDParam);
$login->disconnect($APPLI_address);
$message->set(_("Vous êtes maintenant déconnecté"));
/**
 * Rechargement des variables stockees en base de donnees
 */
require_once 'framework/dbparam/dbparam.class.php';
$dbparam = new DbParam($bdd, $ObjetBDDParam);
$dbparam->sessionSet();
$module_coderetour = 1;
