<?php
/**
 * Created : 2 févr. 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
require_once 'modules/classes/samplingPlace.class.php';
$dataClass = new SamplingPlace($bdd,$ObjetBDDParam);
$keyName = "sampling_place_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
	case "list":
		/*
		 * Display the list of all records of the table
		 */
		$vue->set($dataClass->getListe(2) ,"data" );
		$vue->set("param/samplingPlaceList.tpl" , "corps");
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead($dataClass, $id, "param/samplingPlaceChange.tpl");
		break;
	case "write":
		/*
		 * write record in database
		 */
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
	case "import":
	    if (file_exists($_FILES['upfile']['tmp_name'])) {
	        require_once 'modules/classes/import.class.php';
	        $i = 0;
	        try {
	            $import = new Import($_FILES['upfile']['tmp_name'], ";");
	            $rows = $import->getContentAsArray();
	            foreach ($rows as $row) {
	                if (!$dataClass->isExists($row["name"]) ) {
	                   $data = array("sampling_place_name"=>$row["name"]);
	                   $dataClass->ecrire($data);
	                   $i ++;
	                }
	            }
	            $message->set($i . " lieu(x) importé(s)");
	            $module_coderetour = 1;
	            
	        } catch (Exception $e) {
	            $message->set("Impossible d'importer les emplacements de prélèvement");
	            $message->set($e->getMessage());
	            $module_coderetour = - 1;
	        }
	    } else {
	        $message->set("Impossible de charger le fichier à importer");
	        $module_coderetour = - 1;
	    }
}
?>