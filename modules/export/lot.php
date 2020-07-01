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
    $collection_id = 0;
    if ($_GET["collection_id"] > 0) {
      $collection_id = $_GET["collection_id"];
    } elseif ($_COOKIE["collectionid"] > 0) {
      $collection_id = $_COOKIE["collectionid"];
    }
    if ($collection_id > 0) {
      $vue->set($dataClass->getLotsFromCollection($collection_id), "lots");
    }
    $vue->set($_SESSION["collections"], "collections");
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
          $_POST["lot_id"]  = $dataClass->createLot($_POST["collection_id"], $_POST["uids"]);
          $bdd->commit();
          $message->set(_("Lot créé"));
          $module_coderetour = 1;
        } catch (Exception $e) {
          $message->set(_("Une erreur est survenue pendant la création du lot"), true);
          $message->setSyslog($e->getMessage());
          $module_coderetour = -1;
          $bdd->rollback();
        }
      } else {
        $message->set(_("Vous ne disposez pas des droits suffisants pour créer le lot"), true);
        $module_coderetour = -1;
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
    $vue->set("export/lotDisplay.tpl", "corps");
    $vue->set($dataClass->getDetail($id), "data");
    /**
     * Get the list of exports
     */
    require_once "modules/classes/export/export.class.php";
    $export = new Export($bdd, $ObjetBDDParam);
    $vue->set($export->getListFromLot($id), "exports");
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
