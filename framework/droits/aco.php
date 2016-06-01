<?php
/**
 * @author Eric Quinton
 * @copyright Copyright (c) 2015, IRSTEA / Eric Quinton
 * @license http://www.cecill.info/licences/Licence_CeCILL-C_V1-fr.html LICENCE DE LOGICIEL LIBRE CeCILL-C
 *  Creation 3 juin 2015
 */
include_once 'framework/droits/droits.class.php';
$dataClass = new Aclaco($bdd_gacl,$ObjetBDDParam);
$keyName = "aclaco_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {

	case "display":
		/*
		 * Display the detail of the record
		 */
		$data = $dataClass->lire($id);
		$smarty->assign("data", $data);
		$smarty->assign("corps", "droits/appliDisplay.tpl");
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		$data = dataRead($dataClass, $id, "droits/acoChange.tpl", $_REQUEST["aclappli_id"]);
		$aclAppli = new Aclappli($bdd_gacl, $ObjetBDDParam);
		$smarty->assign("dataAppli", $aclAppli->lire($data["aclappli_id"]));
		$aclgroup = new Aclgroup($bdd_gacl, $ObjetBDDParam);
		$smarty->assign("groupes", $aclgroup->getGroupsFromAco($id));
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