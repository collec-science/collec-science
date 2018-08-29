<?php

/**
 * Code execute systematiquement a chaque appel, apres demarrage de la session
 * Utilise notamment pour recuperer les instances de classes stockees en 
 * variables de session
 */
if (!isset($_SESSION["searchContainer"])) {
    $_SESSION["searchContainer"] = new SearchContainer();
}
if (!isset($_SESSION["searchSample"])) {
    $_SESSION["searchSample"] = new SearchSample();
}
if (!isset($_SESSION["searchMovement"])) {
    $_SESSION["searchMovement"] = new SearchMovement();
}

/*
 * Traitement des parametres stockes dans la base de donnees
 */
if (!$_SESSION["dbparamok"]) {
    require_once 'modules/classes/dbparam.class.php';
    $dbparam = new DbParam($bdd, $ObjetBDDParam);
    $listParam = $dbparam->getListe();
    foreach ($listParam as $param) {
        if (strlen($param["dbparam_value"]) > 0) {
            $_SESSION[$param["dbparam_name"]] = $param["dbparam_value"];
        } else {
            /*
             * parametres obsoletes dans param.inc.php
             */
            $_SESSION[$param["dbparam_name"]] = $$param["dbparam_name"];
        }
    }
    $_SESSION["dbparamok"] = true;
}
?>