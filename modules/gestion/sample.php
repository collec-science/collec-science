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
		if (! isset ( $isDelete ))
			$_SESSION ["searchSample"]->setParam ( $_REQUEST );
		$dataSearch = $_SESSION ["searchSample"]->getParam ();
		if ($_SESSION ["searchSample"]->isSearch () == 1) {
			$data = $dataClass->sampleSearch ( $dataSearch );
			$vue->set ( $data, "samples" );
			$vue->set ( 1, "isSearch" );
		}
		$vue->set ( $dataSearch, "sampleSearch" );
		$vue->set ( "gestion/sampleList.tpl", "corps" );
		
		/*
		 * Ajout des listes deroulantes
		 */
		include 'modules/gestion/sample.functions.php';
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
		* Récupération des métadonnées dans un tableau pour l'affichage
		*/
		$metadata=json_decode($data["metadata"],true);
		$is_modifiable = $dataClass->verifyProject ( $data );
		if($is_modifiable){
			$vue->set($metadata, "metadata");
		}
		/*
		 * Recuperation des identifiants associes
		 */
		require_once 'modules/classes/objectIdentifier.class.php';
		$oi = new ObjectIdentifier ( $bdd, $ObjetBDDParam );
		$vue->set ( $oi->getListFromUid ( $data ["uid"] ), "objectIdentifiers" );
		/*
		 * Recuperation des conteneurs parents
		 */
		require_once 'modules/classes/container.class.php';
		$container = new Container ( $bdd, $ObjetBDDParam );
		$vue->set ( $container->getAllParents ( $data ["uid"] ), "parents" );
		/*
		 * Recuperation des evenements
		 */
		require_once 'modules/classes/event.class.php';
		$event = new Event ( $bdd, $ObjetBDDParam );
		$vue->set ( $event->getListeFromUid ( $data ["uid"] ), "events" );
		/*
		 * Recuperation des mouvements
		 */
		require_once 'modules/classes/storage.class.php';
		$storage = new Storage ( $bdd, $ObjetBDDParam );
		$vue->set ( $storage->getAllMovements ( $id ), "storages" );
		/*
		 * Recuperation des echantillons associes
		 */
		$vue->set ( $dataClass->getSampleassociated ( $data ["uid"] ), "samples" );
		/*
		 * Recuperation des reservations
		 */
		require_once 'modules/classes/booking.class.php';
		$booking = new Booking ( $bdd, $ObjetBDDParam );
		$vue->set ( $booking->getListFromParent ( $data ["uid"], 'date_from desc' ), "bookings" );
		/*
		 * Recuperation des sous-echantillonnages
		 */
		if ($data ["multiple_type_id"] > 0) {
			require_once 'modules/classes/subsample.class.php';
			$subSample = new Subsample ( $bdd, $ObjetBDDParam );
			$vue->set ( $subSample->getListFromParent ( $data ["sample_id"], "subsample_date desc" ), "subsample" );
		}
		/*
		 * Verification que l'echantillon peut etre modifie
		 */
		if ($is_modifiable)
			$vue->set ( 1, "modifiable" );
		/*
		 * Recuperation des documents
		 */
		require_once 'modules/classes/document.class.php';
		$document = new Document ( $bdd, $ObjetBDDParam );
		$vue->set ( $document->getListFromParent ( $data ["uid"] ), "dataDoc" );
		/*
		 * Ajout de la selection des modeles d'etiquettes
		 */
		include 'modules/gestion/label.functions.php';
		/*
		 * Affichage
		 */
		include 'modules/gestion/mapInit.php';
		$vue->set ( "sample", "moduleParent" );
		$vue->set ( "gestion/sampleDisplay.tpl", "corps" );
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		$data = dataRead ( $dataClass, $id, "gestion/sampleChange.tpl" );
		if ($data ["sample_id"] > 0 && $dataClass->verifyProject ( $data ) == false) {
			$message->set ( "Vous ne disposez pas des droits nécessaires pour modifier cet échantillon" );
			$module_coderetour = - 1;
		} else {
			/*
			 * Recuperation des informations concernant l'echantillon parent
			 */
			if ($_REQUEST ["parent_uid"] > 0) {
				$dataParent = $dataClass->lire ( $_REQUEST ["parent_uid"] );
				if ($dataParent ["sample_id"] > 0) {
					$data ["parent_sample_id"] = $dataParent ["sample_id"];
					$vue->set ( $dataParent, "parent_sample" );
					$vue->set ( $data, "data" );
				}
			}
			include 'modules/gestion/sample.functions.php';
		}
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
		}
		break;
	case "delete":
		/*
		 * delete record
		 */
		dataDelete ( $dataClass, $_REQUEST ["uid"] );
		$isDelete = true;
		break;
}
?>