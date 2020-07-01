<?php
class Export extends ObjetBDD
{
  private $sql = "select export_id, lot_id, export_date, export_template_id
                  , export_template_name
                  from export
                  join lot using (lot_id)
                  join export_template using (export_template_id)";
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
  function getListFromLot($lot_id) {
    $where = " where lot_id = :id";
    return $this->getListeParamAsPrepared($this->sql.$where, array("id"=>$lot_id));
  }
}
