<?php
namespace App\Models;

use Ppci\Libraries\PpciException;
use Ppci\Models\PpciModel;

class ExportModelProcessing
{
  private $model = array();
  private $db;
  private $lastResultExec;
  public $modeDebug = false;
  private $lastSql = "";
  private $stmt;
  public $structure = array();
  public $quote = '"';
  public $binaryFolder = "binary";
  private PpciModel $datatable;

  function __construct()
  {
    $this->datatable = new PpciModel;
    $this->db = $this->datatable->db;
    $this->datatable->table("unknown");
  }
  /**
   * Set the used model
   *
   * @param array $model: JSON field contents the description of the tables
   * @return void
   */
  function initModel(array $model)
  {
    /**
     * Generate the model with tableName as identifier
     */
    foreach ($model as $m) {
      /**
       * Set the tableAlias if not defined
       */
      if (empty($m["tableAlias"])) {
        $m["tableAlias"] = $m["tableName"];
      }
      $this->model[$m["tableAlias"]] = $m;
    }
  }

  /**
   * Load the structure of the database
   *
   * @param array $structure
   * @return void
   */
  function initStructure(array $structure = array())
  {
    if (count($structure) == 0) {
      throw new PpciException("The structure of the export in empty");
    }
    $this->structure = $structure;
  }

  /**
   * Generate the structure of database for all tables in the model
   *
   * @param array $model
   * @return array
   */
  function generateStructure(array $model = array()): array
  {
    if (count($model) == 0) {
      $model = $this->model;
    }
    $this->structure = array();
    foreach ($model as $table) {
      $tablename = $table["tableName"];
      $schematable = explode(".", $tablename);
      $schemaname = "";
      if (count($schematable) == 2) {
        $schemaname = $schematable[0];
        $tablename = $schematable[1];
      }
      $attributes = $this->getFieldsFromTable($tablename, $schemaname);
      $this->structure[$table["tableName"]]["attributes"] = $attributes;
      $this->structure[$table["tableName"]]["description"] = $this->getDescriptionFromTable($tablename, $schemaname);
      /**
       * Get specific fields
       */
      $this->structure[$table["tableName"]]["booleanFields"] = $this->getSpecificFields($attributes, "boolean");
      $this->structure[$table["tableName"]]["binaryFields"] = $this->getSpecificFields($attributes, "bytea");
      /**
       * Add the children
       */
      foreach ($table["children"] as $child) {
        $alias = $child["aliasName"];
        $a_alias = array(
          "tableName" => $model[$alias]["tableName"],
          "childKey" => $model[$alias]["parentKey"]
        );
        $this->structure[$table["tableName"]]["children"][] = $a_alias;
      }
      /**
       * Add the parents (parents tables, table nn)
       */
      foreach ($table["parents"] as $parentA) {
        $alias = $parentA["aliasName"];
        $a_alias = array(
          "tableName" => $model[$alias]["tableName"],
          "parentKey" => $model[$alias]["technicalKey"],
          "fieldName" => $parentA["fieldName"]
        );
        $this->structure[$table["tableName"]]["parents"][] = $a_alias;
      }
      /**
       * Add the second n-n part
       */
      /*if ($table["istablenn"]) {
        $alias = $table["tablenn"]["tableAlias"];
        $a_alias = array(
          "tableName" => $model[$alias]["tableName"],
          "parentKey" => $model[$alias]["technicalKey"],
          "fieldName" => $table["tablenn"]["secondaryParentKey"]
        );
      }*/
    }
    return ($this->structure);
  }

