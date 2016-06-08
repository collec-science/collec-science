<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/object.class.php';
class Container extends ObjetBDD {
	private $sql = "select container_id, uid, identifier, container_type_id, container_type_name,
					container_family_id, container_family_name
					from container
					join object using (uid)
					join container_type using (container_type_id)
					join container_family using (container_family_id)
			";
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	function __construct($bdd, $param = null) {
		$this->table = "container";
		$this->colonnes = array (
				"container_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"uid" => array (
						"type" => 1,
						"parentAttrib" => 1,
						"requis" => 1 
				),
				"container_type_id" => array (
						"type" => 1,
						"requis" => 1 
				) 
		);
		parent::__construct ( $bdd, $param );
	}
	
	function ecrire($data) {
		$object = new Object($this->connection, $this->param);
		if ($object->ecrire($data) > 0) {
			return parent::ecrire($data);
		}
	}
	/**
	 * Retourne la liste des contenus d'un conteneur
	 * @param unknown $uid
	 */
	function getContent($uid) {
		if ($uid > 0 && is_numeric ( $uid )) {
			$sql = "select o.uid, o.identifier, sa.*, container_type_id, container_type_name
					from object o
					left outer join sample sa on (sa.uid = o.uid)
					left outer join container co on (co.uid = o.uid)
					left outer join container_type using (container_type_id)
					join last_movement lm on (lm.uid = o.uid and lm.controler_uid = :uid)
					order by o.identifier, o.uid
					";
			$data ["uid"] = $uid;
			return $this->getListeParamAsPrepared($sql, $data);
		}
	}
	/**
	 * Retourne le numero d'un conteneur a partir de son uid
	 * 
	 * @param int $uid     
	 * @return int;   	
	 */
	function getIdFromUid($uid) {
		if (is_numeric ( $uid ) && $uid > 0) {
			$sql = "select container_id from container where uid = :uid";
			$data ["uid"] = $uid;
			$row = $this->lireParamAsPrepared ( $sql, $data );
			return $row ["uid"];
		} else
			return - 1;
	}

	/**
	 * Recherche les conteneurs a partir du tableau de parametres fourni
	 * @param array $param
	 */
	function containerSearch($param) {
		$data = array();
		$isFirst = true;
		$order = " order by container_family_name, container_type_name, identifier, uid";
		$where = "where";
		if ($param["container_type_id"] > 0) {
			$where .= " container_type_id = :container_type_id";
			$data ["container_type_id"] = $param["container_type_id"];
		} elseif ($param["container_family_id"] > 0) {
			$where .=" container_family_id = :container_family_id";
			$data["container_family_id"] = $param["container_family_id"];
		}
		if ($param["limit"] > 0) {
			$order .= " limit :limite";
			$data["limite"] = $param["limit"];
		}
		return $this->getListeParamAsPrepared($this->sql.$where.$order, $data);
	}
}

?>