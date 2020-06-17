<?php
class ExportFormat extends ObjetBDD
{
  /**
   * Constructor
   *
   * @param PDO $bdd: connection to the database
   * @param array $param: specific parameters
   */
  function __construct(PDO $bdd, $param = array())
  {
    $this->table = "export_format";
    $this->colonnes = array(
      "export_format_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
      "export_format_name" => array("type" => 0, "requis" => 1)
    );
    parent::__construct($bdd, $param);
  }
}
