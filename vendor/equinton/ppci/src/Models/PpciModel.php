<?php

namespace Ppci\Models;

use CodeIgniter\Database\Query;
use CodeIgniter\Model;
use Ppci\Libraries\PpciException;

class PpciModel extends Model
{
    protected array $fields = [];
    protected array $numericFields = [];
    protected array $dateFields = [];
    protected array $datetimeFields = [];
    protected array $geomFields = [];
    protected array $defaultValues = [];
    protected array $mandatoryFields = [];
    protected string $parentKeyName = "";
    /**
     * If true, the date and datetime fields are formated into the locale language, and reverse to write into the database
     *
     * @var boolean
     */
    public bool $autoFormatDate = true;
    public string $dateFormatMask = 'd/m/Y';
    public string $datetimeFormat = 'd/m/Y H:i:s';
    /**
     * If true, for numbers, the comma is transformed in point before write in database
     *
     * @var boolean
     */
    public $transformComma = true;
    /**
     * SRID used to generate geom fields
     *
     * @var integer
     */
    public int $srid = 4326;
    /**
     * character used to surround the column names, if necessary
     *
     * @var string
     */
    public $qi = '"';
    public $message;
    /**
     * Populate data for use with model
     * Define the date, datetime and geom types
     * Define the defaults values if a record don't exists
     *
     * @return void
     */
    protected function initialize()
    {
        foreach ($this->fields as $fieldName => $field) {
            if (!isset($field["key"])) {
                $this->allowedFields[] = $fieldName;
            }

            if (!isset($field["type"])) {
                $field["type"] = 0;
            }
            if ($field["type"] == 1) {
                $this->numericFields[] = $fieldName;
            } elseif ($field["type"] == 2) {
                $this->dateFields[] = $fieldName;
            } elseif ($field["type"] == 3) {
                $this->datetimeFields[] = $fieldName;
            } elseif ($field["type"] == 4) {
                $this->geomFields[] = $fieldName;
            }
            if (isset($field["key"])) {
                $this->primaryKey = $fieldName;
            }
            if (isset($field["defaultValue"])) {
                $this->defaultValues[$fieldName] = $field["defaultValue"];
            }
            if (isset($field["parentAttrib"])) {
                $this->parentKeyName = $fieldName;
            }
            if (isset($field["mandatory"]) || isset($field["requis"])) {
                $this->mandatoryFields[] = $fieldName;
            }
            if ($this->id_auto == 1) {
                $this->useAutoIncrement = true;
            }
        }
        /**
         * Add messages to user and syslog
         */
        $this->message = service('MessagePpci');
    }
    /**
     * Execute the requests to the database, with generate error exceptions
     *
     * @param string $sql
     * @param array|null $data
     * @return 
     */
    protected function executeQuery(string $sql, array $data = null, $onlyExecute = false)
    {
        if (isset($data)) {
            $query = $this->db->query($sql, $data);
        } else {
            $query = $this->db->query($sql);
        }
        if (!$query) {
            //$this->message->setSyslog(sprintf(_("Erreur SQL pour la requête %s"), $sql));
            throw new PpciException($this->db->error()["message"]);
            /*$this->message->setSyslog($this->db->error()->code.": ".$this->db->error()->message);*/
            //throw new \Ppci\Libraries\PpciException(_("Une erreur s'est produite lors de l'exécution d'une requête vers la base de données"));
        }
        if (!$onlyExecute) {
            return $query->getResultArray();
        } else {
            return $query;
        }
    }
    public function executeSQL(string $sql, array $data = null, $onlyExecute = false)
    {
        return $this->executeQuery($sql, $data, $onlyExecute);
    }

    /*******************
     * Write functions *
     ******************/

