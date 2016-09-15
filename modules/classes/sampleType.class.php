<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class SampleType extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	private $sql = "select sample_type_id, sample_type_name, 
					metadata_set_id, metadata_set_name, container_type_name,
					operation_id, operation_name, protocol_name, protocol_year, protocol_version,
					multiple_type_id, multiple_unit, multiple_type_name
					from sample_type
					left outer join metadata_set using (metadata_set_id)
					left outer join container_type using (container_type_id)
					left outer join operation using (operation_id)
					left outer join protocol using (protocol_id)
					left outer join multiple_type using (multiple_type_id)
			";
	function __construct($bdd, $param = array()) {
		$this->table = "sample_type";
		$this->colonnes = array (
				"sample_type_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"sample_type_name" => array (
						"type" => 0,
						"requis" => 1 
				),
				"container_type_id" => array (
						"type" => 1 
				),
				"metadata_set_id" => array (
						"type" => 1 
				),
				"operation_id" => array (
						"type" => 1 
				),
				"multiple_type_id" => array (
						"type" => 1 
				),
				"multiple_unit" => array (
						"type" => 0 
				) 
		);
		parent::__construct ( $bdd, $param );
	}
	/**
	 * Ajoute le jeu de métadonnées utilisé
	 * 
	 * {@inheritdoc}
	 *
	 * @see ObjetBDD::getListe()
	 */
	function getListe($order = 0) {
		if ($order > 0)
			$tri = " order by $order";
		return $this->getListeParam ( $this->sql . $tri );
	}
}
?>