<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/container.class.php';
class Storage extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	private $sql = "select s.uid, container_id, movement_type_id, movement_type_name,
					storage_date, range, login, storage_comment,
					identifier, o.uid as parent_uid, o.identifier as parent_identifier,
					container_type_id, container_type_name,
					storage_reason_id, storage_reason_name
					from storage s
					join movement_type using (movement_type_id)
					left outer join container c using (container_id)
					left outer join object o on (c.uid = o.uid)
					left outer join container_type using (container_type_id)
					left outer join storage_reason using (storage_reason_id)
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
						"requis" => 1,
						"parentAttrib" => 1 
				),
				"container_id" => array (
						"type" => 1 
				),
				"movement_type_id" => array (
						"type" => 1,
						"requis" => 1 
				),
				"storage_reason_id" => array(
						"type"=>1
				),
				"storage_date" => array (
						"type" => 3,
						"defaultValue" => "getDateHeure" 
				),
				"login" => array (
						"requis" => 1,
						"defaultValue" => "getLogin" 
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
		if (is_numeric ( $uid ) && $uid > 0) {
			$data ["uid"] = $uid;
			return $this->getListeParamAsPrepared ( $this->sql . $this->where . $this->order, $data );
		}
	}
	/**
	 * Retourne la liste de tous les containers parents
	 * 
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
	
	/**
	 * Fonction generique permettant de rajouter des mouvements
	 * 
	 * @param int $uid        	
	 * @param timestamp $date        	
	 * @param int $type        	
	 * @param number $container_uid        	
	 * @param varchar $login        	
	 * @param varchar $range        	
	 * @param varchar $comment        	
	 * @return Identifier
	 */
	function addMovement($uid, $date, $type, $container_uid = 0, $login = null, $range = null, $comment = null, $storage_reason_id = null) {
		global $LANG;
		/*
		 * Verifications
		 */
		$controle = true;
		$message = $LANG ["appli"] [5];
		if (! ($uid > 0 && is_numeric ( $uid )))
			$controle = false;
		if ($uid == $container_uid) {
			$controle = false;
			$message = "Création du mouvement impossible : le numéro de l'objet est égal au numéro du conteneur";
		}
		$date = $this->encodeData ( $date );
		if (strlen ( $date ) == 0)
			$controle = false;
		if ($type != 1 && $type != 2)
			$controle = false;
		$container_uid = $this->encodeData ( $container_uid );
		if (! is_numeric ( $container_uid ) && strlen ( $container_uid ) > 0)
			$controle = false;
		if (strlen ( $login ) == 0)
			strlen ( $_SESSION ["login"] ) > 0 ? $login = $_SESSION ["login"] : $controle = false;
		$range = $this->encodeData ( $range );
		$comment = $this->encodeData ( $comment );
		$storage_reason_id = $this->encodeData ($storage_reason_id);
		if ($controle) {
			$data ["uid"] = $uid;
			$data ["storage_date"] = $date;
			$data ["movement_type_id"] = $type;
			$data ["login"] = $login;
			$data["storage_reason_id"] = $storage_reason_id;
			/*
			 * Recherche de container_id a partir de uid
			 */
			$container = new Container ( $this->connection, $this->param );
			$container_id = $container->getIdFromUid ( $container_uid );
			if ($container_id > 0)
				$data ["container_id"] = $container_id;
			if (strlen ( $range ) > 0)
				$data ["range"] = $range;
			if (strlen ( $comment ) > 0)
				$data ["storage_comment"] = $comment;
			return $this->ecrire ( $data );
		} 		
		else
			/*
			 * Gestion des erreurs
			 */
			throw new Exception ( $message );
	}
	
	/**
	 * Retourne le nombre de mouvements impliques dans le controleur fourni
	 * 
	 * @param int $id        	
	 */
	function getNbFromContainer($uid) {
		$sql = "select count (*) as nombre from container c
				join storage using (container_id)
				where c.uid = :uid";
		$data ["uid"] = $uid;
		$result = $this->lireParamAsPrepared ( $sql, $data );
		return $result ["nombre"];
	}
}

?>