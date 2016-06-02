<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class SampleType extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "sample_type";
		$this->colonnes = array (
				"sample_type_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0
				),
				"sample_type_name" => array (
						"type" => 0,
						"requis" => 1
				), 
				"metadata_set_id" => array(
						"type"=>1
				)
		);
		parent::__construct ( $bdd, $param );
	}
}
?>