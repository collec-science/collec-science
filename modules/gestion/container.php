<?php

/**
 * Created : 8 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */

require_once 'modules/classes/container.class.php';
require_once 'modules/classes/object.class.php';

$dataClass = new Container($bdd, $ObjetBDDParam);
$keyName = "uid";
if (isset($_SESSION["uid"])) {
  $id = $_SESSION["uid"];
  unset($_SESSION["uid"]);
} else {
  $id = $_REQUEST[$keyName];
}
$_SESSION["moduleParent"] = "container";
if (isset($_REQUEST["activeTab"])) {
  $activeTab = $_REQUEST["activeTab"];
}

switch ($t_module["param"]) {
  case "list":
    $_SESSION["moduleListe"] = "containerList";
    /*
         * Display the list of all records of the table
         */
    if (!isset($isDelete) && !isset($_REQUEST["is_action"])) {
      $_SESSION["searchContainer"]->setParam($_REQUEST);
    }

    $dataSearch = $_SESSION["searchContainer"]->getParam();
    if ($_SESSION["searchContainer"]->isSearch() == 1) {
      $data = $dataClass->containerSearch($dataSearch);
      $vue->set($data, "containers");
      $vue->set(1, "isSearch");
    }
    $vue->set($dataSearch, "containerSearch");
    $vue->set("gestion/containerList.tpl", "corps");
    include_once "modules/classes/borrower.class.php";
    $borrower = new Borrower($bdd, $ObjetBDDParam);
    $vue->set($borrower->getListe(2), "borrowers");
    $vue->set(date($_SESSION["MASKDATE"]), "borrowing_date");
    $vue->set(date($_SESSION["MASKDATE"]), "expected_return_date");
    /*
         * Ajout des listes deroulantes
         */
    include 'modules/gestion/container.functions.php';
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
    $vue->set($activeTab, "activeTab");
    $vue->set("containerDisplay", "moduleFrom");
    $vue->set($id, "containerUid");
    /*
         * Recuperation des identifiants associes
         */
    include_once 'modules/classes/objectIdentifier.class.php';
    $oi = new ObjectIdentifier($bdd, $ObjetBDDParam);
    $vue->set($oi->getListFromUid($data["uid"]), "objectIdentifiers");
    /*
         * Recuperation des contenants parents
         */
    $vue->set($dataClass->getAllParents($data["uid"]), "parents");
    /*
         * Recuperation des contenants et des échantillons contenus
         */
    $dcontainer = $dataClass->getContentContainer($data["uid"]);
    if ($_REQUEST["allSamples"] == 1) {
      require_once "modules/classes/sample.class.php";
      $sample = new Sample($bdd, $ObjetBDDParam);
      $dsample = $sample->getAllSamplesFromContainer($data["uid"]);
      $message->set(_("Affichage avec la liste de tous les échantillons présents dans le contenant, y compris dans les contenants inclus"));
    } else {
      $dsample = $dataClass->getContentSample($data["uid"]);
    }
    $vue->set($dcontainer, "containers");
    $vue->set($dsample, "samples");
    /*
         * Preparation du tableau d'occupation du container
         */
    $vue->set($dataClass->generateOccupationArray($dcontainer, $dsample, $data["columns"], $data["lines"], $data["first_line"], $data["first_column"]), "containerOccupation");
    $vue->set($data["lines"], "nblignes");
    $vue->set($data["columns"], "nbcolonnes");
    $vue->set($data["first_line"], "first_line");
    $vue->set($data["first_column"], "first_column");
    $vue->set($data["line_in_char"], "line_in_char");
    $vue->set($data["column_in_char"], "column_in_char");
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
         * Recuperation des reservations
         */
    include_once 'modules/classes/booking.class.php';
    $booking = new Booking($bdd, $ObjetBDDParam);
    $vue->set($booking->getListFromParent($data["uid"], 'date_from desc'), "bookings");
    /*
         * Recuperation des documents
         */
    include_once 'modules/classes/document.class.php';
    $document = new Document($bdd, $ObjetBDDParam);
    $vue->set($document->getListFromField("uid", $data["uid"]), "dataDoc");
    $vue->set($document->getMaxUploadSize(), "maxUploadSize");
    $vue->set(1, "modifiable");
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
         * Ajout de la liste des referents, pour operations de masse sur les echantillons
         */
    include_once 'modules/classes/referent.class.php';
    $referent = new Referent($bdd, $ObjetBDDParam);
    $vue->set($referent->getListe(2), "referents");
    /**
     * Recuperation des types d'evenements
     */
    include_once 'modules/classes/eventType.class.php';
    $eventType = new EventType($bdd, $ObjetBDDParam);
    $vue->set($eventType->getListe(1), "eventType");
    /**
     * Get the list of borrowings
     */
    include_once "modules/classes/borrowing.class.php";
    $borrowing = new Borrowing($bdd, $ObjetBDDParam);
    $vue->set($borrowing->getFromUid($data["uid"]), "borrowings");
    /**
     * Get the list of borrowers
     */
    include_once 'modules/classes/borrower.class.php';
    $borrower = new Borrower($bdd, $ObjetBDDParam);
    $vue->set($borrower->getListe(2), "borrowers");
    $vue->set(date($_SESSION["MASKDATE"]), "borrowing_date");
    $vue->set(date($_SESSION["MASKDATE"]), "expected_return_date");

    /**
     * Lists for actions on samples
     */
    $vue->set($_SESSION["collections"], "collections");
    include_once 'modules/classes/campaign.class.php';
    $campaign = new Campaign($bdd, $ObjetBDDParam);
    $vue->set($campaign->getListe(2), "campaigns");
    include_once 'modules/classes/containerFamily.class.php';
    $cf = new ContainerFamily($bdd, $ObjetBDDParam);
    $vue->set($cf->getListe(2), "containerFamily");
    include_once 'modules/classes/country.class.php';
    $country = new Country($bdd, $ObjetBDDParam);
    $vue->set($country->getListe(2), "countries");
    include_once 'modules/classes/objectStatus.class.php';
    $objectStatus = new ObjectStatus($bdd, $ObjetBDDParam);
    $vue->set($objectStatus->getListe(1), "objectStatus");
    /**
     * Affichage
     */
    $vue->set($_SESSION["APPLI_code"], "APPLI_code");
    $vue->set("container", "moduleParent");
    $vue->set("gestion/containerDisplay.tpl", "corps");
    include 'modules/gestion/mapInit.php';

    break;
  case "change":
    /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
    dataRead($dataClass, $id, "gestion/containerChange.tpl");
    if ($_REQUEST["container_parent_uid"] > 0 && is_numeric($_REQUEST["container_parent_uid"])) {
      $container_parent = $dataClass->lire($_REQUEST["container_parent_uid"]);
      $vue->set($container_parent["uid"], "container_parent_uid");
      $vue->set($container_parent["identifier"], "container_parent_identifier");
    }
    include 'modules/gestion/container.functions.php';
    include 'modules/gestion/mapInit.php';
    $vue->set(1, "mapIsChange");
    /*
         * Recuperation des referents
         */
    include_once 'modules/classes/referent.class.php';
    $referent = new Referent($bdd, $ObjetBDDParam);
    $vue->set($referent->getListe(2), "referents");

    break;
  case "write":
    /*
         * write record in database
         */
    $id = dataWrite($dataClass, $_REQUEST);
    if ($id > 0) {
      $_REQUEST[$keyName] = $id;
      /*
             * Recherche s'il s'agit d'un contenant a associer dans un autre contenant
             */
      if ($_REQUEST["container_parent_uid"] > 0 && is_numeric($_REQUEST["container_parent_uid"])) {
        include_once 'modules/classes/movement.class.php';
        $movement = new Movement($bdd, $ObjetBDDParam);
        $data = array(
          "uid" => $id,
          "movement_date" => date($_SESSION["MASKDATELONG"]),
          "movement_type_id" => 1,
          "login" => $_SESSION["login"],
          "container_id" => $dataClass->getIdFromUid($_REQUEST["container_parent_uid"]),
          "movement_id" => 0,
          "line_number" => 1,
          "column_number" => 1,

        );
        $movement->ecrire($data);
      }
    }
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
        $message->set(_("Suppression effectuée"));
        $module_coderetour = 1;
      } catch (Exception | ObjetBDDException $e) {
        $message->set($e->getMessage() . " ($uid)");
        $bdd->rollback();
        $module_coderetour = -1;
      }
    } else {
      $message->set(_("Pas de contenants sélectionnés"), true);
      $module_coderetour = -1;
    }
    break;
  case "delete":
    /*
         * delete record
         */
    dataDelete($dataClass, $id);
    $isDelete = true;
    break;


  case "getFromType":
    /*
         * Recherche la liste a partir du type
         */
    $vue->set($dataClass->getFromType($_REQUEST["container_type_id"]));
    break;
  case "getFromUid":
    /*
         * Lecture d'un container a partir de son uid
         */
    $vue->set($dataClass->lire($_REQUEST["uid"]));
    break;
  case "exportGlobal":
    $data = $dataClass->generateExportGlobal($_REQUEST["uids"]);
    $vue->setParam(
      array(
        "content_type" => "application/json",
        "filename" => "export-" . date('Y-m-d-His') . ".json"
      )
    );
    $vue->set(json_encode($data));
    break;
  case "importStage1":
    $vue->set("gestion/containerImport.tpl", "corps");
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
        try {
          /**
           * Get the content of the file
           */
          $handle = fopen($filename, "r");
          $jdata = fread($handle, filesize($filename));
          fclose($handle);

          $data = json_decode($jdata, true);
          if ($data["export_version"] != 1) {
            $module_coderetour = -1;
            throw new ImportException(
              _("La version du fichier importé ne correspond pas à la version attendue")
            );
          }
        } catch (Exception $e) {
          $module_coderetour = -1;
          $message->set($e->getMessage(), true);
        }
        if ($module_coderetour == -1) {
          /**
           * delete of temporary file
           */
          unlink($filename);
          unset($_SESSION["realfilename"]);
        } else {
          $vue->set($dataClass->getAllNamesFromReference($data), "names");
          require_once "modules/gestion/sample.functions.php";
          $sic = new SampleInitClass();
          $vue->set($sic->init(), "dataClass");
          $_SESSION["realfilename"] = $filename;

          $vue->set($_REQUEST["utf8_encode"], "utf8_encode");
          $vue->set(2, "stage");
          $vue->set($_FILES['upfile']['name'], "filename");
        }
      } else {
        $message->set(_("Impossible de recopier le fichier importé dans le dossier temporaire"), true);
        $module_coderetour = -1;
      }
    } else {
      $message->set(_("Pas de fichier téléchargé"), true);
      $module_coderetour = -1;
    }
    $vue->set("gestion/containerImport.tpl", "corps");
    break;
  case "importStage3":
    $realfilename = $_SESSION["realfilename"];

    if (file_exists($realfilename)) {
      try {
        /**
         * Open the file
         */
        $handle = fopen($realfilename, "r");
        $jdata = fread($handle, filesize($realfilename));
        fclose($handle);
        unset($_SESSION["realfilename"]);
        unlink($realfilename);

        $data = json_decode($jdata, true);
        require_once 'modules/gestion/sample.functions.php';
        $sic = new SampleInitClass();
        try {
          $bdd->beginTransaction();
          $dataClass->importExternal($data, $sic, $_POST);
          $result = $dataClass->getUidMinMax();
          $message->set(sprintf(_("Import effectué. %s objets traités"), $result["number"]));
          $message->set(sprintf(_("Premier UID généré : %s"), $result["min"]));
          $message->set(sprintf(_("Dernier UID généré : %s"), $result["max"]));
          $module_coderetour = 1;
          $bdd->commit();
        } catch (ImportObjectException $ie) {
          $bdd->rollBack();
          $message->set($ie->getMessage(), true);
          $module_coderetour = -1;
        } catch (ContainerException $ce) {
          $bdd->rollBack();
          $message->set($ce->getMessage(), true);
          $module_coderetour = -1;
        } catch (Exception $e) {
          $bdd->rollBack();
          $message->set($e->getMessage(), true);
          $module_coderetour = -1;
        }
      } catch (Exception $e1) {
        $message->set($e1->getMessage(), true);
        $module_coderetour = -1;
      }
    }
    break;
  case "lendingMulti":
    /**
     * Lend the containers to a borrower
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

  case "getOccupationAjax":
    $data = $dataClass->lire($id);
    $dcontainer = $dataClass->getContentContainer($id);
    $dsample = $dataClass->getContentSample($id);
    $dgrid = array();
    $grid = $dataClass->generateOccupationArray($dcontainer, $dsample, $data["columns"], $data["lines"], $data["first_line"], $data["first_column"]);
    foreach ($grid as $line) {
      $gl = array();
      foreach ($line as $cell) {
        $gc = array();
        foreach ($cell as $item) {
          $gc[] = $item;
        }
        $gl[] = $gc;
      }
      $dgrid["lines"][] = $gl;
    }
    $dgrid["lineNumber"] = $data["lines"];
    $dgrid["columnNumber"] = $data["columns"];
    $dgrid["firstLine"] = $data["first_line"];
    $dgrid["firstColumn"] = $data["first_column"];
    $dgrid["column_in_char"] = $data["column_in_char"];
    $dgrid["line_in_char"] = $data["line_in_char"];
    $vue->set($dgrid);
    break;

  case "verifyCyclic":
    $vue->set("gestion/containerVerifyCyclic.tpl", "corps");
    break;
  case "verifyCyclicExec":
    $vue->set("gestion/containerVerifyCyclic.tpl", "corps");
    $vue->set($dataClass->getCyclicMovements(), "data");
    $vue->set(1, "exec");
    break;
  case "setStatus":
    try {
      if (count($_POST["uids"]) == 0) {
        throw new ObjectException(_("Pas de contenants sélectionnés"));
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
  case "referentMulti":
    try {
      if (count($_POST["uids"]) == 0) {
        throw new ObjectException(_("Pas de contenants sélectionnés"));
      }
      if (empty($_POST["referent_id"])) {
        throw new ObjectException(_("Pas de référent sélectionné"));
      }
      is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
      $object = new ObjectClass($bdd, $ObjetBDDParam);
      $bdd->beginTransaction();
      foreach ($uids as $uid) {
        $object->setReferent($uid, $_POST["referent_id"]);
      }
      $module_coderetour = 1;
      $bdd->commit();
      $message->set(_("Opération effectuée"));
    } catch (ObjectException $oe) {
      $message->setSyslog($oe->getMessage());
      $message->set(_("Une erreur est survenue pendant l'assignation du référent"), true);
      $message->set($oe->getMessage());
      $module_coderetour = -1;
      $bdd->rollback();
    }
    break;
}
