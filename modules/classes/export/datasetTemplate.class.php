<?php
class DatasetTemplateException extends Exception
{
}
class DatasetTemplate extends ObjetBDD
{
    private $sql = "select dataset_template_id, dataset_template_name, export_format_id, dataset_type_id,
                  only_last_document, separator,
                  dataset_type_name, export_format_name, filename
                  ,xmlroot, xmlnodename, xslcontent
                  ,fields";
    private $from = " from dataset_template
                  join dataset_type using (dataset_type_id)
                  join export_format using (export_format_id)";
    public $classPath = "modules/classes/";
    public $classPathExport = "modules/classes/export/";
    public $datasetColumn, $sample, $collection, $document;
    private $content, $currentId;
    private $columns = array(), $columnsByExportName = array();
    /**
     * Constructor
     *
     * @param PDO $bdd: connection to the database
     * @param array $param: specific parameters
     */
    function __construct(PDO $bdd, $param = array())
    {
        $this->table = "dataset_template";
        $this->colonnes = array(
            "dataset_template_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "dataset_template_name" => array("type" => 0, "requis" => 1),
            "export_format_id" => array("type" => 1, "requis" => 1),
            "dataset_type_id" => array("type" => 1, "requis" => 1),
            "only_last_document" => array("type" => 0, "defaultValue" => "0"),
            "separator" => array("type" => 0, "defaultValue" => ";"),
            "filename" => array("type" => 0, "requis" => 1, "defaultValue" => "cs-export.csv"),
            "xmlroot" => array("type" => 0, "defaultValue" => '<?xml version="1.0"?><samples></samples>'),
            "xmlnodename" => array("type" => 0, "defaultValue" => "sample"),
            "xslcontent" => array("type" => 0)
        );
        parent::__construct($bdd, $param);
    }
    /**
     * overload of getListe
     *
     * @param string $order
     * @return void
     */
    function getListe($order = "")
    {
        if (!empty($order)) {
            $order = " order by " . $order;
        }
        return $this->getListeParam($this->sql . $this->from . $order);
    }
    /**
     * Get the list of datasets attached or not to the exportTemplate.
     *
     * @param integer $id
     * @param boolean $onlyAttached
     * @return void
     */
    function getListFromExportTemplate(int $id)
    {
        $req1 = "select dataset_template_id from export_dataset where export_template_id = :id";
        $req = $this->sql . ",0 as export_template_id " . $this->from . " order by dataset_template_name";
        $data = $this->getListeParam($req);
        $data1 = $this->getListeParamAsPrepared($req1, array("id" => $id));
        $selected = array();
        foreach ($data1 as $row) {
            $selected[] = $row["dataset_template_id"];
        }
        foreach ($data as $key => $row) {
            if (in_array($row["dataset_template_id"], $selected)) {
                $data[$key]["export_template_id"] = $id;
            }
        }
        return ($data);
    }

    /**
     * Get the content of a datasetTemplate
     *
     * @param int $id
     * @return array
     */
    function getDetail(int $id)
    {
        if ($id != $this->currentId) {
            $where = " where dataset_template_id = :id";
            $this->content = $this->lireParamAsPrepared($this->sql . $this->from . $where, array("id" => $id));
            $this->currentId = $id;
        }
        return $this->content;
    }

    /**
     * Generate the data for the uids with the format described into the template
     *
     * @param integer $id
     * @param string $uids
     * @return array
     */
    function generateData(int $id, string $uids): array
    {
        $ddataset = $this->getDetail($id);
        $dbdata = array(); // Data extracted from database before transformation
        switch ($ddataset["dataset_type_id"]) {
            case 1:
                /**
                 * Samples
                 */
                if (!is_object($this->sample)) {
                    include_once $this->classPath . "sample.class.php";
                    $this->sample = new Sample($this->connection, $this->paramori);
                }
                $this->sample->auto_date = 0;
                $dbdata = $this->sample->getListFromUids($uids);
                /**
                 * Add the content_type by default for the web service
                 */
                foreach ($dbdata as $k => $v) {
                    $v["content_type"] = "application/json";
                    $dbdata[$k] = $v;
                }
                break;
            case 2:
                /**
                 * Collection
                 */
                if (!is_object($this->collection)) {
                    include_once $this->classPath . "collection.class.php";
                    $this->collection = new Collection($this->connection, $this->paramori);
                }
                $this->collection->auto_date = 0;
                $dbdata = $this->collection->getCollectionFromUids($uids);
                break;
            case 3:
                /**
                 * Documents
                 */
                if (!is_object($this->document)) {
                    include_once $this->classPath . "document.class.php";
                    $this->document = new Document($this->connection, $this->paramori);
                    $dbdata = $this->document->getDocumentsFromUid($uids, $ddataset["only_last_document"]);
                }
                break;
        }
        return $this->formatData($dbdata);
    }

