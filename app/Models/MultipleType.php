<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * Created : 15 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class MultipleType extends PpciModel
{
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct()
	{
		$this->table = "multiple_type";
		$this->fields = array(
			"multiple_type_id" => array(
				"type" => 1,
				"key" => 1,
				"requis" => 1,
				"defaultValue" => 0
			),
			"multiple_type_name" => array(
				"type" => 0,
				"requis" => 1
			)
		);
		parent::__construct();
	}
}
