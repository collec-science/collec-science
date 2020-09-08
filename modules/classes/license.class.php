<?php
class License extends ObjetBDD
{
  /**
   *
   * @param PDO $bdd
   * @param array $param
   */
  function __construct($bdd, $param = array())
  {
    $this->table = "license";
    $this->colonnes = array(
      "license_id" => array(
        "type" => 1,
        "key" => 1,
        "requis" => 1,
        "defaultValue" => 0
      ),
      "license_name" => array(
        "type" => 0,
        "requis" => 1
      ),
      "license_url" => array(
        "type" => 0,
        "requis" => 0
      )
    );
    parent::__construct($bdd, $param);
  }
}
