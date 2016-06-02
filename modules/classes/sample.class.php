<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Sample extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "sample";
		$this->colonnes = array (
				"sample_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"uid" => array (
						"type" => 1,
						"parentAttrib" => 1,
						"requis" => 1 
				),
				"project_id" => array (
						"type" => 1,
						"requis" => 1 
				),
				"sample_type_id" => array (
						"type" => 1,
						"requis" => 1 
				),
				"sample_creation_date" => array (
						"type" => 3,
						"requis" => 1,
						"defaultValue" => "getDateHeure" 
				),
				"parent_sample_id" => array (
						"type" => 1 
				),
				"sample_date" => array (
						"type" => 3,
						"defaultValue" => "getDateHeure" 
				) 
		);
		
		parent::__construct ( $bdd, $param );
	}
}

?>