<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class Risk extends PpciModel
{
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct()
	{
		$this->table = "risk";
		$this->fields = array(
			"risk_id" => array(
				"type" => 1,
				"key" => 1,
				"requis" => 1,
				"defaultValue" => 0
			),
			"risk_name" => array(
				"type" => 0,
				"requis" => 1
			)
		);
		parent::__construct();
	}
}