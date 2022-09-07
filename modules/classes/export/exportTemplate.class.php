<?php
class ExportTemplate extends ObjetBDD
{
  /**
   * Constructor
   *
   * @param PDO $bdd: connection to the database
   * @param array $param: specific parameters
   */
  function __construct(PDO $bdd, $param = array())
  {
    $this->table = "export_template";
    $this->colonnes = array(
      "export_template_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
      "export_template_name" => array("type" => 0, "requis" => 1),
      "export_template_description" => array("type" => 0),
      "export_template_version" => array("type" => 0),
      "is_zipped" => array("type"=>0),
      "filename" => array("type"=>0, "requis"=>1, "defaultValue"=>"cs-export.csv")
    );
    parent::__construct($bdd, $param);
  }

  /**
   * Overload of getListe to add the list of embedded datasets
   *
   * @param any $order
   * @return array
   */
  function getListe($order="")
  {
    $data = parent::getListe($order);
    /**
     * Get the list of datasets
     */
    foreach ($data as $key => $row) {
      $datasets = $this->getListDatasets($row["export_template_id"]);
      $ds = "";
      $comma = "";
      $is_comma = false;
      foreach ($datasets as $dataset) {
        $ds .= $comma. $dataset["dataset_template_name"] ;
        if (!$is_comma) {
          $comma = ", ";
          $is_comma = true;
        }
      }
      $data[$key]["datasets"] = $ds;
    }
    return $data;
  }
  /**
   * Get the list of datasets attached to a template export
   *
   * @param [type] $id
   * @return array
   */
  function getListDatasets($id)
  {
    $sql = "select dataset_template_id, dataset_template_name
            from export_dataset
            join dataset_template using (dataset_template_id)
            where export_template_id = :id
            order by dataset_template_name";
    return $this->getListeParamAsPrepared($sql, array("id" => $id));
  }

  /**
   * Overload of ecrire to write the datasets attached to the template
   *
   * @param array $data
   * @return int
   */
  function ecrire($data) {
    $id = parent::ecrire($data);
    if ($id > 0) {
      $this->ecrireTableNN("export_dataset", "export_template_id", "dataset_template_id", $id, $data["dataset"]);
    }
    return $id;
  }
}
