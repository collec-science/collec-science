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
$keyName = "uid";
$id = $_REQUEST [$keyName];
$_SESSION["moduleParent"] = "container";

switch ($t_module ["param"]) {
	case "list":
		/*
		 * Display the list of all records of the table
		 */
		$_SESSION ["searchContainer"]->setParam ( $_REQUEST );
		$dataSearch = $_SESSION ["searchContainer"]->getParam ();
		if ($_SESSION ["searchContainer"]->isSearch () == 1) {
			$data = $dataClass->containerSearch( $dataSearch );
			$smarty->assign ( "containers", $data );
			$smarty->assign ( "isSearch", 1 );
		}
		$smarty->assign ( "containerSearch", $dataSearch );
		$smarty->assign ( "corps", "gestion/containerList.tpl" );
		/*
		 * Ajout des listes deroulantes
		 */
		include 'modules/gestion/container.functions.php';
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
		 * Recuperation des conteneurs  et des échantillons contenus
		 */
		$smarty->assign("containers", $dataClass->getContentContainer($data["uid"]));
		$smarty->assign("samples", $dataClass->getContentSample($data["uid"]));
		/*
		 * Recuperation des evenements
		 */
		require_once 'modules/classes/event.class.php';
		$event = new Event($bdd, $ObjetBDDParam);
		$smarty->assign("events", $event->getListeFromUid($data["uid"]));
		$smarty->assign("moduleParent", "container");
		$smarty->assign ( "corps", "gestion/containerDisplay.tpl" );
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead ( $dataClass, $id, "gestion/containerChange.tpl" );
		//$object = new Object ( $bdd, $ObjetBDDParam );
		//$smarty->assign ( "objectData", $object->lire ( $data ["uid"] ) );
		if ($_REQUEST["container_parent_uid"] > 0 && is_numeric($_REQUEST["container_parent_uid"])) {
			$smarty->assign("container_parent_uid", $_REQUEST["container_parent_uid"]);
		}
		include 'modules/gestion/container.functions.php';
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
			if ($_REQUEST["container_parent_uid"] > 0 && is_numeric($_REQUEST["container_parent_uid"])) {
				require_once 'modules/classes/storage.class.php';
				$storage = new Storage($bdd, $ObjetBDDParam);
				$data = array ("uid" =>$id,
						"storage_date"=> date('d/m/Y H:i:s'),
						"movement_type_id"=>1,
						"login"=>$_SESSION["login"],
						"container_id"=>$dataClass->getIdFromUid($_REQUEST["container_parent_uid"]),
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
		
	case "getFromType":
		/*
		 * Recherche la liste a partir du type
		 */
		ob_clean();
		echo json_encode($dataClass->getFromType($_REQUEST["container_type_id"]));
		ob_flush();
}
?>