  /**
   * Get the comment associated to a table
   *
   * @param string $tablename
   * @param string $schemaname
   * @return string
   */
  function getDescriptionFromTable(string $tablename, string $schemaname = ""): string
  {
    !empty($schemaname) ? $hasSchema = true : $hasSchema = false;
    $data["tablename"] = $tablename;
    $sql = "select  description
        from pg_catalog.pg_statio_all_tables st
        left outer join pg_catalog.pg_description on (relid = objoid and objsubid = 0)
        where relname = :tablename:";
    if ($hasSchema) {
      $sql .= " and schemaname = :schema:";
      $data["schema"] = $schemaname;
    }
    $res = $this->datatable->getli($sql, $data);
    $description = $res[0]["description"];
    if ($description) {
      return $description;
    } else {
      return "";
    }
  }
  /**
   * Get the list of columns of the table
   *
   * @param string $tablename
   * @return array|null
   */
  function getFieldsFromTable(string $tablename, string $schemaname = ""): ?array
  {
    !empty($schemaname) ? $hasSchema = true : $hasSchema = false;
    $data = array("tablename" => $tablename);
    $select = "SELECT attnum,  pg_attribute.attname AS field,
                pg_catalog.format_type(pg_attribute.atttypid,pg_attribute.atttypmod) AS type,
                (SELECT col_description(pg_attribute.attrelid,pg_attribute.attnum)) AS COMMENT,
                CASE pg_attribute.attnotnull WHEN FALSE THEN 0 ELSE 1 END AS notnull,
                pg_constraint.conname AS key
                FROM pg_tables
                JOIN pg_namespace ON (pg_namespace.nspname = pg_tables.schemaname)
                JOIN pg_class
                  ON (pg_class.relname = pg_tables.tablename
                AND pg_class.relnamespace = pg_namespace.oid)
                JOIN pg_attribute ON (pg_class.oid = pg_attribute.attrelid AND pg_attribute.atttypid <> 0::OID AND pg_attribute.attnum > 0)
                LEFT JOIN pg_constraint
                ON pg_constraint.contype = 'p'::char
                AND pg_constraint.conrelid = pg_class.oid
                AND (pg_attribute.attnum = ANY (pg_constraint.conkey))
                ";
    $where = ' WHERE tablename = :tablename:';
    if ($hasSchema) {
      $where .= ' AND schemaname = :schemaname:';
      $data["schemaname"] = $schemaname;
    }
    $order = ' ORDER BY attnum ASC';
    $result = $this->execute($select . $where . $order, $data);
    if (count($result) == 0) {
      throw new PpciException("The table $tablename is unknown or has no attributes");
    }
    /**
     * translate sequence field to serial
     */
    foreach ($result as $key => $field) {
      if ($field["type"] == 'integer' && substr($field["def"], 0, 7) == "nextval") {
        $result[$key]["type"] = "serial";
      }
      unset($result[$key]["def"]);
    }
    return ($result);
  }
  /**
   * Generate the sql script to create the tables in the database
   *
   * @param array $structure
   * @return string
   */
  function generateCreateSql(array $structure = array()): string
  {
    $sql = "";
    if (count($structure) == 0) {
      $structure = $this->structure;
    }
    $tables = array();
    /**
     * Creation of tables
     */
    foreach ($structure as $tableName => $table) {
      if (!in_array($tableName, $tables)) {
        $sql .= $this->generateSqlForTable($tableName, $table);
        $tables[] = $tableName;
      }
    }
    /**
     * Creation of relations
     */
    foreach ($structure as $tableName => $table) {
      $key = $this->getPrimaryKey($table);
      if (is_array($table["children"])) {
        foreach ($table["children"] as $child) {
          $sql .= $this->generateSqlRelation($tableName, $key, $child["tableName"], $child["childKey"]);
        }
      }
      if (is_array($table["parents"])) {
        foreach ($table["parents"] as $parent) {
          $sql .= $this->generateSqlRelation($parent["tableName"], $parent["parentKey"], $tableName, $parent["fieldName"]);
        }
      }
    }
    return $sql;
  }
  /**
   * Get the primary key of a table from structure
   *
   * @param array $table
   * @return string
   */
  function getPrimaryKey(array $table): string
  {
    $key = "";
    foreach ($table["attributes"] as $att) {
      if ($att["key"]) {
        $key = $att["field"];
        break;
      }
    }
    return $key;
  }
  /**
   * Generate the sql script for create a relationship between 2 tables
   *
   * @param string $parentTable
   * @param string $parentKey
   * @param string $childTable
   * @param string $childForeignKey
   * @return string
   */
  function generateSqlRelation(string $parentTable, string $parentKey, string $childTable, string $childForeignKey): string
  {
    $sql = "";
    if (empty($parentTable) == 0 || empty($parentKey)  || empty($childTable) || empty($childForeignKey) ) {
      throw new PpciException("An error occurred during the creation of relation between $parentTable and $childTable");
    }
    $sql = "ALTER TABLE " . $this->quote . $childTable . $this->quote;
    $sql .= " ADD CONSTRAINT " . $childTable . "_has_parent_$parentTable" . PHP_EOL;
    $sql .= "FOREIGN KEY (" . $this->quote . $childForeignKey . $this->quote . ")";
    $sql .= " REFERENCES " . $this->quote . $parentTable . $this->quote . "(" .
      $this->quote . $parentKey . $this->quote . ");" . PHP_EOL;
    return $sql;
  }
  /**
   * Generate the sql code for create a table in the database
   *
   * @param string $tableName
   * @param array $table
   * @return string
   */
  function generateSqlForTable(string $tableName, array $table): string
  {
    $pkey = "";
    $comment = "";
    /**
     * Add the comment of the table
     */
    if (!empty($table["description"])) {
      $comment = "comment on table " . $this->quote . $tableName . $this->quote . " is " . $this->db->quote($table["description"]) . ";" . PHP_EOL;
    }
    $script = "create table " . $this->quote . $tableName . $this->quote . " (" . PHP_EOL;
    $nbAtt = count($table["attributes"]) - 1;
    for ($x = 0; $x <= $nbAtt; $x++) {
      if ($x > 0) {
        $script .= ",";
      }
      $attr = $table["attributes"][$x];
      $script .= $this->quote . $attr["field"] . $this->quote;
      $script .= " " . $attr["type"];
      if ($attr["notnull"] == 1) {
        $script .= " not null";
      }
      if (!empty($attr["key"]) ) {
        if (!empty($pkey) > 0) {
          $pkey .= ",";
        }
        $pkey .= $this->quote . $attr["field"] . $this->quote;
      }
      /**
       * Add the comment on the column
       */
      if (!empty($attr["comment"]) ) {
        $comment .= "comment on column " . $this->quote . $tableName . $this->quote . "." . $this->quote . $attr["field"] . $this->quote . " is " . $this->db->quote($attr["comment"]) . ";" . PHP_EOL;
      }
      $script .= PHP_EOL;
    }
    /**
     * Add the primary key
     */
    if (!empty($pkey) ) {
      $script .= ",primary key (" . $pkey . ")" . PHP_EOL;
    }
    $script .= ");" . PHP_EOL;
    $script .= $comment . PHP_EOL;
    return $script;
  }

