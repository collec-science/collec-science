<?php
/**
 * Positionne la langue dans l'application
 */
if (isset($_REQUEST["langue"])) {
	setlanguage($_REQUEST['langue']);
	/*
	 * Regeneration du menu
	 */
	unset ($_SESSION["menu"]);
}
?>