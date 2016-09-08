<?php
/**
 * Created : 8 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Label extends ObjetBDD {
	function __construct($bdd, $param = array()) {
		$this->table = "label";
		$this->colonnes = array (
				"label_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"label_name" => array (
						"requis" => 1 
				),
				"label_xsl" => array (
						"type" => 0,
						"requis" => 1
				) 
		);
		parent::__construct ( $bdd, $param );
	}
}
?>