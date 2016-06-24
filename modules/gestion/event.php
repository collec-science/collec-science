<?php
/**
 * Created : 24 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/event.class.php';
$dataClass = new Event($bdd,$ObjetBDDParam);
$keyName = "event_id";
$id = $_REQUEST[$keyName];
switch ($t_module["param"]) {
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead($dataClass, $id, "gestion/eventChange.tpl", $_REQUEST["uid"], true);
		$smarty->assign("moduleParent", $_SESSION["moduleParent"]);
		/*
		 * Recherche des types d'evenement
		 */
		require_once 'modules/classes/eventType.class.php';
		$eventType = new EventType($bdd, $ObjetBDDParam);
		$smarty->assign("eventType", $eventType->getListeFromCategory($_SESSION["moduleParent"]));
		/*
		 * Lecture de l'object concerne
		 */
		require_once 'modules/classes/object.class.php';
		$object = new Object($bdd, $ObjetBDDParam);
		$smarty->assign("object", $object->lire($_REQUEST["uid"]));
		break;
	case "write":
		/*
		 * write record in database
		 */
		//$dataClass->debug_mode = 2;
		$id = dataWrite($dataClass, $_REQUEST, true);
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