<?php
include_once 'modules/classes/export/datasetType.class.php';
$dataClass = new DatasetType($bdd, $ObjetBDDParam);
$keyName = "dataset_type_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
  case "change":
    /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record 
		 */
    dataRead($dataClass, $id, "export/datasetColumnChange.tpl", $_REQUEST["idParent"]);
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