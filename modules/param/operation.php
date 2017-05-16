<?php
/**
 * Created : 14 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/operation.class.php';
$dataClass = new Operation($bdd,$ObjetBDDParam);
$keyName = "operation_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
	case "list":
		$vue->set( $dataClass->getListe(),"data" );
		$vue->set( "param/operationList.tpl", "corps");
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead($dataClass, $id, "param/operationChange.tpl", $_REQUEST["protocol_id"]);
		/*
		 * Recuperation de la liste des protocoles
		 */
		require_once 'modules/classes/protocol.class.php';
		$protocol = new Protocol($bdd, $ObjetBDDParam);
		$vue->set($protocol->getListe("protocol_year desc, protocol_name, protocol_version desc"), "protocol");
		/*
		 * Recuperation des métadonnées
		 */
		require_once 'modules/classes/metadataForm.class.php';
		$metadata= new MetadataForm($bdd, $ObjetBDDParam);
		$vue->set($metadata->getListe(1),"metadata");

		/*
		 * Recuperation de toutes les opérations
		 */
		$vue->set($dataClass->getListe(1),"operations");

		break;
	case "write":
		/*
		 * write record in database
		 */

		//on vérifie si il existe des échantillons rattachés à l'opération
		if ($dataClass->getNbSample($id)==0){
			//gestion des métadonnées
			require_once 'modules/classes/metadataForm.class.php';
			$metadata = new MetadataForm($bdd, $ObjetBDDParam);
			$data = array ("schema" =>$_REQUEST["metadataField"]);
			
			if($_REQUEST["metadata_form_id"] > 0){
				$data["metadata_form_id"] = $_REQUEST["metadata_form_id"];
			}
			$idmetadata = $metadata->ecrire($data);
			$_REQUEST["metadata_form_id"] = $idmetadata;
			
			$id = dataWrite($dataClass, $_REQUEST);
			if ($id > 0) {
				$_REQUEST[$keyName] = $id;
			}
		}
		else{
			$module_coderetour = - 1;
			$message->set ( "Impossible de modifier une opération à laquelle est rattaché des échantillons" );
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