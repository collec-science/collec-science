<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Container extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	function __construct($bdd, $param = null) {
		$this->connection = $bdd;
		$this->paramori = $param;
		$this->param = $param;
		$this->table = "container";
		$this->id_auto = "1";
		$this->colonnes = array (
				"container_id" => array (
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
				"parent_container_id" => array (
						"type" => 1 
				),
				"container_range" => array (
						"type" => 0 
				) 
		);
		if (! is_array ( $param ))
			$param == array ();
		$param ["fullDescription"] = 1;
		parent::__construct ( $bdd, $param );
	}
}

?>