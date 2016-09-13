<?php
/**
 * Created : 13 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Protocol extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "protocol";
		$this->colonnes = array (
				"protocol_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0
				),
				"protocol_name" => array (
						"type" => 0,
						"requis" => 1
				),
				"protocol_version" => array(
						"type"=>0,
						"requis"=>1,
						"defaultValue"=>"1.0"
				),
				"protocol_year"=>array(
						"type"=>1
				)
		);
		parent::__construct ( $bdd, $param );
	}
	
	function ecrire_document($id, $file) {
		if ($file ["error"] == 0 && $file ["size"] > 0 && $id > 0 && is_numeric ( $id )) {
			
			$extension =  substr ( $file ["name"], strrpos ( $file ["name"], "." ) + 1 ) ;
			if (strtolower($extension) == "pdf") {
				/*
				 * Verification antivirale
				 */
				testScan($file["tmp_name"]);
				/*
				 * Ecriture du fichier
				 */
				/*$dataBinaire = fread ( fopen ( $file ["tmp_name"], "rb" ), $file ["size"] );
				$data ["protocol_file"] = pg_escape_bytea ( $dataBinaire );
				$data["protocol_id"] = $id ;
				$sql = "update protocol set protocol_file = :protocol_file where protocol_id = :protocol_id";
				$this->executeAsPrepared($sql, $data);*/
				$fp = fopen($file['tmp_name'], 'rb');
				$this->updateBinaire($id, "protocol_file", $fp);
				
			} else 
				throw new FileException("Seuls les fichiers PDF peuvent être téléchargés");
		}
	}
	/**
	 * Retourne le fichier contenant la reference de la description du protocole
	 * @param int $id
	 * @return reference|NULL
	 */
	function getProtocolFile($id) {
		if ($id > 0 && is_numeric($id)) {
			return $this->getBlobReference($id, "protocol_file");
		}
	}
}
?>