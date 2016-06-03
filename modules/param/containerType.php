<?php
/**
 * Created : 3 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/containerType.class.php';
$dataClass = new ContainerType($bdd,$ObjetBDDParam);
$keyName = "container_type_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
	case "list":
		/*
		 * Display the list of all records of the table
		 */
		$smarty->assign("data", $dataClass->getListe("container_type_name"));
		$smarty->assign("corps", "param/containerTypeList.tpl");
		break;
	case "display":
		/*
		 * Display the detail of the record
		 */
		$data = $dataClass->lire($id);
		$smarty->assign("data", $data);
		$smarty->assign("corps", "example/exampleDisplay.tpl");
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead($dataClass, $id, "param/containerTypeChange.tpl");
		/*
		 * Lecture des tables associees pour les select
		 */
		require_once 'modules/classes/containerFamily.class.php';
		require_once 'modules/classes/storageCondition.class.php';
		$containerFamily = new ContainerFamily($bdd, $ObjetBDDParam);
		$storageCondition = new StorageCondition($bdd, $ObjetBDDParam);
		$smarty->assign("storageCondition", $storageCondition->getListe(2));
		$smarty->assign("containerFamily", $containerFamily->getListe(2));
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