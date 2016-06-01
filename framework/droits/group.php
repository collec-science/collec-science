<?php
/**
 * @author Eric Quinton
 * @copyright Copyright (c) 2015, IRSTEA / Eric Quinton
 * @license http://www.cecill.info/licences/Licence_CeCILL-C_V1-fr.html LICENCE DE LOGICIEL LIBRE CeCILL-C
 *  Creation 4 juin 2015
 */
 
include_once 'framework/droits/droits.class.php';
$dataClass = new Aclgroup($bdd_gacl,$ObjetBDDParam);
$keyName = "aclgroup_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
	case "list":
		/*
		 * Display the list of all records of the table
		 */
		$smarty->assign("data", $dataClass->getGroups());
		$smarty->assign("corps", "droits/groupList.tpl");
		break;
	case "display":
		/*
		 * Display the detail of the record
		 */
		$data = $dataClass->lire($id);
		$smarty->assign("data", $data);
		$smarty->assign("corps", "droits/groupDisplay.tpl");
		//$aclAco = new Aclaco($bdd_gacl, $ObjetBDDParam);
		//$smarty->assign ("dataAco", $aclAco->getListFromParent($id, 2));
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead($dataClass, $id, "droits/groupChange.tpl", $_REQUEST["aclgroup_id_parent"]);
		/*
		 * Recuperation des logins associes
		 */
		$acllogin = new Acllogin($bdd_gacl, $ObjetBDDParam);
		$smarty->assign("logins", $acllogin->getAllFromGroup($id));
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