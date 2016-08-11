<?php
/**
 * Created : 30 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/sample.class.php';
require_once 'modules/classes/object.class.php';
$dataClass = new Sample ( $bdd, $ObjetBDDParam );
$keyName = "uid";
$id = $_REQUEST [$keyName];
$_SESSION ["moduleParent"] = "sample";

switch ($t_module ["param"]) {
	case "list":
		/*
		 * Display the list of all records of the table
		 */
		$_SESSION ["searchSample"]->setParam ( $_REQUEST );
		$dataSearch = $_SESSION ["searchSample"]->getParam ();
		if ($_SESSION ["searchSample"]->isSearch () == 1) {
			$data = $dataClass->sampleSearch ( $dataSearch );
			$smarty->assign ( "samples", $data );
			$smarty->assign ( "isSearch", 1 );
		}
		$smarty->assign ( "sampleSearch", $dataSearch );
		$smarty->assign ( "corps", "gestion/sampleList.tpl" );
		/*
		 * Ajout des listes deroulantes
		 */
		include 'modules/gestion/sample.functions.php';
		break;
	case "display":
		/*
		 * Display the detail of the record
		 */
		$data = $dataClass->lire ( $id );
		$smarty->assign ( "data", $data );
		/*
		 * Recuperation des conteneurs parents
		 */
		require_once 'modules/classes/container.class.php';
		$container = new Container ( $bdd, $ObjetBDDParam );
		$smarty->assign ( "parents", $container->getAllParents ( $data ["uid"] ) );
		/*
		 * Recuperation des evenements
		 */
		require_once 'modules/classes/event.class.php';
		$event = new Event ( $bdd, $ObjetBDDParam );
		$smarty->assign ( "events", $event->getListeFromUid ( $data ["uid"] ) );
		/*
		 * Recuperation des mouvements
		 */
		require_once 'modules/classes/storage.class.php';
		$storage = new Storage ( $bdd, $ObjetBDDParam );
		$smarty->assign ( "storages", $storage->getAllMovements ( $id ) );
		$smarty->assign ( "moduleParent", "sample" );
		$smarty->assign ( "corps", "gestion/sampleDisplay.tpl" );
		/*
		 * Verification que l'echantillon peut etre modifie
		 */
		$is_modifiable = $dataClass->verifyProject ( $data );
		if ($is_modifiable)
			$smarty->assign ( "modifiable", 1 );
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		$data = dataRead ( $dataClass, $id, "gestion/sampleChange.tpl" );
		if ($data ["sample_id"] > 0 && $dataClass->verifyProject ( $data ) == false) {
			$message = "Vous ne disposez pas des droits nécessaires pour modifier cet échantillon";
			$module_coderetour = - 1;
		} else {
			
			// $object = new Object ( $bdd, $ObjetBDDParam );
			// $smarty->assign ( "objectData", $object->lire ( $data ["uid"] ) );
			include 'modules/gestion/sample.functions.php';
		}
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
		dataDelete ( $dataClass, $_REQUEST["uid"] );
		break;
}
?>