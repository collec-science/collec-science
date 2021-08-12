<?php
/*
 * Recuperation de la structure de la base de donnees
 */
require_once 'framework/utils/structure.class.php';
$vue->set("framework/dbstructure.tpl", "corps");

switch ($t_module["param"]) {
    case "html":
        $dataclass = new Structure($bdd, array());
        $dataclass->extractData($t_module["schemas"]);
        $data = $dataclass->generateSummaryHtml();
        $data .= $dataclass->generateHtml(
            "tablename",
            "tablecomment",
            "table table-bordered table-hover"
        );
        $vue->set($data, "data");
        $vue->htmlVars[] = "data";
        break;
    case "latex":
        $dataclass = new Structure($bdd, array());
        $dataclass->extractData($t_module["schemas"]);
        $vue->set(
            $dataclass->generateLatex(
                "subsection",
                "\\begin{tabular}{|l| p{2cm}|c|c|c| p{3cm}|}",
                "\\end{tabular}"
            )
        );
        $vue->setParam(array("filename"=>"collec-dbstructure.tex"));
        break;
    case "gacl":
        $dataclass = new Structure($bdd_gacl, array(), $t_module["schemas"]);
        $dataclass->extractData($t_module["schemas"]);
        $data = $dataclass->generateSummaryHtml();
        $data .= $dataclass->generateHtml(
            "tablename",
            "tablecomment",
            "table table-bordered table-hover"
        );
        $vue->set($data, "data");
        $vue->htmlVars[] = "data";
        break;
    case "schema":
        $vue->setParam(
            array(
                "tmp_name" => $t_module["realfilename"],
                "filename" => $t_module["generatedfilename"],
                "disposition" => "inline"
            )
        );
        break;
}
