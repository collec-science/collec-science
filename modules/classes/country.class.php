<?php
/**
 * ORM of the table country
 */
class Country extends ObjetBDD
{

  function __construct($bdd, $param = array())
  {
    $this->table = "country";
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
  /**
   * Get the id of the country from its name
   *
   * @param string $name
   * @return integer|null
   */
  function getIdFromName(string $name) :?int {
    $sql = "select country_id from country where lower(country_name) = lower (:name)";
    $data = $this->lireParamAsPrepared($sql, array("name"=>$name));
    if ($data["country_id"] > 0) {
      return $data["country_id"];
    } else {
      return null;
    }
  }
}
