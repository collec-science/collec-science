<?php
/**
 * Created : 16 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/object.class.php';
$dataClass = new Object ( $bdd, $ObjetBDDParam );
$keyName = "uid";
$id = $_REQUEST [$keyName];
switch ($t_module ["param"]) {
	case "getDetailAjax" :
		/**
		 * Retourne le detail d'un objet a partir de son uid
		 * (independamment du type : sample ou container)
		 */
		ob_clean();
		echo json_encode($dataClass->getDetail($id, $_REQUEST["is_container"]));
		ob_flush();
		break;
}
?>