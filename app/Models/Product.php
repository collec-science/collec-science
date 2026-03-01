<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class Product extends PpciModel
{
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct()
	{
		$this->table = "product";
		$this->fields = array(
			"product_id" => array(
				"type" => 1,
				"key" => 1,
				"requis" => 1,
				"defaultValue" => 0
			),
			"product_name" => array(
				"type" => 0,
				"requis" => 1
			)
		);
		parent::__construct();
	}
}