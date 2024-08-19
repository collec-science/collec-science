<?php

namespace App\Libraries;

use App\Models\Booking as ModelsBooking;
use App\Models\ObjectClass;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Booking extends PpciLibrary
{
	/**
	 * @var ModelsBooking
	 */
	protected ModelsBooking $dataclass;

	private $keyName;

function __construct()
	{
		parent::__construct();
		/**
		 * @var ModelsBooking
		 */
		$this->dataClass = new ModelsBooking();
		$this->keyName = "booking_id";
		if (isset($_REQUEST[$this->keyName])) {
			$this->id = $_REQUEST[$this->keyName];
		}
	}

	function change()
	{
		$this->vue = service('Smarty');
		$this->dataRead($this->id, "gestion/bookingChange.tpl", $_REQUEST["uid"]);
		$this->vue->set($_SESSION["moduleParent"], "moduleParent");
		$this->vue->set("tab-booking", "activeTab");
		/*
		 * Lecture de l'object concerne
		 */
		$object = new ObjectClass();
		$this->vue->set($object->lire($_REQUEST["uid"]), "object");
		return $this->vue->send();
	}
	function write()
	{
		try {
			$this->id = $this->dataWrite($_REQUEST);
			if ($this->id > 0) {
				$_REQUEST["booking_id"] = $this->id;
				return ZZZ;
			}
		} catch (PpciException) {
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
		} catch (PpciException $e) {
			return $this->change();
		}
	}
	function verifyInterval()
	{
		$this->dataclass->verifyInterval($_REQUEST["uid"], $_REQUEST["booking_id"], $_REQUEST["date_from"], $_REQUEST["date_to"]) == true ? $overlaps = 0 : $overlaps = 1;
		$this->vue->set(array("overlaps" => $overlaps));
	}
}
