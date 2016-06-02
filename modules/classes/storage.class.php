<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Storage extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "storage";
		$this->colonnes = array (
				"storage_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"uid" => array (
						"type" => 1,
						"requis" => 1 
				),
				"container_id" => array (
						"type" => 1 
				),
				"movement_type_id" => array (
						"type" => 1,
						"requis" => 1 
				),
				"storage_date" => array (
						"type" => 3,
						"defaultValue" => "getDateHeure" 
				),
				"login" => array (
						"requis" => 1 
				),
				"range" => array (
						"type" => 0 
				),
				"storage_comment" => array (
						"type" => 0 
				) 
		);
		parent::__construct ( $bdd, $param );
	}
}

?>