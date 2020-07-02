<?php
include_once 'modules/classes/export/export.class.php';
$dataClass = new Export($bdd, $ObjetBDDParam);
$keyName = "export_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
  case "change":
    /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record 
		 */
    dataRead($dataClass, $id, "export/exportChange.tpl", $_REQUEST["lot_id"]);
    require_once "modules/classes/export/lot.class.php";
    $lot = new Lot($bdd, $ObjetBDDParam);
    $vue->set($lot->getDetail($_REQUEST["lot_id"]), "lot");
    require_once "modules/classes/export/exportTemplate.class.php";
    $template = new ExportTemplate($bdd, $ObjetBDDParam);
    $vue->set($template->getListe("export_template_name"), "templates");
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
  case "exec":

    break;
}