    /**
     * Write a row into the database
     *
     * @param array $row
     * @return integer
     */
    public function write(array $row): int
    {
        $id = 0;
        /**
         * Verify mandatory fields
         */
        if (!isset($row[$this->primaryKey])) {
            $row[$this->primaryKey] = 0;
        }
        foreach ($this->mandatoryFields as $fieldName) {
            if (!isset($row[$fieldName]) || strlen($row[$fieldName]) == 0) {
                throw new \Ppci\Libraries\PpciException(sprintf(_("Le champ %s est obligatoire mais n'a pas été renseigné"), $fieldName));
            }
        }
        /**
         * Geom fields preparation
         */
        $geom = [];
        if (!empty($this->geomFields)) {
            foreach ($this->geomFields as $fieldName) {
                if (!empty($row[$fieldName])) {
                    $geom[$fieldName] = $row[$fieldName];
                    unset($row[$fieldName]);
                }
            }
        }
        $isInsert = false;
        if ($this->useAutoIncrement) {
            if ($row[$this->primaryKey] == 0) {
                $isInsert = true;
            } else {
                $id = $row[$this->primaryKey];
            }
        } else {
            /**
             * Search for existent record
             */
            $sql = "select " . $this->qi . $this->primaryKey . $this->qi . " as id 
            from ". $this->qi . $this->table . $this->qi .
            " where " . $this->qi . $this->primaryKey . $this->qi . " = :id:";
            $param["id"] = $row[$this->primaryKey];
            $exists = $this->readParam($sql, $param);
            if (!$exists["id"] > 0) {
                $isInsert = true;
            } else {
                $id = $row[$this->primaryKey];
            }
        }

        /**
         * Disable the deletion of primary key if not autoincrement in insert context
         */
        if (!($isInsert && !$this->useAutoIncrement)) {
            unset($row[$this->primaryKey]);
        }
        if ($this->autoFormatDate) {
            $row = $this->formatDatesToDB($row);
        }
        if ($this->transformComma) {
            foreach ($this->numericFields as $field) {
                if (isset($row[$field])) {
                    $row[$field] = str_replace(",", ".", $row[$field]);
                }
            }
        }
        if ($isInsert) {
            /**
             * Remove all empty fields
             */
            foreach ($row as $k => $v) {
                if (!is_array($v) && strlen($v) == 0) {
                    unset($row[$k]);
                }
            }
            if ($this->insert($row, false)) {
                $id = $this->getInsertID();
            } else {
                throw new \Ppci\Libraries\PpciException($this->db->error()["message"]);
            }
        } else {
            /**
             * Generate update sql
             */
            $sql = "update " . $this->qi . $this->table . $this->qi . " set ";
            $param = [];
            $comma = "";
            foreach ($row as $k => $v) {
                if (array_key_exists($k, $this->fields) && $this->fields["type"] != 4) {
                    if (strlen($v) == 0) {
                        $sql .= $comma . $this->qi . $k . $this->qi . " = NULL ";
                    } else {
                        $sql .= $comma . $this->qi . $k . $this->qi . " = :$k: ";
                        $param[$k] = $v;
                    }
                    $comma = ",";
                }
            }
            $sql .= " where " . $this->qi . $this->primaryKey . $this->qi . " = :id:";
            $param["id"] = $id;
            if ($comma == ",") {
                $this->executeQuery($sql, $param, true);
            }
            // if (!parent::update($id, $row)) {
            //     throw new \Ppci\Libraries\PpciException($this->db->error()["message"]);
            // }
        }
        /**
         * Geom fields update
         */
        if (!empty($geom)) {
            $sql = "update " . $this->qi . $this->table . $this->qi . " set ";
            $param = [];
            $comma = "";
            foreach ($geom as $k => $v) {
                $sql .= $comma . $this->qi . $k . $this->qi . " = ST_GeomFromText( :" . $k . ": , " . $this->srid . ")";
                $param[$k] = $v;
                $comma = ",";
            }
            $sql .= " where " . $this->qi . $this->primaryKey . $this->qi . " = :id:";
            $param["id"] = $id;
            $this->executeSQL($sql, $param, true);
        }
        /**
         * Return key
         */
        return $id;
    }
    public function ecrire(array $row): int
    {
        return $this->write($row);
    }

