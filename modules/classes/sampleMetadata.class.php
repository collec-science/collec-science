<?php
/**
 * Created : 10 mai 2017
 * Creator : hlinyer
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
class SampleMetadata extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "sample_metadata";
		$this->colonnes = array (
				"sample_metadata_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0
				),
				"data" => array (
						"type" => 0,
						"requis" => 1
				)
		);
		parent::__construct ( $bdd, $param );
	}
}
?>