    function formatData(array $dbdata): array
    {
        $data = array();
        $ddataset = $this->content;
        if (empty($ddataset)) {
            throw new DatasetTemplateException(_("Le modèle d'export n'a pas été correctement initialisé"));
        }
        if (!is_object($this->datasetColumn)) {
            include_once $this->classPathExport . "datasetColumn.class.php";
            $this->datasetColumn = new DatasetColumn($this->connection, $this->paramori);
        }
        $columns = $this->datasetColumn->getListColumns($ddataset["dataset_template_id"]);
        $webmodule = "";
        $template_name = "";
        switch ($ddataset["dataset_type_id"]) {
            case 1:
                $webmodule = "sampleDetail";
                $template_name = $ddataset["dataset_template_name"];
                break;
            case 3:
                $webmodule = "documentGetSW";
                break;
        }
        if ($ddataset["dataset_type_id"] == 4) {
            $data[] = $columns[0]["default_value"];
        } else {
            /**
             * Treatment of each row
             */
            foreach ($dbdata as $dbrow) {
                $row = array();
                $metadata_schema = json_decode($dbrow["metadata_schema"], true);
                /**
                 * Treatment of each column
                 */
                foreach ($columns as $col) {
                    $value = "";
                    if (!empty($col["subfield_name"])) {
                        if ($col["column_name"] == "metadata") {
                            if (!is_array($dbrow["metadata"])) {
                                $md = json_decode($dbrow["metadata"], true);
                            } else {
                                $md = $dbrow["metadata"];
                            }
                            if (is_array($md[$col["subfield_name"]])) {
                                $isFirst = true;
                                foreach ($md[$col["subfield_name"]] as $mdval) {
                                    $isFirst ? $isFirst = false : $value .= ",";
                                    $value .= $mdval;
                                }
                            } else {
                                $value = $md[$col["subfield_name"]];
                            }
                        } elseif ($col["column_name"] == "metadata_unit") {
                            foreach ($metadata_schema as $ms) {
                                if ($ms["name"] == $col["subfield_name"]) {
                                    $value = $ms["measureUnit"];
                                    break;
                                }
                            }
                        } elseif ($col["column_name"] == "identifiers" || $col["column_name"] == "parent_identifiers") {
                            /**
                             * The structure is under the form:
                             * igsn:123,other:456
                             * subfield_name contains igsn or other
                             */
                            $identArr = explode(",", $dbrow[$col["column_name"]]);
                            foreach ($identArr as $identifier) {
                                $idArr = explode(":", $identifier);
                                if ($idArr[0] == $col["subfield_name"]) {
                                    $value = $idArr[1];
                                }
                            }
                        }
                    } else {
                        $value = $dbrow[$col["column_name"]];
                    }
                    if ($col["translator_id"] > 0 && !empty($col["translations"][$value])) {
                        $value = $col["translations"][$value];
                    }
                    if (!empty($col["default_value"]) && empty($value)) {
                        $value = $col["default_value"];
                    }
                    /**
                     * Treatment of keywords
                     */
                    if ($col["column_name"] == "collection_keywords" && !empty($value)) {
                        $words = explode(",", $value);
                        $value = array();
                        foreach ($words as $word) {
                            $value[] = array("keyword" => $word);
                        }
                    }
                    if (!empty($col["date_format"]) && !empty($value)) {
                        $value = date_format(date_create($value), $col["date_format"]);
                    }
                    if ($col["column_name"] == "web_address" && !empty($webmodule)) {
                        /**
                         * Create a link to download the content of the record
                         */
                        $value = "https://" . $_SERVER["HTTP_HOST"] . "/index.php?module=" . $webmodule . "&uuid=" . $dbrow["uuid"];
                        if (!empty($template_name)) {
                            $value .= "&template_name=$template_name";
                        }
                    }
                    if ($col["mandatory"] == 1 && empty($value)) {
                        if ($col["column_name"] == "metadata" || $col["column_name"] == "metadata_unit") {
                            $subfield = $col["subfield_name"];
                        } else {
                            $subfield = "";
                        }
                        throw new DatasetTemplateException(sprintf(_("Le champ %1\$s %3\$s est obligatoire, mais est vide pour l'échantillon %2\$s"), $col["column_name"], $dbrow["uid"], $subfield));
                    }
                    $row[$col["export_name"]] = $value;
                }
                $data[] = $row;
            }
        }
        return $data;
    }
    /**
     * Get the datasetTemplate from its name
     *
     * @param string $name
     * @return array
     */
    function getTemplateFromName(string $name): array
    {
        $sql = "select dataset_template_id from dataset_template where dataset_template_name = :name";
        $res = $this->lireParamAsPrepared($sql, array("name" => $name));
        if ($res["dataset_template_id"] > 0) {
            return $this->getDetail($res["dataset_template_id"]);
        } else {
            throw new DatasetTemplateException(sprintf(_("Le modèle %s n'existe pas"), $name));
        }
    }
    /**
     * Delete a record with its children
     *
     * @param int $id
     * @return void
     */
    function supprimer($id)
    {
        if (!isset($this->datasetColumn)) {
            include_once $this->classPathExport . "datasetColumn.class.php";
            $this->datasetColumn = new DatasetColumn($this->connection, $this->paramori);
        }
        $this->datasetColumn->supprimerChamp($id, "dataset_template_id");
        parent::supprimer($id);
    }

