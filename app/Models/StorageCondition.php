<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * Created : 3 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class StorageCondition extends PpciModel
{
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct()
	{
		$this->table = "storage_condition";
		$this->fields = array(
			"storage_condition_id" => array(
				"type" => 1,
				"key" => 1,
				"requis" => 1,
				"defaultValue" => 0
			),
			"storage_condition_name" => array(
				"type" => 0,
				"requis" => 1
			)
		);
		parent::__construct();
	}
}
