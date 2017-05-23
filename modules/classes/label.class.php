<?php
/**
 * Created : 8 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Label extends ObjetBDD {
	private $sql="select label_id, label_name, label_xsl, label_fields,
			operation_id,
			schema
			from label
			left outer join operation using(operation_id)
			left outer join metadata_form using (metadata_form_id)
		";

	function __construct($bdd, $param = array()) {
		$this->table = "label";
		$this->colonnes = array (
				"label_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"label_name" => array (
						"requis" => 1 
				),
				"label_xsl" => array (
						"type" => 0,
						"requis" => 1
				),
				"label_fields" => array (
						"requis" => 1,
						"defaultValue" => 'uid,id,clp,db'
				),
				"operation_id" => array(
						"type"=>1,
						"requis"=> 0
				)
		);
		parent::__construct ( $bdd, $param );
	}
	/**
	 * Surcharge de lire pour ramener le schéma de métadonnées
	 *
	 * {@inheritdoc}
	 *
	 * @see ObjetBDD::lire()
	 */
	function lire($label_id, $getDefault=true, $parentValue=0) {
		$sql = $this->sql . " where label_id = :label_id";
		$data ["label_id"] = $label_id;
		if (is_numeric ( $label_id ) && $label_id > 0) {
			return parent::lireParamAsPrepared ( $sql, $data );
		}
	}
}
?>