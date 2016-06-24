<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class EventType extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "event_type";
		$this->colonnes = array (
				"event_type_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"event_type_name" => array (
						"type" => 0,
						"requis" => 1 
				),
				"is_sample" => array (
						"type" => 0,
						"defaultValue" => "1",
						"requis" => 1 
				),
				"is_container" => array (
						"type" => 0,
						"defaultValue" => "1",
						"requis" => 1 
				) 
		);
		parent::__construct ( $bdd, $param );
	}

	/**
	 * Retourne la liste selon la categorie choisie
	 * @param string $category
	 */
	function getListeFromCategory($category) {
		$sql = "select event_type_id, event_type_name
				from event_type";
		$category == "container" ? $sql .= " where is_container = true" : $sql. " where is_sample = true";
		$sql .= " order by event_type_name";
		return parent::getListeParam($sql);
	}
}

?>