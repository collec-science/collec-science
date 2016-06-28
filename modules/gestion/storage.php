<?php
/**
 * Created : 28 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/storage.class.php';
$dataClass = new Storage($bdd,$ObjetBDDParam);
$dataClass->isBootstrap = true;
$keyName = "storage_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
	case "input":
		$data = dataRead($dataClass, $id, "gestion/storageInput.tpl", $_REQUEST["uid"], true);
		$data ["storage_date"] = "2015-07-01 14:10:00";
		printr($data);
		require_once 'modules/classes/containerFamily.class.php';
		$containerFamily = new ContainerFamily($bdd, $ObjetBDDParam);
		$smarty->assign ("containerFamily", $containerFamily->getListe(2));
		/*
		 * Recherche de l'objet
		 */
		require_once 'modules/classes/object.class.php';
		$object = new Object($bdd, $ObjetBDDParam);
		$smarty->assign("object", $object->lire($_REQUEST["uid"]));
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead($dataClass, $id, "example/exampleChange.tpl", $_REQUEST["idParent"]);
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
?>