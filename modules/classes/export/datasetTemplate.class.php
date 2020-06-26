<?php
class DatasetTemplate extends ObjetBDD
{
  private $sql = "select dataset_template_id, dataset_template_name, export_format_id, dataset_type_id, 
                  only_last_document, separator,
                  dataset_type_name, export_format_name
                  ,fields";
  private $from = " from dataset_template
                  join dataset_type using (dataset_type_id)
                  join export_format using (export_format_id)";
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
      "separator" => array("type" => 0, "defaultValue" => ";")
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
        $data[$key]["dataset_template_id"] = $id;
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
  function getDetail($id)
  {
    $where = " where dataset_template_id = :id";
    return $this->lireParamAsPrepared($this->sql . $this->from . $where, array("id" => $id));
  }
}
