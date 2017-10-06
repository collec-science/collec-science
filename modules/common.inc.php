<?php
/**
 * Code execute systematiquement a chaque appel, apres demarrage de la session
 * Utilise notamment pour recuperer les instances de classes stockees en 
 * variables de session
 */

if (! isset ( $_SESSION ["searchContainer"] )) {
	$_SESSION ["searchContainer"] = new SearchContainer ();
}
if (! isset ( $_SESSION ["searchSample"] )) {
	$_SESSION ["searchSample"] = new SearchSample ();
}
if (!isset($_SESSION["APPLI_code"])) {
    require_once 'modules/classes/dbparam.class.php';
    $dbparam = new DbParam($bdd, $ObjetBDDParam);
    $code = $dbparam->getParam("APPLI_code");
    strlen($code) > 0 ? $_SESSION["APPLI_code"] = $code : $_SESSION["APPLI_code"] = $APPLI_code;
}
?>