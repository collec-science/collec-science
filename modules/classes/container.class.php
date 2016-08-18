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
					container_family_id, container_family_name, container_status_id, container_status_name,
					storage_product, clp_classification, storage_condition_name
					from container
					join object using (uid)
					join container_type using (container_type_id)
					join container_family using (container_family_id)
					left outer join container_status using (container_status_id)
					left outer join storage_condition using (storage_condition_id)
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
						"requis" => 1,
						"defaultValue"=>0
				),
				"container_type_id" => array (
						"type" => 1,
						"requis" => 1 
				),
				"container_status_id" => array (
						"type"=>1,
						"defaultValue"=>1
				)
		);
		parent::__construct ( $bdd, $param );
	}
	/**
	 * Surcharge de lire pour ramener les informations
	 * generales (table object, notamment)
	 * {@inheritDoc}
	 * @see ObjetBDD::lire()
	 */
	function lire($uid, $getDefault, $parentValue) {
		$sql = $this->sql." where uid = :uid";
		$data["uid"] = $uid;
		if (is_numeric($uid) && $uid > 0) {
		$retour = parent::lireParamAsPrepared($sql, $data);
		} else {
			$retour = parent::getDefaultValue($parentValue);
		}
		return $retour;
	}
	
	/**
	 * Surcharge de la fonction ecrire pour 
	 * enregistrer les informations dans object
	 * {@inheritDoc}
	 * @see ObjetBDD::ecrire()
	 */
	function ecrire($data) {
		$object = new Object($this->connection, $this->param);
		$uid = $object->ecrire($data);
		if ($uid > 0) {
			$data ["uid"] = $uid;
			 parent::ecrire($data);
			 return $uid;
		}
	}
	/**
	 * Surcharge de supprimer pour effacer les donnees liees
	 * 
	 * {@inheritDoc}
	 * @see ObjetBDD::supprimer()
	 */
	function supprimer($uid) {
		$data = $this->lire ( $uid );
			/*
			 * suppression de l'echantillon
			 */
			parent::supprimer ( $data ["container_id"] );
			/*
			 * Suppression de l'objet
			 */
			require_once 'modules/classes/object.class.php';
			$object = new Object ( $this->connection, $this->paramori );
			$object->supprimer ( $uid );
	}
	
	
	/**
	 * Retourne tous les échantillons contenus
	 * dans le conteneur
	 * @param int $uid
	 * @return array
	 */
	function getContentSample($uid) {
		if ($uid > 0 && is_numeric ( $uid )) {
			$sql = "select o.uid, o.identifier, sa.*
					from object o
					join sample sa on (sa.uid = o.uid)
					join last_movement lm on (lm.uid = o.uid and lm.container_uid = :uid)
					where lm.movement_type_id = 1
					order by o.identifier, o.uid
					";
			$data ["uid"] = $uid;
			$this->colonnes["sample_creation_date"] = array("type"=>2);
			$this->colonnes["sample_date"] = array("type"=>2);
			return $this->getListeParamAsPrepared($sql, $data);			
		}
	}
	/**
	 * Retourne tous les conteneurs contenus
	 * @param int $uid
	 * @return array
	 */
	function getContentContainer($uid) {
		if ($uid > 0 && is_numeric ( $uid )) {
			$sql = "select o.uid, o.identifier, container_type_id, container_type_name,
					container_family_id, container_family_name, container_status_id,
					storage_product, storage_condition_name, 
					container_status_name, clp_classification
					from object o
					join container co on (co.uid = o.uid)
					join container_type using (container_type_id)
					join container_family using (container_family_id)
					join last_movement lm on (lm.uid = o.uid and lm.container_uid = :uid)
					left outer join container_status using (container_status_id)
					left outer join storage_condition using (storage_condition_id)
					where lm.movement_type_id = 1
					order by o.identifier, o.uid
					";
			$data ["uid"] = $uid;
			return $this->getListeParamAsPrepared($sql, $data);
		}
	}

	/**
	 * Retourne le conteneur parent
	 * @param int $uid
	 * @return array
	 */
	function getParent($uid) {
		if ($uid > 0 && is_numeric ( $uid )) {
			$sql = "select co.container_id, o.uid, o.identifier, container_type_id, container_type_name
					from object o
					join container co on (co.uid = o.uid)
					join container_type using (container_type_id)
					join last_movement lm on (lm.uid = :uid and lm.container_uid = o.uid) 
					where lm.movement_type_id = 1
					order by o.identifier, o.uid
					";
			$data ["uid"] = $uid;
			return $this->lireParamAsPrepared($sql, $data);
		}
	}
	/**
	 * Retourne tous les conteneurs parents d'un objet
	 * @param int $uid
	 * @return array
	 */
	function getAllParents($uid) {
		$data = array();
		if ($uid > 0 && is_numeric ( $uid )) {
			$continue = true;
			while ($continue) {
				$parent = $this->getParent($uid);
				if ($parent["uid"] > 0) {
					$data[] = $parent;
					$uid = $parent["uid"];
				} else 
					$continue = false;
			}
		}
		return $data;
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
			return $row ["container_id"];
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
		$and = "";
		if ($param["container_type_id"] > 0) {
			$where .= " container_type_id = :container_type_id";
			$data ["container_type_id"] = $param["container_type_id"];
			$and = " and ";
		} elseif ($param["container_family_id"] > 0) {
			$where .=" container_family_id = :container_family_id";
			$data["container_family_id"] = $param["container_family_id"];
			$and = " and ";
		}
		if (strlen($param["name"]) > 0) {
			$where .= $and."( ";
			$or = "";
			if (is_numeric($param["name"])) {
				$where .= " uid = :uid";
				$data["uid"] = $param["name"];
				$or = " or ";
			}
			$identifier = "%".strtoupper($this->encodeData($param["name"]))."%";
			$where .= "$or upper(identifier) like :identifier )";
			$and = " and ";
			$data["identifier"] = $identifier;
		}
		if ($param["container_status_id"] > 0) {
			$where .= $and." container_status_id = :container_status_id";
			$and = " and ";
			$data["container_status_id"] = $param["container_status_id"];
		}
		if ($param["uid_max"] > 0 && $param["uid_max"] >= $param["uid_min"]) {
			$where .= $and. "uid between :uid_min and :uid_max";
			$and = " and ";
			$data["uid_min"] = $param["uid_min"];
			$data["uid_max"] = $param["uid_max"];
		}
		if ($param["limit"] > 0) {
			$order .= " limit :limite";
			$data["limite"] = $param["limit"];
		return $this->getListeParamAsPrepared($this->sql.$where.$order, $data);
		}
	}

	/**
	 * Retourne la liste des conteneurs correspondant au type
	 * @param int $container_type_id
	 * @return array
	 */
	function getFromType($container_type_id) {
		if (is_numeric($container_type_id) && $container_type_id > 0) {
			$data["container_type_id"] = $container_type_id;
			$where = " where container_type_id = :container_type_id";
			$order = " order by uid desc";
			return $this->getListeParamAsPrepared($this->sql.$where.$order, $data);
		}
	}
}

?>