    /**
     * update a table which contains only 2 fields,
     * each field is a parent key (tables n-n)
     *
     * @param string $tablename : the name of the table to update
     * @param string $firstKey : main key name
     * @param string $secondKey : key of the related table from main key name
     * @param integer $id : value of the main key
     * @param array $data : array which contains all values of the secondary key
     * @return void
     */
    function writeTableNN(string $tablename, string $firstKey, string $secondKey, int $id, $data = array()): void
    {
        if (!$id > 0) {
            throw new \Ppci\Libraries\PpciException(sprintf(_("La clé principale %s n'est pas renseignée ou vaut zéro"), $firstKey));
        }
        foreach ($data as $value) {
            if (!is_numeric($value)) {
                throw new \Ppci\Libraries\PpciException(sprintf(_("Une valeur fournie n'est pas numérique (%s)"), $value));
            }
        }
        $tablename = $this->qi . $tablename . $this->qi;
        $k1 = $this->qi . $firstKey . $this->qi;
        $k2 = $this->qi . $secondKey . $this->qi;
        /** 
         * get the current content of the table
         */
        $sql = "select " . $k2 . " from " . $tablename . " where " . $k1 . " = :id:";
        $origin = array();
        $result = $this->executeQuery($sql, ["id" => $id]);
        if (!empty($result)) {
            foreach ($result as $row) {
                $origin[] = $row[$secondKey];
            }
        }
        if (is_null($data)) {
            $data = [];
        }

        /**
         * Get the values presents in the two arrays
         */
        $intersect = array_intersect($origin, $data);
        $delete = array_diff($origin, $intersect);
        $create = array_diff($data, $intersect);
        $param = array("id" => $id);
        if (count($delete) > 0) {
            $sql = "delete from " . $tablename . " where " . $k1 . " = :id: and " . $k2 . "= :key2:";
            foreach ($delete as $key2) {
                $param["key2"] = $key2;
                $this->executeQuery($sql, $param, true);
            }
        }
        if (count($create) > 0) {
            $sql = "insert into $tablename (" . $k1 . "," . $k2 . ") values ( :id:, :key2:)";
            foreach ($create as $key2) {
                $param["key2"] = $key2;
                $this->executeQuery($sql, $param, true);
            }
        }
    }
    function ecrireTableNN(string $tablename, string $firstKey, string $secondKey, int $id, $data = array()): void
    {
        $this->writeTableNN($tablename, $firstKey, $secondKey, $id, $data);
    }

    /**
     * Update a binary field
     *
     * @param int $id
     * @param string $fieldName
     * @param $data
     * @return 
     */
    function updateBinary(int $id, string $fieldName, $data)
    {
        $sql = "update " . $this->qi . $this->tablename . $this->qi .
            "set " . $this->qi . $fieldName . $this->qi .
            " = :data: where " . $this->key . " = :id:";
        return $this->executeQuery(
            $sql,
            [
                "data" => pg_escape_bytea($data),
                "id" => $id
            ]
        );
    }
    /**
     * Delete an item
     *
     * @param int $id
     * @param boolean $purge
     * @return void
     */
    function delete($id = null, bool $purge = false)
    {
        if (!parent::delete($id)) {
            throw new PpciException($this->db->error()["message"]);
        }
    }

    function supprimer($id)
    {
        $this->delete($id);
    }

    /**
     * Delete one ou multiple records in a table
     * Used to delete records in a child table
     * when field is the parent key
     *
     * @param integer $id
     * @param string $field
     * @return void
     */
    function deleteFromField(int $id, string $field)
    {
        $key = $this->qi . $field . $this->qi;
        $sql = "delete from " . $this->table . " where " . $key . "= :id:";
        $data["id"] = $id;
        $this->executeQuery($sql, $data, true);
    }
    function supprimerChamp(int $id, string $field)
    {
        $this->deleteFromField($id, $field);
    }

    /******************
     * Read functions *
     ******************/

    /**
     * Read a row, and return the data formatted
     * If the id is 0, return the default values
     *
     * @param integer $id
     * @param boolean $getDefault
     * @param integer $parentKey
     * @return array
     */
    public function read(int $id, bool $getDefault = true, $parentKey = 0): array
    {
        if ($getDefault) {
            if (empty($id) || $id == 0) {
                $data = $this->getDefaultValues($parentKey);
            } else {
                $data = $this->find($id);
                if (empty($data)) {
                    $data = $this->getDefaultValues($parentKey);
                }
            }
        }
        if ($this->autoFormatDate) {
            $data = $this->formatDatesToLocale($data);
        }
        return $data;
    }
    public function lire(int $id, bool $getDefault = true, $parentKey = 0): array
    {
        return $this->read($id, $getDefault, $parentKey);
    }

