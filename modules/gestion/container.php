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
if (isset($_SESSION["uid"])) {
    $id = $_SESSION["uid"];
    unset($_SESSION["uid"]);
} else {
    $id = $_REQUEST[$keyName];
}
$_SESSION ["moduleParent"] = "container";
switch ($t_module ["param"]) {
	case "list":
	    $_SESSION["moduleListe"] = "containerList";
		/*
		 * Display the list of all records of the table
		 */
		if (! isset ( $isDelete ))
			$_SESSION ["searchContainer"]->setParam ( $_REQUEST );
		$dataSearch = $_SESSION ["searchContainer"]->getParam ();
		if ($_SESSION ["searchContainer"]->isSearch () == 1) {
			$data = $dataClass->containerSearch ( $dataSearch );
			$vue->set ( $data, "containers" );
			$vue->set ( 1, "isSearch" );
		}
		$vue->set ( $dataSearch, "containerSearch" );
		$vue->set ( "gestion/containerList.tpl", "corps" );
		/*
		 * Ajout des listes deroulantes
		 */
		include 'modules/gestion/container.functions.php';
		/*
		 * Ajout de la selection des modeles d'etiquettes
		 */
		include 'modules/gestion/label.functions.php';
		break;
	case "display":
		/*
		 * Display the detail of the record
		 */
		$data = $dataClass->lire ( $id );
		$vue->set ( $data, "data" );
		/*
		 * Recuperation des identifiants associes
		 */
		require_once 'modules/classes/objectIdentifier.class.php';
		$oi = new ObjectIdentifier ( $bdd, $ObjetBDDParam );
		$vue->set ( $oi->getListFromUid ( $data ["uid"] ), "objectIdentifiers" );
		/*
		 * Recuperation des conteneurs parents
		 */
		$vue->set ( $dataClass->getAllParents ( $data ["uid"] ), "parents" );
		/*
		 * Recuperation des conteneurs et des échantillons contenus
		 */
		$dcontainer = $dataClass->getContentContainer ( $data ["uid"] );
		$dsample = $dataClass->getContentSample ( $data ["uid"] );
		$vue->set ( $dcontainer, "containers" );
		$vue->set ($dsample , "samples" );
		/*
		 * Preparation du tableau d'occupation du container
		 */
		$vue->set($dataClass->generateOccupationArray($dcontainer, $dsample, $data["columns"], $data["lines"], $data["first_line"]), "containerOccupation");
		$vue->set($data["lines"], "nblignes");
		$vue->set($data["columns"], "nbcolonnes");
		$vue->set($data["first_line"], "first_line");
		/*
		 * Recuperation des evenements
		 */
		require_once 'modules/classes/event.class.php';
		$event = new Event ( $bdd, $ObjetBDDParam );
		$vue->set ( $event->getListeFromUid ( $data ["uid"] ), "events" );
		/*
		 * Recuperation des mouvements
		 */
		require_once 'modules/classes/movement.class.php';
		$movement = new Movement ( $bdd, $ObjetBDDParam );
		$vue->set ( $movement->getAllMovements ( $id ), "movements" );
		/*
		 * Recuperation des reservations
		 */
		require_once 'modules/classes/booking.class.php';
		$booking = new Booking ( $bdd, $ObjetBDDParam );
		$vue->set ( $booking->getListFromParent ( $data ["uid"], 'date_from desc' ), "bookings" );
		/*
		 * Recuperation des documents
		 */
		require_once 'modules/classes/document.class.php';
		$document = new Document ( $bdd, $ObjetBDDParam );
		$vue->set ( $document->getListFromParent ( $data ["uid"] ), "dataDoc" );
		$vue->set ( 1, "modifiable" );
		/*
		 * Ajout de la selection des modeles d'etiquettes
		 */
		include 'modules/gestion/label.functions.php';
		/*
		 * Affichage
		 */
		$vue->set ( "container", "moduleParent" );
		$vue->set ( "gestion/containerDisplay.tpl", "corps" );
		include 'modules/gestion/mapInit.php';
		
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead ( $dataClass, $id, "gestion/containerChange.tpl" );
		if ($_REQUEST ["container_parent_uid"] > 0 && is_numeric ( $_REQUEST ["container_parent_uid"] )) {
			$container_parent = $dataClass->lire ( $_REQUEST ["container_parent_uid"] );
			$vue->set ( $container_parent ["uid"], "container_parent_uid" );
			$vue->set ( $container_parent ["identifier"], "container_parent_identifier" );
		}
		include 'modules/gestion/container.functions.php';
		include 'modules/gestion/mapInit.php';
		$vue->set ( 1, "mapIsChange" );
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
			if ($_REQUEST ["container_parent_uid"] > 0 && is_numeric ( $_REQUEST ["container_parent_uid"] )) {
				require_once 'modules/classes/movement.class.php';
				$movement = new Movement ( $bdd, $ObjetBDDParam );
				$data = array (
						"uid" => $id,
				    "movement_date" => date ( $_SESSION["MASKDATELONG"] ),
						"movement_type_id" => 1,
						"login" => $_SESSION ["login"],
						"container_id" => $dataClass->getIdFromUid ( $_REQUEST ["container_parent_uid"] ),
						"movement_id" => 0,
				        "line_number" => 1,
				        "column_number" =>1
				        
				);
				$movement->ecrire ( $data );
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
		require_once 'modules/classes/movement.class.php';
		$movement = new Movement ( $bdd, $ObjetBDDParam );
		try {
			$nb = $movement->getNbFromContainer ( $id );
		} catch ( Exception $e ) {
			$nb = 0;
		}
		if ($nb > 0) {
			$message->set(_("Le contenant est référencé dans les mouvements et ne peut être supprimé"));
			$module_coderetour = - 1;
		} else
			dataDelete ( $dataClass, $id );
		$isDelete = true;
		break;
	
	case "getFromType":
		/*
		 * Recherche la liste a partir du type
		 */
		$vue->set ( $dataClass->getFromType ( $_REQUEST ["container_type_id"] ) );
		break;
	case "getFromUid":
		/*
		 * Lecture d'un container a partir de son uid
		 */
		$vue->set ( $dataClass->lire ( $_REQUEST ["uid"] ) );
		break;
}
?>