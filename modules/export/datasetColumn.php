<?php
include_once 'modules/classes/export/datasetColumn.class.php';
$dataClass = new DatasetColumn($bdd, $ObjetBDDParam);
$keyName = "dataset_column_id";
$id = $_REQUEST[$keyName];
$parentId = $_REQUEST["dataset_template_id"];
switch ($t_module["param"]) {
  case "change":
    /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
    dataRead($dataClass, $id, "export/datasetColumnChange.tpl", $parentId);
    /**
     * Get the list of all columns
     */
    $vue->set($dataClass->getListFromParent($parentId), "columns");
    /**
     * Get the template record
     */
    include_once "modules/classes/export/datasetTemplate.class.php";
    $datasetTemplate = new DatasetTemplate($bdd, $ObjetBDDParam);
    $vue->set($dt = $datasetTemplate->getDetail($parentId), "template");
    $fields = json_decode($dt["fields"],true);
    asort($fields);
    $vue->set($fields,"fields");
    /**
     * Get the translators
     */
    include_once "modules/classes/export/translator.class.php";
    $translator = new Translator($bdd, $ObjetBDDParam);
    $vue->set($translator->getListe(2), "translators");
    break;
  case "write":
    /*
		 * write record in database
		 */
    $id = dataWrite($dataClass, $_REQUEST);
    /**
     * Reset to 0 to create a new column
     */
    if ($module_coderetour == 1) {
      $_REQUEST[$keyName] = 0;
    }
    break;
  case "delete":
    /*
		 * delete record
		 */
    dataDelete($dataClass, $id);
    if ($module_coderetour == 1) {
      $_REQUEST[$keyName] = 0;
    }
    break;
}
