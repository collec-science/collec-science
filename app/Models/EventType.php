<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class EventType extends PpciModel
{
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct()
	{
		$this->table = "event_type";
		$this->fields = array(
			"event_type_id" => array(
				"type" => 1,
				"key" => 1,
				"requis" => 1,
				"defaultValue" => 0
			),
			"event_type_name" => array(
				"type" => 0,
				"requis" => 1
			),
			"is_sample" => array(
				"type" => 0,
				"defaultValue" => "1",
				"requis" => 1
			),
			"is_container" => array(
				"type" => 0,
				"defaultValue" => "1",
				"requis" => 1
			)
		);
		parent::__construct();
	}

	/**
	 * Retourne la liste selon la categorie choisie
	 * @param string $category
	 * @param int $collection_id
	 */
	function getListeFromCategory($category, $collection_id = 0)
	{
		$data = array();
		$sql = "select distinct event_type_id, event_type_name
				from event_type";
		$order = " order by event_type_name";
		if ($category == "container") {
			$data = $this->getListeParam($sql . " where is_container = true" . $order);
		} else {
			$sql1 = $sql . " left outer join collection_eventtype using (event_type_id)
                         where collection_id = :collection_id:" . $order;
			$sql2 = $sql . " where is_sample = true and event_type_id not in (select distinct event_type_id from collection_eventtype)" . $order;
			$data = array_merge(
				$this->getListeParamAsPrepared($sql1, array("collection_id" => $collection_id)),
				$this->getListeParam($sql2)
			);
		}
		return $data;
	}

	function getListForSamples()
	{
		$sql = "select event_type_id, event_type_name, is_sample, is_container
						from event_type
						where is_sample = true
						order by event_type_name";
		return $this->getListeParam($sql);
	}
}
