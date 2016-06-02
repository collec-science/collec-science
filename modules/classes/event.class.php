<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Event extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "event";
		$this->colonnes = array (
				"event_id" => array (
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
				"event_date" => array (
						"type" => 3,
						"requis" => 1,
						"defaultValue" => "getDateHeure" 
				),
				"event_type_id" => array (
						"type" => 1,
						"requis" => 1 
				),
				"still_available" => array (
						"type" => 0 
				),
				"event_comment" => array (
						"type" => 0 
				) 
		);
		parent::__construct ( $bdd, $param );
	}
}

?>