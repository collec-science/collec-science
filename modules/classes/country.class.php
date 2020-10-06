<?php
/**
 * ORM of the table country
 */
class Country extends ObjetBDD
{

  function __construct($bdd, $param = array())
  {
    $this->table = "container_type";
    $this->colonnes = array(
      "country_id" => array(
        "type" => 1,
        "key" => 1,
        "requis" => 1,
        "defaultValue" => 0
      ),
      "country_name" => array(
        "type" => 0,
        "requis" => 1
      ),
      "country_code2" => array("type" => 0, "requis" => 1),
      "country_code3" => array("type" => 0)
    );
    parent::__construct($bdd, $param);
  }
/**
 * Get the id of the country from its code (on 2 or 3 positions)
 *
 * @param string $code
 * @param integer $codelength
 * @return integer|null
 */
  function getIdFromCode(string $code, int $codelength = 2) :?int {
    $sql = "select country_id from country where upper(country_code$codelength) = upper (:code)";
    $data = $this->lireParamAsPrepared($sql, array("code"=>$code));
    if ($data["country_id"] > 0) {
      return $data["country_id"];
    } else {
      return null;
    }
  }
}
