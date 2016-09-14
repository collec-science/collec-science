<?php
/**
 * Created : 14 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Operation extends ObjetBDD {
	private $sql = "select operation_id, operation_name, operation_order,
					protocol_id, protocol_name, protocol_year, protocol_version
					from operation
					join protocol using (protocol_id)";
	private $order = " order by protocol_year desc, protocol_name, protocol_version,
					operation_order, operation_name";
	
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "operation";
		$this->colonnes = array (
				"operation_id" => array(
						"type"=>1,
						"key"=>1,
						"requis"=>1,
						"defaultValue"=>0
				),
				"protocol_id" => array (
						"type" => 1,
						"requis" => 1,
						"parentAttrib" => 1
				),
				"operation_name" => array (
						"type" => 0,
						"requis" => 1
				),
				"operation_order" => array (
						"type" => 1
				)
		);
		parent::__construct ( $bdd, $param );
	}
	/**
	 * Retourne la liste des operations associees aux protocoles
	 * 
	 * {@inheritDoc}
	 * @see ObjetBDD::getListe()
	 */
	function getListe() {
		return $this->getListeParam($this->sql.$this->order);
	}
}
?>