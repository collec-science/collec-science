<?php
include_once 'modules/classes/borrowing.class.php';
$dataClass = new Borrowing($bdd, $ObjetBDDParam);
$keyName = "borrowing_id";
$id = $_REQUEST[$keyName];
switch ($t_module["param"]) {
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		dataRead($dataClass, $id, "gestion/borrowingChange.tpl", $_REQUEST["uid"]);
		$vue->set($_SESSION["moduleParent"], "moduleParent");
		/*
		 * Recherche des types d'evenement
		 */
		require_once 'modules/classes/borrower.class.php';
		$borrower = new Borrower($bdd, $ObjetBDDParam);
		$vue->set($borrower->getListe(2), "borrowers");
		$vue->set("tab-event", "activeTab");
		/*
		 * Lecture de l'object concerne
		 */
		require_once 'modules/classes/object.class.php';
		$object = new ObjectClass($bdd, $ObjetBDDParam);
		$vue->set($object->lire($_REQUEST["uid"]), "object");
		break;
	case "write":
		/*
		 * write record in database
		 */
		//$dataClass->debug_mode = 2;
		$id == 0 ? $isNew = true : $isNew = false;
		try {
			$bdd->beginTransaction();
			if ($isNew) {
				$id = $dataClass->setBorrowing(
					$_REQUEST["uid"],
					$_REQUEST["borrower_id"],
					$_REQUEST["borrowing_date"],
					$_REQUEST["expected_return_date"]
				);
				/**
				 *  add movement
				 */
				include_once 'modules/classes/movement.class.php';
				$movement = new Movement($bdd, $ObjetBDDParam);
				$movement->addMovement($_REQUEST["uid"], null, 2, 0, $_SESSION["login"], null, _("Objet prêté"));
			} else {
				/**
				 * Treatment of the return for all included objects
				 */
				if (!empty($_REQUEST["return_date"])) {
					$dataClass->setReturn($_REQUEST["uid"], $_REQUEST["return_date"]);
				}
				$id = dataWrite($dataClass, $_REQUEST, true);
			}
			if ($id > 0) {
				$_REQUEST[$keyName] = $id;
			}
			$module_coderetour = 1;
			$bdd->commit();
		} catch (Exception $e) {
			$message->set(_("Problème rencontré lors de l'enregistrement du prêt"), true);
			$message->set($e->getMessage());
			$bdd->rollback();
			$module_coderetour = -1;
		}
		break;
	case "delete":
		/*
		 * delete record
		 */
		dataDelete($dataClass, $id);
		break;
}
