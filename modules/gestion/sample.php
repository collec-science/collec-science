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
$_SESSION["moduleParent"] = "sample";

switch ($t_module ["param"]) {
	case "list":
		/*
		 * Display the list of all records of the table
		 */
		$_SESSION ["searchSample"]->setParam ( $_REQUEST );
		$dataSearch = $_SESSION ["searchSample"]->getParam ();
		if ($_SESSION ["searchSample"]->isSearch () == 1) {
			$data = $dataClass->sampleSearch( $dataSearch );
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
		$smarty->assign("parents", $dataClass->getAllParents($data["uid"]));
		/*
		 * Recuperation des evenements
		 */
		require_once 'modules/classes/event.class.php';
		$event = new Event($bdd, $ObjetBDDParam);
		$smarty->assign("events", $event->getListeFromUid($data["uid"]));
		/*
		 * Recuperation des mouvements
		 */
		require_once 'modules/classes/storage.class.php';
		$storage = new Storage($bdd, $ObjetBDDParam);
		$smarty->assign("storages", $storage->getAllMovements($id));
		$smarty->assign("moduleParent", "sample");
		$smarty->assign ( "corps", "gestion/sampleDisplay.tpl" );
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		$data = dataRead ( $dataClass, $id, "gestion/sampleChange.tpl" );
		if ($data["sample_id"] > 0 && !in_array($data["project_id"], $_SESSION["projects"])) {
			$message = "Vous ne disposez pas des droits nécessaires pour modifier cet échantillon";
			$module_coderetour = -1;
		} else {
			
		//$object = new Object ( $bdd, $ObjetBDDParam );
		//$smarty->assign ( "objectData", $object->lire ( $data ["uid"] ) );
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
			/*
			 * Recherche s'il s'agit d'un conteneur a associer dans un autre conteneur
			 */
			if ($_REQUEST["sample_parent_uid"] > 0 && is_numeric($_REQUEST["sample_parent_uid"])) {
				require_once 'modules/classes/storage.class.php';
				$storage = new Storage($bdd, $ObjetBDDParam);
				$data = array ("uid" =>$id,
						"storage_date"=> date('d/m/Y H:i:s'),
						"movement_type_id"=>1,
						"login"=>$_SESSION["login"],
						"sample_id"=>$dataClass->getIdFromUid($_REQUEST["sample_parent_uid"]),
						"storage_id"=>0
				);
				$storage->ecrire($data);
			}
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
			$nb = $storage->getNbFromControler($id);
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