  /**
   * Get the list of the tables which are not children
   *
   * @return array
   */
  function getListPrimaryTables(): array
  {
    $list = array();
    foreach ($this->model as $table) {
      if (empty($table["parentKey"]) && !$table["isEmpty"]) {
        $list[] = $table["tableAlias"];
      }
    }
    return $list;
  }
  /**
   * Prepare the list of columns for sql clause
   *
   * @param string $tableName
   * @return string
   */
  function generateListColumns(string $tableName): string
  {
    $cols = "";
    $comma = "";
    foreach ($this->structure[$tableName]["attributes"] as $col) {
      if (!in_array($col["field"], $this->structure[$tableName]["binaryFields"])) {
        $cols .= $comma . $this->quote . $col["field"] . $this->quote;
        $comma = ",";
      }
    }
    return $cols;
  }
  /**
   * Get the list of specific fields for a table
   *
   * @param array $tableName
   * @param string $fieldType
   * @return array
   */
  function getSpecificFields(array $attributes, string $fieldType): array
  {
    $fields = array();
    foreach ($attributes as $col) {
      if ($col["type"] == $fieldType) {
        $fields[] = $col["field"];
      }
    }
    return $fields;
  }
  /**
   * Get the content of a table
   *
   * @param string $tableName: alias of the table
   * @param array $keys: list of the keys to extract
   * @param integer $parentKey: value of the technicalKey of the parent (foreign key)
   * @return array
   */
  function getTableContent(string $tableAlias, array $keys = array(), $parentKey = 0): array
  {
    $model = $this->model[$tableAlias];
    if (count($model) == 0) {
      throw new PpciException("The alias $tableAlias was not described in the model");
    }
    $tableName = $model["tableName"];

    $content = array();
    $args = array();
    if (!$model["isEmpty"] || count($keys) > 0) {
      $cols = $this->generateListColumns($tableName);
      $sql = "select $cols from " . $this->quote . $tableName . $this->quote;
      if (count($keys) > 0) {
        $where = " where " . $this->quote . $model["technicalKey"] . $this->quote . " in (";
        $comma = "";
        foreach ($keys as $k) {
          if (is_numeric($k)) {
            $where .= $comma . $k;
            $comma = ",";
          }
        }
        $where .= ")";
      } else if (!empty($model["parentKey"]) && $parentKey > 0) {
        /**
         * Search by parent
         */
        $where = " where " . $this->quote . $model["parentKey"] . $this->quote . " = :parentKey:";
        $args["parentKey"] = $parentKey;
      } else {
        $where = "";
      }
      if (!empty($model["technicalKey"])) {
        $order = " order by " . $this->quote . $model["technicalKey"] . $this->quote;
      } else {
        $order = " order by 1";
      }
      $content = $this->execute($sql . $where . $order, $args);

      /**
       * export the binary data in files
       */
      $binaryFields = $this->structure[$tableName]["binaryFields"];
      if (count($binaryFields) > 0) {
        /**
         * Verifiy if a business key is defined
         */
        if (empty($model["businessKey"]) == 0) {
          throw new PpciException(
            "The businessKey is not defined for table $tableName, it's necessary to export the binary fields"
          );
        }
        /**
         * Verify if binary folder exists
         */
        if (!is_dir($this->binaryFolder)) {
          if (!mkdir($this->binaryFolder, 0700)) {
            throw new PpciException("The folder $this->binaryFolder can't be created");
          }
        }
        foreach ($binaryFields as $fieldName) {
          foreach ($content as $row) {
            if (!empty($row[$model["technicalKey"]])) {
              $ref = $this->getBlobReference($tableName, $model["technicalKey"], $row[$model["technicalKey"]], $fieldName);
              if ($ref) {
                $filename = $model["tableName"] . "-" . $fieldName . "-" . $row[$model["businessKey"]] . ".bin";
                $fb = fopen($this->binaryFolder . "/" . $filename, "wb");
                $dataContent = "";
                while (!feof($ref)) {
                  $dataContent .= fread($ref, 1024);
                }
                fwrite($fb, $dataContent);
                fclose($fb);
                fclose($ref);
              }
            }
          }
        }
      }


      if ($model["istablenn"] == 1) {
        /**
         * get the description of the secondary table
         */
        $model2 = $this->model[$model["tablenn"]["tableAlias"]];
      }
      /**
       * Search the data from the children
       */
      if (count($model["children"]) > 0) {
        foreach ($content as $k => $row) {
          foreach ($model["children"] as $child) {
            $content[$k]["children"][$child["aliasName"]] = $this->getTableContent(
              $child["aliasName"],
              array(),
              $row[$model["technicalKey"]]
            );
          }
        }
      }
      /**
       * Search the parents
       */
      if (count($model["parents"]) > 0) {
        foreach ($content as $k => $row) {
          foreach ($model["parents"] as $parent) {
            $id = $row[$parent["fieldName"]];
            if ($id > 0) {
              $content[$k]["parents"][$parent["aliasName"]] = $this->getTableContent($parent["aliasName"], array($id))[0];
            }
          }
        }
      }
      if ($model["istablenn"] == 1 && !isset($model["parents"][0])) {
        foreach ($content as $k => $row) {
          /**
           * Get the record associated with the current record
           */
          $sql = "select * from $this->quote" . $model2["tableName"] . "$this->quote where $this->quote" . $model["tablenn"]["secondaryParentKey"] . "$this->quote = :secKey";
          $data = $this->execute($sql, array("secKey" => $row[$model["tablenn"]["secondaryParentKey"]]));
          $content[$k][$model["tablenn"]["tableAlias"]] = $data[0];
        }
      }
    }
    return $content;
  }

