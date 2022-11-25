<?php

/**
 * Created : 3 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class ContainerFamily extends ObjetBDD
{
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	function __construct($bdd, $param = array())
	{
		$this->table = "container_family";
		$this->colonnes = array(
			"container_family_id" => array(
				"type" => 1,
				"key" => 1,
				"requis" => 1,
				"defaultValue" => 0
			),
			"container_family_name" => array(
				"type" => 0,
				"requis" => 1
			)
		);
		parent::__construct($bdd, $param);
	}
	function getListe($order = "")
	{
		$sql = "select container_family_id, translate(container_family_name, '" . $_SESSION["locale"] . "') as container_family_name
			from container_family";
		if (strlen($order) > 0) {
			$sql .= " order by " . $order;
		}
		return $this->getListeParam($sql);
	}
}