    public function readParam(string $sql, array $param = null)
    {
        $data = $this->getListParam($sql, $param);
        if (!empty($data)) {
            return $data[0];
        } else {
            return array();
        }
    }
    public function readParamAsPrepared(string $sql, array $param = null)
    {
        return $this->readParam($sql, $param);
    }
    public function lireParam(string $sql, array $param = null)
    {
        return $this->readParam($sql, $param);
    }
    public function lireParamAsPrepared(string $sql, array $param = null)
    {
        return $this->readParam($sql, $param);
    }
    /**
     * Get the default values for a record, if not exists
     *
     * @param integer $parentKey
     * @return array
     */
    public function getDefaultValues($parentKey = 0): array
    {
        $data = array();
        foreach ($this->defaultValues as $k => $v) {
            if ($v != 0 && method_exists($this, $v)) {
                $data[$k] = $this->{$v}();
            } else {
                $data[$k] = $v;
            }
        }
        /**
         * Search for parent key
         */
        if ($parentKey > 0) {
            $data[$this->parentKeyName] = $parentKey;
        }
        if ($this->autoFormatDate) {
            $data = $this->formatDatesToLocale($data);
        }
        return $data;
    }

    /**
     * Get the formated list of the datatable
     *
     * @param string $order
     * @return array
     */
    public function getList(string $order = ""): array
    {
        $sql = "select * from " . $this->qi . $this->table . $this->qi;
        if (!empty($order)) {
            $sql .= " order by $order";
        }
        return $this->getListParam($sql);
    }
    function getListe(string $order = ""): array
    {
        return $this->getList($order);
    }

    /**
     * Execute a request to get a list of records
     *
     * @param string $sql
     * @param array|null $param
     * @return array
     */
    function getListParam(string $sql, array $param = null): array
    {
        $result = array();
        $query = $this->db->query($sql, $param);
        if ($query) {
            $data = $query->getResult("array");
            if ($this->autoFormatDate) {
                foreach ($data as $row) {
                    $result[] = $this->formatDatesToLocale($row);
                }
            } else {
                $result = $data;
            }
        } else {
            throw new PpciException($this->db->error()["message"]);
        }
        return $result;
    }
    function getListeParam(string $sql, array $param = null): array
    {
        return $this->getListParam($sql, $param);
    }
    function getListeParamAsPrepared(string $sql, array $param = null): array
    {
        return $this->getListParam($sql, $param);
    }

    /**
     * Get the list of children for a parent record
     *
     * @param integer $parentId
     * @param string $order
     * @return array
     */
    function getListFromParent(int $parentId, $order = ""): array
    {
        if ($parentId > 0 && !empty($this->parentKeyName)) {
            $sql = "select * from " . $this->qi . $this->table . $this->qi .
                " where " . $this->qi . $this->parentKeyName . $this->qi . "= :id:";
            if (!empty($order)) {
                $sql .= " order by $order";
            }
            return $this->getListParam($sql, ["id" => $parentId]);
        } else {
            return array();
        }
    }

    /*******************
     * Dates functions *
     *******************/

