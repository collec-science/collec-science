<?php
/**
 * @author Eric Quinton
 * @copyright Copyright (c) 2015, IRSTEA / Eric Quinton
 * @license http://www.cecill.info/licences/Licence_CeCILL-C_V1-fr.html LICENCE DE LOGICIEL LIBRE CeCILL-C
 *  Creation 3 juin 2015
 */
 
include_once 'framework/droits/droits.class.php';
$dataClass = new Aclappli($bdd_gacl,$ObjetBDDParam);
$keyName = "aclappli_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
	case "list":
		/*
		 * Display the list of all records of the table
		 */
		$vue->set($dataClass->getListe(2) , "data");
		$vue->set("framework/droits/appliList.tpl" , "corps");
		break;
	case "display":
		/*
		 * Display the detail of the record
		 */
		$data = $dataClass->lire($id);
		$vue->set($data , "data");
		$vue->set("framework/droits/appliDisplay.tpl" , "corps");
		$aclAco = new Aclaco($bdd_gacl, $ObjetBDDParam);
		$vue->set( $aclAco->getListFromParent($id, 3), "dataAco");
		$GACL_disable_new_right == 1 ? $vue->set(0, "newRightEnabled") : $vue->set(1, "newRightEnabled");
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead($dataClass, $id, "framework/droits/appliChange.tpl");
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