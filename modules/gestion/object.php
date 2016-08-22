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
		$vue->set($dataClass->getDetail($id, $_REQUEST["is_container"]));
		break;
	case "printLabel" :
		$data = $dataClass->getForPrint($_REQUEST["uid"]);
		if (count($data) > 0) {
			$vue->set($data);
			$vue->setFilename("printlabel.csv");
		} else {
			unset($vue);
			$module_coderetour = -1;
		}
}
?>