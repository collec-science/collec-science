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
    $this->table = "";
    $this->colonnes = array(
      "" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
      "" => array("type" => 0, "requis" => 1)
    );
    parent::__construct($bdd, $param);
  }

  /**
   * Overload of getListe to add the list of embedded datasets
   *
   * @param any $order
   * @return array
   */
  function getListe($order)
  {
    $data = parent::getListe($order);
    /**
     * Get the list of datasets
     */
    foreach ($data as $key => $row) {
      $datasets = $this->getListDatasets($row["dataset_template_id"]);
      $ds = "";
      foreach ($datasets as $dataset) {
        $ds .= $dataset["datset_template_name"] . " ";
      }
      $data[$key]["datasets"] = $ds;
    }
    return $data;
  }
  /**
   * Get the list of datasets attached to a template export
   *
   * @param [type] $id
   * @return void
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
}
