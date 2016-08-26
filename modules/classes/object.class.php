<?php
/**
 * Created : 2016-06-02
 * Creator : Eric Quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */

class Object extends ObjetBDD {
	/**
	 * 
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct($bdd, $param = null) {
		$this->table = "object";
		$this->colonnes = array (
				"uid" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0
				),
				"identifier" => array (
						"type" => 0
				),
				"wgs84_x" => array("type"=>1),
				"wgs84_y" => array("type"=>1)
		);
			parent::__construct ( $bdd, $param );
	}
	/**
	 * Surcharge de la fonction supprimer pour effacer les mouvements et les evenements
	 * {@inheritDoc}
	 * @see ObjetBDD::supprimer()
	 */
	function supprimer($uid) {
		if ($uid > 0 && is_numeric($uid)) {
			/*
			 * Supprime les mouvements associes
			 */
			require_once 'modules/classes/storage.class.php';
			$storage = new Storage ( $this->connection, $this->paramori );
			$storage->supprimerChamp($uid, "uid");
			/*
			 * Supprime les evenements associes
			 */
			require_once 'modules/classes/event.class.php';
			$event = new Event($this->connection, $this->paramori);
			$event -> supprimerChamp($uid, "uid");
			/*
			 * Supprime l'objet
			 */
			parent::supprimer($uid);
		}
	}
	
	function getDetail($uid, $is_container = 0) {
		if (is_numeric($uid) && $uid > 0) {
			$data ["uid"] = $uid;
			$sql = "select uid, identifier, wgs84_x, wgs84_y,
					container_type_name as type_name
					from object 
					join container using (uid)
					join container_type using (container_type_id)
					where uid = :uid";
			if ($is_container == 0) 
					$sql .= " UNION
					select uid, identifier, wgs84_x, wgs84_y,
					sample_type_name as type_name
					from object 
					join sample using (uid)
					join sample_type using (sample_type_id)
					where uid = :uid
					";
			return $this->getListeParamAsPrepared($sql, $data);
		}
	}
	/**
	 * Prepare la liste des objets pour impression des etiquettes
	 * @param array $list
	 * @return tableau
	 */
	function getForPrint(array $list) {
		/*
		 * Verification que la liste ne soit pas vide
		 */
		if (count($list) > 0) {
			/*
			 * Verification que les uid sont numeriques
			 * preparation de la clause where
			 */
			$comma = false;
			$uids = "";
			foreach ($list as $value) {
				if (is_numeric($value) && $value > 0) {
					$comma == true ? $uids .= "," : $comma = true;
					$uids.=$value;
				}
			}
			$sql = "select uid, identifier, container_type_name as type_name, clp_classification as clp
					from object 
					join container using (uid)
					join container_type using (container_type_id)
					where uid in ($uids)
					UNION
					select uid, identifier, sample_type_name as type_name, '' as clp
					from object 
					join sample using (uid)
					join sample_type using (sample_type_id)
					where uid in ($uids)
					order by uid
			";
			return $this->getListeParam($sql);
			
		}
	}
}


