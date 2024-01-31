<?php

/**
 * Created : 24 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/event.class.php';
$dataClass = new Event($bdd, $ObjetBDDParam);
$keyName = "event_id";
$id = $_REQUEST[$keyName];
switch ($t_module["param"]) {
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead($dataClass, $id, "gestion/eventChange.tpl", $_REQUEST["uid"]);
		$vue->set($_SESSION["moduleParent"], "moduleParent");
		$vue->set("tab-event", "activeTab");
		/*
		 * Lecture de l'object concerne
		 */
		require_once 'modules/classes/object.class.php';
		$object = new ObjectClass($bdd, $ObjetBDDParam);
		$vue->set($data = $object->lire($_REQUEST["uid"]), "object");

		/*
		 * Recherche des types d'evenement
		 */
		require_once 'modules/classes/eventType.class.php';
		$eventType = new EventType($bdd, $ObjetBDDParam);
		$vue->set($eventType->getListeFromCategory($_SESSION["moduleParent"], $data["collection_id"]), "eventType");
		break;
	case "display":
		$data = $dataClass->getDetail($id);
		$vue->set($data, "data");
		$vue->set("gestion/eventDisplay.tpl", "corps");
		$vue->set($_SESSION["moduleParent"], "moduleParentOnly");
		$vue->set($_SESSION["moduleParent"] . "event", "moduleParent");
		$vue->set("tab-event", "activeTab");
		/*
		 * Lecture de l'object concerne
		 */
		require_once 'modules/classes/object.class.php';
		$object = new ObjectClass($bdd, $ObjetBDDParam);
		$vue->set($dobject = $object->lire($data["uid"]), "object");
		/**
		 * Recuperation des documents
		 */
		include_once 'modules/classes/document.class.php';
		$document = new Document($bdd, $ObjetBDDParam);
		$vue->set($doc = $document->getListFromField("event_id", $id), "dataDoc");
		$vue->set($document->getMaxUploadSize(), "maxUploadSize");
		$vue->set($_SESSION["collections"][$data["collection_id"]]["external_storage_enabled"], "externalStorageEnabled");
		/**
		 * Get the list of authorized extensions
		 */
		$mimeType = new MimeType($bdd, $ObjetBDDParam);
		$vue->set($mimeType->getListExtensions(false), "extensions");
		$vue->set("event_id", "parentKeyName");
		$vue->set($object->verifyCollection($dobject), "modifiable");
		break;
	case "write":
		/*
		 * write record in database
		 */
		//$dataClass->debug_mode = 2;
		$id = dataWrite($dataClass, $_REQUEST, false);
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

	case "search":
		$_SESSION["moduleParent"] = "eventSearch";
		$vue->set("eventSearch", "moduleParent");
		$_SESSION["searchEvent"]->setParam($_REQUEST);
		$dataSearch = $_SESSION["searchEvent"]->getParam();
		if ($_SESSION["searchEvent"]->isSearch() == 1) {
			try {
				$vue->set(
					$dataClass->searchDueEvent(
						$dataSearch["search_type"],
						$dataSearch["date_from"],
						$dataSearch["date_to"],
						$dataSearch["is_done"],
						$dataSearch["collection_id"],
						$dataSearch["event_type_id"],
						$dataSearch["object_type_id"],
						$dataSearch["object_type"]
					),
					"events"
				);
				$vue->set(1, "isSearch");
			} catch (Exception $e) {
				$message->set($e->getMessage(), true);
			}
		}
		include_once "modules/classes/collection.class.php";
		$collection = new Collection($bdd, $ObjetBDDParam);
		$vue->set($collection->getAllCollections(), "collections");
		include_once "modules/classes/eventType.class.php";
		if ($dataSearch["object_type"] == 1) {
			$category = "sample";
			include_once "modules/classes/sampleType.class.php";
			$sampleType = new SampleType($bdd, $ObjetBDDParam);
			$vue->set($sampleType->getListFromCollection($dataSearch["collection_id"]), "objectTypes");
		} else {
			$category = "container";
			include_once "modules/classes/containerType.class.php";
			$ct = new ContainerType($bdd, $ObjetBDDParam);
			$vue->set($ct->getListe("container_type_name"), "objectTypes");
		}
		$eventType = new EventType($bdd, $ObjetBDDParam);
		$vue->set($eventType->getListeFromCategory($category, $dataSearch["collection_id"]), "eventTypes");
		$vue->set($dataSearch, "eventSearch");
		$vue->set("gestion/eventSearchList.tpl", "corps");
		break;
	case "deleteList":
		if (!empty($_POST["events"])) {
			$bdd->beginTransaction();
			try {
				foreach ($_POST["events"] as $event_id) {
					$dataClass->supprimer($event_id);
				}
				$bdd->commit();
				$message->set(_("Événements supprimés"));
				$module_coderetour = 1;
			} catch (Exception $e) {
				$message->set(_("Un problème est survenu pendant la suppression d'un événement"), true);
				$message->setSyslog($e->getMessage());
				$bdd->rollBack();
				$module_coderetour = -1;
			}
		} else {
			$message->set(_("Aucun événement n'a été sélectionné"), true);
			$module_coderetour = -1;
		}
		break;
	case "changeList":
		if (!empty($_POST["events"])) {
			$fields = array("event_date", "event_type_id", "due_date", "event_comment", "still_available");
			$data = array();
			foreach ($fields as $field) {
				if (!empty($_POST[$field])) {
					$data[$field] = $_POST[$field];
				}
			}
			if (!empty($data)) {
				$dataClass->colonnes["uid"]["requis"] = 0;
				$dataClass->colonnes["event_type_id"]["requis"] = 0;
				$bdd->beginTransaction();
				try {
					foreach ($_POST["events"] as $event_id) {
						$data["event_id"] = $event_id;
						$dataClass->ecrire($data);
					}
					$bdd->commit();
					$message->set(_("Événements modifiés"));
					$module_coderetour = 1;
				} catch (Exception $e) {
					$message->set(_("Un problème est survenu pendant la modification d'un événement"), true);
					$message->setSyslog($e->getMessage());
					$bdd->rollBack();
					$module_coderetour = -1;
				}
			} else {
				$message->set(_("Aucune modification n'est à apporter aux événements"), true);
				$module_coderetour = -1;
			}
		} else {
			$message->set(_("Aucun événement n'a été sélectionné"), true);
			$module_coderetour = -1;
		}
		break;
}