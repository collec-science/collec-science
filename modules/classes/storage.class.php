<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Storage extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	private $sql = "select s.uid, container_id, movement_type_id, movement_type_name,
					storage_date, range, login, storage_comment,
					identifier, o.uid as parent_uid,
					container_type_id, container_type_name
					from storage s
					join movement_type using (movement_type_id)
					left outer join container c using (container_id)
					left outer join object o on (c.uid = o.uid)
					left outer join container_type using (container_type_id)
					";
	private $order = " order by storage_date desc";
	private $where = " where s.uid = :uid";
	function __construct($bdd, $param = array()) {
		$this->table = "storage";
		$this->colonnes = array (
				"storage_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"uid" => array (
						"type" => 1,
						"requis" => 1 
				),
				"container_id" => array (
						"type" => 1 
				),
				"movement_type_id" => array (
						"type" => 1,
						"requis" => 1 
				),
				"storage_date" => array (
						"type" => 3,
						"defaultValue" => "getDateHeure" 
				),
				"login" => array (
						"requis" => 1 
				),
				"range" => array (
						"type" => 0 
				),
				"storage_comment" => array (
						"type" => 0 
				) 
		);
		parent::__construct ( $bdd, $param );
	}
	
	/**
	 * Retrouve la derniere position connue de l'objet considere
	 * 
	 * @param int $id        	
	 * @return array
	 */
	function getLastPosition($uid) {
		if (is_numeric ( $id ) && $id > 0) {
			$data ["uid"] = $id;
			return $this->getListeParamAsPrepared ( $this->sql . $this->where . $this->order . " limit 1", $data );
		}
	}
	/**
	 * Retourne tous les mouvements d'un objet
	 * 
	 * @param int $uid        	
	 * @return array
	 */
	function getAllMovements($uid) {
		if (is_numeric ( $id ) && $id > 0) {
			$data ["uid"] = $uid;
			return $this->getListeParamAsPrepared ( $this->sql . $this->where . $this->order, $data );
		}
	}
	/**
	 * Retourne la liste de tous les containers parents
	 * @param int $uid
	 * @throws Exception
	 * @return array
	 */
	function getParents($uid) {
		if (is_numeric ( $id ) && $id > 0) {
			$retour = array ();
			$data ["uid"] = $uid;
			$continue = true;
			try {
				/*
				 * Preparation de la requete
				 */
				$stmt = $this->connection->prepare ( $this->sql . $this->where . $this->order . " limit 1" );
				while ( $continue == true ) {
					if ($stmt->execute ( $data )) {
						$result = $stmt->fetch ( PDO::FETCH_ASSOC );
						$retour [] = $result;
						if ($result ["parent_uid"] > 0) {
							$data ["uid"] = $result ["parent_uid"];
						} else
							$continue = false;
					} else
						$continue = false;
				}
				return $retour;
			} catch ( PDOException $e ) {
				$this->lastResultExec = false;
				if ($this->debug_mode > 0)
					$this->addMessage ( $e->getMessage () );
				throw new Exception ( $e->getMessage () );
			}
		}
	}
}

?>