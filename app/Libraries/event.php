<?php 
namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Xx extends PpciLibrary { 
    /**
     * @var xx
     */
    protected PpciModel $dataclass;

    private $keyName;

function __construct()
    {
        parent::__construct();
        $this->dataClass = new XXX();
        $this->keyName = "xxx_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

/**
 * Created : 24 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/event.class.php';
$this->dataclass = new Event();
$this->keyName = "event_id";
$this->id = $_REQUEST[$this->keyName];

	function change(){
$this->vue=service('Smarty');
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		$this->dataRead( $this->id, "gestion/eventChange.tpl", $_REQUEST["uid"]);
		$this->vue->set($_SESSION["moduleParent"], "moduleParent");
		$this->vue->set("tab-event", "activeTab");
		/*
		 * Lecture de l'object concerne
		 */
		require_once 'modules/classes/object.class.php';
		$object = new ObjectClass();
		$this->vue->set($data = $object->lire($_REQUEST["uid"]), "object");

		/*
		 * Recherche des types d'evenement
		 */
		require_once 'modules/classes/eventType.class.php';
		$eventType = new EventType();
		$this->vue->set($eventType->getListeFromCategory($_SESSION["moduleParent"], $data["collection_id"]), "eventType");
		}
	function display(){
$this->vue=service('Smarty');
		$data = $this->dataclass->getDetail($this->id);
		$this->vue->set($data, "data");
		$this->vue->set("gestion/eventDisplay.tpl", "corps");
		$this->vue->set($_SESSION["moduleParent"], "moduleParentOnly");
		$this->vue->set($_SESSION["moduleParent"] . "event", "moduleParent");
		$this->vue->set("tab-event", "activeTab");
		/*
		 * Lecture de l'object concerne
		 */
		require_once 'modules/classes/object.class.php';
		$object = new ObjectClass();
		$this->vue->set($dobject = $object->lire($data["uid"]), "object");
		/**
		 * Recuperation des documents
		 */
		include_once 'modules/classes/document.class.php';
		$document = new Document();
		$this->vue->set($doc = $document->getListFromField("event_id", $this->id), "dataDoc");
		$this->vue->set($document->getMaxUploadSize(), "maxUploadSize");
		$this->vue->set($_SESSION["collections"][$data["collection_id"]]["external_storage_enabled"], "externalStorageEnabled");
		/**
		 * Get the list of authorized extensions
		 */
		$mimeType = new MimeType();
		$this->vue->set($mimeType->getListExtensions(false), "extensions");
		$this->vue->set("event_id", "parentKeyName");
		$this->vue->set($object->verifyCollection($dobject), "modifiable");
		}
	    function write() {
    try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return $this->display();
            } else {
                return $this->change();
            }
        } catch (PpciException) {
            return $this->change();
        }
    }
		/*
		 * write record in database
		 */
		//$this->dataclass->debug_mode = 2;
		$this->id = $this->dataWrite( $_REQUEST, false);
		if ($this->id > 0) {
			$_REQUEST[$this->keyName] = $this->id;
		}
		}
	function delete(){
		/*
		 * delete record
		 */
		 try {
            $this->dataDelete($this->id);
            return $this->list();
        } catch (PpciException $e) {
            return $this->change();
        }
		}

	function search() {
		$_SESSION["moduleParent"] = "eventSearch";
		$this->vue->set("eventSearch", "moduleParent");
		$_SESSION["searchEvent"]->setParam($_REQUEST);
		$dataSearch = $_SESSION["searchEvent"]->getParam();
		if ($_SESSION["searchEvent"]->isSearch() == 1) {
			try {
				$this->vue->set(
					$this->dataclass->searchDueEvent(
						$dataSearch["search_type"],
						$dataSearch["date_from"],
						$dataSearch["date_to"],
						$dataSearch["is_done"],
						$dataSearch["collection_id"],
						$dataSearch["event_type_id"],
						$dataSearch["object_type_id"],
						$dataSearch["object_type"]
					),
					"events"
				);
				$this->vue->set(1, "isSearch");
			} catch (Exception $e) {
				$this->message->set($e->getMessage(), true);
			}
		}
		include_once "modules/classes/collection.class.php";
		$collection = new Collection();
		$this->vue->set($collection->getAllCollections(), "collections");
		include_once "modules/classes/eventType.class.php";
		if ($dataSearch["object_type"] == 1) {
			$category = "sample";
			include_once "modules/classes/sampleType.class.php";
			$sampleType = new SampleType();
			$this->vue->set($sampleType->getListFromCollection($dataSearch["collection_id"]), "objectTypes");
		} else {
			$category = "container";
			include_once "modules/classes/containerType.class.php";
			$ct = new ContainerType();
			$this->vue->set($ct->getListe("container_type_name"), "objectTypes");
		}
		$eventType = new EventType();
		$this->vue->set($eventType->getListeFromCategory($category, $dataSearch["collection_id"]), "eventTypes");
		$this->vue->set($dataSearch, "eventSearch");
		$this->vue->set("gestion/eventSearchList.tpl", "corps");
		}
	function deleteList() {
		if (!empty($_POST["events"])) {
			$db = $this->dataClass->db;
$db->transBegin();
			try {
				foreach ($_POST["events"] as $event_id) {
					$this->dataclass->supprimer($event_id);
				}
				
				$this->message->set(_("Événements supprimés"));
				$module_coderetour = 1;
			} catch (Exception $e) {
				$this->message->set(_("Un problème est survenu pendant la suppression d'un événement"), true);
				$this->message->setSyslog($e->getMessage());
				if ($db->transEnabled) {
    $db->transRollback();
}
				$module_coderetour = -1;
			}
		} else {
			$this->message->set(_("Aucun événement n'a été sélectionné"), true);
			$module_coderetour = -1;
		}
		}
	function changeList() {
		if (!empty($_POST["events"])) {
			$fields = array("event_date", "event_type_id", "due_date", "event_comment", "still_available");
			$data = array();
			foreach ($fields as $field) {
				if (!empty($_POST[$field])) {
					$data[$field] = $_POST[$field];
				}
			}
			if (!empty($data)) {
				$this->dataclass->colonnes["uid"]["requis"] = 0;
				$this->dataclass->colonnes["event_type_id"]["requis"] = 0;
				$db = $this->dataClass->db;
$db->transBegin();
				try {
					foreach ($_POST["events"] as $event_id) {
						$data["event_id"] = $event_id;
						$this->dataclass->ecrire($data);
					}
					
					$this->message->set(_("Événements modifiés"));
					$module_coderetour = 1;
				} catch (Exception $e) {
					$this->message->set(_("Un problème est survenu pendant la modification d'un événement"), true);
					$this->message->setSyslog($e->getMessage());
					if ($db->transEnabled) {
    $db->transRollback();
}
					$module_coderetour = -1;
				}
			} else {
				$this->message->set(_("Aucune modification n'est à apporter aux événements"), true);
				$module_coderetour = -1;
			}
		} else {
			$this->message->set(_("Aucun événement n'a été sélectionné"), true);
			$module_coderetour = -1;
		}
		}
}