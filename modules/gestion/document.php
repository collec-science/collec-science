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
			$id = $dataClass->documentWrite($file, $parentKeyName, $parentKeyValue, $_REQUEST["document_description"], $_REQUEST["document_creation_date"]);
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
	case "getSW":
		/**
		 * Get the document from a web service or direct request
		 */
		$errors = array(
			500 => "Internal Server Error",
			401 => "Unauthorized",
			520 => "Unknown error",
			404 => "Not Found"
		);
		try {
			if (strlen($_REQUEST["uid"]) == 0 && strlen($_REQUEST["uuid"]) == 0) {
				throw new DocumentException("Identifier not provided", 404);
			}
			strlen($_REQUEST["uid"] == 0)  ? $uuid = $_REQUEST["uuid"] : $uuid = $_REQUEST["uid"];
			$data = $dataClass->getDetailFromUuid($uuid);
			if (count($data) == 0) {
				throw new SampleException("$uuid not found", 404);
			}
			/**
			 * Search for collection
			 */
			if (isset($_SESSION["login"])) {
				$collectionOk = false;
				foreach ($_SESSION["collections"] as $value) {
					if ($data["collection_id"] == $value["collection_id"]) {
						$collectionOk = true;
						break;
					}
				}
				if (!$collectionOk) {
					throw new DocumentException("Not sufficient rights for $uuid", 401);
				}
			} else {
				/**
				 * Verify if the collection is public
				 */
				require_once "modules/classes/collection.class.php";
				$collection = new Collection($bdd, $ObjetBDDParam);
				$dcollection = $collection->lire($data["collection_id"]);
				if (!$dcollection["public_collection"]) {
					throw new DocumentException("Not a public collection for $uuid", 401);
				}
			}
			/**
			 * Get the content of the document
			 */
			$handle = $dataClass->getDocument($data["document_id"]);
			isset($_REQUEST["mode"]) ? $mode = $_REQUEST["mode"] : $mode = "inline";
			$vue->setParam(
				array(
					"filename" => $data["document_name"],
					"tmp_name" => $handle,
					"content_type" => $data["content_type"],
					"disposition" => $mode,
					"is_reference" => true,
					"handle" => $handle
				)
			);
		} catch (Exception $e) {
			$error_code = $e->getCode();
			if ($error_code == 0) {
				$error_code = 520;
			}
			$data = array(
				"error_code" => $error_code,
				"error_message" => $e->getMessage()
			);
			$module_coderetour = -1;
			$message->setSyslog($e->getMessage());
		}
		break;
	case "getSWerror":
		$vue->set($data);
		break;
		case "externalGetList":

		if ($_REQUEST["uid"] > 0) {
			/**
			 * Get the collection of the sample
			 */
			include_once "modules/classes/sample.class.php";
			$sample = new Sample($bdd, $ObjetBDDParam);
			$dsample = $sample->lire($_REQUEST["uid"]);
			if (! $sample->verifyCollection($dsample)) {
				break;
			}
    $listFiles = array();
		$dir = $_SESSION["collections"][$dsample["collection_id"]]["external_storage_root"];
    if (!empty($_REQUEST["path"]) && $_REQUEST["path"] != "#") {
			$path = str_replace(array(".."), array(""), $_REQUEST["path"]);
      $dir .= "/". $path;
		}
      if (is_dir($dir)) {
        if ($dh = opendir($dir)) {
          while (($file = readdir($dh)) !== false) {
            if ($file != ".." && $file != ".") {
              $f = array("name" => $file, "id"=>$path."-".$file, "value"=>$path.'/'.$file, "folder"=>false);
							if (filetype($dir . "/" . $file) == "dir") {
								$f["folder"] = true;
							}
              /*if (filetype($dir . "/" . $file) == "dir") {
                $f["isFolder"] = true;
                $f["hasSubfolder"] = true;
              } else {
                $f["ext"] =  pathinfo($dir . "/" . $file, PATHINFO_EXTENSION);
                $f["subitems"][] = date($_SESSION["MASKDATE"], filemtime($dir . "/" . $file));
                $f["subitems"][] = number_format((filesize($dir . "/" . $file) / (1024 * 1024)), 3) . " Mb";
              }*/
              $listFiles[] = $f;
            }
          }
        }
      }
    }
    $vue->set($listFiles);
    break;

}
