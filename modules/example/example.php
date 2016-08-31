<?php
/**
 * Example of a gestion from a table :
 * - display the list
 * - show detail
 * - modify record
 * - write or delete data in database
 * 
 * Smarty templates are in display/templates folder
 * modules are described in param/actions.xml file :
 * exampleListe, exampleDetail, exampleModif, exampleWrite exampleDelete
 * 
 * menu items are declared in locales/fr.php
 */

include_once 'modules/example/example.class.php';
$dataClass = new Example($bdd,$ObjetBDDParam);
$keyName = "idExample";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
	case "list":
		/*
		 * Display the list of all records of the table
		 */
		 /*
		 * $searchExample must be defined into modules/beforesession.inc.php :
		 * include_once 'modules/classes/searchParam.class.php';
		 * and into modules/common.inc.php :
		 * if (!isset($_SESSION["searchExample"])) {
    	 * $searchExample = new SearchExample();
		 *	$_SESSION["searchExample"] = $searchExample; 
		 *	} else {
		 *	$searchExample = $_SESSION["searchExample"];
		 *	}
		 * and, also, into modules/classes/searchParam.class.php...
		 */
		 $searchExample->setParam ( $_REQUEST );
		 $dataSearch = $searchExample->getParam ();
		if ($searchExample->isSearch () == 1) {
			$data = $dataClass->getListeSearch ( $dataExample );	
			$vue->set( $data  ,"data" );
			$vue->set(1 ,"isSearch" );

		}
		$vue->set($dataSearch ,"exampleSearch" );
		//$vue->set( $dataClass->getListe(),"data" );
		$vue->set( "example/exampleList.tpl", "corps");
		break;
	case "display":
		/*
		 * Display the detail of the record
		 */
		$vue->set($dataClass->lire($id) , "data");
		$vue->set("example/exampleDisplay.tpl" , "corps");
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record 
		 */
		dataRead($dataClass, $id, "example/exampleChange.tpl", $_REQUEST["idParent"]);
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
}
?>