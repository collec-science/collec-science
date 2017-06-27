<?php
/**
 * Created : 30 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/sampleType.class.php';
$dataClass = new SampleType($bdd,$ObjetBDDParam);
$keyName = "sample_type_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
	case "list":
		/*
		 * Display the list of all records of the table
		 */
		$vue->set($dataClass->getListe(2), "data");
		$vue->set("param/sampleTypeList.tpl", "corps");
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead($dataClass, $id, "param/sampleTypeChange.tpl");
		
		require_once 'modules/classes/containerType.class.php';
		$containerType = new ContainerType($bdd, $ObjetBDDParam);
		$vue->set($containerType->getListe("container_type_name"), "container_type");
		require_once 'modules/classes/operation.class.php';
		$operation = new Operation($bdd, $ObjetBDDParam);
		$vue->set($operation->getListe(), "operation");
		require_once 'modules/classes/multipleType.class.php';
		$multipleType = new MultipleType($bdd, $ObjetBDDParam);
		$vue->set($multipleType->getListe(1), "multiple_type");
		break;
	case "write":
		/*
		 * write record in database
		 */

		//on vérifie si il existe des échantillons rattachés à l'opération
		if ($dataClass->getNbSample($id)==0){
			$id = dataWrite($dataClass, $_REQUEST);
			if ($id > 0) {
				$_REQUEST[$keyName] = $id;
			}
		}
		else{
			$module_coderetour = - 1;
			$message->set ( "Impossible de modifier un type d'échantillon auquel est rattaché des échantillons" );
		}
		break;
	case "delete":
		/*
		 * delete record
		 */
		dataDelete($dataClass, $id);
		break;
	case "getDetailFormAjax":
		$schema=$dataClass->getMetadataForm($_REQUEST ["sample_type_id"]);
		$vue->set (array("schema"=>$schema));
		break;
}
?>