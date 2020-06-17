<?php
class Export extends ObjetBDD
{
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
}
