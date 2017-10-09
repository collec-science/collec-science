<?php
/**
 * Created : 2 févr. 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
class SamplingPlace extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "sampling_place";
		$this->colonnes = array (
				"sampling_place_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0
				),
				"sampling_place_name" => array (
						"type" => 0,
						"requis" => 1
				)
		);
		parent::__construct ( $bdd, $param );
	}
	/**
	 * Teste si un libelle existe deja dans la base
	 * @param string $name
	 * @return boolean
	 */
	function isExists($name) {
	    $id = 0;
	    $name = $this->encodeData($name);
	    if (strlen($name) > 0) {
	        $sql  = "select sampling_place_id from sampling_place where sampling_place_name = :name";
	        $id = $this->lireParamAsPrepared($sql, array("name"=>$name));
	    }
	    if ($id > 0) {
	        return true;
	    } else {
	        return false;
	    }
	}
}
?>