<?php

namespace App\Models;

use Ppci\Libraries\PpciException;
use Ppci\Models\PpciModel;

/**
 * ORM of the table export_model
 */
class ExportModel extends PpciModel
{
    private $model = array();
    public $structure = array();
    public $binaryFolder = WRITEPATH . "/temp/binary";
    public $modeDebug = false;

    /**
     * Class constructor.
     */
    public function __construct()
    {
        $this->table = "export_model";
        $this->fields = array(
            "export_model_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "export_model_name" => array("type" => 0, "requis" => 1),
            "pattern" => array("type" => 0),
            "target" => array("type" => 0)
        );
        parent::__construct();
    }
    /**
     * Get a model from his name
     *
     * @param string $name
     * @return array
     */
    function getModelFromName(string $name): ?array
    {
        $sql = "select export_model_id, export_model_name, pattern, target from export_model
                where export_model_name = :name:";
        return $this->lireParamAsPrepared($sql, array("name" => $name));
    }
    /**
     * Get the list of models of export associated to a target
     *
     * @param string $target
     * @return array|null
     */
    function getListFromTarget(string $target): ?array
    {
        $sql = "select export_model_id, export_model_name, target
                from export_model
                where target = :target:";
        return $this->getListeParamAsPrepared($sql, array("target" => $target));
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

    /*********************************************************
     * Structuration of model
     *********************************************************/
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
        }
        return ($this->structure);
    }

    /***************************************************
     * Generate SQL from structure
     ***************************************************/
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
            $comment = "comment on table " . $this->qi . $tableName . $this->qi . " is " . pg_escape_string($this->db->connID, $table["description"]) . $this->qi . ";" . PHP_EOL;
        }
        $script = "create table " . $this->qi . $tableName . $this->qi . " (" . PHP_EOL;
        $nbAtt = count($table["attributes"]) - 1;
        for ($x = 0; $x <= $nbAtt; $x++) {
            if ($x > 0) {
                $script .= ",";
            }
            $attr = $table["attributes"][$x];
            $script .= $this->qi . $attr["field"] . $this->qi;
            $script .= " " . $attr["type"];
            if ($attr["notnull"] == 1) {
                $script .= " not null";
            }
            if (!empty($attr["key"])) {
                if (!empty($pkey) > 0) {
                    $pkey .= ",";
                }
                $pkey .= $this->qi . $attr["field"] . $this->qi;
            }
            /**
             * Add the comment on the column
             */
            if (!empty($attr["comment"])) {
                $comment .= "comment on column " . $this->qi . $tableName . $this->qi . "." . $this->qi . $attr["field"] . $this->qi . " is " . pg_escape_string($this->db->connID,$attr["comment"]) . ";" . PHP_EOL;
            }
            $script .= PHP_EOL;
        }
        /**
         * Add the primary key
         */
        if (!empty($pkey)) {
            $script .= ",primary key (" . $pkey . ")" . PHP_EOL;
        }
        $script .= ");" . PHP_EOL;
        $script .= $comment . PHP_EOL;
        return $script;
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
        if (empty($parentTable) == 0 || empty($parentKey)  || empty($childTable) || empty($childForeignKey)) {
            throw new PpciException("An error occurred during the creation of relation between $parentTable and $childTable");
        }
        $sql = "ALTER TABLE " . $this->qi . $childTable . $this->qi;
        $sql .= " ADD CONSTRAINT " . $childTable . "_has_parent_$parentTable" . PHP_EOL;
        $sql .= "FOREIGN KEY (" . $this->qi . $childForeignKey . $this->qi . ")";
        $sql .= " REFERENCES " . $this->qi . $parentTable . $this->qi . "(" .
            $this->qi . $parentKey . $this->qi . ");" . PHP_EOL;
        return $sql;
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
        $res = $this->lireParam($sql, $data);
        $description = $res["description"];
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
        $result = $this->getListParam($select . $where . $order, $data);
        if (count($result) == 0) {
            throw new PpciException("The table $tablename is unknown or has no attributes");
        }
        /**
         * transform sequence field to serial
         */
        foreach ($result as $key => $field) {
            if ($field["type"] == 'integer' && substr($field["def"], 0, 7) == "nextval") {
                $result[$key]["type"] = "serial";
            }
            unset($result[$key]["def"]);
        }
        return ($result);
    }

    /****************************************************************
     * Treatement of import/export
     ****************************************************************/

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
            printA($model);
            $cols = $this->generateListColumns($tableName);
            $sql = "select $cols from " . $this->qi . $tableName . $this->qi;
            if (count($keys) > 0) {
                $where = " where " . $this->qi . $model["technicalKey"] . $this->qi . " in (";
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
                $where = " where " . $this->qi . $model["parentKey"] . $this->qi . " = :parentKey:";
                $args["parentKey"] = $parentKey;
            } else {
                $where = "";
            }
            if (!empty($model["technicalKey"])) {
                $order = " order by " . $this->qi . $model["technicalKey"] . $this->qi;
            } else {
                $order = " order by 1";
            }
            $content = $this->getListParam($sql . $where . $order, $args);

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
                            $sql = "select " . $this->qi . $fieldName . $this->qi . " as binaryfield from " . $this->qi . $tableName . $this->qi .
                                " where " . $this->qi . $model["technicalKey"] . $this->qi . " = :tk:";
                            $res = $this->lireParam($sql, ["tk" => $row[$model["technicalKey"]]]);
                            if (count($res) > 0) {
                                $filename = $model["tableName"] . "-" . $fieldName . "-" . $row[$model["businessKey"]] . ".bin";
                                $fb = fopen($this->binaryFolder . "/" . $filename, "wb");
                                fwrite($fb, pg_unescape_bytea($res["binaryfield"]));
                                fclose($fb);
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
                    $sql = "select * from $this->qi" . $model2["tableName"] . "$this->qi where $this->qi" . $model["tablenn"]["secondaryParentKey"] . "$this->qi = :secKey";
                    $data = $this->getListParam($sql, array("secKey" => $row[$model["tablenn"]["secondaryParentKey"]]));
                    $content[$k][$model["tablenn"]["tableAlias"]] = $data[0];
                }
            }
        }
        return $content;
    }

    /**
     * Prepare the list of columns for sql clause without binary fields
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
                $cols .= $comma . $this->qi . $col["field"] . $this->qi;
                $comma = ",";
            }
        }
        return $cols;
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
            $sqlSearchKey = "select $this->qi$tkeyName$this->qi as key
                    from $this->qi$tableName$this->qi
                    where $this->qi$bkeyName$this->qi = :businessKey:";
            $isBusiness = true;
        } else {
            $isBusiness = false;
        }
        if ($deleteBeforeInsert && $parentKey > 0) {
            $sqlDeleteFromParent = "delete from $this->qi$tableName$this->qi where $this->qi$pkeyName$this->qi = :parent:";
            $this->executeSQL($sqlDeleteFromParent, array("parent" => $parentKey), true);
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
            $sqlDelete = "delete from $this->qi$tableName$this->qi
            where $this->qi$pkeyName$this->qi = :parentKey:";
            $this->executeSQL($sqlDelete, array("parentKey" => $parentKey), true);
        }
        foreach ($data as $row) {
            if (!empty($row[$tkeyName]) || ($model["istablenn"] == 1 && !empty($row[$pkeyName]))) {
                /**
                 * search for preexisting record
                 */
                if ($isBusiness && !empty($row[$bkeyName])) {
                    $previousData = $this->getListParam($sqlSearchKey, array("businessKey" => $row[$bkeyName]));
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
                $sqlSearchSecondary = "select $this->qi$tkeyName2$this->qi as key
                    from $this->qi$tableName2$this->qi
                    where $this->qi$bkey2$this->qi = :businessKey:";
                $sdata = $this->getListeParam($sqlSearchSecondary, array("businessKey" => $row["parents"][$tableAlias2][$model2["businessKey"]]));
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
                $sdata = $this->getListParam($sqlSearchSecondary, array("businessKey" => $row["parents"][$tableAlias2][$model2["businessKey"]]));
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
                    $sqlSearchParent = "select $this->qi$parentKey2$this->qi as key
                    from $this->qi$parentTablename$this->qi
                    where $this->qi$parentBusinessKey$this->qi = :businessKey:";
                    $pdata = $this->getListParam($sqlSearchParent, array("businessKey" => $parent[$modelParent["businessKey"]]));
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
                            $pdata = $this->executeSQL(
                                $sqlSearchParent,
                                array("businessKey" => $parent[$modelParent["businessKey"]])
                            );
                            $ptkey = $pdata[0]["key"];
                            if (!$ptkey) {
                                throw new PpciException(
                                    "parent table $parentName - value: " . $parent[$modelParent["businessKey"]] . " not found"
                                );
                            }
                        } catch (\Exception $e) {
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
                    if (empty($fieldName)) {
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
      $sql = "select " . $this->qi . $tkeyName . $this->qi
        . " as key from " . $this->qi . $tableName . $this->qi
        . " where " . $this->qi . $tkeyName . $this->qi
        . " = :key:";
      $result = $this->getListeParam($sql, array("key" => $data[$tkeyName]));
      if (!empty($result[0]["key"])) {
        $mode = "update";
      }
    }
    $model["istablenn"] == 1 ? $returning = "" : $returning = " RETURNING $tkeyName";
    /**
     * update
     */
    if ($mode == "update") {
      $sql = "update $this->qi$tableName$this->qi set ";
      foreach ($data as $field => $value) {
        if (
          is_array($structure["booleanFields"])
          && in_array($field, $structure["booleanFields"]) && !$value
        ) {
          $value = "false";
        }
        if ($field != $tkeyName) {
          $sql .= "$comma$this->qi$field$this->qi = :$field:";
          $comma = ", ";
          $dataSql[$field] = $value;
        }
      }
      if (!empty($pkeyName) && !empty($skeyName)) {
        $where = " where $this->qi$pkeyName$this->qi = :$pkeyName: and $this->qi$skeyName$this->qi = :$skeyName:";
      } else {
        $where = " where $this->qi$tkeyName$this->qi = :$tkeyName:";
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
            $cols .= $comma . $this->qi . $field . $this->qi;
            $values .= $comma . ":$field:";
            $dataSql[$field] = $value;
            $comma = ", ";
          }
        }
      }
      $cols .= ")";
      $values .= ")";
      //$sql = "insert into $this->qi$tableName$this->qi $cols values $values $returning";
      $sql = "insert into $this->qi$tableName$this->qi $cols values $values";
    }
    $result = $this->executeQuery($sql, $dataSql,true);
    if ($model["istablenn"] == 1) {
      $newKey = null;
    } else if ($mode == "insert") {
      //$newKey = $result[0][$tkeyName];
      $newKey = $this->getInsertID();
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
          $sql = "update  $this->qi$tableName$this->qi set ";
          $sql .= "$this->qi$binaryField$this->qi = :binaryFile:";
          $sql .= " where $this->qi$tkeyName$this->qi = :key:";
          $this->executeSQL($sql, ["key"=>$newKey, "binaryFile"=>pg_escape_bytea($this->db->connID,fread($fp, filesize($filename)))],true);
        }
      }
    }
    return $newKey;
  }
}
