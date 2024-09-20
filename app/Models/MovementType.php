<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class MovementType extends PpciModel
{
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct()
	{
		$this->table = "movement_type";
		$this->fields = array(
			"movement_type_id" => array(
				"type" => 1,
				"key" => 1,
				"requis" => 1,
				"defaultValue" => 0
			),
			"movement_type_name" => array(
				"type" => 0,
				"requis" => 1
			)
		);
		parent::__construct();
	}
}
