<?php
/**
 * Created : 30 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/booking.class.php';
$dataClass = new Booking($bdd,$ObjetBDDParam);
$keyName = "booking_id";
$id = $_REQUEST[$keyName];
switch ($t_module["param"]) {
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead($dataClass, $id, "gestion/bookingChange.tpl", $_REQUEST["uid"]);
		$vue->set($_SESSION["moduleParent"], "moduleParent");
		/*
		 * Lecture de l'object concerne
		 */
		require_once 'modules/classes/object.class.php';
		$object = new Object($bdd, $ObjetBDDParam);
		$vue->set($object->lire($_REQUEST["uid"]),"object");

		break;
	case "write":
		/*
		 * write record in database
		 */
		//$dataClass->debug_mode = 2;
		$id = dataWrite($dataClass, $_REQUEST);
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
	case "verifyInterval":
		$dataClass->verifyInterval($_REQUEST["uid"], $_REQUEST["booking_id"], $_REQUEST["date_from"], $_REQUEST["date_to"]) == true ? $overlaps = 0 : $overlaps = 1;
		$vue->set(array("overlaps"=>$overlaps));
		break;
}
?>