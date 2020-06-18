<?php
include_once 'modules/classes/export/datasetTemplate.class.php';
$dataClass = new DatasetTemplate($bdd, $ObjetBDDParam);
$keyName = "dataset_type_id";
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
    $vue->set($dataClass->lire($id), "data");
    $vue->set("example/exampleDisplay.tpl", "corps");
    break;
  case "change":
    /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record 
		 */
    dataRead($dataClass, $id, "export/datasetTemplateChange.tpl", $_REQUEST["idParent"]);
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
}
