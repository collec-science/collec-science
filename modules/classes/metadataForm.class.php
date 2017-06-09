<?php
/**
 * Created : 04 mai 2017
 * Creator : hlinyer
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
class MetadataForm extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "metadata_form";
		$this->colonnes = array (
				"metadata_form_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0
				),
				"metadata_schema" => array (
						"type" => 0,
						"requis" => 1
				)
		);
		parent::__construct ( $bdd, $param );
	}
}
?>