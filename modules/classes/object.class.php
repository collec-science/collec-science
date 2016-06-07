<?php
/**
 * Created : 2016-06-02
 * Creator : Eric Quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */

class Object extends ObjetBDD {
	/**
	 * 
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct($bdd, $param = null) {
		$this->table = "object";
		$this->colonnes = array (
				"uid" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0
				),
				"identifier" => array (
						"type" => 0
				)
		);
			parent::__construct ( $bdd, $param );
	}
}


