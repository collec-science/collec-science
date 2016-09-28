<?php
/**
 * Created : 28 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class ObjectIdentifier extends ObjetBDD {
	private $sql = "select object_identifier_id, uid, object_identifier_value, identifier_type_id,
					identifier_type_name, identifier_type_code
					from object_identifier
					join identifier_type using (identifier_type_id)";
	function __construct($bdd, $param = array()) {
		$this->table = "object_identifier";
		$this->colonnes = array (
				"object_identifier_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"uid" => array (
						"type" => 1,
						"requis" => 1,
						"parentAttrib" => 1 
				),
				"identifier_type_id" => array (
						"type" => 1,
						"requis" => 1 
				),
				"object_identifier_value" => array (
						"type" => 0,
						"requis" => 1 
				) 
		);
		parent::__construct ( $bdd, $param );
	}
	/**
	 * Retourne la liste des identifiants secondaires associes a un UID
	 * 
	 * @param unknown $uid        	
	 */
	function getListFromUid($uid) {
		if ($uid > 0) {
			$data ["uid"] = $uid;
			$where = " where uid = :uid";
			return $this->getListeParamAsPrepared ( $this->sql . $where, $data );
		}
	}
}
?>