<?php
include_once 'modules/classes/export/translator.class.php';
$dataClass = new Translator($bdd, $ObjetBDDParam);
$keyName = "translator_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
  case "list":
    /*
		 * Display the list of all records of the table
		 */
    $vue->set($dataClass->getListe(2), "data");
    $vue->set("export/translatorList.tpl", "corps");
    break;
  case "display":
    /*
		 * Display the detail of the record
		 */
    $vue->set($dataClass->lire($id), "data");
    $vue->set("export/translatorDisplay.tpl", "corps");
    break;
  case "change":
    /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record 
		 */
    $data = dataRead($dataClass, $id, "export/translatorChange.tpl", $_REQUEST["idParent"]);
    /**
     * Generate an array from translator_data
     */
    $vue->set(json_decode($data["translator_data"], true), "items");
    break;
  case "write":
    /*
		 * write record in database
		 */
    /**
     * Regenerate json data from items
     */
    $nb = count($_POST["name"]);
    $items = array();
    for ($i = 0; $i < $nb; $i++) {
      if (strlen($_POST["name"][$i]) > 0) {
        $items[][$_POST["name"][$i]] = htmlspecialchars_decode($_POST["value"][$i]);
      }
    }
    $data = $_REQUEST;
    $data["translator_data"] = json_encode($items);
    $id = dataWrite($dataClass, $data);
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