    /**
     * Specify the locale format to use for dates fields
     *
     * @param string $dateFormatMask
     * @return void
     */
    public function setDateFormat(string $dateFormat)
    {
        $this->dateFormatMask = $dateFormat;
        $this->datetimeFormat = $dateFormat . " H:i:s";
    }
    /**
     * Get a record or, if not exists, get the default values
     *
     * @param integer $id
     * @param boolean $getDefault
     * @param integer $parentKey
     * @return array
     */
    /**
     * Format all date and datetime columns of a row in locale
     *
     * @param array $row
     * @return array
     */
    protected function formatDatesToLocale(array $row): array
    {
        foreach ($this->dateFields as $field) {
            if (!empty($row[$field])) {
                $date = date_create_from_format("Y-m-d H:i:s", $row[$field]);
                if ($date) {
                    $row[$field] = date_format($date, $this->dateFormatMask);
                }
            }
        }
        foreach ($this->datetimeFields as $field) {
            if (!empty($row[$field])) {
                $date = date_create_from_format("Y-m-d H:i:s", $row[$field]);
                if ($date) {
                    $row[$field] = date_format($date, $this->datetimeFormat);
                }
            }
        }
        return $row;
    }
    function formatDateLocaleToDB(string $value)
    {
        $newdate = "";
        $date = date_create_from_format($this->dateFormatMask, $value);
        if ($date) {
            $newdate = date_format($date, 'Y-m-d H:i:s');
        }
        return $newdate;
    }
    function formatDateTimeLocaleToDB(string $value)
    {
        $newdate = "";
        $date = date_create_from_format($this->datetimeFormat, $value);
        if ($date) {
            $newdate = date_format($date, 'Y-m-d H:i:s');
        }
        return $newdate;
    }
    function formatDateLocaleVersDB($value)
    {
        return $this->formatDateLocaleToDB($value);
    }
    /**
     * Format a date/time furnished by the database to the locale format
     *
     * @param string $value
     * @return string
     */
    function formatDateDBtoLocal(string $value)
    {
        $date = date_create_from_format("Y-m-d", $value);
        if ($date) {
            return date_format($date, $this->dateFormatMask);
        } else {
            return "";
        }
    }
    function formatDateDBversLocal(string $value)
    {
        return $this->formatDateDBtoLocal($value);
    }
    function formatDateTimeDBtoLocal(string $value)
    {
        $date = date_create_from_format("Y-m-d H:i:s", $value);
        if ($date) {
            return date_format($date, $this->datetimeFormat);
        } else {
            return "";
        }
    }
    function formatDatetimeDBversLocal(string $value)
    {
        return $this->formatDatetimeDBtoLocal($value);
    }
    function getBinaryField(int $id, string $fieldName)
    {
        $sql = "select " . $this->escapeField($fieldName) .
            " as binarycontent from " . $this->escapeField($this->table) .
            " where " . $this->escapeField($this->primaryKey) . " = :id:";
        $data = $this->executeQuery($sql, ["id" => $id]);
        if (!empty($data[0]["binarycontent"])) {
            return pg_unescape_bytea($data[0]["binarycontent"]);
        } else {
            return null;
        }
    }

    /**************************
     * Micellaneous functions *
     **************************/

    /**
     * Format all date and datetime columns from locale to database format
     *
     * @param array $row
     * @return array
     */
    protected function formatDatesToDB(array $row): array
    {
        foreach ($this->dateFields as $field) {
            if (!empty($row[$field])) {
                $date = date_create_from_format($this->dateFormatMask, $row[$field]);
                $row[$field] = date_format($date, "Y-m-d");
            }
        }
        foreach ($this->datetimeFields as $field) {
            if (!empty($row[$field])) {
                $date = date_create_from_format($this->datetimeFormat, $row[$field]);
                if ($date) {
                    $row[$field] = date_format($date, "Y-m-d H:i:s");
                }
            }
        }
        return $row;
    }
    function getUUID(): string
    {
        $sql = "select gen_random_uuid() as uuid";
        $res = $this->executeQuery($sql);
        return $res[0]["uuid"];
    }

    function getDateTime(): string
    {
        return date($this->datetimeFormat);
    }
    function getDateHeure(): string
    {
        return date($this->datetimeFormat);
    }
    function getDate(): string
    {
        return (date($this->dateFormatMask));
    }
    function getDateJour(): string
    {
        return (date($this->dateFormatMask));
    }

    /**
     * Disable a mandatory field before write
     *
     * @param string $name
     * @return void
     */
    function disableMandatoryField(string $name)
    {
        foreach ($this->mandatoryFields as $k => $v) {
            if ($name == $v) {
                unset($this->mandatoryFields[$k]);
                break;
            }
        }
    }

    /**
     * surround the name of a column or a table with "
     *
     * @param string $name
     * @return string
     */
    private function escapeField($name) {
        return $this->qi.$name.$this->qi;
    }
}
