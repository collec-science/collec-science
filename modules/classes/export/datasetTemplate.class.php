<?php
class DatasetTemplate extends ObjetBDD
{
  private $sql = "select dataset_template_id, dataset_template_name, export_format_id, dataset_type_id, 
                  only_last_document, separator,
                  dataset_type_name, export_format_name
                  ,fields
                  from dataset_template
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
    return $this->getListeParam($this->sql . $order);
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
    return $this->lireParamAsPrepared($this->sql . $where, array("id" => $id));
  }
}
