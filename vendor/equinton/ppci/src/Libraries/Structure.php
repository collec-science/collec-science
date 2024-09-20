<?php
namespace Ppci\Libraries;

class Structure extends PpciLibrary
{
    /**
     * Generate the description of the database in html format
     *
     * @param [type] $schemas
     */
    function html($schemas = "")
    {
        if (empty ($schemas)) {
            $dbconf = config("Database");
            $schemas = $dbconf->default["searchpath"];
        }
        $dataclass = new \Ppci\Models\Structure();
        $dataclass->extractData($schemas);
        $data = $dataclass->generateSummaryHtml();
        $data .= $dataclass->generateHtml(
            "tablename",
            "tablecomment",
            "table table-bordered table-hover"
        );
        $vue = service ("Smarty");
        $vue->set($data, "data");
        $vue->htmlVars[] = "data";
        $vue->set("ppci/dbstructure.tpl", "corps");
        return $vue->send();
    }
    /**
     * Generate the description of the database in latex format
     *
     * @param [type] $schemas
     */
    function latex($schemas = "")
    {
        if (empty ($schemas)) {
            $dbconf = config("Database");
            $schemas = $dbconf->default["searchpath"];
        }
        $dataclass = new \Ppci\Models\Structure();
        $dataclass->extractData($schemas);
        $vue = service ("FileView");
        $vue->set(
            $dataclass->generateLatex(
                "subsection",
                "\\begin{tabular}{|l| p{2cm}|c|c|c| p{3cm}|}",
                "\\end{tabular}"
            )
        );
        $vue->setParam(array("filename" => $_SESSION["dbparams"]["APPLI_code"]."-dbstructure.tex"));
        return $vue->send();
    }
    /**
     * Display the graphic schema of the database
     *
     * @return 
     */
    function schema()
    {
        $realfilename = $this->appConfig->databaseSchemaFile;
        if (file_exists($realfilename)) {
            $generatedfilename = $_SESSION["dbparams"]["APPLI_code"]."-database-schema.png";
            $vue = service("BinaryView");
            $vue->setParam(
                array(
                    "tmp_name" => $realfilename,
                    "filename" => $generatedfilename,
                    "disposition" => "inline"
                )
            );
            return $vue->send();
        } else {
            $this->message->set(_("Le fichier contenant le schéma de la base de données n'a pas été trouvé"), true);
            return defaultPage();
        }
    }
}
