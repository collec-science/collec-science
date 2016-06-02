<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class MetadataSchema extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "metadata_schema";
		$this->colonnes = array (
				"metadata_schema_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"metadata_schema_name" => array (
						"type" => 0,
						"requis" => 1 
				),
				"metadata_short_name" => array (
						"type" => 0 
				),
				"uri" => array (
						"type" => 0 
				) 
		);
		parent::__construct ( $bdd, $param );
	}
}

?>