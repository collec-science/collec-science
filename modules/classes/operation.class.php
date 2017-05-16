<?php
/**
 * Created : 14 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Operation extends ObjetBDD {
	private $sql = "select operation_id, operation_name, operation_order,
					protocol_id, protocol_name, protocol_year, protocol_version,
					metadata_form_id, schema
					from operation
					join metadata_form using (metadata_form_id)
					join protocol using (protocol_id)";
	private $order = " order by protocol_year desc, protocol_name, protocol_version,
					operation_order, operation_name";
	
	/**
	 *
	 * @param PDO $bdd
	 * @param array $param
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "operation";
		$this->colonnes = array (
				"operation_id" => array(
						"type"=>1,
						"key"=>1,
						"requis"=>1,
						"defaultValue"=>0
				),
				"protocol_id" => array (
						"type" => 1,
						"requis" => 1,
						"parentAttrib" => 1
				),
				"operation_name" => array (
						"type" => 0,
						"requis" => 1
				),
				"operation_order" => array (
						"type" => 1
				),
				"metadata_form_id" => array (
						"type" => 1
				)
		);
		parent::__construct ( $bdd, $param );
	}
	/**
	 * Retourne la liste des operations associees aux protocoles
	 * 
	 * {@inheritDoc}
	 * @see ObjetBDD::getListe()
	 */
	function getListe() {
		return $this->getListeParam($this->sql.$this->order);
	}

	/**
	 * Surcharge de la fonction supprimer pour verifier si l'utilisateur peut supprimer l'echantillon
	 *
	 * {@inheritdoc}
	 *
	 * @see ObjetBDD::supprimer()
	 */
	function supprimer($id) {
		$data = $this->lire ( $id );
			/*
			 * suppression de l'operation
			 */
			parent::supprimer ( $data ["operation_id"] );
			/*
			*suppression des metadonnées
			*/
			require_once 'modules/classes/metadataForm.class.php';
			$metadata = new metadataForm($this->connection, $this->paramori);
			$metadata->supprimer($data["metadata_form_id"]);

	}


	/**
	 * Retourne le nombre d'échantillons attachés a une opération
	 *
	 * @param int $operation_id        	
	 */
	function getNbSample($operation_id) {
		if ($operation_id > 0) {
                                        $sql = "select count(*) as nb from sample s, sample_type st where s.sample_type_id = st.sample_type_id and st.operation_id = :operation_id";
			$var ["operation_id"] = $operation_id;
			$data = $this->lireParamAsPrepared ( $sql, $var );
			if (count ( $data ) > 0) {
				return $data ["nb"];
			} else
				return 0;
		}
	}
}
?>