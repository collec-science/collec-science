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
	private $sql = "select s.sample_id, s.uid,
					s.project_id, project_name, s.sample_type_id,
					sample_type_name, s.sample_creation_date, s.sample_date, s.parent_sample_id,
					st.multiple_type_id, s.multiple_value, st.multiple_unit, mt.multiple_type_name,
					so.identifier, so.wgs84_x, so.wgs84_y, 
					so.object_status_id, object_status_name,
					pso.uid as parent_uid, pso.identifier as parent_identifier,
					container_type_name, clp_classification,
					operation_id, protocol_name, protocol_year, protocol_version, operation_name, operation_order,
					document_id
					from sample s
					join sample_type st on (st.sample_type_id = s.sample_type_id)
					join project p on (p.project_id = s.project_id)
					join object so on (s.uid = so.uid)
					left outer join object_status os on (so.object_status_id = os.object_status_id)
					left outer join sample ps on (s.parent_sample_id = ps.sample_id)
					left outer join object pso on (ps.uid = pso.uid)	
					left outer join container_type ct using (container_type_id)
					left outer join operation using (operation_id)
					left outer join protocol using (protocol_id)
					left outer join multiple_type mt on (st.multiple_type_id = mt.multiple_type_id)
					left outer join last_photo on (so.uid = last_photo.uid)
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
						"requis" => 1,
						"defaultValue" => 0 
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
				),
				"multiple_value" => array("type"=>1)
		);
		parent::__construct ( $bdd, $param );
	}
	/**
	 * Surcharge de lire pour ramener les informations
	 * generales (table object, notamment)
	 *
	 * {@inheritdoc}
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
	
	function lireFromId($sample_id) {
		$sql = $this->sql . " where s.sample_id = :sample_id";
		$data ["sample_id"] = $sample_id;
		return parent::lireParamAsPrepared ( $sql, $data );
	}
	
	/**
	 * Surcharge de la fonction ecrire pour verifier si l'echantillon est modifiable
	 *
	 * {@inheritdoc}
	 *
	 * @see ObjetBDD::ecrire()
	 */
	function ecrire($data) {
		$ok = $this->verifyProject ( $data );
		/*
		 * Verification complementaire par rapport aux donnees deja stockees
		 */
		if ($ok && $data ["uid"] > 0)
			$ok = $this->verifyProject ( $this->lire ( $data ["uid"] ) );
		if ($ok) {
			$object = new Object ( $this->connection, $this->param );
			$uid = $object->ecrire ( $data );
			if ($uid > 0) {
				$data ["uid"] = $uid;
				parent::ecrire ( $data );
				return $uid;
			}
		} else
			throw new Exception ( $LANG ["appli"] [4] );
		return - 1;
	}
	
	/**
	 * Surcharge de la fonction supprimer pour verifier si l'utilisateur peut supprimer l'echantillon
	 *
	 * {@inheritdoc}
	 *
	 * @see ObjetBDD::supprimer()
	 */
	function supprimer($uid) {
		$data = $this->lire ( $uid );
		if ($this->verifyProject ( $data )) {
			/*
			 * Suppression des attributs specifiques
			 */
			require_once 'modules/classes/sampleAttribute.class.php';
			$sampleAttribute = new SampleAttribute ( $this->connection, $this->paramori );
			$sampleAttribute->supprimerChamp ( $data ["sample_id"], "sample_id" );
			
			/*
			 * suppression de l'echantillon
			 */
			parent::supprimer ( $data ["sample_id"] );
			/*
			 * Suppression de l'objet
			 */
			require_once 'modules/classes/object.class.php';
			$object = new Object ( $this->connection, $this->paramori );
			$object->supprimer ( $uid );
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
		$retour = false;
		foreach ( $_SESSION ["projects"] as $value ) {
			if ($data ["project_id"] == $value ["project_id"]) {
				$retour = true;
				break;
			}
		}
		return $retour;
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
	 *
	 * @param array $param        	
	 */
	function sampleSearch($param) {
		$data = array ();
		$isFirst = true;
		$order = " order by project_name, sample_type_name, identifier, uid";
		$where = "where";
		$and = "";
		if ($param ["sample_type_id"] > 0) {
			$where .= " s.sample_type_id = :sample_type_id";
			$data ["sample_type_id"] = $param ["sample_type_id"];
			$and = " and ";
		}
		if (strlen ( $param ["name"] ) > 0) {
			$where .= $and . "( ";
			$or = "";
			if (is_numeric ( $param ["name"] )) {
				$where .= " s.uid = :uid";
				$data ["uid"] = $param ["name"];
				$or = " or ";
			}
			$identifier = "%" . strtoupper ( $this->encodeData ( $param ["name"] ) ) . "%";
			$where .= "$or upper(so.identifier) like :identifier )";
			$and = " and ";
			$data ["identifier"] = $identifier;
		}
		if ($param ["project_id"] > 0) {
			$where .= $and . " s.project_id = :project_id";
			$and = " and ";
			$data ["project_id"] = $param ["project_id"];
		}
		if ($param ["object_status_id"] > 0) {
			$where .= $and . " so.object_status_id = :object_status_id";
			$and = " and ";
			$data ["object_status_id"] = $param ["object_status_id"];
		}
		
		if ($param["uid_max"] > 0 && $param["uid_max"] >= $param["uid_min"]) {
			$where .= $and. " s.uid between :uid_min and :uid_max";
			$and = " and ";
			$data["uid_min"] = $param["uid_min"];
			$data["uid_max"] = $param["uid_max"];
		}
		
		if ($param ["limit"] > 0) {
			$order .= " limit :limite";
			$data ["limite"] = $param ["limit"];
		}
		if ($where == "where")
			$where = "";
		return $this->getListeParamAsPrepared ( $this->sql . $where . $order, $data );
	}
	/**
	 * Retourne les echantillons associes a un parent
	 * @param int $uid : uid du parent
	 */
	function getSampleassociated($uid) {
		if ($uid > 0 && is_numeric($uid)) {
			$data ["uid"] = $uid;
			$where = " where pso.uid = :uid";
			$order = " order by s.uid";
			return $this->getListeParamAsPrepared($this->sql.$where. $order, $data);
		}
	}
}

?>