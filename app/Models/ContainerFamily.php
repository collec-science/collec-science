<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * Created : 3 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class ContainerFamily extends PpciModel
{
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	function __construct()
	{
		$this->table = "container_family";
		$this->fields = array(
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
		parent::__construct();
	}
}
