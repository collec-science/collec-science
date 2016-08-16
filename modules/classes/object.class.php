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
				)
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
	
	function getDetail($uid) {
		if (is_numeric($uid) && $uid > 0) {
			$data ["uid"] = $uid;
			$sql = "select uid, identifier, sample_type_name as type_name
					from object 
					join sample using (uid)
					join sample_type using (sample_type_id)
					where uid = :uid
					UNION
					select uid, identifier, container_type_name as type_name
					from object 
					join container using (uid)
					join container_type using (container_type_id)
					where uid = :uid";
			return lireParam($sql);
		}
	}
}


