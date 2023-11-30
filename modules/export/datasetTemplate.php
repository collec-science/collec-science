<?php
include_once 'modules/classes/export/datasetTemplate.class.php';
$dataClass = new DatasetTemplate($bdd, $ObjetBDDParam);
$keyName = "dataset_template_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
  case "list":
    /*
		 * Display the list of all records of the table
		 */
    $vue->set($dataClass->getListe(2), "data");
    $vue->set("export/datasetTemplateList.tpl", "corps");
    break;
  case "display":
    /*
		 * Display the detail of the record
		 */
    $vue->set($dataClass->getDetail($id), "data");
    $vue->set("export/datasetTemplateDisplay.tpl", "corps");
    include_once "modules/classes/export/datasetColumn.class.php";
    $dc = new DatasetColumn($bdd, $ObjetBDDParam);
    $vue->set($dc->getListFromParent($id), "columns");
    break;
  case "change":
    /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record 
		 */
    dataRead($dataClass, $id, "export/datasetTemplateChange.tpl");
    require_once "modules/classes/export/datasetType.class.php";
    require_once "modules/classes/export/exportFormat.class.php";
    $dt = new DatasetType($bdd, $ObjetBDDParam);
    $vue->set($dt->getListe(1), "datasetTypes");
    $ef = new ExportFormat($bdd, $ObjetBDDParam);
    $vue->set($ef->getListe(1), "exportFormats");
    break;
  case "write":
    /*
		 * write record in database
		 */
    $id = dataWrite($dataClass, $_REQUEST);
    if ($id > 0) {
      $_REQUEST[$keyName] = $id;
    }
    break;
  case "delete":
    /*
		 * delete record
		 */
    dataDelete($dataClass, $id);
    break;
  case "duplicate":
    try {
      $bdd->beginTransaction();
      $_REQUEST[$keyName] = $dataClass->duplicate($id);
      $module_coderetour = 1;
      $bdd->commit();
    } catch (Exception $e) {
      $module_coderetour = -1;
      $message->set($e->getMessage(), true);
      $bdd->rollback();
    }
}
