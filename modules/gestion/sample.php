<?php
/**
 * Created : 30 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/sample.class.php';
require_once 'modules/classes/object.class.php';
require_once 'modules/gestion/sample.functions.php';
$dataClass = new Sample($bdd, $ObjetBDDParam);
$keyName = "uid";
$id = $_REQUEST[$keyName];
$_SESSION["moduleParent"] = "sample";

switch ($t_module["param"]) {
    case "list":
		/*
		 * Display the list of all records of the table
		 */
		if (! isset($isDelete))
            $_SESSION["searchSample"]->setParam($_REQUEST);
        $dataSearch = $_SESSION["searchSample"]->getParam();
        if ($_SESSION["searchSample"]->isSearch() == 1) {
            $data = $dataClass->sampleSearch($dataSearch);
            $vue->set($data, "samples");
            $vue->set(1, "isSearch");
        }
        $vue->set($dataSearch, "sampleSearch");
        $vue->set("gestion/sampleList.tpl", "corps");
        
        /*
         * Ajout des listes deroulantes
         */
        sampleInitDatEntry();
        /*
         * Ajout de la selection des modeles d'etiquettes
         */
        include 'modules/gestion/label.functions.php';
        break;
    case "display":
		/*
		 * Display the detail of the record
		 */
		$data = $dataClass->lire($id);
        $vue->set($data, "data");
        /*
         * Récupération des métadonnées dans un tableau pour l'affichage
         */
        $metadata = json_decode($data["metadata"], true);
        $is_modifiable = $dataClass->verifyProject($data);
        if ($is_modifiable && count($metadata) > 0) {
            $vue->set($metadata, "metadata");
        }
        /*
         * Recuperation des identifiants associes
         */
        require_once 'modules/classes/objectIdentifier.class.php';
        $oi = new ObjectIdentifier($bdd, $ObjetBDDParam);
        $vue->set($oi->getListFromUid($data["uid"]), "objectIdentifiers");
        /*
         * Recuperation des conteneurs parents
         */
        require_once 'modules/classes/container.class.php';
        $container = new Container($bdd, $ObjetBDDParam);
        $vue->set($container->getAllParents($data["uid"]), "parents");
        /*
         * Recuperation des evenements
         */
        require_once 'modules/classes/event.class.php';
        $event = new Event($bdd, $ObjetBDDParam);
        $vue->set($event->getListeFromUid($data["uid"]), "events");
        /*
         * Recuperation des mouvements
         */
        require_once 'modules/classes/movement.class.php';
        $movement = new Movement($bdd, $ObjetBDDParam);
        $vue->set($movement->getAllMovements($id), "movements");
        /*
         * Recuperation des echantillons associes
         */
        $vue->set($dataClass->getSampleassociated($data["uid"]), "samples");
        /*
         * Recuperation des reservations
         */
        require_once 'modules/classes/booking.class.php';
        $booking = new Booking($bdd, $ObjetBDDParam);
        $vue->set($booking->getListFromParent($data["uid"], 'date_from desc'), "bookings");
        /*
         * Recuperation des sous-echantillonnages
         */
        if ($data["multiple_type_id"] > 0) {
            require_once 'modules/classes/subsample.class.php';
            $subSample = new Subsample($bdd, $ObjetBDDParam);
            $vue->set($subSample->getListFromParent($data["sample_id"], "subsample_date desc"), "subsample");
        }
        /*
         * Verification que l'echantillon peut etre modifie
         */
        if ($is_modifiable)
            $vue->set(1, "modifiable");
        /*
         * Recuperation des documents
         */
        require_once 'modules/classes/document.class.php';
        $document = new Document($bdd, $ObjetBDDParam);
        $vue->set($document->getListFromParent($data["uid"]), "dataDoc");
        /*
         * Ajout de la selection des modeles d'etiquettes
         */
        include 'modules/gestion/label.functions.php';
        /*
         * Affichage
         */
        include 'modules/gestion/mapInit.php';
        $vue->set("sample", "moduleParent");
        $vue->set("gestion/sampleDisplay.tpl", "corps");
        break;
    case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		$data = dataRead($dataClass, $id, "gestion/sampleChange.tpl");
        if ($data["sample_id"] > 0 && $dataClass->verifyProject($data) == false) {
            $message->set("Vous ne disposez pas des droits nécessaires pour modifier cet échantillon");
            $module_coderetour = - 1;
        } else {
            /*
             * Recuperation des informations concernant l'echantillon parent
             */
            if ($data["parent_sample_id"] > 0) {
                $dataParent = $dataClass->lireFromId($data["parent_sample_id"]);
            } else {
                if ($_REQUEST["parent_uid"] > 0) {
                    $dataParent = $dataClass->lire($_REQUEST["parent_uid"]);
                }
            }
            
            if ($dataParent["sample_id"] > 0) {
                $vue->set($dataParent, "parent_sample");
                if ($dataParent["sample_id"] > 0) {
                    if ($data["sample_id"] == 0) {
                        $data["parent_sample_id"] = $dataParent["sample_id"];
                        /*
                         * Pre-positionnement des informations de base
                         */
                        $data["project_id"] = $dataParent["project_id"];
                        $data["wgs84_x"] = $dataParent["wgs84_x"];
                        $data["wgs84_y"] = $dataParent["wgs84_y"];
                        $data["metadata"] = $dataParent["metadata"];
                        $data["sampling_place_id"] = $dataParent["sampling_place_id"];
                    }
                    $vue->set($data, "data");
                }
            } else {
                
                if ($data["sample_id"] == 0 && $_SESSION["last_sample_id"] > 0) {
                    /*
                     * Recuperation des dernieres donnees saisies
                     */
                    $dl = $dataClass->lire($_SESSION["last_sample_id"]);
                    $data["wgs84_x"] = $dl["wgs84_x"];
                    $data["wgs84_y"] = $dl["wgs84_y"];
                    $data["project_id"] = $dl["project_id"];
                    $data["sample_type_id"] = $dl["sample_type_id"];
                    $data["sample_date"] = $dl["sample_date"];
                    $data["sampling_place_id"] = $dl["sampling_place_id"];
                    $data["metadata"] = $dl["metadata"];
                    $data["multiple_value"] = $dl["multiple_value"];
                    $vue->set($data, "data");
                }
            }
            
            sampleInitDatEntry();
            
            include 'modules/gestion/mapInit.php';
            $vue->set(1, "mapIsChange");
        }
        break;
    case "write":
		/*
		 * write record in database
		 */
		$id = dataWrite($dataClass, $_REQUEST);
        if ($id > 0) {
            $_REQUEST[$keyName] = $id;
            /*
             * Stockage en session du dernier echantillon modifie,
             * pour recuperation des informations rattachees pour duplication ou autre
             */
            $_SESSION["last_sample_id"] = $id;
        }
        break;
    case "delete":
		/*
		 * delete record
		 */
		dataDelete($dataClass, $_REQUEST["uid"]);
        $isDelete = true;
        break;
    case "export":
        try {
            $vue->set($dataClass->getForExport($dataClass->generateArrayUidToString($_REQUEST["uid"])));
        } catch (Exception $e) {
            unset($vue);
            $message->set($e->getMessage());
            $module_coderetour = - 1;
        }
        break;
    case "importStage1":
        $vue->set("gestion/sampleImport.tpl", "corps");
        $vue->set(";", "separator");
        $vue->set(0, "utf8_encode");
        break;
    case "importStage2":
        unset($_SESSION["filename"]);
        if (file_exists($_FILES['upfile']['tmp_name'])) {
            /*
             * Deplacement du fichier dans le dossier temporaire
             */
            $filename = $APPLI_temp . '/' . bin2hex(openssl_random_pseudo_bytes(4));
            
            if (copy($_FILES['upfile']['tmp_name'], $filename)) {
                require_once 'modules/classes/import.class.php';
                $import = new Import($filename, $_REQUEST["separator"], $_REQUEST["utf8_encode"]);
                $data = $import->getContentAsArray();
                $import->fileClose();
                /*
                 * Verification si l'import peut etre realise
                 */
                $line = 1;
                foreach ($data as $row) {
                    if (count($row) > 0) {
                        try {
                            $dataClass->verifyBeforeImport($row);
                        } catch (Exception $e) {
                            $message->set("Ligne $line : " . $e->getMessage());
                            $module_coderetour = - 1;
                        }
                        $line ++;
                    }
                }
                if ($module_coderetour == - 1) {
                    /*
                     * Suppression du fichier temporaire
                     */
                    unset($filename);
                } else {
                    
                    /*
                     * Extraction de tous les libelles des tables de reference
                     */
                    $vue->set($dataClass->getAllNamesFromReference($data), "names");
                    /*
                     * Recuperation de tous les libelles connus dans la base de donnees
                     */
                    $sic = new SampleInitClass();
                    $vue->set($sic->init(), "dataClass");
                    $vue->set($filename, "realfilename");
                    $vue->set($_REQUEST["separator"], "separator");
                    $vue->set($_REQUEST["utf8_encode"], "utf8_encode");
                    $vue->set(2, "stage");
                    $vue->set($_FILES['upfile']['name'], "filename");
                    $vue->set("gestion/sampleImport.tpl", "corps");
                }
            } else {
                $message->set("Impossible de recopier le fichier importé dans le dossier temporaire");
                $module_coderetour = - 1;
            }
        }
        break;
    case "importStage3":
        /*
         * Declenchement de l'import
         */
        require_once 'modules/classes/import.class.php';
        require_once 'modules/classes/objectIdentifier.class.php';
        $oid = new ObjectIdentifier($bdd, $ObjetBDDParam);
        $import = new Import($_REQUEST["realfilename"], $_REQUEST["separator"], $_REQUEST["utf8_encode"]);
        $data = $import->getContentAsArray();
        $sic = new SampleInitClass();
        $dclass = $sic->init(true);
        $simpleFields = array(
            "identifier",
            "wgs84_x",
            "wgs84_y",
            "sample_creation_date",
            "sample_date",
            "multiple_value",
            "dbuid_origin",
            "metadata"
        );
        $refFields = array(
            "sampling_place_name",
            "project_name",
            "object_status_name",
            "sample_type_name"
        );
        $dataClass->auto_date = 0;
        $uidmin = 999999999;
        $uidmax = 0;
        foreach ($data as $row) {
            /*
             * Preparation de l'echantillon a importer dans la base
             */
            $sample = array();
            /*
             * Champs simples, sans transcodage
             */
            foreach ($simpleFields as $field) {
                if (strlen($row[$field]) > 0) {
                    if ($field == "metadata") {
                        /*
                         * Ajout d'un decodage/encodage pour les champs json, pour 
                         * eviter les problemes potentiels et verifier la structure
                         */
                        $sample[$field] = json_encode(json_decode($row[$field]));
                    } else {
                        $sample[$field] = $row[$field];
                    }
                }
            }
            /*
             * Champs transcodes
             */
            foreach ($refFields as $field) {
                if (strlen($row[$field]) > 0) {
                    /*
                     * Recheche de la valeur a appliquer dans les donnees post
                     */
                    $value = $row[$field];
                    /*
                     * Transformation des espaces en underscore,
                     * pour tenir compte du transcodage opere par le navigateur
                     */
                    $fieldHtml = str_replace(" ", "_", $value);
                    $newval = $_POST[$field . "-" . $fieldHtml];
                    /*
                     * Recherche de la cle correspondante
                     */
                    $id = $dclass[$field][$newval];
                    if ($id > 0) {
                        $key = $sic->classes[$field]["id"];
                        $sample[$key] = $id;
                    }
                }
            }
            /*
             * Declenchement de l'ecriture en base
             */
            try {
                $uid = $dataClass->ecrireImport($sample);
                if ($uid > 0) {
                    if ($uid < $uidmin) {
                        $uidmin = $uid;
                    }
                    $uidmax = $uid;
                    /*
                     * Traitement des identifiants complementaires
                     */
                    if (strlen($row["identifiers"]) > 0) {
                        $idents = explode(",", $row["identifiers"]);
                        foreach ($idents as $ident) {
                            $idvalue = explode(":", $ident);
                            $dataIdent = array();
                            $dataIdent["uid"] = $uid;
                            /*
                             * Recheche de la valeur a appliquer dans les donnees post
                             */
                            $value = $row[$field];
                            $newval = $_POST["identifier_type_code-" . $idvalue[0]];
                            $dataIdent["identifier_type_id"] = $dclass["identifier_type_code"][$newval];
                            $dataIdent["object_identifier_value"] = $idvalue[1];
                            $oid->ecrire($dataIdent);
                        }
                    }
                }
            } catch (Exception $e) {
                $message->set($e->getMessage());
            }
        }
        if ($uidmax > 0) {
            $message->set("Import des données externes réalisé");
            $message->set("UID minimum généré : " . $uidmin);
            $message->set("UID maximum généré : " . $uidmax);
        } else {
            $message->set("L'import n'a pas abouti, aucun échantillon n'a pu être intégré");
            $module_coderetour = - 1;
        }
        break;
}
?>