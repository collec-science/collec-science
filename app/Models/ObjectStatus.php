<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * Created : 15 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class ObjectStatus extends PpciModel
{
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct()
	{
		$this->table = "object_status";
		$this->fields = array(
			"object_status_id" => array(
				"type" => 1,
				"key" => 1,
				"requis" => 1,
				"defaultValue" => 0
			),
			"object_status_name" => array(
				"type" => 0,
				"requis" => 1
			)
		);
		parent::__construct();
	}
}
