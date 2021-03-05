<?php

/**
 * @author Eric Quinton
 * @copyright Copyright (c) 2015, IRSTEA / Eric Quinton
 * @license http://www.cecill.info/licences/Licence_CeCILL-C_V1-fr.html LICENCE DE LOGICIEL LIBRE CeCILL-C
 *  Creation 3 juin 2015
 */
include_once 'framework/droits/acllogin.class.php';
$dataClass = new Acllogin($bdd_gacl, $ObjetBDDParam);
$keyName = "acllogin_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
	case "list":
		/*
		 * Display the list of all records of the table
		 */
		$vue->set($dataClass->getListLogins(), "data");
		$vue->set("framework/droits/loginList.tpl", "corps");
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		$data = dataRead($dataClass, $id, "framework/droits/loginChange.tpl");
		if (strlen($data["login"]) > 0) {
			$vue->set($dataClass->getListDroits($data["login"], $GACL_aco, $LDAP), "loginDroits");
		}
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
		try {
			if (function_exists("acllogin_before_delete")) {
				acllogin_before_delete($id);
			}
			dataDelete($dataClass, $id);
		} catch (Exception $e) {
			$message->set($e->getMessage());
		}
		break;
}
