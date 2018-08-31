<?php
/* 
 * Recuperation de la structure de la base de donnees
 */
require_once 'framework/utils/structure.class.php';
$dataclass = new Structure($bdd);

switch ($t_module["param"]) {
    case "html":
        $vue->set($dataclass->generateHtml(), "data");
        $vue->htmlVars[] = "data";
        $vue->set("dbstructure.tpl", "corps");
        break;
}

?>