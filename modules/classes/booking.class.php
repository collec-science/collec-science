<?php
/**
 * Created : 30 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Booking extends ObjetBDD {
	function __construct($bdd, $param = array()) {
		$this->table = "booking";
		$this->colonnes = array (
				"storage_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"uid" => array (
						"type" => 1,
						"requis" => 1,
						"parentAttrib" => 1 
				),
				"booking_date" => array (
						"type" => 3,
						"defaultValue" => "getDateHeure" 
				),
				"booking_login" => array (
						"requis" => 1,
						"defaultValue" => "getLogin" 
				),
				"date_from" => array (
						"type" => 3,
						"defaultValue" => "getDateHeure",
						"requis" => 1 
				),
				"date_to" => array (
						"type" => 3,
						"defaultValue" => "getDateHeure",
						"requis" => 1 
				),
				"booking_comment" => array (
						"type" => 0 
				) 
		);
	}
	/**
	 * Fonction verifiant si un intervalle en chevauche un autre,
	 * pour verification de la reservation
	 * @param int $uid
	 * @param int $storage_id
	 * @param string $date_from
	 * @param string $date_to
	 * @return boolean
	 */
	function verifyInterval($uid, $storage_id, $date_from, $date_to) {
		if ($uid > 0 && is_numeric ( $uid ) && is_numeric ( $storage_id ) && strlen ( $date_from ) > 0 && strlen ( $date_to ) > 0) {
			$date_from = $this->formatDateLocaleVersDB($date_from, 3);
			$date_to = $this->formatDateLocaleVersDB($date_to, 3);
			$sql = "select count(*) as overlaps
					from $this->table 
					where 
					((:date_from, :date_to) overlaps (date_from, date_to)) = true
					and uid = :uid
					and storage_id <> :storage_id";
			$data = array ("uid"=>$uid, "date_from"=>$date_from, "date_to"=>$date_to, "storage_id"=>$storage_id);
			$result = $this->lireParamAsPrepared($sql, $data);
			$result["overlaps"] == 0 ? $retour = true : $retour = false; 
			return $retour;
		}
	}
}
?>