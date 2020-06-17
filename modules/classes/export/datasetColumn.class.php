<?php
class DatasetColumn extends ObjetBDD
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
      "dataset_column_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
      "dataset_template_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
      "translator_id" => array("type" => 1),
      "column_name" => array("requis" => 1),
      "export_name" => array("requis" => 1),
      "metadata_name" => array("type" => 0)
    );
    parent::__construct($bdd, $param);
  }
}
