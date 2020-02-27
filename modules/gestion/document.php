<?php

/**
 * @author Eric Quinton
 * @copyright Copyright (c) 2014, IRSTEA / Eric Quinton
 * @license http://www.cecill.info/licences/Licence_CeCILL-C_V1-fr.html LICENCE DE LOGICIEL LIBRE CeCILL-C
 *  Creation 7 avr. 2014
 */
include_once 'modules/classes/document.class.php';
$dataClass = new Document($bdd, $ObjetBDDParam);
$keyName = "document_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 * moduleParent : nom du module a rappeler apres enregistrement
		 * parentType : nom de la table à laquelle sont rattaches les documents
		 * parentIdName : nom de la cle de la table parente
		 * parent_id : cle de la table parente
		 */
		dataRead($dataClass, $id, "gestion/documentChange.tpl", $_REQUEST["uid"]);
		/**
		 * Get the list of authorized extensions
		 */
		$mimeType = new MimeType($bdd, $ObjetBDDParam);
		$vue->set($data = $mimeType->getListExtensions(false), "extensions");
		break;
	case "write":
		/*
		 * write record in database
		 */
		/*
			 * Preparation de files
			 */
		$files = array();
		$fdata = $_FILES['documentName'];
		if (is_array($fdata['name'])) {
			for ($i = 0; $i < count($fdata['name']); ++$i) {
				$files[] = array(
					'name' => $fdata['name'][$i],
					'type' => $fdata['type'][$i],
					'tmp_name' => $fdata['tmp_name'][$i],
					'error' => $fdata['error'][$i],
					'size' => $fdata['size'][$i]
				);
			}
		} else {
			$files[] = $fdata;
		}
		strlen($_REQUEST["parentKeyName"]) > 0 ? $parentKeyName = $_REQUEST["parentKeyName"] : $parentKeyName = "uid";
		$parentKeyValue = $_REQUEST[$parentKeyName];
		foreach ($files as $file) {
			$id = $dataClass->ecrire($file, $parentKeyName, $parentKeyValue, $_REQUEST["document_description"], $_REQUEST["document_creation_date"]);
			if ($id > 0) {
				$_REQUEST[$keyName] = $id;
				$module_coderetour = 1;
			} else {
				$module_coderetour = -1;
			}
		}
		break;
	case "delete":
		/*
		 * delete record
		 */
		dataDelete($dataClass, $id);
		break;
	case "get":
		/*
		 * Envoi du document au navigateur
		 * Generation du nom du document
		 */
		$tmp_name = $dataClass->prepareDocument($id, $_REQUEST["phototype"]);
		if (strlen($tmp_name) > 0 && is_file($tmp_name)) {
			/*
			 * Recuperation du type mime
			 */
			$data = $dataClass->getData($id);
			$param = array("tmp_name" => $tmp_name, "content_type" => $data["content_type"]);
			if ($_REQUEST["attached"] == 1) {
				$param["disposition"] = "attachment";
				$fn = explode('/', $tmp_name);
				$param["filename"] = $fn[count($fn) - 1];
			} else {
				$param["disposition"] = "inline";
			}
			$vue->setParam($param);
		} else {
			unset($vue);
			$module_coderetour = -1;
		}
		break;
}
