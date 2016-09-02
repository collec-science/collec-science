<?php
/**
 * Created : 30 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/project.class.php';
$dataClass = new Project ( $bdd, $ObjetBDDParam );
$keyName = "project_id";
$id = $_REQUEST [$keyName];

switch ($t_module ["param"]) {
	case "list":
		/*
		 * Display the list of all records of the table
		 */
		try {
			$vue->set ( $dataClass->getListe ( 2 ), "data" );
			$vue->set ( "param/projectList.tpl", "corps" );
		} catch ( Exception $e ) {
			$message->set ( $e->getMessage () );
		}
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead ( $dataClass, $id, "param/projectChange.tpl" );
		/*
		 * Recuperation des groupes
		 */
		$vue->set($dataClass->getAllGroupsFromProject ( $id ) , "groupes");
		break;
	case "write":
		/*
		 * write record in database
		 */
		$id = dataWrite ( $dataClass, $_REQUEST );
		if ($id > 0) {
			$_REQUEST [$keyName] = $id;
			/*
			 * Rechargement eventuel des projets autorises pour l'utilisateur courant
			 */
			try {
			$_SESSION ["projects"] = $dataClass->getProjectsFromLogin ();
			} catch (Exception $e) {
				if ($APPLI_modeDeveloppement)
					$message->set($e->getMessage());
			}
		}
		break;
	case "delete":
		/*
		 * delete record
		 */
		dataDelete ( $dataClass, $id );
		break;
}
?>