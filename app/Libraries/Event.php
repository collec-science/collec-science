<?php

namespace App\Libraries;

use App\Models\Collection;
use App\Models\ContainerType;
use App\Models\Document;
use App\Models\Event as ModelsEvent;
use App\Models\EventType;
use App\Models\MimeType;
use App\Models\ObjectClass;
use App\Models\SampleType;
use App\Models\SearchEvent;
use DateInterval;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Event extends PpciLibrary
{
	/**
	 * @var ModelsEvent
	 */
	protected PpciModel $dataclass;



	function __construct()
	{
		parent::__construct();
		$this->dataclass = new ModelsEvent();
		$this->keyName = "event_id";
		if (isset($_REQUEST[$this->keyName])) {
			$this->id = $_REQUEST[$this->keyName];
		}
		if (!isset($_SESSION["searchEvent"])) {
			$_SESSION["searchEvent"] = new SearchEvent;
		}
	}

	function change()
	{
		if (empty($_SESSION["moduleParent"])) {
			$this->message->set(_("L'accès direct à ce module n'est pas possible"), true);
			return defaultPage();
		}
		$this->vue = service('Smarty');
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		$this->dataRead($this->id, "gestion/eventChange.tpl", $_REQUEST["uid"]);
		$this->vue->set($_SESSION["moduleParent"], "moduleParent");
		$this->vue->set("tab-event", "activeTab");
		/*
		 * Lecture de l'object concerne
		 */
		$object = new ObjectClass();
		$this->vue->set($data = $object->lire($_REQUEST["uid"]), "object");

		/*
		 * Recherche des types d'evenement
		 */
		$eventType = new EventType();
		$this->vue->set($eventType->getListeFromCategory($_SESSION["moduleParent"], $data["collection_id"]), "eventType");
		return $this->vue->send();
	}
	function display()
	{
		$this->vue = service('Smarty');
		$data = $this->dataclass->getDetail($this->id);
		$this->vue->set($data, "data");
		$this->vue->set("gestion/eventDisplay.tpl", "corps");
		$this->vue->set($_SESSION["moduleParent"], "moduleParentOnly");
		$this->vue->set($_SESSION["moduleParent"] . "event", "moduleParent");
		$this->vue->set("tab-event", "activeTab");
		/*
		 * Lecture de l'object concerne
		 */
		$object = new ObjectClass();
		$this->vue->set($dobject = $object->lire($data["uid"]), "object");
		/**
		 * Recuperation des documents
		 */
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
		return $this->vue->send();
	}
	function write()
	{
		try {
			$this->id = $this->dataWrite($_REQUEST);
			if ($this->id > 0) {
				$_REQUEST[$this->keyName] = $this->id;
				return true;
			} else {
				return false;
			}
		} catch (PpciException) {
			return false;
		}
	}
	function delete()
	{
		/*
		 * delete record
		 */
		try {
			$this->dataDelete($this->id);
			return true;
		} catch (PpciException $e) {
			return false;
		}
	}

	function search()
	{
		$this->vue = service('Smarty');
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
			} catch (PpciException $e) {
				$this->message->set($e->getMessage(), true);
			}
		}
		$collection = new Collection();
		$this->vue->set($collection->getAllCollections(), "collections");
		if ($dataSearch["object_type"] == 1) {
			$category = "sample";
			$sampleType = new SampleType();
			$this->vue->set($sampleType->getListFromCollection($dataSearch["collection_id"]), "objectTypes");
		} else {
			$category = "container";
			$ct = new ContainerType();
			$this->vue->set($ct->getListe("container_type_name"), "objectTypes");
		}
		$eventType = new EventType();
		$this->vue->set($eventType->getListeFromCategory($category, $dataSearch["collection_id"]), "eventTypes");
		$this->vue->set($dataSearch, "eventSearch");
		$this->vue->set("gestion/eventSearchList.tpl", "corps");
		return $this->vue->send();
	}
	function deleteList()
	{
		if (!empty($_POST["events"])) {
			$db = $this->dataclass->db;
			$db->transBegin();
			try {
				foreach ($_POST["events"] as $event_id) {
					$this->dataclass->supprimer($event_id);
				}
				$db->transCommit();
				$this->message->set(_("Événements supprimés"));
			} catch (PpciException $e) {
				$this->message->set(_("Un problème est survenu pendant la suppression d'un événement"), true);
				$this->message->setSyslog($e->getMessage(), true);
				if ($db->transEnabled) {
					$db->transRollback();
				}
			}
		} else {
			$this->message->set(_("Aucun événement n'a été sélectionné"), true);
		}
		return $this->search();
	}
	function changeList()
	{
		if (!empty($_POST["events"])) {
			$fields = array("event_date", "event_type_id", "due_date", "event_comment", "still_available");
			$data = array();
			foreach ($fields as $field) {
				if (!empty($_POST[$field])) {
					$data[$field] = $_POST[$field];
				}
			}
			if (!empty($data)) {
				$this->dataclass->disableMandatoryField("uid");
				$this->dataclass->disableMandatoryField("event_type_id");
				$db = $this->dataclass->db;
				$db->transBegin();
				try {
					foreach ($_POST["events"] as $event_id) {
						$data["event_id"] = $event_id;
						$this->dataclass->ecrire($data);
					}
					$db->transCommit();
					$this->message->set(_("Événements modifiés"));
				} catch (PpciException $e) {
					$this->message->set(_("Un problème est survenu pendant la modification d'un événement"), true);
					$this->message->setSyslog($e->getMessage(), true);
					if ($db->transEnabled) {
						$db->transRollback();
					}
				}
			} else {
				$this->message->set(_("Aucune modification n'est à apporter aux événements"), true);
			}
		} else {
			$this->message->set(_("Aucun événement n'a été sélectionné"), true);
		}
		return $this->search();
	}
	/**
	 * Duplicate one or multiple events,
	 * if the date of realization is filled in
	 *
	 * @return void
	 */
	function duplicate()
	{
		if ($_REQUEST["event_id"] > 0) {
			$events[] = $_REQUEST["event_id"];
		} else {
			$events = $_POST["events"];
		}
		if (empty($events)) {
			$this->message->set(_("Aucun événement n'a été sélectionné"), true);
		} else {
			$eventDueDelay = $_REQUEST["eventDueDelay"];
			if (empty($eventDueDelay)) {
				$this->message->set(_("Le délai de reprogrammation des événements n'a pas été indiqué"), true);
			} else {
				$db = $this->dataclass->db;
				$this->dataclass->autoFormatDate = false;
				$db->transBegin();
				try {
					$delay = new DateInterval('P' . $eventDueDelay . 'D');
					foreach ($events as $event_id) {
						if (!$this->dataclass->verifyCollection("event_id", ["id" => $event_id])) {
							throw new PpciException(sprintf(_("Vous ne disposez pas des droits suffisants pour modifier l'événement %s"), $event_id));
						}
						$devent = $this->dataclass->read($event_id);
						if (empty($devent["event_date"])) {
							throw new PpciException(sprintf(_("La date de réalisation del l'événement %s n'a pas été renseignée"), $event_id));
						}
						$devent["event_id"] = 0;
						$devent["event_comment"] = "";
						$devent["still_available"] = "";
						$currentdate = date_create($devent["event_date"]);
						$devent["due_date"] = date_format(date_add($currentdate, $delay),'Y-m-d');
						$devent["event_date"] = "";
						$this->dataclass->write($devent);
					}
					$db->transcommit();
				} catch (PpciException $e) {
					$this->message->set($e->getMessage(), true);
					$db->transRollback();
				}
				$this->dataclass->autoFormatDate = true;
			}
		}
	}
}
