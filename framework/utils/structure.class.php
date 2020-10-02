<?php


/**
 * Class for extract structure of a Postgresql database
 */
class Structure extends ObjetBDD
{

  private $_schema = "public";
  private $_tables, $_colonnes, $_views, $_viewsCols;
  public $tables, $views, $schemas;

  /**
   * __construct
   *
   * @param PDO   $p_connection
   * @param mixed $param
   *
   * @return void
   */
  function __construct(\PDO $p_connection, array $param = array())
  {
    parent::__construct($p_connection, $param);
  }

  function extractData($schema = "public")
  {
    $schemas = explode(",", $schema);
    $comma = "";
    $this->_schema = "";
    foreach ($schemas as $sc) {
      $this->_schema .= $comma . "'" . $sc . "'";
      $comma = ",";
    }

    /** Extract table structure from database */
    $this->getTables();
    $this->getColumns();
    $this->getViews();
    $this->getViewsCols();

    foreach ($this->_tables as $table) {
      $this->schemas[$table["schemaname"]]["tables"][$table["tablename"]] = $table;
    }
    foreach ($this->_colonnes as $colonne) {
      $this->schemas[$colonne["schemaname"]]["tables"][$colonne["tablename"]]["columns"][] = $colonne;
    }
    foreach ($this->_views as $view) {
      $this->schemas[$view["schemaname"]]["views"][$view["viewname"]] = $view;
    }
    foreach ($this->_viewsCols as $colonne) {
      $this->schemas[$colonne["schemaname"]]["views"][$colonne["viewname"]]["columns"][] = $colonne;
    }
    /**
     * Creation of useful arrays
     */
    foreach ($this->_tables as $table) {
      /**
       * Search attached columns
       */
      foreach ($this->_colonnes as $colonne) {
        if ($colonne["tablename"] == $table["tablename"] && $colonne["schemaname"] == $table["schemaname"]) {
          $table["columns"][] = $colonne;
        }
      }
      $this->tables[] = $table;
    }
    foreach ($this->_views as $view) {
      foreach ($this->_viewsCols as $colonne) {
        if ($colonne["viewname"] == $table["viewname"] && $colonne["schemaname"] == $view["schemaname"]) {
          $view["columns"][] = $colonne;
        }
      }
      $this->views[] = $view;
    }
  }

  /**
   * Get tables list
   *
   * @return void
   */
  function getTables()
  {
    $sql = "select schemaname, relname as tablename, description
        from pg_catalog.pg_statio_all_tables st
        left outer join pg_catalog.pg_description on (relid = objoid and objsubid = 0)
        where schemaname in (" . $this->_schema . ")
        order by schemaname, relname";
    $this->_tables = $this->getListeParam($sql);
  }

  function getViews()
  {
    $sql = "select schemaname, viewname, definition
        from pg_catalog.pg_views
        where schemaname in (" . $this->_schema . ")
        order by schemaname, viewname";
    $this->_views = $this->getListeParam($sql);
  }

  /**
   * Get columns list
   *
   * @return void
   */
  function getColumns()
  {
    $sql = 'SELECT DISTINCT on (schemaname, tablename, attnum) schemaname, pg_tables.tablename,
           attnum,  pg_attribute.attname AS field,
           pg_catalog.format_type(pg_attribute.atttypid,pg_attribute.atttypmod) AS "type",
         (SELECT col_description(pg_attribute.attrelid,pg_attribute.attnum)) AS comment,
         CASE pg_attribute.attnotnull
            WHEN FALSE THEN 0
           ELSE 1
         END AS "notnull",
         pg_constraint.conname AS "key",
         pc2.conname AS ckey
        FROM pg_tables
        JOIN pg_namespace ON (pg_namespace.nspname = pg_tables.schemaname)
        JOIN pg_class
         ON (pg_class.relname = pg_tables.tablename
         AND pg_class.relnamespace = pg_namespace.oid)
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
        WHERE pg_attribute.atttypid <> 0::OID
        and schemaname in ( ' . $this->_schema . ')
       ORDER BY schemaname, tablename, attnum ASC';
    $this->_colonnes = $this->getListeParam($sql);
  }

