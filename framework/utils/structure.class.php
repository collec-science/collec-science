<?php


/**
 * Classe utilitaire, permettant de recuperer la structure du 
 * schéma courant et de le transformer soit en en Latex,
 * soit en tableau html
 * @var mixed
 */
class Structure extends ObjetBDD
{

    private $_schema;

    private $_tables;

    private $_colonnes;

    public $tables;

    /**
     * __construct
     * Realise les interrogations pour extraire les infos de la base de données
     * 
     * @param PDO   $p_connection 
     * @param mixed $param 
     * 
     * @return void 
     */
    function __construct(\PDO $p_connection, array $param = array())
    {

        parent::__construct($p_connection, $param);
        $this->getSchema();
        $this->getTables();
        $this->getColumns();
        /*
         * Mise en forme du tableau utilisable
         */
        foreach ($this->_tables as $table) {
            /* 
             * Recherche des colonnes attachees
             */
            foreach ($this->_colonnes as $colonne) {
                if ($colonne["tablename"] == $table["tablename"]) {
                    $table["columns"][] = $colonne;
                }
            }
            $this->tables[] = $table;
        }
    }
    /**
     * Recupere le schema courant
     * 
     * @return void
     */
    function getSchema()
    {
        $sql = "select current_schema()";
        $res = $this->lireParam($sql);
        $this->_schema = $res["current_schema"];
    }

    /**
     * Recupere la liste des tables
     * 
     * @return void 
     */
    function getTables()
    {
        $sql = "select relname as tablename, description
        from pg_catalog.pg_statio_all_tables st
        join pg_catalog.pg_description on (relid = objoid and objsubid = 0)
        where schemaname = :schema
        order by relname"
        ;

        $this->_tables = $this->getListeParamAsPrepared(
            $sql,
            array("schema" => $this->_schema)
        );
    }

    /**
     * Recupere la liste des colonnes
     * 
     * @return void 
     */
    function getColumns()
    {
        $sql = 'with req as 
        (SELECT DISTINCT on (tablename, field) pg_tables.tablename, 
           attnum,  pg_attribute.attname AS field,
            format_type(pg_attribute.atttypid,NULL) AS "type",
         (SELECT col_description(pg_attribute.attrelid,pg_attribute.attnum)) AS COMMENT,
         CASE pg_attribute.attnotnull
            WHEN FALSE THEN 0
           ELSE 1
         END AS "notnull",
         pg_constraint.conname AS "key",
         pc2.conname AS ckey,
         (SELECT pg_attrdef.adsrc
          FROM pg_attrdef
          WHERE pg_attrdef.adrelid = pg_class.oid
          AND   pg_attrdef.adnum = pg_attribute.attnum) AS def
        FROM pg_tables,
       pg_class
       JOIN pg_attribute
       ON pg_class.oid = pg_attribute.attrelid
       AND pg_attribute.attnum > 0
       LEFT JOIN pg_constraint
           ON pg_constraint.contype = \'p\'::"char"
           AND pg_constraint.conrelid = pg_class.oid
           AND (pg_attribute.attnum = ANY (pg_constraint.conkey))
        LEFT JOIN pg_constraint AS pc2
           ON pc2.contype = \'f\'::"char"
           AND pc2.conrelid = pg_class.oid
           AND (pg_attribute.attnum = ANY (pc2.conkey))
        WHERE pg_class.relname = pg_tables.tablename
        AND   pg_attribute.atttypid <> 0::OID
        and schemaname = :schema
       ORDER BY tablename, field ASC)
        select * from req order by tablename, attnum;
       ';
        $this->_colonnes = $this->getListeParamAsPrepared(
            $sql,
            array("schema" => $this->_schema)
        );
    }
    /**
     * Met en forme les donnees sous forme de tableau
     * 
     * @param string $classTableName    : Nom de la classe correspondant 
     *                                  au nom de la table
     * @param string $classTableComment : Nom de la classe correspondant 
     *                                  à la description de la table
     * @param string $classTableColumns : nom de la classe utilisée pour
     *                                  mettre en forme le tableau
     * 
     * @return string
     */
    function generateHtml(
        $classTableName = "tablename",
        $classTableComment = "tablecomment",
        $classTableColumns = "datatable"
    ) {
        $val = "";
        foreach ($this->tables as $table) {
            $val .= '<div class="' . $classTableName . '">' . $table["tablename"] . "</div>"
                . '<br><div class="' . $classTableComment . '">'
                . $table["description"] . '</div>.<br>';
            $val .= '<table class="' . $classTableColumns . '">';
            $val .= '<thead><tr><th>Column name</th>
            <th>Type</th><th>Not null</th>
            <th>key</th><th>Foreign key</th><th>Comment</th></tr></thead>';
            $val .= '<tbody>';
            foreach ($table["columns"] as $column) {
                $val .= '<tr>
                <td>' . $column["field"] . '</td>
                <td>' . $column["type"] . '</td>
                <td>' . $column["notnull"] . '</td>
                <td>' . $column["key"] . '</td>
                <td>' . $column["ckey"] . '</td>
                <td>' . $column["comment"] . '</td>
                </tr>';
            }
            $val .= '</tbody></table>';
        }

        return $val;
    }

    function generateLatex(
        $structureLevel = "subsection",
        $headerTable = "\\begin{tabular}{|l|l|c|l|l|l|}",
        $closeTable = "\\end{tabular}"
    ) {
        $val = "";
        foreach ($this->tables as $table) {
            $val .= "\\" . $structureLevel . "{"
                . $this->el($table["tablename"]) . "}"
                . "<br>";
            $val .= $this->el($table["description"]) . "<br><br>";
            $val .= $headerTable . "<br>";
            $val .= "\\hline" . "<br>";
            $val .= "Column name & Type & Not null & Key & Foreign key 
            & Comment \\\\" . "<br>"
                . "\\hline" . "<br>";
            foreach ($table["columns"] as $column) {
                $val .= $this->el($column["field"]) . " & "
                    . $this->el($column["type"]) . " & ";
                ($column["notnull"] == 1) ? $val .= "X & " : $val .= " & ";
                strlen($column["key"]) > 0 ? $val .= "X & " : $val .= " & ";
                strlen($column["ckey"]) > 0 ? $val .= "X & " : $val .= " & ";
                $val .= $this->el($column["comment"])
                    . "\\\\" . "<br>"
                    . "\\hline" . "<br>";
            }
            $val .= $closeTable . "<br>";
        }
        return $val;
    }

    /**
     * Echappe les _ par \_ pour l'encodage Latex
     * @param string $chaine
     *  
     * @return string 
     */
    function el($chaine)
    {
        return str_replace("_", "\\_", $chaine);
    }
}


?>