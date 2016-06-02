<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class SampleAttribute extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "sample_attribute";
		$this->colonnes = array (
				"sample_attribute_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"sample_id" => array (
						"type" => 1,
						"requis" => 1,
						"parentAttrib" => 1 
				),
				"metadata_attribute_id" => array (
						"type" => 1,
						"requis" => 1 
				),
				"sample_attribute_value" => array (
						"type" => 0,
						"requis" => 1 
				) 
		);
		parent::__construct ( $bdd, $param );
	}
}

?>