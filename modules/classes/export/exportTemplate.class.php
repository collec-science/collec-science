<?php
class ExportTemplate extends ObjetBDD
{
  /**
   * Constructor
   *
   * @param PDO $bdd: connection to the database
   * @param array $param: specific parameters
   */
  function __construct(PDO $bdd, $param = array())
  {
    $this->table = "";
    $this->colonnes = array(
      "" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
      "" => array("type" => 0, "requis" => 1)
    );
    parent::__construct($bdd, $param);
  }
}