    function duplicate(int $id)
    {
        $data = $this->lire($id);
        if (empty($data["dataset_template_id"])) {
            throw new DatasetTemplateException(_("Impossible de lire le modèle à dupliquer"));
        }
        /**
         * prepare the new data
         */
        $data["dataset_template_id"] = 0;
        $data["dataset_template_name"] = "copy of " . $data["dataset_template_name"];
        $newid = $this->ecrire($data);
        if (!is_object($this->datasetColumn)) {
            include_once $this->classPathExport . "datasetColumn.class.php";
            $this->datasetColumn = new DatasetColumn($this->connection, $this->paramori);
        }
        /**
         * Copy the columns
         */
        $columns = $this->datasetColumn->getListColumns($id);
        foreach ($columns as $column) {
            $column ["dataset_column_id"] = 0;
            $column["dataset_template_id"] = $newid;
            $this->datasetColumn->ecrire($column);
        }
        return $newid;
    }
    /**
     * initialize the columns of the dataset template, for import
     *
     * @param [type] $dataset_template_id
     * @return void
     */
    private function getColumns($dataset_template_id)
    {
        if ($dataset_template_id != $this->currentId) {
            $this->columns = array();
            $this->columnsByExportName = array();
            if (!is_object($this->datasetColumn)) {
                include_once $this->classPathExport . "datasetColumn.class.php";
                $this->datasetColumn = new DatasetColumn($this->connection, $this->paramori);
            }
            $columns = $this->datasetColumn->getListColumns($dataset_template_id);
            foreach ($columns as $column) {
                /**
                 * reverse the translator
                 */
                foreach ($column["translations"] as $k => $v) {
                    $column["translations_reverse"][$v] = $k;
                }
                $this->columnsByExportName[$column["export_name"]] = $column;
                $this->columns[$column["column_name"]] = $column;
            }
        }
    }
    /**
     * Get the order of fields to search sample
     *
     * @param int $dataset_template_id
     * @return array
     */
    function getSearchOrder(int $dataset_template_id): array
    {
        $this->getColumns($dataset_template_id);
        $this->currentId = $dataset_template_id;
        $searchOrder = array();
        foreach ($this->columns as $col) {
            if (!empty($col["search_order"])) {
                $searchOrder[$col["search_order"]] = $col["column_name"];
            }
        }
        ksort($searchOrder);
        $so = array();
        foreach ($searchOrder as $val) {
            $so[] = $val;
        }
        return $so;
    }
    /**
     * Format data for import, with the dataset_template
     *
     * @param integer $dataset_template_id
     * @param [type] $dataset
     * @return array
     */
    function formatDataForImport(int $dataset_template_id, $dataset): array
    {
        $data = array();
        $this->getColumns($dataset_template_id);
        foreach ($dataset as $key => $value) {
            if (!empty($this->columnsByExportName[$key])) {
                $cbe = $this->columnsByExportName[$key];
                if (!empty($cbe["translations_reverse"][$value])) {
                    $value = $cbe["translations_reverse"][$value];
                }
                if (empty($cbe["subfield_name"])) {
                    $data[$cbe["column_name"]] = $value;
                } else {
                    /**
                     * metadata
                     */
                    if ($cbe["column_name"] == "metadata") {
                        $data["md_" . $cbe["subfield_name"]] = $value;
                    } else {
                        /**
                         * Secondary identifier
                         */
                        if ($cbe["column_name"] == "parent_identifiers") {
                            $data["parent_" . $cbe["subfield_name"]] = $value;
                        } else {
                            $data[$cbe["subfield_name"]] = $value;
                        }
                    }
                }
            }
        }
        return $data;
    }
    /**
     * Get the key of a dataset_template from its name
     *
     * @param string $name
     * @return array
     */
    function getFromName(string $name): array
    {
        $sql = "select * from dataset_template
            where dataset_template_name = :name";
        return $this->lireParamAsPrepared($sql, array("name" => $name));
    }
}
