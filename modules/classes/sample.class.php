<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Sample extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	private $sql = "select s.sample_id, s.uid, s.project_id, project_name, s.sample_type_id,
					sample_type_name, s.sample_creation_date, s.sample_date, s.parent_sample_id,
					so.identifier,
					pso.uid as parent_uid, pso.identifier as parent_identifier
					from sample s
					join sample_type st on (st.sample_type_id = s.sample_type_id)
					join project p on (p.project_id = s.project_id)
					join object so on (s.uid = so.uid)
					left outer join sample ps on (s.parent_sample_id = ps.sample_id)
					left outer join object pso on (ps.uid = pso.uid)					
					";
	function __construct($bdd, $param = array()) {
		$this->table = "sample";
		$this->colonnes = array (
				"sample_id" => array (
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
				"project_id" => array (
						"type" => 1,
						"requis" => 1 
				),
				"sample_type_id" => array (
						"type" => 1,
						"requis" => 1 
				),
				"sample_creation_date" => array (
						"type" => 2,
						"requis" => 1,
						"defaultValue" => "getDateJour" 
				),
				"parent_sample_id" => array (
						"type" => 1 
				),
				"sample_date" => array (
						"type" => 2,
						"defaultValue" => "getDateJour" 
				) 
		);
		
		parent::__construct ( $bdd, $param );
	}
	/**
	 * Surcharge de lire pour ramener les informations
	 * generales (table object, notamment)
	 * 
	 * {@inheritDoc}
	 *
	 * @see ObjetBDD::lire()
	 */
	function lire($uid, $getDefault, $parentValue) {
		$sql = $this->sql . " where s.uid = :uid";
		$data ["uid"] = $uid;
		if (is_numeric ( $uid ) && $uid > 0) {
			$retour = parent::lireParamAsPrepared ( $sql, $data );
		} else {
			$retour = parent::getDefaultValue ( $parentValue );
		}
		return $retour;
	}
	
	/**
	 * Surcharge de la fonction ecrire pour verifier si l'echantillon est modifiable
	 * 
	 * {@inheritDoc}
	 *
	 * @see ObjetBDD::ecrire()
	 */
	function ecrire($data) {
		$ok = $this->verifyProject ( $data );
		/*
		 * Verification complementaire par rapport aux donnees deja stockees
		 */
		if ($ok && $data ["uid"] > 0)
			$ok = $this->verifyProject ( $this->lire ( $uid ) );
		if ($ok) {
			return parent::ecrire ( $data );
		} else
			return - 1;
	}
	
	/**
	 * Surcharge de la fonction supprimer pour verifier si l'utilisateur peut supprimer l'echantillon
	 * 
	 * {@inheritDoc}
	 *
	 * @see ObjetBDD::supprimer()
	 */
	function supprimer($uid) {
		global $LANG;
		$data ["uid"] = $uid;
		if ($this->verifyProject ( $this->lire ( $uid ) )) {
			return parent::supprimer ( $id );
		} else {
			return - 1;
		}
	}
	
	/**
	 * Fonction permettant de verifier si l'echantillon peut etre modifie ou non
	 * par l'utilisateur
	 * 
	 * @param array $data        	
	 * @throws Exception
	 * @return boolean
	 */
	function verifyProject($data) {
		global $LANG;
		if (! in_array ( $data ["project_id"], $_SESSION ["projects"] )) {
			throw new Exception ( $LANG ["appli"] [4] );
			return false;
		}
		return true;
	}
	
	/**
	 * Retourne le nombre d'echantillons attaches a un projet
	 *
	 * @param int $project_id        	
	 */
	function getNbFromProject($project_id) {
		if ($project_id > 0) {
			$sql = "select count(*)as nb from sample where project_id = :project_id";
			$var ["project_id"] = $project_id;
			$data = $this->lireParamAsPrepared ( $sql, $var );
			if (count ( $data ) > 0) {
				return $data ["nb"];
			} else
				return 0;
		}
	}

	/**
	 * Fonction de recherche des échantillons
	 * @param array $param
	 */
	function sampleSearch($param) {
		$data = array();
		$isFirst = true;
		$order = " order by project_name, sample_type_name, identifier, uid";
		$where = "where";
		$and = "";
		if ($param["sample_type_id"] > 0) {
			$where .= " s.sample_type_id = :sample_type_id";
			$data ["sample_type_id"] = $param["sample_type_id"];
			$and = " and ";
		}
		if (strlen($param["name"]) > 0) {
			$where .= $and."( ";
			$or = "";
			if (is_numeric($param["name"])) {
				$where .= " s.uid = :uid";
				$data["uid"] = $param["name"];
				$or = " or ";
			}
			$identifier = "%".strtoupper($this->encodeData($param["name"]))."%";
			$where .= "$or upper(s.identifier) like :identifier )";
			$and = " and ";
			$data["identifier"] = $identifier;
		}
		if ($param["project_id"] > 0) {
			$where .= $and." s.project_id = :project_id";
			$and = " and ";
			$data["project_id"] = $param["project_id"];
		}
		if ($param["limit"] > 0) {
			$order .= " limit :limite";
			$data["limite"] = $param["limit"];
			return $this->getListeParamAsPrepared($this->sql.$where.$order, $data);
		}
	}
	
}

?>