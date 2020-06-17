<?php
class DatasetTemplate extends ObjetBDD
{
  /**
   * Constructor
   *
   * @param PDO $bdd: connection to the database
   * @param array $param: specific parameters
   */
  function __construct(PDO $bdd, $param = array())
  {
    $this->table = "dataset_template";
    $this->colonnes = array(
      "dataset_template_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
      "dataset_template_name" => array("type" => 0, "requis" => 1),
      "export_format_id" => array("type" => 1, "requis" => 1),
      "dataset_type_id" => array("type" => 1, "requis" => 1),
      "only_last_document" => array("type" => 0, "defaultValue" = "0"),
      "separator" => array("type" => 0, "defaultValue" => ";")
    );
    parent::__construct($bdd, $param);
  }
}
