<?php
/**
 * Created : 8 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/container.class.php';
require_once 'modules/classes/object.class.php';
$dataClass = new Container ( $bdd, $ObjetBDDParam );
$keyName = "container_id";
$id = $_REQUEST [$keyName];

switch ($t_module ["param"]) {
	case "list":
		/*
		 * Display the list of all records of the table
		 */
		$_SESSION ["searchContainer"]->setParam ( $_REQUEST );
		$dataSearch = $_SESSION ["searchContainer"]->getParam ();
		if ($_SESSION ["searchContainer"]->isSearch () == 1) {
			$data = $dataClass->getListeSearch ( $dataSearch );
			$smarty->assign ( "data", $data );
			$smarty->assign ( "isSearch", 1 );
		}
		$smarty->assign ( "containerSearch", $dataSearch );
		$smarty->assign ( "corps", "gestion/containerList.tpl" );
		break;
	case "display":
		/*
		 * Display the detail of the record
		 */
		$data = $dataClass->lire ( $id );
		$object = new Object ( $bdd, $ObjetBDDParam );
		$smarty->assign ( "objectData", $object->lire ( $data ["uid"] ) );
		$smarty->assign ( "data", $data );
		$smarty->assign ( "corps", "gestion/containerDisplay.tpl" );
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		$data = dataRead ( $dataClass, $id, "gestion/containerChange.tpl" );
		$object = new Object ( $bdd, $ObjetBDDParam );
		$smarty->assign ( "objectData", $object->lire ( $data ["uid"] ) );
		break;
	case "write":
		/*
		 * write record in database
		 */
		$id = dataWrite ( $dataClass, $_REQUEST );
		if ($id > 0) {
			$_REQUEST [$keyName] = $id;
		}
		break;
	case "delete":
		/*
		 * delete record
		 */
		/*
		 * Recherche si le conteneur est reference
		 */
		require_once 'modules/classes/storage.class.php';
		$storage = new Storage ( $bdd, $ObjetBDDParam );
		try {
			$nb = $storage->getNbFromContainer ( $id );
		} catch (Exception $e){
			$nb = 0;
		}
		if ($nb > 0) {
			$message = "Le conteneur est référencé dans les mouvements et ne peut être supprimé";
			$module_coderetour = - 1;
		} else
			dataDelete ( $dataClass, $id );
		break;
}
?>