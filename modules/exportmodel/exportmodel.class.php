<?php
class ExportException extends Exception
{ };
/**
 * ORM of the table export_model
 */
class ExportModel extends ObjetBDD
{
    /**
     * Class constructor.
     */
    public function __construct($bdd, $param = array())
    {
        $this->table = "export_model";
        $this->colonnes = array(
            "export_model_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "export_model_name" => array("type" => 0, "requis" => 1),
            "pattern" => array("type" => 0),
            "target" => array("type" => 0)
        );

        parent::__construct($bdd, $param);
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
                where export_model_name = :name";
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
                where target = :target";
        return $this->getListeParamAsPrepared($sql, array("target" => $target));
    }
}
class ExportModelProcessing
{
    private $model = array();
    private $bdd;
    private $lastResultExec;
    public $modeDebug = false;
    /**
     * Constructor
     *
     * @param PDO $bdd: database connection object
     */
    function __construct(PDO $bdd)
    {
        $this->bdd = $bdd;
    }
    /**
     * Display the content of a variable
     *
     * @param any $tableau
     * @param integer $mode_dump
     * @param boolean $force
     * @return void
     */
    private function printr($tableau, $mode_dump = 0, $force = false)
    {
        global $APPLI_modeDeveloppement;
        if ($APPLI_modeDeveloppement || $force) {
            if ($mode_dump == 1) {
                var_dump($tableau);
            } else {
                if (is_array($tableau)) {
                    print_r($tableau);
                } else {
                    echo $tableau;
                }
            }
            echo "<br>";
        }
    }

