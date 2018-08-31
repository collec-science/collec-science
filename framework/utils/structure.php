<?php
/* 
 * Recuperation de la structure de la base de donnees
 */
require_once 'framework/utils/structure.class.php';
$dataclass = new Structure($bdd);
switch ($t_module["param"]) {
    case "html":
        $vue->set(
            $dataclass->generateHtml(
                "tablename",
                "tablecomment",
                "table table-bordered table-hover"
            ),
            "data"
        );
        $vue->htmlVars[] = "data";
        $vue->set("dbstructure.tpl", "corps");
        break;
    case "latex":
        $vue->set(
            $dataclass->generateLatex(
                "subsection",
                "\\begin{tabular}{|l| p{2cm}|c|c|c| p{3cm}|}",
                "\\end{tabular}"
            ),
            "data"
        );
        $vue->htmlVars[] = "data";
        $vue->set("dbstructure.tpl", "corps");
        break;
}

?>