  function getViewsCols()
  {
    $sql = 'select schemaname, viewname, definition
        ,attnum,  pg_attribute.attname AS field,
                   pg_catalog.format_type(pg_attribute.atttypid,pg_attribute.atttypmod) AS "type"
        FROM pg_views
                JOIN pg_namespace ON (pg_namespace.nspname = pg_views.schemaname)
                JOIN pg_class
                 ON (pg_class.relname = pg_views.viewname
                 AND pg_class.relnamespace = pg_namespace.oid)
         JOIN pg_attribute
               ON pg_class.oid = pg_attribute.attrelid
               AND pg_attribute.attnum > 0
        WHERE schemaname in (' . $this->_schema . ')
        ORDER BY schemaname, viewname, attnum ASC';
    $this->_viewsCols = $this->getListeParam($sql);
  }
  /**
   * Format structure in html
   *
   * @param string $classTableName: css class for table name
   * @param string $classTableComment: css class for the comment of the table
   * @param string $classTableColumns: css class for the table of columns
   * @return string
   */
  function generateHtml(
    $classTableName = "tablename",
    $classTableComment = "tablecomment",
    $classTableColumns = "datatable"
  ) {
    $val = "";
    foreach ($this->schemas as $schemaname => $schema) {
      $val .= '<h2><div id="' . $schemaname . '">Schema ' . $schemaname . '</div></h2>';
      foreach ($schema["tables"] as $table) {
        $val .= '<div id="' . $table["schemaname"] . $table["tablename"] . '" class="' . $classTableName . '">' . $table["schemaname"] . "." . $table["tablename"] . " (<i>table</i>)</div>"
          . '<br><div class="' . $classTableComment . '">'
          . $table["description"] . '</div>.<br>';
        $val .= '<table class="' . $classTableColumns . '">';
        $val .= '<thead><tr>
                    <th>Column name</th>
                    <th>Type</th>
                    <th>Not null</th>
                    <th>key</th>
                    <th>Comment</th>
                    </tr></thead>';
        $val .= '<tbody>';
        foreach ($table["columns"] as $column) {
          $val .= '<tr>
                <td>' . $column["field"] . '</td>
                <td>' . $column["type"] . '</td>
                <td class="center">';
          if ($column["notnull"] == 1) {
            $val .= "X";
          }
          $val .= '</td>
                <td class="center">';
          if (strlen($column["key"]) > 0) {
            $val .= "X";
          }
          $val .= '</td>
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
      foreach ($schema["views"] as $view) {
        $val .= '<div id="' . $view["schemaname"] . $view["viewname"] . '" class="' . $classTableName . '">' . $view["schemaname"] . "." . $view["viewname"] . " (<i>view</i>)</div>"
          . '<br><div class="' . $classTableComment . '">'
          . $view["definition"] . '</div>.<br>';
        $val .= '<table class="' . $classTableColumns . '">';
        $val .= '<thead><tr>
                  <th>Column name</th>
                  <th>Type</th>
                  </tr></thead>';
        $val .= '<tbody>';
        foreach ($view["columns"] as $column) {
          $val .= '<tr>
              <td>' . $column["field"] . '</td>
              <td>' . $column["type"] . '</td>';
        }
        $val .= '</tbody></table>';
      }
    }
    return $val;
  }

  /**
   * format structure in latex
   *
   * @param string $structureLevel: first level of the structure in the latex document
   * @param string $headerTable: definition of the table
   * @param string $closeTable: end tag for table
   * @param boolean $hline: add a hline between each column
   * @return string
   */
  function generateLatex(
    $structureLevel = "subsection",
    $headerTable = "\\begin{tabular}{|l|l|c|l|l|}",
    $closeTable = "\\end{tabular}",
    $hline = false
  ) {
    $val = "";
    switch ($structureLevel) {
      case "section":
        $level = array("schema" => "section", "type" => "subsection", "object" => "subsubsection");
        break;
      case "subsection":
        $level = array("schema" => "subsection", "type" => "subsubsection", "object" => "paragraph");
        break;
      default:
        $level = array("schema" => "subsection", "type" => "subsubsection", "object" => "paragraph");
    }
    foreach ($this->schemas as $schemaname => $schema) {
      $val .= "\\" . $level["schema"] . "{Schema " . $schemaname . '}' . PHP_EOL;
      $val .= "\\" . $level["type"] . "{Tables}" . PHP_EOL;
      foreach ($schema["tables"] as $table) {
        $val .= "\\" . $level["object"] . "{"
          . $this->el($table["tablename"]) . "}"
          . PHP_EOL;
        $val .= $this->el($table["description"]) . PHP_EOL . PHP_EOL;
        $val .= $headerTable . PHP_EOL;
        $val .= "\\hline" . PHP_EOL;
        $val .= "Column name & Type & Not null & Key & Comment \\\\" . PHP_EOL
          . "\\hline" . PHP_EOL;
        foreach ($table["columns"] as $column) {
          $val .= $this->el($column["field"]) . " & "
            . $this->el($column["type"]) . " & ";
          ($column["notnull"] == 1) ? $val .= "X & " : $val .= " & ";
          strlen($column["key"]) > 0 ? $val .= "X & " : $val .= " & ";
          $val .= $this->el($column["comment"])
            . "\\\\" . PHP_EOL;
          if ($hline) {
            $val .= "\\hline" . PHP_EOL;
          }
        }
        if (!$hline) {
          $val .= "\\hline" . PHP_EOL;
        }
        $val .= $closeTable . PHP_EOL;

        /**
         * Add references
         */
        $refs = $this->getReferences($table["schemaname"], $table["tablename"]);
        if (count($refs) > 0) {
          $val .= "\\paragraph{References}" . PHP_EOL;
          foreach ($refs as $ref) {
            $val .= $this->el($ref["column_name"]) . ": " . $this->el($ref["foreign_schema_name"]) . "."
              . $this->el($ref["foreign_table_name"])
              . " (" . $this->el($ref["foreign_column_name"]) . ")" . PHP_EOL . PHP_EOL;
          }
        }
        $refs = $this->getReferencedBy($table["schemaname"], $table["tablename"]);
        if (count($refs) > 0) {
          $val .= "\\paragraph{Referenced by}" . PHP_EOL;
          foreach ($refs as $ref) {
            $val .= $this->el($ref["foreign_column_name"]) . ": " . $this->el($ref["schema_name"]) . "."
              . $this->el($ref["table_name"])
              . " (" . $this->el($ref["column_name"]) . ")" . PHP_EOL . PHP_EOL;
          }
        }
      }
      if (!empty($schema["views"])) {
        $val .= "\\" . $level["type"] . "{Views}" . PHP_EOL;
        foreach ($schema["views"] as $view) {
          $val .= "\\" . $level["object"] . "{"
            . $this->el($view["viewname"]) . "}"
            . PHP_EOL;
          $val .= $this->el($view["definition"]) . PHP_EOL . PHP_EOL;
          $val .= $headerTable . PHP_EOL;
          $val .= "\\hline" . PHP_EOL;
          $val .= "Column name & Type \\\\" . PHP_EOL
            . "\\hline" . PHP_EOL;
          foreach ($view["columns"] as $column) {
            $val .= $this->el($column["field"]) . " & "
              . $this->el($column["type"]) . "\\\\" . PHP_EOL;
            if ($hline) {
              $val .= "\\hline" . PHP_EOL;
            }
          }
          if (!$hline) {
            $val .= "\\hline" . PHP_EOL;
          }
          $val .= $closeTable . PHP_EOL;
        }
      }
    }
    return $val;
  }

  /**
   * escape  _ by \_ for latex
   * @param string $chaine
   *
   * @return string
   */
  function el($chaine)
  {
    return str_replace("_", "\\_", $chaine);
  }

  /**
   * Get the name of the database
   *
   * @return string
   */
  function getDatabaseName()
  {
    $sql = "select current_database()";
    $data = $this->lireParam($sql);
    return ($data["current_database"]);
  }

  /**
   * Get the description of the database
   *
   * @return string
   */
  function getDatabaseComment()
  {
    $sql = "select shobj_description((select oid from pg_catalog.pg_database where datname = current_database()), 'pg_database') as comment";
    $data = $this->lireParam($sql);
    return ($data["comment"]);
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
      $schemaType = 'x';
    } else {
      $type = 'x';
      $schemaType = 'y';
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
    return ($this->getListeParamAsPrepared($sql, array("schema" => $schema, "table" => $table)));
  }
  /**
   * Generate the list of tables for html summary
   *
   * @return string
   */
  function generateSummaryHtml()
  {
    $summary = "<ul>";
    foreach ($this->schemas as $schemaname => $schema) {
      $summary .= '<li><a href="#'
        . $schemaname
        . '">' . $schemaname . "</a><ul><li>Tables<ul>";
      foreach ($schema["tables"] as $table) {
        $summary .= '<li><a href="#'
          . $table["schemaname"] . $table["tablename"]
          . '">' . $table["tablename"] . "</a></li>";
      }
      $summary .= "</ul></li>";
      if (!empty($schema["views"])) {
        $summary .= "<li>Views<ul>";
        foreach ($schema["views"] as $view) {
          $summary .= '<li><a href="#'
            . $view["schemaname"] . $view["viewname"]
            . '">' . $view["viewname"] . "</a></li>";
        }
        $summary .= "</ul></li></ul>";
      }
      $summary .= "</li>";
    }
    $summary .= "</ul>";
    return ($summary);
  }
  /**
   * Get the list of all columns
   *
   * @return array
   */
  function getAllColumns()
  {
    return $this->_colonnes;
  }

  /**
   * Get the list of all tables
   *
   * @return array
   */
  function getAllTables()
  {
    return $this->_tables;
  }
}
