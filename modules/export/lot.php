<?php
include_once 'modules/classes/export/lot.class.php';
$dataClass = new Lot($bdd, $ObjetBDDParam);
$keyName = "lot_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
  case "list":
    /*
		 * Display the list of all records of the table
		 */
    $vue->set($dataClass->getListe(2), "data");
    $vue->set("export/lotList.tpl", "corps");
    break;
  case "create":
    /**
     * Verify if each uid is authorized
     */
    include_once "modules/classes/sample.class.php";
    $ok = false;
    $sample = new Sample($bdd, $ObjetBDDParam);
    if (count($_POST["uids"]) > 0) {
      foreach ($_SESSION["collections"] as $value) {
        if ($_POST["collection_id"] == $value["collection_id"]) {
          $ok = true;
          break;
        }
      }
      if ($ok) {
        try {
          $bdd->beginTransaction();
          $lot_id = $dataClass->createLot($_POST["collection_id"], $_POST["uids"]);
          $bdd->commit();
          $module_coderetour = 1;
        } catch (Exception $e) {
          $message->set(_("Une erreur est survenue pendant la création du lot"), true);
          $message->setSyslog($e->getMessage());
          $module_coderetour = -1;
          $bdd->rollback();
        }
      }
    } else {
      $message->set(_("Aucun échantillon n'a été sélectionné"), true);
      $module_coderetour = -1;
    }
    break;
  case "display":
    /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
    dataRead($dataClass, $id, "export/lotChange.tpl", $_REQUEST["idParent"]);
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
