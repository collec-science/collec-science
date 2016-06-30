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
						"type" => 3,
						"requis" => 1,
						"defaultValue" => "getDateHeure" 
				),
				"parent_sample_id" => array (
						"type" => 1 
				),
				"sample_date" => array (
						"type" => 3,
						"defaultValue" => "getDateHeure" 
				) 
		);
		
		parent::__construct ( $bdd, $param );
	}
	/**
	 * Retourne le nombre d'echantillons attaches a un projet
	 * @param int $project_id
	 */
	function getNbFromProject($project_id) {
		if ($project_id > 0 ) {
			$sql = "select count(*)as nb from sample where project_id = :project_id";
			$var["project_id"] = $project_id;
			$data = $this->lireParamAsPrepared($sql, $var);
			if (count($data) > 0) {
				return $data["nb"];
			} else 
				return 0;
		}
	}
}

?>