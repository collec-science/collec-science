<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class MetadataAttribute extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "metadata_attribute";
		$this->colonnes = array (
				"metadata_attribute_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"metadata_name" => array (
						"type" => 0,
						"requis" => 1 
				),
				"metadata_set_id" => array (
						"type" => 1,
						"requis" => 1,
						"parentAttrib" => 1 
				),
				"metadata_schema_id" => array (
						"type" => 1 
				),
				"metadata_code" => array (
						"type" => 0 
				) 
		);
		parent::__construct ( $bdd, $param );
	}
}

?>