<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class ContainerType extends ObjetBDD {
	private $sql = "select * 
			from container_type
			join container_family using (container_family_id)
			left outer join storage_condition using (storage_condition_id)
			left outer join label using (label_id)";
	
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "container_type";
		$this->colonnes = array (
				"container_type_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"container_type_name" => array (
						"type" => 0,
						"requis" => 1 
				),
				"container_family_id" => array (
						"type" => 1,
						"requis" => 1,
						"parentAttrib"=>1
				),
				"container_type_description" => array (
						"type" => 0 
				),
				"storage_condition_id" => array (
						"type" => 1 
				),
				"storage_product" => array (
						"type" => 0 
				),
				"clp_classification" => array (
						"type" => 0 
				),
				"label_id" => array (
						"type" => 1
				)
		);
		parent::__construct ( $bdd, $param );
	}
	
	function getListe($order="") {
		$order = "";
		if ($order != 0 && strlen ($order) > 0) 
			$order = " order by $order";
		return parent::getListeParam($this->sql.$order);
	}
}

?>