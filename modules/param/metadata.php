<?php
/**
 * Created : 8 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/metadata.class.php';
$dataClass = new Metadata ( $bdd, $ObjetBDDParam );
$keyName = "metadata_id";
$id = $_REQUEST [$keyName];

switch ($t_module ["param"]) {
	case "list":
		/*
		 * Display the list of all records of the table
		 */
		try {
			$vue->set ( $dataClass->getListe ( 2 ), "data" );
			$vue->set ( "param/metadataList.tpl", "corps" );
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
		dataRead ( $dataClass, $id, "param/metadataChange.tpl" );
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
		dataDelete ( $dataClass, $id );
		break;
	case "copy":
	    /*
	     * Duplication d'une etiquette
	     */
	    $data = $dataClass->lire($id);
	    $data["metadata_id"] = 0;
	    $data["metadata_name"] .= " - new version";
	    $vue->set($data, "data");
	    $vue->set("param/metadataChange.tpl", "corps");
	    break;
	case "getSchema":
	    $data = $dataClass->lire($id);
	    $vue->setJson($data["metadata_schema"]);
	    break;
}
?>