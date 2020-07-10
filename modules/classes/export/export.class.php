<?php
class ExportException extends Exception
{ }

class Export extends ObjetBDD
{
  private $sql = "select export_id, lot_id, export_date, export_template_id
                  , export_template_name
                  from export
                  join lot using (lot_id)
                  join export_template using (export_template_id)";
  public $classPath = "modules/classes/";
  public $classPathExport = "modules/classes/export/";
  public $sample, $lot, $exportTemplate, $datasetTemplate, $datasetColumn;

  /**
   * Constructor
   *
   * @param PDO $bdd: connection to the database
   * @param array $param: specific parameters
   */
  function __construct(PDO $bdd, $param = array())
  {
    $this->table = "export";
    $this->colonnes = array(
      "export_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
      "lot_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
      "export_date" => array("type" => 3, "defaultValue" => "getDateHeure"),
      "export_template_id" => array("type" => 1, "requis" => 1)
    );
    parent::__construct($bdd, $param);
  }
  /**
   * Get the list of exports attached to a lot
   *
   * @param integer $lot_id
   * @return array
   */
  function getListFromLot($lot_id)
  {
    $where = " where lot_id = :id";
    return $this->getListeParamAsPrepared($this->sql . $where, array("id" => $lot_id));
  }

  function generate($export_id)
  {
    global $APPLI_temp;
    $dexport = $this->lire($export_id);
    /**
     * Get the list of dataset templates
     */
    if (!is_object($this->exportTemplate)) {
      include_once $this->classPathExport . "exportTemplate.class.php";
      $this->exportTemplate = new ExportTemplate($this->connection, $this->paramori);
    }
    $dtemplate = $this->exportTemplate->lire($dexport["export_template_id"]);
    $datasets = $this->exportTemplate->getListDatasets($dexport["export_template_id"]);
    /**
     * Get list of uids
     */
    if (!is_object($this->lot)) {
      include_once $this->classPathExport . "lot.class.php";
      $this->lot = new Lot($this->connection, $this->paramori);
    }
    $uids = $this->lot->getUidsAsString($dexport["lot_id"]);
    /**
     * Traitement des datasets
     */
    if (!is_object($this->datasetTemplate)) {
      include_once $this->classPathExport . "datasetTemplate.class.php";
      $this->datasetTemplate = new DatasetTemplate($this->connection, $this->paramori);
    }
    if (!is_object($this->datasetColumn)) {
      include_once $this->classPathExport . "datasetColumn.class.php";
      $this->datasetColumn = new DatasetColumn($this->connection, $this->paramori);
    }
    /**
     * $files: list of generated files. Array with these fields
     * filetmp: name of temporary file in the system
     * filename: name of the file to send
     * filetype: type of the file (CSV, JSON, XML)
     */
    $files = array();
    foreach ($datasets as $dataset) {
      $ddataset = $this->datasetTemplate->getDetail($dataset["dataset_template_id"]);
      $data = array(); // Contains all data to export, with transformation
      $dbdata = array(); // Data extracted from database before transformation
      $columns = $this->datasetColumn->getListColumns($ddataset["dataset_template_id"]);
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
          break;
        case 3:
          /**
           * Documents
           */
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
          $value = $dbrow[$colname];
          if ($col["translator_id"] > 0) {
            $value = $col["translations"][$value];
          }
          if (strlen($col["date_format"]) > 0 && strlen($value) > 0) {
            $value = date_format(date_create($value), $col["date_format"]);
          }
          if ($col["mandatory"] == 1 && strlen($value) == 0) {
            throw new ExportException(sprintf(_("Le champ %1s est obligatoire, mais est vide pour l'échantillon %2s"), $colname, $dbrow["uid"]));
          }
          $row[$col["export_name"]] = $value;
        }
        $data[] = $row;
      }
      /**
       * Generate the file
       */
      $filetmp = tempnam($APPLI_temp, $ddataset["export_format_name"]);
      $handle = fopen($filetmp, 'w');
      switch ($ddataset["export_format_name"]) {
        case "CSV":
          $delimiter = $ddataset["separator"];
          if ($delimiter == "tab") {
            $delimiter = "\t";
          }
          /** first line, header */
          fputcsv($handle, array_keys($this->data[0]), $delimiter);
          foreach ($this->data as $value) {
            fputcsv($handle, $value, $delimiter);
          }
          break;
        case "JSON":
          fwrite($handle, json_encode($data));
          break;
        case "XML":
          $xml = new SimpleXMLElement($ddataset["xmlroot"]);
          to_xml($xml, $data, $ddataset["xmlnodename"]);
          $xml::asXML($filetmp);
          break;
        default:
          throw new ExportException(_("Impossible de générer le fichier, le type est inconnu ou non spécifié"));
      }
      fclose($handle);
      $files[] = array("filetmp" => $filetmp, "filename" => $ddataset["filename"], "filetype" => $ddataset["export_format_name"]);
    }
    /**
     * If zipped, generate the zip file
     */
  }

  /**
   * Generate a xml content
   *
   * @param SimpleXMLElement $object
   * @param array $data
   * @param string $nodename: name of the node for each row
   * @return void
   */
  function to_xml(SimpleXMLElement $object, array $data, $nodename = "sample")
  {
    foreach ($data as $key => $value) {
      if (is_array($value)) {
        $new_object = $object->addChild($key);
        to_xml($new_object, $value, $nodename);
      } else {
        /**
         * Transform each row to a $nodename object
         */
        if ($key == (int) $key) {
          $key = $nodename;
        }

        $object->addChild($key, $value);
      }
    }
  }
}
