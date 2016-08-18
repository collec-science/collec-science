<?php
/*
 * Gestion des URL conviviales
 * prototypephp/module/1/sous-module
 * 1 correspond a l'ID a traiter
 * 
 * Attention : verifier la configuration de .htaccess, et notamment RewriteBase
 */
if (isset($_GET["url"])) {
	$url = split("/", $_GET["url"]);
	if (is_numeric($url[1]) && ! isset($_REQUEST["id"])) {
		$_GET["id"] = $url[1];
		$_REQUEST["id"] = $url[1];
	}
	if (!isset($_REQUEST["module"])) {
		if (strlen($url[0]) > 0) {
			$_GET["module"] = $url[0];
			if (strlen($url[2])> 0)
				$_GET["module"] .= $url[2];
		} else
			$_GET["module"] = "default";
			$_REQUEST["module"] = $_GET["module"];
	}
	//print_r($_GET);
}
include "framework/controller.php";
?>