<?php
class DatasetColumn extends ObjetBDD
{
  /**
   * Constructor
   *
   * @param PDO $bdd: connection to the database
   * @param array $param: specific parameters
   */
  function __construct(PDO $bdd, $param = array())
  {
    $this->table = "dataset_column";
    $this->colonnes = array(
      "dataset_column_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
      "dataset_template_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
      "translator_id" => array("type" => 1),
      "column_name" => array("requis" => 1),
      "export_name" => array("requis" => 1),
      "metadata_name" => array("type" => 0),
      "order" => array("type" => 1, "defaultValue" => 1)
    );
    parent::__construct($bdd, $param);
  }
  /**
   * overload of lire to calculate the last order
   *
   * @param integer $id
   * @param boolean $getDefault
   * @param integer $parentValue
   * @return void
   */
  function lire(int $id, $getDefault = true, int $parentValue = 0)
  {
    test($id);
    if ($id == 0) {
      $data = $this->getDefaultValue($parentValue);
      /**
       * Search for last order
       */
      $sql = "select count(*) as number from dataset_column where dataset_template_id = :parent";
      $res = $this->lireParamAsPrepared($sql, array("parent" => $parentValue));
      if (!$res["number"] > 0) {
        $res["number"] = 1;
      }
      $data["order"] = $res["number"] * 10;
      printr($data);
      return ($data);
    } else {
      return $this->lire($id);
    }
  }
  function getListFromParent($parentId, $order = "")
  { }
}
