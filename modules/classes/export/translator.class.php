<?php
class Translator extends ObjetBDD
{
  /**
   * Constructor
   *
   * @param PDO $bdd: connection to the database
   * @param array $param: specific parameters
   */
  function __construct(PDO $bdd, $param = array())
  {
    $this->table = "translator";
    $this->colonnes = array(
      "translator_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
      "translator_name" => array("type" => 0, "requis" => 1),
      "translator_data"=>array("type"=>0)
    );
    parent::__construct($bdd, $param);
  }
}