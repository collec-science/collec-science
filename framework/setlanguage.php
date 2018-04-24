<?php
/**
 * Positionne la langue dans l'application
 */
unset($_SESSION["menu"]);
switch ($t_module["param"]) {
    case "fr":
        setlanguage("fr");
        break;
    case "en":
        setlanguage("en");
        break;
    default:
        if (isset($_REQUEST["langue"])) {
            setlanguage($_REQUEST['langue']);
        }
}
/*
 * Reaffectation des bons parametres pour la classe log
 */
$log->setParam($ObjetBDDParam);
$module_coderetour = 1;
?>