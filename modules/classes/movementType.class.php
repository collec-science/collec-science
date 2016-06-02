<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class MovementType extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "movement_type";
		$this->colonnes = array (
				"movement_type_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0
				),
				"movement_type_name" => array (
						"type" => 0,
						"requis" => 1
				)
		);
		parent::__construct ( $bdd, $param );
	}
}

?>