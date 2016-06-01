<?php
/**
 * Definit les droits si le login est connu
 */
if (isset ( $_SESSION ["login"] )) {	
	require_once 'framework/droits/droits.class.php';
	$acllogin = new Acllogin ( $bdd_gacl, $ObjetBDDParam );
	$_SESSION ["droits"] = $acllogin->getListDroits ( $_SESSION ["login"], $GACL_aco );
}
?>