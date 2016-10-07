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
				"wgs84_x" => array (
						"type" => 1 
				),
				"wgs84_y" => array (
						"type" => 1 
				),
				"object_status_id" => array (
						"type" => 1,
						"defaultValue" => 1 
				) 
		);
		parent::__construct ( $bdd, $param );
	}
	/**
	 * Surcharge de la fonction supprimer pour effacer les mouvements et les evenements
	 *
	 * {@inheritdoc}
	 *
	 * @see ObjetBDD::supprimer()
	 */
	function supprimer($uid) {
		if ($uid > 0 && is_numeric ( $uid )) {
			/*
			 * Supprime les mouvements associes
			 */
			require_once 'modules/classes/storage.class.php';
			$storage = new Storage ( $this->connection, $this->paramori );
			$storage->supprimerChamp ( $uid, "uid" );
			/*
			 * Supprime les evenements associes
			 */
			require_once 'modules/classes/event.class.php';
			$event = new Event ( $this->connection, $this->paramori );
			$event->supprimerChamp ( $uid, "uid" );
			/*
			 * Supprime l'objet
			 */
			parent::supprimer ( $uid );
		}
	}
	function getDetail($uid, $is_container = 0) {
		if (is_numeric ( $uid ) && $uid > 0) {
			$data ["uid"] = $uid;
			$sql = "select uid, identifier, wgs84_x, wgs84_y,
					container_type_name as type_name
					from object 
					join container using (uid)
					join container_type using (container_type_id)
					where uid = :uid";
			if ($is_container != 1)
				$sql .= " UNION
					select uid, identifier, wgs84_x, wgs84_y,
					sample_type_name as type_name
					from object 
					join sample using (uid)
					join sample_type using (sample_type_id)
					where uid = :uid
					";
			return $this->getListeParamAsPrepared ( $sql, $data );
		}
	}
	/**
	 * Prepare la liste des objets pour impression des etiquettes
	 *
	 * @param array $list        	
	 * @return tableau
	 */
	function getForPrint(array $list) {
		/*
		 * Verification que la liste ne soit pas vide
		 */
		if (count ( $list ) > 0) {
			$data = $this->getForList($list);
			/**
			 * Rajout des identifiants complementaires
			 */
			/*
			 * Recherche des types d'etiquettes
			 */
			require_once 'modules/classes/identifierType.class.php';
			$it = new IdentifierType($this->connection, $this->param);
			$dit = $it->getListe("identifier_type_code");
			require_once 'modules/classes/objectIdentifier.class.php';
			$oi = new ObjectIdentifier($this->connection, $this->param);
			
			/*
			 * Traitement de la liste
			 */
			foreach ($data as $key => $value) {
				/*
				 * Recuperation de la liste des identifiants externes
				 */
				$doi = $oi->getListFromUid($value["uid"]);
				/*
				 * Transformation en tableau direct
				 */
				$codes = array();
				foreach ($doi as $vdoi)
					$codes[$vdoi["identifier_type_code"]] = $vdoi["object_identifier_value"];
				/*
				 * Rajout des codes 
				 */
				foreach ($dit as $vdit)
					$data[$key][$vdit["identifier_type_code"]] = $codes[$vdit["identifier_type_code"]];
			}
			return $data;
		}
	}
	/**
	 * Recupere la liste des objets 
	 * @param array $list
	 * @return tableau
	 */
	function getForList(array $list) {
		/*
		 * Verification que les uid sont numeriques
		 * preparation de la clause where
		 */
		$comma = false;
		$uids = "";
		foreach ( $list as $value ) {
			if (is_numeric ( $value ) && $value > 0) {
				$comma == true ? $uids .= "," : $comma = true;
				$uids .= $value;
			}
		}
		$sql = "select uid, identifier, container_type_name as type_name, clp_classification as clp,
		label_id, 'container' as object_type
		from object
		join container using (uid)
		join container_type using (container_type_id)
		where uid in ($uids)
		UNION
		select uid, identifier, sample_type_name as type_name, clp_classification as clp,
		label_id, 'sample' as object_type
		from object
		join sample using (uid)
		join sample_type using (sample_type_id)
		left outer join container_type using (container_type_id)
		where uid in ($uids)
		order by uid
		";
		return $this->getListeParam ( $sql );
		
	}
	/**
	 * Genere le QRCODE
	 * @param unknown $list
	 * @return unknown[][]|tableau[][]
	 */
	function generateQrcode($list) {
		/*
		 * Verification que la liste ne soit pas vide
		 */
		if (count ( $list ) > 0) {
			/*
			 * Verification que les uid sont numeriques
			 * preparation de la clause where
			 */
			$comma = false;
			$uids = "";
			foreach ( $list as $value ) {
				if (is_numeric ( $value ) && $value > 0) {
					$comma == true ? $uids .= "," : $comma = true;
					$uids .= $value;
				}
			}
			require_once 'plugins/phpqrcode/qrlib.php';
			global $APPLI_code, $APPLI_temp;
			require_once 'modules/classes/objectIdentifier.class.php';
			$oi = new ObjectIdentifier ( $this->connection, $this->param );
			require_once 'modules/classes/label.class.php';
			$label = new Label ( $this->connection, $this->param );
			
			/*
			 * Recuperation des informations generales
			 */
			$sql = "select uid, identifier as id, clp_classification as clp, '' as pn, 
			 		'$APPLI_code' as db,
			 		'' as prj,
			 		label_id
					from object 
					join container using (uid)
					join container_type using (container_type_id)
					where uid in ($uids)
					UNION
					select uid, identifier as id, clp_classification as clp, protocol_name as pn, 
			 		'$APPLI_code' as db, 
			 		project_name as prj,
			 		label_id
					from object 
					join sample using (uid)
					join sample_type using (sample_type_id)
					join project using (project_id)
					left outer join container_type using (container_type_id)
			 		left outer join operation using (operation_id)
			 		left outer join protocol using (protocol_id)
					where uid in ($uids)
			";
			$data = $this->getListeParam ( $sql );
			
			/*
			 * Preparation du tableau de sortie
			 * transcodage des noms de champ
			 */
			/*
			 * Recuperation de la liste des champs a inserer dans l'etiquette
			 */
			
			/*
			 * $convert = array (
			 * "uid" => "uid",
			 * "identifier" => "id",
			 * "clp" => "clp",
			 * "protocol_name" => "pn",
			 * "project_name" => "prj",
			 * "db" => "db"
			 * )
			 * ;
			 */
			$dataConvert = array ();
			/**
			 * Traitement de chaque ligne, et generation
			 * du qrcode
			 */
			$labelId = 0;
			$fields = array ();
			foreach ( $data as $row ) {
				if ($row ["label_id"] > 0) {
					/*
					 * Lecture des labels
					 */
					if ($row ["label_id"] != $labelId) {
						/*
						 * Lecture de l'etiquette
						 */
						$dlabel = $label->lire ( $row ["label_id"] );
						$labelId = $row ["label_id"];
						$fields = explode ( ",", $dlabel ["label_fields"] );
					}
					/*
					 * Recuperation des identifiants complementaires
					 */
					$doi = $oi->getListFromUid ( $row ["uid"] );
					$rowq = array ();
					foreach ( $row as $key => $value ) {
						
						if (strlen ( $value ) > 0 && in_array( $key, $fields ))
							$rowq [$key] = $value;
					}
					foreach ( $doi as $value ) {
						if (in_array ( $value ["identifier_type_code"], $fields ))
							$rowq [$value ["identifier_type_code"]] = $value ["object_identifier_value"];
					}
					/*
					 * Generation du qrcode
					 */
					$filename = $APPLI_temp . '/' . $rowq ["uid"] . ".png";
					//if (! file_exists ( $filename ))
					QRcode::png ( json_encode ( $rowq ), $filename );
						
					/*
					 * Ajout du modele d'etiquette
					 */
					foreach ( $doi as $value ) {
						$rowq [$value ["identifier_type_code"]] = $value ["object_identifier_value"];
					}
					$rowq ["label_id"] = $row ["label_id"];
					/*
					 * Ajout des identifiants complementaires
					 */
					$dataConvert [] = $rowq;
				}
			}
			return $dataConvert;
		}
	}
	/**
	 * Lit les objets a partir des saisies batch
	 * @param unknown $batchdata
	 * @return tableau
	 */
	function batchRead($batchdata) {
		global $APPLI_code;
		if (strlen($batchdata) > 0) {
			$batchdata = $this->encodeData($batchdata);
			/*
			 * Preparation du tableau de travail
			 */
			$data = explode("\t", $batchdata);
			/*
			 * Extraction des UID de chaque ligne scanee
			 */
			$uids = array();
			foreach ($data as $value) {
				$datajson = json_decode($value, true);
				if ($datajson["uid"] > 0 && $datajson["db"] == $APPLI_code)
					$uids [] = $datajson ["uid"];
			}
			if (count($uids) > 0){
				return $this->getForList($uids);
			}
		}
	}
	
}


