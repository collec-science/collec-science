<?php

/**
 * Created : 30 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/sample.class.php';
require_once 'modules/classes/object.class.php';
require_once 'modules/gestion/sample.functions.php';
$dataClass = new Sample($bdd, $ObjetBDDParam);
$keyName = "uid";
if (isset($_SESSION["uid"])) {
  $id = $_SESSION["uid"];
  unset($_SESSION["uid"]);
} else {
  $id = $_REQUEST[$keyName];
}
$_SESSION["moduleParent"] = "sample";
if (isset($_REQUEST["activeTab"])) {
  $activeTab = $_REQUEST["activeTab"];
}

switch ($t_module["param"]) {
  case "list":
    $_SESSION["moduleListe"] = "sampleList";
    /**
     * Display the list of all records of the table
     */
    if (!isset($isDelete) && !isset($_REQUEST["is_action"])) {
      $_SESSION["searchSample"]->setParam($_REQUEST);
    }
    $vue->set("sampleList", "moduleFrom");
    /**
     * Get the content of a recorded request
     */
    require_once "modules/classes/utils/samplesearch.class.php";
    $samplesearch = new Samplesearch($bdd, $ObjetBDDParam);
    if ($_REQUEST["samplesearch_id"] > 0) {
      $dsamplesearch = $samplesearch->lire($_REQUEST["samplesearch_id"]);
      $_SESSION["searchSample"]->setParamFromJson($dsamplesearch["samplesearch_data"]);
    }
    $dataSearch = $_SESSION["searchSample"]->getParam();
    /**
     * Storage of the request
     */
    if (!empty($_REQUEST["samplesearch_name"])) {
      $dsamplesearch = array(
        "samplesearch_id" => 0,
        "samplesearch_name" => $_REQUEST["samplesearch_name"],
        "samplesearch_data" => json_encode($dataSearch),
        "samplesearch_login" => $_SESSION["login"]
      );
      if ($_REQUEST["samplesearch_collection"] == 1 && $dataClass->verifyCollection($_REQUEST["collection_id"])) {
        $dsamplesearch["collection_id"] = $_REQUEST["collection_id"];
      }
      $samplesearch->ecrire($dsamplesearch, $dsamplesearch["collection_id"]);
    }
    /**
     * Delete a request
     */
    if ($_REQUEST["samplesearchDelete"] == 1 && $_REQUEST["samplesearch_id"] > 0) {
      $samplesearch->delete($_REQUEST["samplesearch_id"]);
    }
    /**
     * Get the list of recorded researches
     */
    $vue->set($samplesearch->getList($_SESSION["collections"]), "samplesearches");
    /**
     * Search samples
     */
    if ($_SESSION["searchSample"]->isSearch() == 1) {
      try {
        $data = $dataClass->sampleSearch($dataSearch);
        /**
         * explode metadata
         */
        foreach ($data as $k => $v) {
          if (!empty($v["metadata"]) && $dataClass->verifyCollection($v)) {
            $data[$k]["metadata_array"] = json_decode($v["metadata"], true);
          }
        }
        $vue->set($data, "samples");
        $vue->set(1, "isSearch");
      } catch (Exception $e) {
        $message->set(_("Un problème est survenu lors de l'exécution de la requête. Contactez votre administrateur pour obtenir un diagnostic"));
        $message->setSyslog($e->getMessage());
      }
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
    /**
     * Map default data
     */
    include "modules/gestion/mapInit.php";
    /**
     * Generate data for markers on the map
     */
    $dataMap["markers"] = array();
    foreach ($data as $row) {
      if (strlen($row["wgs84_x"]) > 0 && strlen($row["wgs84_y"]) > 0) {
        $dataMap["markers"][] = array("latlng" => array($row["wgs84_y"], $row["wgs84_x"]), "uid" => $row["uid"], "identifier" => $row["identifier"]);
      }
    }
    $vue->set(json_encode($dataMap), "markers");
    $vue->htmlVars[] = "markers";
    break;
  case "searchAjax":
    $vue->set($dataClass->sampleSearch($_REQUEST));
    break;
  case "getFromId":
    $vue->set($dataClass->lireFromId($_REQUEST["sample_id"]));
    break;
  case "display":
    /*
         * Display the detail of the record
         */
    $data = $dataClass->lire($id);
    $vue->set($data, "data");
    $vue->set($activeTab, "activeTab");
    /*
         * Récupération des métadonnées dans un tableau pour l'affichage
         */
    $metadata = json_decode($data["metadata"], true);
    $is_modifiable = $dataClass->verifyCollection($data);
    if ($is_modifiable && count($metadata) > 0) {
      $vue->set($metadata, "metadata");
    }
    /*
         * Recuperation des identifiants associes
         */
    include_once 'modules/classes/objectIdentifier.class.php';
    $oi = new ObjectIdentifier($bdd, $ObjetBDDParam);
    $vue->set($oi->getListFromUid($data["uid"]), "objectIdentifiers");
    /*
         * Recuperation des contenants parents
         */
    include_once 'modules/classes/container.class.php';
    $container = new Container($bdd, $ObjetBDDParam);
    $vue->set($container->getAllParents($data["uid"]), "parents");
    /*
         * Recuperation des evenements
         */
    include_once 'modules/classes/event.class.php';
    $event = new Event($bdd, $ObjetBDDParam);
    $vue->set($event->getListeFromUid($data["uid"]), "events");
    /*
         * Recuperation des mouvements
         */
    include_once 'modules/classes/movement.class.php';
    $movement = new Movement($bdd, $ObjetBDDParam);
    $vue->set($movement->getAllMovements($id), "movements");
    /*
         * Recuperation des echantillons associes
         */
    $vue->set($dataClass->getSampleassociated($data["uid"]), "samples");
    /*
         * Recuperation des reservations
         */
    include_once 'modules/classes/booking.class.php';
    $booking = new Booking($bdd, $ObjetBDDParam);
    $vue->set($booking->getListFromParent($data["uid"], 'date_from desc'), "bookings");
    /*
         * Recuperation des sous-echantillonnages
         */
    if ($data["multiple_type_id"] > 0) {
      include_once 'modules/classes/subsample.class.php';
      $subSample = new Subsample($bdd, $ObjetBDDParam);
      $vue->set($subSample->getListFromSample($data["sample_id"]), "subsample");
    }
    /**
     * Get the list of borrowings
     */
    include_once "modules/classes/borrowing.class.php";
    $borrowing = new Borrowing($bdd, $ObjetBDDParam);
    $vue->set($borrowing->getFromUid($data["uid"]), "borrowings");
    /*
         * Verification que l'echantillon peut etre modifie
         */
    if ($is_modifiable) {
      $vue->set(1, "modifiable");
    }
    $vue->set($_SESSION["APPLI_code"], "APPLI_code");
    /*
         * Recuperation des documents
         */
    include_once 'modules/classes/document.class.php';
    $document = new Document($bdd, $ObjetBDDParam);
    $vue->set($document->getListFromField("uid", $data["uid"]), "dataDoc");
    $vue->set($document->getMaxUploadSize(), "maxUploadSize");
    $vue->set($_SESSION["collections"][$data["collection_id"]]["external_storage_enabled"], "externalStorageEnabled");
    /**
     * Get the list of authorized extensions
     */
    $mimeType = new MimeType($bdd, $ObjetBDDParam);
    $vue->set($mimeType->getListExtensions(false), "extensions");
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
    if ($data["sample_id"] > 0 && !$dataClass->verifyCollection($data)) {
      $message->set(_("Vous ne disposez pas des droits nécessaires pour modifier cet échantillon"), true);
      $module_coderetour = -1;
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
            /**
             * Pre-positionnement des informations de base
             */
            $data["collection_id"] = $dataParent["collection_id"];
            $data["wgs84_x"] = $dataParent["wgs84_x"];
            $data["wgs84_y"] = $dataParent["wgs84_y"];
            $data["location_accuracy"] = $dataParent["location_accuracy"];
            $data["metadata"] = $dataParent["metadata"];
            $data["sampling_place_id"] = $dataParent["sampling_place_id"];
            $data["referent_id"] = $dataParent["referent_id"];
            $data["identifier"] = $dataParent["identifier"];
            $data["campaign_id"] = $dataParent["campaign_id"];
            $data["country_id"] = $dataParent["country_id"];
            $data["country_origin_id"] = $dataParent["country_origin_id"];
            $data["uuid"] = $dataClass->getUUID();
          }
          $vue->set($data, "data");
        }
      } else {

        if ($data["sample_id"] == 0 && ($_SESSION["last_sample_id"] > 0 || $_REQUEST["last_sample_id"] > 0)) {
          $_REQUEST["last_sample_id"] > 0 ? $lid = $_REQUEST["last_sample_id"] : $lid = $_SESSION["last_sample_id"];
          /**
           * Recuperation des dernieres donnees saisies
           */
          $dl = $dataClass->lire($lid);
          $data["wgs84_x"] = $dl["wgs84_x"];
          $data["wgs84_y"] = $dl["wgs84_y"];
          $data["location_accuracy"] = $dl["location_accuracy"];
          $data["collection_id"] = $dl["collection_id"];
          $data["sample_type_id"] = $dl["sample_type_id"];
          $data["sampling_date"] = $dl["sampling_date"];
          $data["sampling_place_id"] = $dl["sampling_place_id"];
          $data["metadata"] = $dl["metadata"];
          $data["multiple_value"] = $dl["multiple_value"];
          $data["expiration_date"] = $dl["expiration_date"];
          $data["referent_id"] = $dl["referent_id"];
          $data["campaign_id"] = $dl["campaign_id"];
          $data["country_id"] = $dl["country_id"];
          $data["country_origin_id"] = $dl["country_origin_id"];
          if (empty($data["country_id"])) {
            $data["country_id"] = $_SESSION["countryDefaultId"];
          }
          if ($_REQUEST["is_duplicate"] == 1) {
            $data["parent_sample_id"] = $dl["parent_sample_id"];
            $data["sample_type_id"] = $dl["sample_type_id"];
            $data["identifier"] = $dl["identifier"];
            $data["uuid"] = $dataClass->getUUID();
            if ($data["parent_sample_id"] > 0) {
              $dataParent = $dataClass->lireFromId($data["parent_sample_id"]);
              $vue->set($dataParent, "parent_sample");
            }
          }
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
  case "deleteMulti":
    /*
         * Delete all records in uid array
         */
    if (count($_POST["uids"]) > 0) {
      is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
      $bdd->beginTransaction();
      try {
        foreach ($uids as $uid) {
          dataDelete($dataClass, $uid, true);
        }
        $bdd->commit();
        $module_coderetour = 1;
        $message->set(_("Suppression effectuée"));
      } catch (Exception $e) {
        $message->set(_("La suppression des échantillons a échoué"), true);
        $message->set($e->getMessage());
        $bdd->rollback();
        $module_coderetour = -1;
      }
    } else {
      $message->set(_("Pas d'échantillons sélectionnés"), true);
      $module_coderetour = -1;
    }
    break;
  case "referentAssignMulti":
    /*
         * change all referents for records in uid array
         */
    if (count($_POST["uids"]) > 0) {
      is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
      include_once 'modules/classes/object.class.php';
      $object = new ObjectClass($bdd, $ObjetBDDParam);
      $bdd->beginTransaction();
      try {
        foreach ($uids as $uid) {
          $dataClass->setReferent($uid, $object, $_REQUEST["referent_id"]);
        }
        $bdd->commit();
        $message->set(_("Affectation effectuée"));
        $module_coderetour = 1;
        /**
         * Forçage du retour
         */
        $t_module["retourok"] = $_POST["lastModule"];
      } catch (ObjectException $oe) {
        $message->set(_("Erreur d'écriture dans la base de données"), true);
        $bdd->rollback();
        $module_coderetour = -1;
        $t_module["retourko"] = $_POST["lastModule"];
      } catch (Exception $e) {
        $message->set(
          _("L'affectation des référents aux échantillons a échoué"),
          true
        );
        $message->set($e->getMessage());
        $t_module["retourko"] = $_POST["lastModule"];
        $module_coderetour = -1;
        $bdd->rollback();
      }
    }
    break;
  case "eventAssignMulti":
    /**
     * Create an event for all selected samples
     */
    if (count($_POST["uids"]) > 0) {
      is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
      include_once 'modules/classes/event.class.php';
      $event = new Event($bdd, $ObjetBDDParam);
      $de = $event->getDefaultValue();
      $de["event_date"] = $_POST["event_date"];
      $de["event_type_id"] = $_POST["event_type_id"];
      $de["event_comment"] = $_POST["event_comment"];
      $bdd->beginTransaction();
      try {
        foreach ($uids as $uid) {
          $de["uid"] = $uid;
          $event->ecrire($de);
        }
        $bdd->commit();
        $message->set(_("Création des événements effectuée"));
        $module_coderetour = 1;
        /**
         * Forçage du retour
         */
        $t_module["retourok"] = $_POST["lastModule"];
      } catch (ObjectException $oe) {
        $message->set(_("Erreur d'écriture dans la base de données"), true);
        $bdd->rollback();
        $module_coderetour = -1;
        $t_module["retourko"] = $_REQUEST["lastModule"];
      } catch (Exception $e) {
        $message->set(
          _("La création des événements a échoué"),
          true
        );
        $message->set($e->getMessage());
        $t_module["retourko"] = $_REQUEST["lastModule"];
        $module_coderetour = -1;
        $bdd->rollback();
      }
    }
    break;
  case "lendingMulti":
    /**
     * Lend the samples to a borrower
     */
    if (count($_POST["uids"]) > 0 && $_POST["borrower_id"] > 0) {
      is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
      include_once "modules/classes/borrowing.class.php";
      $borrowing = new Borrowing($bdd, $ObjetBDDParam);
      include_once "modules/classes/movement.class.php";
      $movement = new Movement($bdd, $ObjetBDDParam);
      try {
        $bdd->beginTransaction();
        $datejour = date($_SESSION["MASKDATE"]);
        foreach ($uids as $uid) {
          $borrowing->setBorrowing(
            $uid,
            $_POST["borrower_id"],
            $_POST["borrowing_date"],
            $_POST["expected_return_date"]
          );
          /**
           * Generate an exit movement
           */
          $movement->addMovement($uid, null, 2, 0, $_SESSION["login"], null, _("Objet prêté"));
        }
        $module_coderetour = 1;
        $message->set(_("Opération de prêt enregistrée"));
        $bdd->commit();
      } catch (MovementException $me) {
        $message->set(_("Erreur lors de la génération du mouvement de sortie"), true);
        $message->set($me->getMessage());
        $bdd->rollback();
      } catch (Exception $e) {
        $message->set(_("Un problème est survenu lors de l'enregistrement du prêt"), true);
        $message->set($e->getMessage());
        $bdd->rollback();
        $module_coderetour = -1;
      }
    } else {
      $module_coderetour = -1;
    }

    break;
  case "exitMulti":
    if (count($_POST["uids"]) > 0) {
      include_once "modules/classes/movement.class.php";
      $movement = new Movement($bdd, $ObjetBDDParam);
      try {
        $bdd->beginTransaction();
        foreach ($_POST["uids"] as $uid) {
          $movement->addMovement($uid, null, 2, 0, $_SESSION["login"], null, null);
        }
        $module_coderetour = 1;
        $bdd->commit();
      } catch (MovementException $me) {
        $message->set(_("Erreur lors de la génération du mouvement de sortie"), true);
        $message->set($me->getMessage());
        $bdd->rollback();
      } catch (Exception $e) {
        $message->set(_("Un problème est survenu lors de la génération des mouvements"), true);
        $message->set($e->getMessage());
        $bdd->rollback();
        $module_coderetour = -1;
      }
    } else {
      $module_coderetour = -1;
    }
    break;
  case "entryMulti":
    if (count($_POST["uids"]) > 0 && $_POST["container_uid"] > 0) {
      include_once "modules/classes/movement.class.php";
      $movement = new Movement($bdd, $ObjetBDDParam);
      try {
        $bdd->beginTransaction();
        foreach ($_POST["uids"] as $uid) {
          if ($_POST["container_uid"] == $uid) {
            throw new MovementException(sprintf(_("L'objet %s ne peut être stocké dans lui-même", $uid)));
          }
          $movement->addMovement($uid, null, 1, $_POST["container_uid"], $_SESSION["login"], $_POST["storage_location"], null, null, $_POST["column_number"], $_POST["line_number"]);
        }
        $module_coderetour = 1;
        $bdd->commit();
      } catch (MovementException $me) {
        $message->set(_("Erreur lors de la génération du mouvement d'entrée"), true);
        $message->set($me->getMessage());
        $bdd->rollback();
      } catch (Exception $e) {
        $message->set(_("Un problème est survenu lors de la génération des mouvements"), true);
        $message->set($e->getMessage());
        $bdd->rollback();
        $module_coderetour = -1;
      }
    } else {
      $module_coderetour = -1;
    }
    break;
  case "export":
    try {
      $vue->set(
        $dataClass->getForExport(
          $dataClass->generateArrayUidToString($_REQUEST["uids"])
        )
      );
      $vue->regenerateHeader();
    } catch (Exception $e) {
      unset($vue);
      $message->set($e->getMessage(), true);
      $module_coderetour = -1;
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
      $_SESSION["realfilename"] = $filename;
      if (copy($_FILES['upfile']['tmp_name'], $filename)) {
        include_once 'modules/classes/import.class.php';
        try {
          $fields = array(
            "dbuid_origin",
            "identifier",
            "sample_type_name",
            "collection_name",
            "object_status_name",
            "wgs84_x",
            "wgs84_y",
            "sample_creation_date",
            "sampling_date",
            "expiration_date",
            "multiple_value",
            "sampling_place_name",
            "metadata",
            "identifiers",
            "dbuid_parent",
            "referent_name",
            "location_accuracy",
            "campaign_name",
            "uuid",
            "country_code",
            "country_origin_code",
            "comment"
          );
          $import = new Import($filename, $_REQUEST["separator"], $_REQUEST["utf8_encode"], $fields);
          $data = $import->getContentAsArray();
          $import->fileClose();

          /**
           * Verification si l'import peut etre realise
           */
          $line = 1;
          foreach ($data as $row) {
            if (count($row) > 0) {
              try {
                $dataClass->verifyBeforeImport($row);
              } catch (Exception $e) {
                // traduction: bien conserver inchangées les chaînes %1$s, %2$s
                $message->set(sprintf(_('Ligne %1$s : %2$s'), $line, $e->getMessage()), true);
                $module_coderetour = -1;
              }
              $line++;
            }
          }
          if ($module_coderetour == -1) {
            /*
                         * Suppression du fichier temporaire
                         */
            unset($filename);
            unset($_SESSION["realfilename"]);
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
        } catch (ImportException $e) {
          $module_coderetour = -1;
          $message->set($e->getMessage(), true);
        }
      } else {
        $message->set(_("Impossible de recopier le fichier importé dans le dossier temporaire"), true);
        $module_coderetour = -1;
      }
    }
    break;
  case "detail":
    /**
     * Get all data for a sample in raw format
     */
    $errors = array(
      500 => "Internal Server Error",
      400 => "Bad request",
      401 => "Unauthorized",
      520 => "Unknown error",
      404 => "Not Found"
    );
    try {
      if (strlen($_REQUEST["uuid"]) == 36) {
        $id = $_REQUEST["uuid"];
      }
      if (strlen($id) == 0) {
        throw new SampleException("uid $id not valid", 404);
      }
      $withContainer = true;
      $withEvent = true;
      $withTemplate = false;
      if (isset($_REQUEST["template_name"])) {
        require_once "modules/classes/export/datasetTemplate.class.php";
        $datasetTemplate = new DatasetTemplate($bdd, $ObjetBDDParam);
        try {
          $ddataset = $datasetTemplate->getTemplateFromName($_REQUEST["template_name"]);
          $withTemplate = true;
        } catch (DatasetTemplateException $dte) {
          throw new SampleException($dte->getMessage());
        }
      }
      $data = $dataClass->getRawDetail($id, $withContainer, $withEvent);
      if (count($data) == 0) {
        throw new SampleException("$id not found", 404);
      }
      /**
       * purge the technical fields
       */
      $fields = array("sample_id", "sample_type_id", "campaign_id", "parent_sample_id", "multiple_type_id", "multiple_type_name", "country_id", "object_status_id", "operation_id", "operation_order", "document_id", "movement_type_id", "sampling_place_id", "real_referent_id", "borrower_id", "country_origin_id");
      foreach ($fields as $field) {
        unset($data[$field]);
      }
      /**
       * Search for collection
       */
      if (isset($_SESSION["login"])) {
        if (!$dataClass->verifyCollection($data)) {
          throw new SampleException("Not sufficient rights for $id", 401);
        }
      } else {
        /**
         * Verify if the collection is public
         */
        require_once "modules/classes/collection.class.php";
        $collection = new Collection($bdd, $ObjetBDDParam);
        $dcollection = $collection->lire($data["collection_id"]);
        if (!$dcollection["public_collection"]) {
          throw new SampleException("Not a public collection for $id", 401);
        }
        if (!$withTemplate) {
          throw new SampleException("The name of the template is not specified in the request", 400);
        }
      }
      /**
       * Format the data, if required
       */
      if ($withTemplate) {
        $data = $datasetTemplate->formatData(array(0 => $data))[0];
      }
    } catch (Exception $e) {
      $error_code = $e->getCode();
      if ($error_code == 0) {
        $error_code = 520;
      }
      $data = array(
        "error_code" => $error_code,
        "error_message" => $errors[$error_code]
      );
      if ($APPLI_modeDeveloppement) {
        $data["error_content"] = $e->getMessage();
      }
      $message->setSyslog($e->getMessage());
    } finally {
      $vue->setJson(json_encode($data));
    }
    break;
  case "setCountry":
    try {
      if (count($_POST["uids"]) == 0) {
        throw new ObjectException(_("Pas d'échantillons sélectionnés"));
      }
      if (empty($_POST["country_id"])) {
        throw new ObjectException(_("Pas de pays sélectionné"));
      }
      is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
      $dataClass->setCountry($_POST["uids"], $_POST["country_id"]);
      $module_coderetour = 1;
    } catch (ObjectException $oe) {
      $message->setSyslog($oe->getMessage());
      $message->set(_("Une erreur est survenue pendant la mise à jour du pays"), true);
      $message->set($oe->getMessage());
      $module_coderetour = -1;
    }
    break;
  case "setCollection":
    try {
      if (count($_POST["uids"]) == 0) {
        throw new ObjectException(_("Pas d'échantillons sélectionnés"));
      }
      if (empty($_POST["collection_id_change"])) {
        throw new ObjectException(_("Pas de collection sélectionnée"));
      }
      is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
      $dataClass->setCollection($_POST["uids"], $_POST["collection_id_change"]);
      $module_coderetour = 1;
    } catch (ObjectException $oe) {
      $message->setSyslog($oe->getMessage());
      $message->set(_("Une erreur est survenue pendant la mise à jour de la collection"), true);
      $message->set($oe->getMessage());
      $module_coderetour = -1;
    }
    break;
  case "setCampaign":
    try {
      if (count($_POST["uids"]) == 0) {
        throw new ObjectException(_("Pas d'échantillons sélectionnés"));
      }
      if (empty($_POST["campaign_id"])) {
        throw new ObjectException(_("Pas de campagne sélectionnée"));
      }
      is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);

      $dataClass->setCampaign($_POST["uids"], $_POST["campaign_id"]);
      $module_coderetour = 1;
    } catch (ObjectException $oe) {
      $message->setSyslog($oe->getMessage());
      $message->set(_("Une erreur est survenue pendant la mise à jour de la campagne"), true);
      $message->set($oe->getMessage());
      $module_coderetour = -1;
    }
    break;
  case "setStatus":
    try {
      if (count($_POST["uids"]) == 0) {
        throw new ObjectException(_("Pas d'échantillons sélectionnés"));
      }
      if (empty($_POST["object_status_id"])) {
        throw new ObjectException(_("Pas de statut sélectionné"));
      }
      is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
      $object = new ObjectClass($bdd, $ObjetBDDParam);
      $object->setStatus($_POST["uids"], $_POST["object_status_id"]);
      $module_coderetour = 1;
    } catch (ObjectException $oe) {
      $message->setSyslog($oe->getMessage());
      $message->set(_("Une erreur est survenue pendant la mise à jour du statut"), true);
      $message->set($oe->getMessage());
      $module_coderetour = -1;
    }
    break;
  default:
    break;
}
