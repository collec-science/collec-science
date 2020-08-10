<?php
class DatasetTemplate extends ObjetBDD
{
  private $sql = "select dataset_template_id, dataset_template_name, export_format_id, dataset_type_id, 
                  only_last_document, separator,
                  dataset_type_name, export_format_name, filename
                  ,xmlroot, xmlnodename
                  ,fields";
  private $from = " from dataset_template
                  join dataset_type using (dataset_type_id)
                  join export_format using (export_format_id)";
  public $classPath = "modules/classes/";
  public $classPathExport = "modules/classes/export/";
  public $datasetColumn, $sample, $collection, $document;
  private $content, $currentId;
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
      "xmlnodename" => array("type" => 0, "defaultValue" => "sample")
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
    if (strlen($order) > 0) {
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
    $data = array(); // Contains all data to export, with transformation
    $dbdata = array(); // Data extracted from database before transformation
    if (!is_object($this->datasetColumn)) {
      include_once $this->classPathExport . "datasetColumn.class.php";
      $this->datasetColumn = new DatasetColumn($this->connection, $this->paramori);
    }
    $columns = $this->datasetColumn->getListColumns($ddataset["dataset_template_id"]);
    $webmodule = "";
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
        $webmodule = "documentGetSW";
        if (!is_object($this->document)) {
          include_once $this->classPath . "document.class.php";
          $this->document = new Document($this->connection, $this->paramori);
          $dbdata = $this->document->getDocumentsFromUid($uids, $ddataset["only_last_document"]);
        }
        break;
    }
    /**
     * Treatment of each row
     */
    foreach ($dbdata as $dbrow) {
      $row = array();
      /**
       * Treatment of each column
       */
      foreach ($columns as $colname => $col) {
        if (strlen($col["metadata_name"]) > 0) {
          $md = json_decode($dbrow[$colname], true);
          $value = $md[$col["metadata_name"]];
        } else {
          $value = $dbrow[$colname];
        }
        if ($col["translator_id"] > 0) {
          if (strlen($col["translations"][$value]) > 0) {
            $value = $col["translations"][$value];
          }
        }
        if (strlen($col["default_value"]) > 0 && strlen($value) == 0) {
          $value = $col["default_value"];
        }
        if (strlen($col["date_format"]) > 0 && strlen($value) > 0) {
          $value = date_format(date_create($value), $col["date_format"]);
        }
        if ($colname == "web_address") {
          /**
           * Create a link to download the content of the record
           */
          $value = "https://" . $_SERVER["HTTP_HOST"] . "/index.php?module=" . $webmodule . "&uuid=" . $dbrow["uuid"];
        }
        if ($col["mandatory"] == 1 && strlen($value) == 0) {
          throw new ExportException(sprintf(_("Le champ %1s est obligatoire, mais est vide pour l'échantillon %2s"), $colname, $dbrow["uid"]));
        }
        $row[$col["export_name"]] = $value;
      }
      $data[] = $row;
    }
    return $data;
  }
}
