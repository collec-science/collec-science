<?php

/** Fichier cree le 10 mai 07 par quinton
 *
 *UTF-8
 */
$login = $_SESSION["login"];
$message->setSyslog("Deconnexion from $login - address " . getIPClientAddress());
if ($identification->disconnect($APPLI_address) == 1) {
    $message->set(_("Vous êtes maintenant déconnecté"));
    /*
     * Rechargement des variables stockees en base de donnees
     */
    require_once 'framework/dbparam/dbparam.class.php';
    $dbparam = new DbParam($bdd, $ObjetBDDParam);
    $dbparam->sessionSet();
} else {
    $message->set(_("Connexion"));
}

?>