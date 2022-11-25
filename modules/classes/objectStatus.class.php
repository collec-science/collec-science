<?php
/**
 * Created : 15 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class ObjectStatus extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "object_status";
		$this->colonnes = array (
				"object_status_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0
				),
				"object_status_name" => array (
						"type" => 0,
						"requis" => 1
				)
		);
		parent::__construct ( $bdd, $param );
	}
	function getListe($order = "")
	{
		$sql = "select object_status_id, translate(object_status_name, '" . $_SESSION["locale"] . "') as object_status_name
			from object_status";
		if (strlen($order) > 0) {
			$sql .= " order by " . $order;
		}
		return $this->getListeParam($sql);
	}
}
?>