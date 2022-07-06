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
if (!isset($_SESSION["searchEvent"])) {
    $_SESSION["searchEvent"] = new SearchEvent();
}
