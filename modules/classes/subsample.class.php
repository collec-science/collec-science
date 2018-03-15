<?php
/**
 * Created : 15 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Subsample extends ObjetBDD {
	private $sql = "select subsample_id, sample_id, subsampling_date,
					movement_type_id, subsample_quantity, subsample_comment,
					subsample_login,
					multiple_unit
			from subsample
			join sample using (sample_id)
			join sample_type using (sample_type_id)
			";
	
	function __construct($bdd, $param = array()) {
		$this->table = "subsample";
		$this->colonnes = array (
				"subsample_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"sample_id" => array (
						"type" => 1,
						"requis" => 1,
						"parentAttrib" => 1 
				),
				"subsampling_date" => array (
						"type" => 3,
						"requis" => 1,
						"defaultValue" => "getDateHeure" 
				),
				"movement_type_id" => array (
						"type" => 1,
						"requis" => 1,
						"defaultValue" => 1 
				),
				"subsample_quantity" => array (
						"type" => 1 
				),
				"subsample_comment" => array (
						"type" => 0 
				),
				"subsample_login" => array (
						"type" => 0,
						"defaultValue" => "getLogin" 
				) 
		);
		parent::__construct ( $bdd, $param );
	}
	/**
	 * Surcharge de la fonction lire pour recuperer l'unite de sous-echantillonnage
	 * {@inheritDoc}
	 * @see ObjetBDD::lire()
	 */
	function lire($subsample_id, $getDefault, $parentValue) {
		$sql = $this->sql . " where subsample_id = :subsample_id";
		$data ["subsample_id"] = $subsample_id;
		if (is_numeric ( $subsample_id ) && $subsample_id > 0) {
			$retour = parent::lireParamAsPrepared ( $sql, $data );
		} else {
			$retour = parent::getDefaultValue ( $parentValue );
			/*
			 * Recherche de l'unite des sous-échantillons
			 */
			require_once 'modules/classes/sample.class.php';
			$sample = new Sample($this->connection);
			$dataSample = $sample->lireFromId($parentValue);
			$retour["multiple_unit"] = $dataSample["multiple_unit"];
		}
		return $retour;
	}
}
?>