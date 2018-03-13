<?php
/**
 * Created : 6 oct. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
 
class MovementReason extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "movement_reason";
		$this->colonnes = array (
				"movement_reason_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"movement_reason_name" => array (
						"type" => 0,
						"requis" => 1 
				)
		);
		parent::__construct ( $bdd, $param );
	}
}
?>