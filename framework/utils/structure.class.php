<?php


/**
 * Classe utilitaire, permettant de recuperer la structure du
 * schéma courant et de le transformer soit en en Latex,
 * soit en tableau html
 * @var mixed
 */
class Structure extends ObjetBDD
{

    private $_schemas = array();
    private $whereSchema;
    private $schemaParam = array();
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
    function __construct(\PDO $p_connection, array $param = array(), $schemas = "")
    {

        parent::__construct($p_connection, $param);
        $this->getSchema($schemas);
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
    function getSchema($schemas)
    {
        if (strlen($schemas) > 0) {
            $this->_schemas = explode(",", $schemas);
        } else {
            $sql = "select current_schema()";
            $res = $this->lireParam($sql);
            $this->_schemas[] = $res["current_schema"];
        }
        $this->whereSchema = "";
        $comma = "";
        $i = 0;
        foreach ($this->_schemas as $schema) {
            $this->whereSchema .= $comma . ":sc$i";
            $comma = ",";
            $this->schemaParam["sc$i"] = $schema;
            $i++;
        }
    }

    /**
     * Recupere la liste des tables
     *
     * @return void
     */
    function getTables()
    {
        $sql = "select schemaname, relname as tablename, description
        from pg_catalog.pg_statio_all_tables st
        left outer join pg_catalog.pg_description on (relid = objoid and objsubid = 0)";
        $order = " order by schemaname, relname";
        $this->_tables = $this->getListeParamAsPrepared(
            $sql . " where  schemaname in (" . $this->whereSchema . ")" . $order,
            $this->schemaParam
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
        (SELECT DISTINCT on (schemaname, tablename, field) schemaname, pg_tables.tablename,
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
           AND (pg_attribute.attnum = ANY (pc2.conkey))';
        $where = " WHERE pg_class.relname = pg_tables.tablename
        AND   pg_attribute.atttypid <> 0::OID
        and  schemaname in (" . $this->whereSchema . ")";
        $order = 'ORDER BY schemaname, tablename, field ASC)
        select * from req order by tablename, attnum;
       ';
        $this->_colonnes = $this->getListeParamAsPrepared(
            $sql . $where . $order,
            $this->schemaParam
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
            $val .= '<div id="' . $table["schemaname"] . $table["tablename"] . '" class="' . $classTableName . '">' . $table["schemaname"] . "." . $table["tablename"] . "</div>"
                . '<br><div class="' . $classTableComment . '">'
                . $table["description"] . '</div>.<br>';
            $val .= '<table class="' . $classTableColumns . '">';
            $val .= '<thead><tr><th>Column name</th>
            <th>Type</th><th class="center">Not null</th>
            <th>key</th><th>Foreign key</th><th>Comment</th></tr></thead>';
            $val .= '<tbody>';
            foreach ($table["columns"] as $column) {
                $val .= '<tr>
                <td>' . $column["field"] . '</td>
                <td>' . $column["type"] . '</td>
                <td class="center">' . $column["notnull"] . '</td>
                <td>' . $column["key"] . '</td>
                <td>' . $column["ckey"] . '</td>
                <td>' . $column["comment"] . '</td>
                </tr>';
            }
            $val .= '</tbody></table>';
            /**
             * Add references
             */
            $refs = $this->getReferences($table["schemaname"], $table["tablename"]);
            if (count($refs) > 0) {
                $val .= "<h3>References</h3>";
                foreach ($refs as $ref) {
                    $val .= $ref["column_name"] . ": " . $ref["foreign_schema_name"]
                        . '.<a href="#' . $ref["foreign_schema_name"] . $ref["foreign_table_name"] . '">'
                        . $ref["foreign_table_name"]
                        . "</a>"
                        . " (" . $ref["foreign_column_name"] . ")<br>";
                }
            }
            $refs = $this->getReferencedBy($table["schemaname"], $table["tablename"]);
            if (count($refs) > 0) {
                $val .= "<h3>Referenced by</h3>";
                foreach ($refs as $ref) {
                    $val .= $ref["foreign_column_name"] . ": " . $ref["schema_name"]
                        . '.<a href="#' . $ref["schema_name"] . $ref["table_name"] . '">'
                        . $ref["table_name"]
                        . "</a>"
                        . " (" . $ref["column_name"] . ")<br>";
                }
            }
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
                . $this->el($table["schemaname"] . "." . $table["tablename"]) . "}"
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

    /**
     * Get references for a table
     *
     * @param string $schema
     * @param string $table
     * @return array
     */
    function getReferences($schema, $table)
    {
        return $this->_getReference($schema, $table, false);
    }

    /**
     * Return the tables referenced by the table
     *
     * @param string $schema
     * @param string $table
     * @return array
     */
    function getReferencedBy($schema, $table)
    {
        return $this->_getReference($schema, $table, true);
    }
    /**
     * Execute the request to get references from a table,
     * or tables referenced by
     *
     * @param [type] $schema
     * @param [type] $table
     * @param boolean $referencedBy
     * @return array
     */
    private function _getReference($schema, $table, $referencedBy = false)
    {
        if ($referencedBy) {
            $type = 'y';
        } else {
            $type = 'x';
        }
        $sql = "
        select distinct c.constraint_name
          , x.table_schema as schema_name
           , x.table_name
            , x.column_name
           , y.table_schema as foreign_schema_name
            , y.table_name as foreign_table_name
            , y.column_name as foreign_column_name
        from information_schema.referential_constraints c
        join information_schema.key_column_usage x
            on x.constraint_name = c.constraint_name
        join information_schema.key_column_usage y
           on y.ordinal_position = x.position_in_unique_constraint
            and y.constraint_name = c.unique_constraint_name
        where " . $type . ".table_schema = :schema and " . $type . ".table_name = :table
        order by y.table_schema, y.table_name
        ";
        return ($this->getListeParamAsPrepared($sql, array("table" => $table, "schema" => $schema)));
    }
}