  /**
   * Execute a SQL command
   *
   * @param string $sql: request to execute
   * @param array $data: data associated with the request
   * @return array|null
   */
  private function execute(string $sql, array $data = array()): ?array
  {
    if ($this->modeDebug) {
      printA($sql);
      printA($data);
    }
    return $this->datatable->executeQuery($sql,$data);
  }

  /**
   * Read a binary object in the database and returns the resource file
   *
   * @param string $tableName
   * @param string $keyName
   * @param integer $id
   * @param string $fieldName
   * @return resource|null
   */
  function getBlobReference(string $tableName, string $keyName, int $id, string $fieldName)
  {
    if ($id > 0) {
      $blobRef = null;
      $sql = "select " . $this->quote . $fieldName . $this->quote . "
          from " . $this->quote . $tableName . $this->quote . "
			    where " . $this->quote . $keyName . $this->quote  . " = ?";
      $query = $this->db->prepare($sql);
      $query->execute(array($id));
      if ($query->rowCount() == 1) {
        $query->bindColumn(1, $blobRef, PDO::PARAM_LOB);
        $query->fetch(PDO::FETCH_BOUND);
        return $blobRef;
      }
    }
    return null;
  }
  /**
   * Import data into the database
   *
   * @param array $data
   * @return void
   */
  function importData(array $data)
  {
    $this->db->transBegin();
    try {
      foreach ($data as $tableName => $values) {
        $this->importDataTable($tableName, $values);
      }
    } catch (\Exception $e) {
      $messageError = $this->stmt->errorInfo()[2];
      $this->db->transRollback();
      throw new PpciException(
        "An error occurred during the database import:" . PHP_EOL .
          $messageError . PHP_EOL .
          $e->getMessage()
      );
    }
    $this->db->transCommit();
  }