    /**
     * Set the used model
     *
     * @param string $model: JSON field contents the description of the tables
     * @return void
     */
    function initModel(string $model)
    {
        $model = json_decode($model, true);
        /**
         * Generate the model with tableName as identifier
         */
        foreach ($model as $m) {
            /**
             * Set the tableAlias if not defined
             */
            if (strlen($m["tableAlias"]) == 0) {
                $m["tableAlias"] = $m["tableName"];
            }
            $this->model[$m["tableAlias"]] = $m;
        }
    }
    /**
     * Get the list of the tables witch are not children
     *
     * @return array
     */
    function getListPrimaryTables(): array
    {
        $list = array();
        foreach ($this->model as $table) {
            if (strlen($table["parentKey"]) == 0 && !$table["isEmpty"]) {
                $list[] = $table["tableAlias"];
            }
        }
        return $list;
    }
    /**
     * Get the content of a table
     *
     * @param string $tableName: alias of the table
     * @param array $keys: list of the keys to extract
     * @param integer $parentKey: value of the technicalKey of the parent (foreign key)
     * @return array
     */
    function getTableContent(string $tableAlias, array $keys = array(), int $parentKey = 0): array
    {
        $model = $this->model[$tableAlias];
        if (count($model) == 0) {
            throw new ExportException(sprintf(_("L'alias %s n'a pas été décrit dans le modèle"), $tableAlias));
        }
        $tableName = $model["tableName"];
        $quote = '"';
        $content  = array();
        $args = array();
        if (!$model["isEmpty"] || count($keys) > 0) {
            $sql = "select * from $quote$tableName$quote";
            if (count($keys) > 0) {
                $where = " where " . $quote . $model["technicalKey"] . $quote . " in (";
                $comma = "";
                foreach ($keys as $k) {
                    if (is_numeric($k)) {
                        $where .= $comma . $k;
                        $comma = ",";
                    }
                }
                $where .= ")";
            } else if (strlen($model["parentKey"]) > 0 && $parentKey > 0) {
                /**
                 * Search by parent
                 */
                $where = " where " . $quote . $model["parentKey"] . $quote . " = :parentKey";
                $args["parentKey"] = $parentKey;
            } else {
                $where = "";
            }
            if (strlen($model["technicalKey"]) > 0) {
                $order = " order by " . $quote . $model["technicalKey"] . $quote;
            } else {
                $order = " order by 1";
            }
            $content = $this->execute($sql . $where . $order, $args);
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
                        $content[$k]["children"][$child["aliasName"]] = $this->getTableContent($child["aliasName"], array(), $row[$model["technicalKey"]]);
                    }
                }
            }
            /**
             * Search the parameters
             */
            if (count($model["parameters"]) > 0) {
                foreach ($content as $k => $row) {
                    foreach ($model["parameters"] as $parameter) {
                        $id = $row[$parameter["fieldName"]];
                        if ($id > 0) {
                            $content[$k]["parameters"][$parameter["aliasName"]] = $this->getTableContent($parameter["aliasName"], array($id))[0];
                        }
                    }
                }
            }
            if ($model["istablenn"] == 1) {
                foreach ($content as $k => $row) {
                    /**
                     * Get the record associated with the current record
                     */
                    $sql = "select * from $quote" . $model2["tableName"] . "$quote where $quote" . $model["tablenn"]["secondaryParentKey"] . "$quote = :secKey";
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
     * @return array
     */
    function execute(string $sql, array $data = array()): array
    {
        if ($this->modeDebug) {
            $this->printr($sql);
            $this->printr($data);
        }
        try {
            $stmt = $this->bdd->prepare($sql);
            $this->lastResultExec = $stmt->execute($data);
            if ($this->lastResultExec) {
                return $stmt->fetchAll(PDO::FETCH_ASSOC);
            }
        } catch (PDOException $e) {
            $this->lastResultExec = false;
            throw new ExportException($e->getMessage());
        }
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

        $quote = '"';
        if (!isset($this->model[$tableAlias])) {
            throw new ExportException(sprintf(_("Aucune description trouvée pour l'alias de table %s dans le fichier de paramètres"), $tableAlias));
        }
        /**
         * prepare sql request for search key
         */
        $model = $this->model[$tableAlias];
        $tableName = $model["tableName"];
        $bkeyName = $model["businessKey"];
        $tkeyName = $model["technicalKey"];
        $pkeyName = $model["parentKey"];
        if (strlen($bkeyName) > 0) {
            $sqlSearchKey = "select $quote$tkeyName$quote as key
                    from $quote$tableName$quote
                    where $quote$bkeyName$quote = :businessKey";
            $isBusiness = true;
        } else {
            $isBusiness = false;
        }
        if ($deleteBeforeInsert && $parentKey > 0) {
            $sqlDeleteFromParent = "delete $quote$tableName$quote where $quote$pkeyName$quote = :parent";
            $this->execute($sqlDeleteFromParent, array("parent" => $parentKey));
        }
        if ($model["istablenn"] == 1) {
            $tableAlias2 = $model["tablenn"]["tableAlias"];
            $model2 = $this->model[$tableAlias2];
            if (count($model2) == 0) {
                throw new ExportException(sprintf(_("Le modèle ne contient pas la description de la table %s"), $model["tablenn"]["tableAlias"]));
            }
            $tableName2 = $model2["tableName"];
            $tkeyName2 = $model2["technicalKey"];
            $bkey2 = $model2["businessKey"];
            /**
             * delete pre-existent rows
             */
            $sqlDelete = "delete from $quote$tableName$quote
            where $quote$pkeyName$quote = :parentKey";
            $this->execute($sqlDelete, array("parentKey" => $parentKey));
        }
        foreach ($data as $row) {
            if (strlen($row[$tkeyName]) > 0 || ($model["istablenn"] == 1 && strlen($row[$pkeyName]) > 0)) {
                /**
                 * search for preexisting record
                 */
                if ($this->modeDebug) {
                    test($tableName . " key:" . $row[$tkeyName]);
                    test($tableAlias . " tablename:" . $tableName . " businessKey:" . $bkeyName . " technicalKey:" . $tkeyName . " parentKey:" . $pkeyName);
                }
                if ($isBusiness && strlen($row[$bkeyName]) > 0) {
                    $previousData = $this->execute($sqlSearchKey, array("businessKey" => $row[$bkeyName]));
                    if ($previousData[0]["key"] > 0) {
                        $row[$tkeyName] = $previousData[0]["key"];
                    } else {
                        unset($row[$tkeyName]);
                    }
                } else {
                    unset($row[$tkeyName]);
                }
                if ($parentKey > 0 && strlen($pkeyName) > 0) {
                    $row[$pkeyName] = $parentKey;
                }
                if ($model["istable11"] == 1 && $parentKey > 0) {
                    $row[$tkeyName] = $parentKey;
                }
                if ($model["istablenn"] == 1) {
                    /**
                     * Search id of secondary table
                     */
                    $sqlSearchSecondary = "select $quote$tkeyName2$quote as key
                    from $quote$tableName2$quote
                    where $quote$bkey2$quote = :businessKey";
                    $sdata = $this->execute($sqlSearchSecondary, array("businessKey" => $row[$tableAlias2][$model2["businessKey"]]));
                    $skey = $sdata[0]["key"];
                    if (!$skey > 0) {
                        /**
                         * write the secondary parent
                         */
                        $skey = $this->writeData($tableAlias2, $row[$tableAlias2]);
                    }
                    $row[$model["tablenn"]["secondaryParentKey"]] = $skey;
                }
                /**
                 * Get the real values for parameters
                 */
                foreach ($row["parameters"] as $parameterName => $parameter) {
                    $modelParam = $this->model[$parameterName];
                    if (count($modelParam) == 0) {
                        throw new ExportException(sprintf(_("L'alias %s n'a pas été décrit dans le modèle"), $parameterName));
                    }
                    /**
                     * Search the id from the parameter
                     */
                    $paramKey = $modelParam["technicalKey"];
                    $paramBusinessKey = $modelParam["businessKey"];
                    $paramTablename = $modelParam["tableName"];
                    $sqlSearchParam = "select $quote$paramKey$quote as key
                    from $quote$paramTablename$quote
                    where $quote$paramBusinessKey$quote = :businessKey";
                    $pdata = $this->execute($sqlSearchParam, array("businessKey" => $parameter[$modelParam["businessKey"]]));
                    $pkey = $pdata[0]["key"];
                    if (!$pkey > 0) {
                        /**
                         * write the parameter
                         */
                        unset($parameter[$modelParam["technicalKey"]]);
                        try {
                            $pkey = $this->writeData($parameterName, $parameter);
                        } catch (Exception $e) {
                            throw new ExportException(sprintf(_("Erreur d'enregistrement dans la table de paramètres %1$s pour la valeur %2$s"), $parameterName, $parameter[$modelParam["businessKey"]]));
                        }
                    }
                    if ($this->modeDebug) {
                        $this->printr("Parameter " . $parameterName . ": key for " . $parameter[$modelParam["businessKey"]] . " is " . $pkey);
                    }
                    if (!$pkey > 0) {
                        throw new ExportException(sprintf(_("Aucune clé n'a pu être trouvée ou générée pour la table de paramètres %s"), $parameterName));
                    }
                    /**
                     * Search the name of the attribute corresponding in the row
                     */
                    $fieldName = "";
                    foreach ($model["parameters"] as $modParam) {
                        if ($modParam["aliasName"] == $parameterName) {
                            $fieldName = $modParam["fieldName"];
                            break;
                        }
                    }
                    if (strlen($fieldName) == 0) {
                        throw new ExportException(sprintf(_("Erreur inattendue : impossible de trouver le nom du champ correspondant à la table de paramètres %s"), $parameterName));
                    }
                    $row[$fieldName] = $pkey;
                }
                /**
                 * Set values
                 */
                if (count($setValues) > 0) {
                    foreach ($setValues as $kv => $dv) {
                        if (strlen($dv) == 0) {
                            throw new ExportException(sprintf(_("Une valeur vide a été trouvée pour l'attribut ajouté %s"), $kv));
                        }
                        $row[$kv] = $dv;
                    }
                }
                /**
                 * Write data
                 */
                $children = $row["children"];
                unset($row["children"]);
                unset($row["parameters"]);
                $id = $this->writeData($tableAlias, $row);
                /**
                 * Record the children
                 */
                if ($id > 0) {
                    foreach ($children as $tableChield => $child) {
                        if (count($child) > 0) {
                            if (!isset($child["isStrict"])) {
                                $child["isStrict"] = false;
                            }
                            $this->importDataTable($tableChield, $child, $id, array(), $child["isStrict"]);
                        }
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
     * @return integer: technical key generated or updated
     */
    function writeData(string $tableAlias, array $data): ?int
    {
        $model = $this->model[$tableAlias];
        $tableName = $model["tableName"];
        $tkeyName = $model["technicalKey"];
        $pkeyName = $model["parentKey"];
        $skeyName = $model["tablenn"]["secondaryParentKey"];
        $dataSql = array();
        $comma = "";
        $quote = '"';
        $mode = "insert";
        if ($data[$tkeyName] > 0) {
            $mode = "update";
        }
        $model["istablenn"] == 1 ? $returning = "" : $returning = " RETURNING $tkeyName";
        /**
         * update
         */
        if ($mode == "update") {
            $sql = "update $quote$tableName$quote set ";
            foreach ($data as $field => $value) {
                if (in_array($field, $model["booleanFields"]) && !$value) {
                    $value = "false";
                }
                if ($field != $tkeyName) {
                    $sql .= "$comma$quote$field$quote = :$field";
                    $comma = ", ";
                    $dataSql[$field] = $value;
                }
            }
            if (strlen($pkeyName) > 0 && strlen($skeyName) > 0) {
                $where = " where $quote$pkeyName$quote = :$pkeyName and $quote$skeyName$quote = :$skeyName";
            } else {
                $where = " where $quote$tkeyName$quote = :$tkeyName";
                $dataSql[$tkeyName] = $data[$tkeyName];
            }
            if (!isset($where)) {
                throw new ExportException(sprintf(_("la clause where n'a pu être construite pour la table %s"), $tableName));
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
                if (in_array($field, $model["booleanFields"]) && !$value) {
                    $value = "false";
                }
                if (!($model["istablenn"] == 1 && $field == $model["tablenn"]["tableAlias"])) {
                    $cols .= $comma . $quote . $field . $quote;
                    $values .= $comma . ":$field";
                    $dataSql[$field] = $value;
                    $comma = ", ";
                }
            }
            $cols .= ")";
            $values .= ")";
            $sql = "insert into $quote$tableName$quote $cols values $values $returning";
        }
        $result = $this->execute($sql, $dataSql);
        if ($model["istablenn"] == 1) {
            $newkey = null;
        } else if ($mode == "insert") {
            $newKey = $result[0][$tkeyName];
        } else {
            $newKey = $data[$tkeyName];
        }
        return $newKey;
    }
}
