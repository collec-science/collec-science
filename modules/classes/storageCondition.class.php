<?php
/**
 * Created : 3 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class StorageCondition extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "storage_condition";
		$this->colonnes = array (
				"storage_condition_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0
				),
				"storage_condition_name" => array (
						"type" => 0,
						"requis" => 1
				)
		);
		parent::__construct ( $bdd, $param );
	}
}
?>