  /**
   * Import data from a table
   *
   * @param string $tableName: name of the table
   * @param array $data: all data to be recorded
   * @param integer $parentKey: key of the parent from the table
   * @param array $setValues: list of values to insert into each row. Used for set a parent key
   * @param bool $deleteBeforeInsert: delete all records linked to the parent before insert new records
   * @return void
   */
  function importDataTable(string $tableAlias, array $data, int $parentKey = 0, array $setValues = array(), $deleteBeforeInsert = false)
  {
    if (!isset($this->model[$tableAlias])) {
      throw new PpciException(sprintf("No description found for the table alias %s in the parameter file", $tableAlias));
    }
    if ($this->modeDebug) {
      printA("Import into $tableAlias");
    }
    /**
     * prepare sql request for searching key
     */
    $model = $this->model[$tableAlias];
    $tableName = $model["tableName"];
    $bkeyName = $model["businessKey"];
    $tkeyName = $model["technicalKey"];
    $pkeyName = $model["parentKey"];
    if (!empty($bkeyName)) {
      $sqlSearchKey = "select $this->quote$tkeyName$this->quote as key
                    from $this->quote$tableName$this->quote
                    where $this->quote$bkeyName$this->quote = :businessKey";
      $isBusiness = true;
    } else {
      $isBusiness = false;
    }
    if ($deleteBeforeInsert && $parentKey > 0) {
      $sqlDeleteFromParent = "delete from $this->quote$tableName$this->quote where $this->quote$pkeyName$this->quote = :parent";
      $this->execute($sqlDeleteFromParent, array("parent" => $parentKey));
    }
    if ($this->modeDebug) {
      printA("Treatment of " . $tableAlias . " tablename:" . $tableName . " businessKey:" . $bkeyName . " technicalKey:" . $tkeyName . " parentKey:" . $pkeyName);
    }
    if ($model["istablenn"] == 1) {
      $tableAlias2 = $model["tablenn"]["tableAlias"];
      $model2 = $this->model[$tableAlias2];
      if (count($model2) == 0) {
        throw new PpciException(
          "The model don't contains the description of the table " . $model["tablenn"]["tableAlias"]
        );
      }
      $tableName2 = $model2["tableName"];
      $tkeyName2 = $model2["technicalKey"];
      $bkey2 = $model2["businessKey"];
      /**
       * delete pre-existent rows
       */
      $sqlDelete = "delete from $this->quote$tableName$this->quote
            where $this->quote$pkeyName$this->quote = :parentKey";
      $this->execute($sqlDelete, array("parentKey" => $parentKey));
    }
    foreach ($data as $row) {
      if (!empty($row[$tkeyName]) || ($model["istablenn"] == 1 && !empty($row[$pkeyName]))) {
        /**
         * search for preexisting record
         */
        if ($isBusiness && !empty($row[$bkeyName])) {
          $previousData = $this->execute($sqlSearchKey, array("businessKey" => $row[$bkeyName]));
          if ($this->modeDebug) {
            printA("previousData keyfound:" . $previousData[0]["key"]);
          }
          if ($previousData[0]["key"] > 0) {
            $row[$tkeyName] = $previousData[0]["key"];
          } else {
            if (isset($row[$tkeyName]) && $tkeyName != $bkeyName) {
              $row[$tkeyName] = null;
            }
          }
        } else {
          unset($row[$tkeyName]);
        }
        if ($parentKey > 0 && !empty($pkeyName)) {
          $row[$pkeyName] = $parentKey;
        }
        if ($model["istable11"] == 1 && $parentKey > 0) {
          $row[$tkeyName] = $parentKey;
        }
      }
      if ($model["istablenn"] == 1 /*&& !isset($model["parents"][0])*/) {
        /**
         * Search id of secondary table
         */
        $sqlSearchSecondary = "select $this->quote$tkeyName2$this->quote as key
                    from $this->quote$tableName2$this->quote
                    where $this->quote$bkey2$this->quote = :businessKey";
        $sdata = $this->execute($sqlSearchSecondary, array("businessKey" => $row["parents"][$tableAlias2][$model2["businessKey"]]));
        $skey = $sdata[0]["key"];
        //if (!$skey > 0) {
        /**
         * write the secondary parent
         */
        //$skey = $this->writeData($tableAlias2, $row[$tableAlias2]);
        $dataSecondary = array();
        $dataSecondary[] = $row["parents"][$tableAlias2];
        $this->importDataTable($tableAlias2, $dataSecondary);
        /**
         * New request to get the secondary key, after creation
         */
        $sdata = $this->execute($sqlSearchSecondary, array("businessKey" => $row["parents"][$tableAlias2][$model2["businessKey"]]));
        $skey = $sdata[0]["key"];
        //}
        $row[$model["tablenn"]["secondaryParentKey"]] = $skey;
      }
      /**
       * Get the real values for parents
       */
      if (is_array($row["parents"]) && $model["istablenn"] != 1) {
        foreach ($row["parents"] as $parentName => $parent) {
          $modelParent = $this->model[$parentName];
          if (count($modelParent) == 0) {
            throw new PpciException("The alias $parentName was not described in the model");
          }
          /**
           * Record the current parent
           */
          /**
           * Search the id from the parent
           */
          $parentKey2 = $modelParent["technicalKey"];
          $parentBusinessKey = $modelParent["businessKey"];
          $parentTablename = $modelParent["tableName"];
          $sqlSearchParent = "select $this->quote$parentKey2$this->quote as key
                    from $this->quote$parentTablename$this->quote
                    where $this->quote$parentBusinessKey$this->quote = :businessKey";
          $pdata = $this->execute($sqlSearchParent, array("businessKey" => $parent[$modelParent["businessKey"]]));
          $ptkey = $pdata[0]["key"];
          if (!strlen($ptkey) > 0) {
            /**
             * write the parent
             */
            try {
              $parentA = array();
              $parentA[0] = $parent;
              $this->importDataTable($parentTablename, $parentA);
              /**
               * Get the real value from the parent
               */
              $pdata = $this->execute(
                $sqlSearchParent,
                array("businessKey" => $parent[$modelParent["businessKey"]])
              );
              $ptkey = $pdata[0]["key"];
              if (!$ptkey) {
                throw new PpciException(
                  "parent table $parentName - value: " . $parent[$modelParent["businessKey"]] . " not found"
                );
              }
            } catch (Exception $e) {
              throw new PpciException(
                "Record error for the parent table $parentName for the value " . $parent[$modelParent["businessKey"]]
              );
            }
          }
          if ($this->modeDebug) {
            printA("parent " . $parentName . ": key for " . $parent[$modelParent["businessKey"]] . " is " . $ptkey);
          }
          if (!strlen($ptkey) > 0) {
            throw new PpciException(
              "No key was found or generate for the parent table $parentName"
            );
          }
          /**
           * Search the name of the attribute corresponding in the row
           */
          $fieldName = "";
          foreach ($model["parents"] as $modParam) {
            if ($modParam["aliasName"] == $parentName) {
              $fieldName = $modParam["fieldName"];
              break;
            }
          }
          if (empty($fieldName) ) {
            throw new PpciException(sprintf("Unexpected error: impossible to find the name of the field corresponding to the parent table %s", $parentName));
          }
          $row[$fieldName] = $ptkey;
        }
      }
      /**
       * Set values
       */
      if (count($setValues) > 0) {
        foreach ($setValues as $kv => $dv) {
          if (strlen($dv) == 0) {
            throw new PpciException(sprintf("An empty value has been found for the added attribute %s", $kv));
          }
          $row[$kv] = $dv;
        }
      }
      /**
       * Write data
       */
      $dataRow = array();
      $dataRow = array_merge($row);
      unset($dataRow["children"]);
      unset($dataRow["parents"]);
      $id = $this->writeData($tableAlias, $dataRow);
      if ($this->modeDebug) {
        printA("Recorded $tableAlias - id: $id");
      }
      /**
       * Record the children
       */
      if ($id > 0 && is_array($row["children"])) {
        foreach ($model["children"] as $childMod) {
          if (count($row["children"][$childMod["aliasName"]]) > 0) {
            if (!isset($childMod["isStrict"])) {
              $childMod["isStrict"] = false;
            }
            if ($this->modeDebug) {
              printA("Import children " . $childMod["aliasName"] . " from $tableAlias with key $id");
            }
            $this->importDataTable($childMod["aliasName"], $row["children"][$childMod["aliasName"]], $id, array(), $childMod["isStrict"]);
          }
        }
      }
    }
  }

