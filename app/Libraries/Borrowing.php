<?php

namespace App\Libraries;

use App\Models\Borrower;
use App\Models\Borrowing as ModelsBorrowing;
use App\Models\Movement;
use App\Models\ObjectClass;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Borrowing extends PpciLibrary
{
	/**
	 * @var ModelsBorrowing
	 */
	protected PpciModel $dataclass;

	private $keyName;

	function __construct()
	{
		parent::__construct();
		$this->dataclass = new ModelsBorrowing();
		$this->keyName = "borrowing_id";
		if (isset($_REQUEST[$this->keyName])) {
			$this->id = $_REQUEST[$this->keyName];
		}
	}

	function change()
	{
		$this->vue = service('Smarty');
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		$this->dataRead($this->id, "gestion/borrowingChange.tpl", $_REQUEST["uid"]);
		$this->vue->set($_SESSION["moduleParent"], "moduleParent");
		/*
		 * Recherche des types d'evenement
		 */
		$borrower = new Borrower();
		$this->vue->set($borrower->getListe(2), "borrowers");
		$this->vue->set("tab-event", "activeTab");
		/*
		 * Lecture de l'object concerne
		 */
		require_once 'modules/classes/object.class.php';
		$object = new ObjectClass();
		$this->vue->set($object->lire($_REQUEST["uid"]), "object");
	}
	function write()
	{
		try {

			/*
		 * write record in database
		 */
			//$this->dataclass->debug_mode = 2;
			$this->id == 0 ? $isNew = true : $isNew = false;
			$db = $this->dataclass->db;
			$db->transBegin();
			if ($isNew) {
				$this->id = $this->dataclass->setBorrowing(
					$_REQUEST["uid"],
					$_REQUEST["borrower_id"],
					$_REQUEST["borrowing_date"],
					$_REQUEST["expected_return_date"]
				);
				/**
				 *  add movement
				 */
				$movement = new Movement();
				$movement->addMovement($_REQUEST["uid"], null, 2, 0, $_SESSION["login"], null, _("Objet prêté"));
			} else {
				/**
				 * Treatment of the return for all included objects
				 */
				if (!empty($_REQUEST["return_date"])) {
					$this->dataclass->setReturn($_REQUEST["uid"], $_REQUEST["return_date"]);
				}
				$this->id = $this->dataWrite($_REQUEST, true);
			}
			if ($this->id > 0) {
				$_REQUEST[$this->keyName] = $this->id;
			}
			return ZZZ;
		} catch (PpciException $e) {
			$this->message->set(_("Problème rencontré lors de l'enregistrement du prêt"), true);
			$this->message->set($e->getMessage());
			if ($db->transEnabled) {
				$db->transRollback();
			}
			return ZZZ;
		}
	}
	function delete()
	{
		/*
		 * delete record
		 */
		try {
			$this->dataDelete($this->id);
			return ZZZ;
		} catch (PpciException) {
			return $this->change();
		}
	}
}
