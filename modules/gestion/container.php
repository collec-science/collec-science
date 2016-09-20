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
			$vue->set($data , "containers");
			$vue->set(1, "isSearch");
		}
		$vue->set($dataSearch, "containerSearch");
		$vue->set("gestion/containerList.tpl","corps" );
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
		$vue->set($data, "data");
		/*
		 * Recuperation des conteneurs parents
		 */
		$vue->set( $dataClass->getAllParents($data["uid"]),"parents");
		/*
		 * Recuperation des conteneurs  et des échantillons contenus
		 */
		$vue->set($dataClass->getContentContainer($data["uid"]),"containers");
		$vue->set($dataClass->getContentSample($data["uid"]),"samples");
		/*
		 * Recuperation des evenements
		 */
		require_once 'modules/classes/event.class.php';
		$event = new Event($bdd, $ObjetBDDParam);
		$vue->set($event->getListeFromUid($data["uid"]),"events");
		/*
		 * Recuperation des mouvements
		 */
		require_once 'modules/classes/storage.class.php';
		$storage = new Storage($bdd, $ObjetBDDParam);
		$vue->set($storage->getAllMovements($id),"storages" );
		/*
		 * Recuperation des reservations
		 */
		require_once 'modules/classes/booking.class.php';
		$booking = new Booking($bdd, $ObjetBDDParam);
		$vue->set($booking->getListFromParent($data["uid"],'date_from desc'), "bookings");
		/*
		 * Recuperation des documents
		 */
		require_once 'modules/classes/document.class.php';
		$document = new Document($bdd, $ObjetBDDParam);
		$vue->set($document->getListFromParent($data["uid"]), "dataDoc");
		$vue->set ( 1, "modifiable" );
		/*
		 * Affichage
		 */
		$vue->set( "container", "moduleParent");
		$vue->set("gestion/containerDisplay.tpl", "corps" );
		

		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead ( $dataClass, $id, "gestion/containerChange.tpl" );
		if ($_REQUEST["container_parent_uid"] > 0 && is_numeric($_REQUEST["container_parent_uid"])) {
			$container_parent = $dataClass->lire($_REQUEST["container_parent_uid"]);
			$vue->set($container_parent["uid"],"container_parent_uid");
			$vue->set($container_parent["identifier"], "container_parent_identifier");
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
			$message->set(  "Le conteneur est référencé dans les mouvements et ne peut être supprimé");
			$module_coderetour = - 1;
		} else
			dataDelete ( $dataClass, $id );
		break;
		
	case "getFromType":
		/*
		 * Recherche la liste a partir du type
		 */
		$vue->set($dataClass->getFromType($_REQUEST["container_type_id"]));
}
?>