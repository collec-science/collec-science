<?php
class DatasetColumn extends ObjetBDD
{
  private $sql = "select dataset_column_id, dataset_template_id, translator_id,
                  column_name, export_name, metadata_name, column_order, mandatory,
                  translator_name
                  from dataset_column
                  left outer join translator using (translator_id)";
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
      "column_order" => array("type" => 1, "defaultValue" => 1),
      "mandatory" => array("type"=>1, "defaultValue"=>0)
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
    if ($id == 0) {
      $data = $this->getDefaultValue($parentValue);
      /**
       * Search for last order
       */
      $sql = "select count(*) as number from dataset_column where dataset_template_id = :parent";
      $res = $this->lireParamAsPrepared($sql, array("parent" => $parentValue));
      if (!$res["number"] > 0) {
        $res["number"] = 0;
      }
      $data["column_order"] = ($res["number"] + 1) * 10;
      return ($data);
    } else {
      return parent::lire($id);
    }
  }
  /**
   * Overload of getListFromParent to get the name of the translator
   *
   * @param int $parentId
   * @param string $order
   * @return array
   */
  function getListFromParent($parentId, $order = "")
  {
    $where = " where dataset_template_id = :parentId";
    if (strlen($order) > 0) {
      $order = " order by $order";
    }
    return $this->getListeParamAsPrepared($this->sql . $where . $order, array("parentId" => $parentId));
  }
}
