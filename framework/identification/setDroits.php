<?php
/**
 * Definit les droits si le login est connu
 */
if (isset ( $_SESSION ["login"] )) {	
	require_once 'framework/droits/droits.class.php';
	$acllogin = new Acllogin ( $bdd_gacl, $ObjetBDDParam );
	try {
	$_SESSION ["droits"] = $acllogin->getListDroits ( $_SESSION ["login"], $GACL_aco, $LDAP );
	} catch (Exception $e) {
		if ($APPLI_modeDeveloppement) {
			$message->set($e->getMessage());
		}
		$message->setSyslog($e->getMessage());
	}
}
?>