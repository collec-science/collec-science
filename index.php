<?php
/*
 * Gestion des URL conviviales
 * prototypephp/module/1/sous-module
 * 1 correspond a l'ID a traiter
 * 
 * Attention : verifier la configuration de .htaccess, et notamment RewriteBase
 */

echo "GET : ";
print_r($_GET);
echo "<br>SESSION : ";
print_r($_SESSION);
echo "<br>SERVER : ";
print_r($_SERVER);

include "framework/controller.php";
?>