<?php
namespace App\Models;
use Ppci\Models\PpciModel;
/**
 * ORM of the table export_model
 */
class ExportModel extends PpciModel
{
  /**
   * Class constructor.
   */
  public function __construct()
  {
    $this->table = "export_model";
    $this->fields = array(
      "export_model_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
      "export_model_name" => array("type" => 0, "requis" => 1),
      "pattern" => array("type" => 0),
      "target" => array("type" => 0)
    );

    parent::__construct();
  }
  /**
   * Get a model from his name
   *
   * @param string $name
   * @return array
   */
  function getModelFromName(string $name): ?array
  {
    $sql = "select export_model_id, export_model_name, pattern, target from export_model
                where export_model_name = :name";
    return $this->lireParamAsPrepared($sql, array("name" => $name));
  }
  /**
   * Get the list of models of export associated to a target
   *
   * @param string $target
   * @return array|null
   */
  function getListFromTarget(string $target): ?array
  {
    $sql = "select export_model_id, export_model_name, target
                from export_model
                where target = :target";
    return $this->getListeParamAsPrepared($sql, array("target" => $target));
  }
}
