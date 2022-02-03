<?php

/**
 * ORM for table barcode
 */
class Barcode extends ObjetBDD
{
  /**
   *
   * @param PDO $bdd
   * @param array $param
   */
  function __construct(PDO $bdd, $param = array())
  {
    $this->table = "barcode";
    $this->colonnes = array(
      "barcode_id" => array(
        "type" => 1,
        "key" => 1,
        "requis" => 1,
        "defaultValue" => 0
      ),
      "barcode_name" => array(
        "type" => 0,
        "requis" => 1
      ),
      "barcode_code" => array(
        "type" => 0,
        "requis" => 1
      )
    );
    parent::__construct($bdd, $param);
  }
}
