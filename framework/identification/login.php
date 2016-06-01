<?php
/**
 * 
 * Gestion de la saisie, de la modification d'un login
 * Gestion du changement du mot de passe (en mode BDD)
*/

$dataClass = new LoginGestion($bdd_gacl,$ObjetBDDParam);
$id = $_REQUEST["id"];

switch ($t_module["param"]) {
	case "list":
		/*
		 * Display the list of all records of the table
		 */
		$smarty->assign("liste", $dataClass->getListeTriee());
		$smarty->assign("corps", "ident/loginliste.tpl");
		break;
	case "display":
		/*
		 * Display the detail of the record
		 */
		$data = $dataClass->lire($id);
		$smarty->assign("data", $data);
		$smarty->assign("corps", "example/exampleDisplay.tpl");
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead($dataClass, $id, "ident/loginsaisie.tpl");
		break;
	case "write":
		/*
		 * write record in database
		 */
		$id = dataWrite($dataClass, $_REQUEST);
		if ($id > 0) {
			/*
			 * Ecriture du compte dans la table acllogin
			 */
			require_once 'framework/droits/droits.class.php';
			$acllogin = new Acllogin($bdd_gacl, $ObjetBDDParam);
			if (strlen($_REQUEST["nom"]) > 0) {
				$nom = $_REQUEST["nom"]." ".$_REQUEST["prenom"];
			} else 
				$nom = $_REQUEST["login"];
			$acllogin->addLoginByLoginAndName($_REQUEST["login"], $nom);
		}
		break;
	case "delete":
		/*
		 * delete record
		 */
		dataDelete($dataClass, $id);
		break;
	case "changePassword":
		$smarty->assign("corps", "ident/loginChangePassword.tpl");
		break;
	case 'changePasswordExec':
		$ret = $dataClass->changePassword($_REQUEST["oldPassword"], $_REQUEST["pass1"], $_REQUEST["pass2"]);
		if ($ret < 1) $module_coderetour = -1;
		$message .= $dataClass->getErrorData(1);
		break;
}
?>