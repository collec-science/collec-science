<?php
/**
 * Created : 30 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/project.class.php';
$dataClass = new Project($bdd,$ObjetBDDParam);
$keyName = "project_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
	case "list":
		/*
		 * Display the list of all records of the table
		 */
		$smarty->assign("data", $dataClass->getListe(2));
		$smarty->assign("corps", "param/projectList.tpl");
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead($dataClass, $id, "param/projectChange.tpl");
		/*
		 * Recuperation des groupes
		 */
		$smarty->assign("groupes", $dataClass->getAllGroupsFromProject($id));
		break;
	case "write":
		/*
		 * write record in database
		 */
		$id = dataWrite($dataClass, $_REQUEST);
		if ($id > 0) {
			$_REQUEST[$keyName] = $id;
			/*
			 * Rechargement eventuel des projets autorises pour l'utilisateur courant
			 */
			$_SESSION["projects"] = $dataClass->getProjectIdFromLogin($_SESSION["login"]);
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