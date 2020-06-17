<?php
class Lot extends ObjetBDD
{
  /**
   * Constructor
   *
   * @param PDO $bdd: connection to the database
   * @param array $param: specific parameters
   */
  function __construct(PDO $bdd, $param = array())
  {
    $this->table = "lot";
    $this->colonnes = array(
      "lot_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
      "collection_id" => array("type" => 1, "requis" => 1),
      "lot_date" => array("type" => 3, "defaultValue" => "getDateHeure")
    );
    parent::__construct($bdd, $param);
  }
}
