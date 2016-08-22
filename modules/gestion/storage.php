<?php
/**
 * Created : 28 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/storage.class.php';
$dataClass = new Storage ( $bdd, $ObjetBDDParam );
$keyName = "storage_id";
$id = $_REQUEST [$keyName];
$smarty->assign ( "moduleParent", $_SESSION ["moduleParent"] );
switch ($t_module ["param"]) {
	case "input" :
		$data = dataRead ( $dataClass, $id, "gestion/storageChange.tpl", $_REQUEST ["uid"], false );
		$data ["movement_type_id"] = 1;
		require_once 'modules/classes/containerFamily.class.php';
		$containerFamily = new ContainerFamily ( $bdd, $ObjetBDDParam );
		$smarty->assign ( "containerFamily", $containerFamily->getListe ( 2 ) );
		$smarty->assign ( "data", $data );
		/*
		 * Recherche de l'objet
		 */
		require_once 'modules/classes/object.class.php';
		$object = new Object ( $bdd, $ObjetBDDParam );
		$smarty->assign ( "object", $object->lire ( $_REQUEST ["uid"] ) );
		$smarty->assign ( "data", $data );
		break;
	
	case "output" :
		$data = dataRead ( $dataClass, $id, "gestion/storageChange.tpl", $_REQUEST ["uid"], false );
		$data ["movement_type_id"] = 2;
		/*
		 * Recherche de l'objet
		 */
		require_once 'modules/classes/object.class.php';
		$object = new Object ( $bdd, $ObjetBDDParam );
		$smarty->assign ( "object", $object->lire ( $_REQUEST ["uid"] ) );
		$smarty->assign ( "data", $data );
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead ( $dataClass, $id, "example/exampleChange.tpl", $_REQUEST ["idParent"] );
		break;
	case "write":
		/*
		 * write record in database
		 */
		/*
		 * Recherche de storage_id si uid renseigne
		 */
		if (strlen ( $_REQUEST ["container_id"] ) == 0 && strlen ( $_REQUEST ["container_uid"] ) > 0) {
			require_once 'modules/classes/container.class.php';
			$container = new Container ( $bdd, $ObjetBDDParam );
			$_REQUEST ["container_id"] = $container->getIdFromUid ( $_REQUEST ["container_uid"] );
		}
		/*
		 * Verification de l'existence de container_id si entree
		 */
		$error = false;
		if ($_REQUEST ["movement_type_id"] == 1 ) {
			if ($_REQUEST["uid"] == $_REQUEST["container_uid"])
				$error = true;
			if ( strlen ( $_REQUEST ["container_id"] ) == 0) 
				$error = true;
		}
		if ($error) {
			$message->set( $LANG ["appli"] [3]);
			$module_coderetour = - 1;
		} else {
			$id = dataWrite ( $dataClass, $_REQUEST );
			if ($id > 0) {
				$_REQUEST [$keyName] = $id;
			}
		}
		break;
	case "delete":
		/*
		 * delete record
		 */
		dataDelete ( $dataClass, $id );
		break;
	case "fastInputChange" :
		if (isset ( $_REQUEST ["container_uid"] ) && is_numeric ( $_REQUEST ["container_uid"] ))
			$smarty->assign ( "container_uid", $_REQUEST ["container_uid"] );
		$smarty->assign ( "data", $dataClass->getDefaultValue () );
		$smarty->assign("corps", "gestion/fastInputChange.tpl");
		if (isset($_REQUEST["read_optical"]))
			$smarty->assign("read_optical", $_REQUEST["read_optical"]);
		
		break;
	case "fastInputWrite" :
		try {
			$dataClass->addMovement ( $_REQUEST ["object_uid"], $_REQUEST ["storage_date"], 1, $_REQUEST ["container_uid"], $_SESSION ["login"], $_REQUEST ["range"], $_REQUEST ["storage_comment"] );
			$message->set(  $LANG["message"][5]);
			$module_coderetour = 1;
		} catch ( Exception $e ) {
			//$message->set(  $LANG["message"][42]);
			$message->set($e->getMessage());
			$module_coderetour = -1;
		}
		break;
	case "fastOutputChange" :
		$smarty->assign ( "data", $dataClass->getDefaultValue () );
		$smarty->assign("corps", "gestion/fastOutputChange.tpl");
		if (isset($_REQUEST["read_optical"]))
			$smarty->assign("read_optical", $_REQUEST["read_optical"]);
		break;
	case "fastOutputWrite" :
		try {
			$dataClass->addMovement ( $_REQUEST ["object_uid"], $_REQUEST ["storage_date"], 2, 0, $_SESSION ["login"], $_REQUEST ["range"], $_REQUEST ["storage_comment"] );
			$message->set(  $LANG["message"][5]);
			$module_coderetour = 1;
		} catch ( Exception $e ) {
			$message->set(  $LANG["message"][42]);
			$module_coderetour = -1;
		}
		break;
}
?>