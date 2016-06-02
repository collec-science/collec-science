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
		$this->connection = $bdd;
		$this->paramori = $param;
		$this->param = $param;
		$this->table = "object";
		$this->id_auto = "1";
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
		if (! is_array ( $param ))
			$param == array ();
			$param ["fullDescription"] = 1;
			parent::__construct ( $bdd, $param );
	}
}