  /**
   * insert or update a record
   *
   * @param string $tableName: name of the table
   * @param array $data: data of the record
   * @return int|null: technical key generated or updated
   */
  function writeData(string $tableAlias, $data): ?int
  {
    if (!$data) {
      throw new PpciException("data are empty for $tableAlias");
    }
    $model = $this->model[$tableAlias];
    $tableName = $model["tableName"];
    $structure = $this->structure[$tableName];
    if (!is_array($structure) || count($structure) == 0) {
      throw new PpciException("The structure of the table $tableName is unknown");
    }
    $tkeyName = $model["technicalKey"];
    $pkeyName = $model["parentKey"];
    $bkeyName = $model["businessKey"];
    $skeyName = $model["tablenn"]["secondaryParentKey"];
    $newKey = null;
    $dataSql = array();
    $comma = "";
    $mode = "insert";
    if ($data[$tkeyName] > 0) {
      /**
       * Search if the record exists
       */
      $sql = "select " . $this->quote . $tkeyName . $this->quote
        . " as key from " . $this->quote . $tableName . $this->quote
        . " where " . $this->quote . $tkeyName . $this->quote
        . " = :key";
      $result = $this->execute($sql, array("key" => $data[$tkeyName]));
      if (!empty($result[0]["key"])) {
        $mode = "update";
      }
    }
    $model["istablenn"] == 1 ? $returning = "" : $returning = " RETURNING $tkeyName";
    /**
     * update
     */
    if ($mode == "update") {
      $sql = "update $this->quote$tableName$this->quote set ";
      foreach ($data as $field => $value) {
        if (
          is_array($structure["booleanFields"])
          && in_array($field, $structure["booleanFields"]) && !$value
        ) {
          $value = "false";
        }
        if ($field != $tkeyName) {
          $sql .= "$comma$this->quote$field$this->quote = :$field";
          $comma = ", ";
          $dataSql[$field] = $value;
        }
      }
      if (!empty($pkeyName) && !empty($skeyName)) {
        $where = " where $this->quote$pkeyName$this->quote = :$pkeyName and $this->quote$skeyName$this->quote = :$skeyName";
      } else {
        $where = " where $this->quote$tkeyName$this->quote = :$tkeyName";
        $dataSql[$tkeyName] = $data[$tkeyName];
      }
      if (!isset($where)) {
        throw new PpciException(
          "The where clause can't be construct for the table $tableName"
        );
      }
      $sql .= $where;
    } else {
      /**
       * insert
       */
      $mode = "insert";
      $cols = "(";
      $values = "(";
      foreach ($data as $field => $value) {
        if (!($field == $tkeyName && $bkeyName != $tkeyName)) {
          if (
            is_array($structure["booleanFields"])
            && in_array($field, $structure["booleanFields"]) && !$value
          ) {
            $value = "false";
          }
          if (!($model["istablenn"] == 1 && $field == $model["tablenn"]["tableAlias"])) {
            $cols .= $comma . $this->quote . $field . $this->quote;
            $values .= $comma . ":$field";
            $dataSql[$field] = $value;
            $comma = ", ";
          }
        }
      }
      $cols .= ")";
      $values .= ")";
      $sql = "insert into $this->quote$tableName$this->quote $cols values $values $returning";
    }
    $result = $this->execute($sql, $dataSql);
    if ($model["istablenn"] == 1) {
      $newKey = null;
    } else if ($mode == "insert") {
      $newKey = $result[0][$tkeyName];
    } else {
      $newKey = $data[$tkeyName];
    }
    if ($this->modeDebug) {
      printA("newkey: " . $newKey);
    }
    /**
     * Get the binary data
     */
    if (
      !empty($newKey)
      && is_array($structure["binaryFields"])
      && count($structure["binaryFields"]) > 0
    ) {
      if (empty($data[$bkeyName])) {
        throw new PpciException(
          "The businessKey is empty for the table $tableName and the binary data can't be imported"
        );
      }
      if (!is_dir($this->binaryFolder)) {
        throw new PpciException(
          "The folder that contains binary files don't exists (" . $this->binaryFolder . ")"
        );
      }
      foreach ($structure["binaryFields"] as $binaryField) {
        $filename = $this->binaryFolder . "/" . $tableName . "-" . $binaryField . "-" . $data[$bkeyName] . ".bin";
        if (file_exists($filename)) {
          $fp = fopen($filename, 'rb');
          if (!$fp) {
            throw new PpciException("The file $filename can't be opened");
          }
          $sql = "update  $this->quote$tableName$this->quote set ";
          $sql .= "$this->quote$binaryField$this->quote = :binaryFile";
          $sql .= " where $this->quote$tkeyName$this->quote = :key";
          $this->prepare($sql);
          $this->stmt->bindParam(":binaryFile", $fp, PDO::PARAM_LOB);
          $this->stmt->bindParam(":key", $newKey);
          if (!$this->stmt->execute()) {
            throw new PpciException("Error when execute the request" . PHP_EOL
              . $sql . PHP_EOL
              . $this->stmt->errorInfo()[2]);
          };
        }
      }
    }
    return $newKey;
  }
}
