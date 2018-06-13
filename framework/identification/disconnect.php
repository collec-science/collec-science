<?php
/** Fichier cree le 10 mai 07 par quinton
 *
 *UTF-8
 */
$login = $_SESSION["login"];
$message->setSyslog("Deconnexion from $login - address " . getIPClientAddress());
if ($identification->disconnect($APPLI_address) == 1) {
    $message->set(_("Vous êtes maintenant déconnecté"));
} else {
    $message->set(_("Connexion"));
}

?>