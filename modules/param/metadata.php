<?php
/**
 * Created : 8 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/metadata.class.php';
$dataClass = new Metadata($bdd, $ObjetBDDParam);
$keyName = "metadata_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
		/*
		 * Display the list of all records of the table
		 */
		try {
            $vue->set($dataClass->getListe(2), "data");
            $vue->set("param/metadataList.tpl", "corps");
        } catch (Exception $e) {
            $message->set($e->getMessage());
        }
        break;
    case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead($dataClass, $id, "param/metadataChange.tpl");
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
    case "copy":
	    /*
	     * Duplication d'une etiquette
	     */
	    $data = $dataClass->lire($id);
        $data["metadata_id"] = 0;
        $data["metadata_name"] .= " - new version";
        $vue->set($data, "data");
        $vue->set("param/metadataChange.tpl", "corps");
        break;
    case "getSchema":
        $data = $dataClass->lire($id);
        $vue->setJson($data["metadata_schema"]);
        break;
    case "export":
        
        $vue->set($dataClass->getListFromIds($_POST["metadata_id"]));
        break;
    case "import":
        if (file_exists($_FILES['upfile']['tmp_name'])) {
            require_once 'modules/classes/import.class.php';
            try {
                $import = new Import($_FILES['upfile']['tmp_name'], ";", false, array(
                    "metadata_name",
                    "metadata_schema",
                    "metadata_id"
                ));
                $rows = $import->getContentAsArray();
                foreach ($rows as $row) {
                    $data = array(
                        "metadata_name" => $row["metadata_name"],
                        "metadata_schema" => $row["metadata_schema"],
                        "metadata_id" => 0
                    );
                    $dataClass->ecrire($data);
                }
                $message->set("Métadonnée(s) importée(s)");
                $module_coderetour = 1;
            } catch (Exception $e) {
                $message->set("Impossible d'importer les métadonnées");
                $message->set($e->getMessage());
                $module_coderetour = - 1;
            }
        } else {
            $message->set("Impossible de charger le fichier à importer");
            $module_coderetour = - 1;
        }
        break;
}
?>