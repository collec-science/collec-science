<?php
/* 
 * Recuperation de la structure de la base de donnees
 */
require_once 'framework/utils/structure.class.php';
$vue->set("framework/dbstructure.tpl", "corps");

switch ($t_module["param"]) {
    case "html":
        $dataclass = new Structure($bdd);
        $vue->set(
            $dataclass->generateHtml(
                "tablename",
                "tablecomment",
                "table table-bordered table-hover"
            ),
            "data"
        );
        $vue->htmlVars[] = "data";

        break;
    case "latex":
        $dataclass = new Structure($bdd);
        $vue->set(
            $dataclass->generateLatex(
                "subsection",
                "\\begin{tabular}{|l| p{2cm}|c|c|c| p{3cm}|}",
                "\\end{tabular}"
            ),
            "data"
        );
        $vue->htmlVars[] = "data";

        break;
    case "gacl":
        $dataclass = new Structure($bdd_gacl);
        $vue->set(
            $dataclass->generateHtml(
                "tablename",
                "tablecomment",
                "table table-bordered table-hover"
            ),
            "data"
        );
        $vue->htmlVars[] = "data";

        break;
}

?>