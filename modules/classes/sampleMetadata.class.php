<?php
/**
 * Created : 10 mai 2017
 * Creator : hlinyer
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
class SampleMetadata extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "sample_metadata";
		$this->colonnes = array (
				"sample_metadata_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0
				),
				"data" => array (
						"type" => 0,
						"requis" => 1
				)
		);
		parent::__construct ( $bdd, $param );
	}
	/**
	 * Récupére le jeu de métadonnées à partir de l'uid d'un échantillon
	 *
	 * @param $uid
	 */
	function getMetadataFromUid($uid) {
		if ($uid > 0 && is_numeric ( $uid )) {
			$sql = "select data from sample_metadata
			join sample using (sample_metadata_id)
			where uid = :uid";
			$var ["uid"] = $uid;
			$data =$this->lireParamAsPrepared ( $sql, $var );
			return $data["data"];
		}
	}
}
?>