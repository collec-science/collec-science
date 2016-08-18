<?php
/**
 * Created : 17 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
/**
 * Classes d'exception
 *
 * @author quinton
 *        
 */
class FichierException extends Exception {
}
;
class HeaderException extends Exception {
}
;
class ImportException extends Exception {
}
;

/**
 * Classe realisant l'import
 *
 * @author quinton
 *        
 */
class Import {
	private $separator = ",";
	private $utf8_encode = false;
	private $colonnes = array (
			"sample_identifier",
			"project_id",
			"sample_type_id",
			"sample_date",
			"container_identifier",
			"container_type_id",
			"container_status_id",
			"sample_range",
			"container_parent_uid",
			"container_range" 
	);
	private $handle;
	private $fileColumn = array ();
	public $nbTreated = 0;
	private $project = array ();
	private $sample_type = array ();
	private $container_type = array ();
	private $container_status = array ();
	private $sample;
	private $container;
	private $storage;
	
	/**
	 * Initialise la lecture du fichier, et lit la ligne d'entete
	 *
	 * @param string $filename        	
	 * @param string $separator        	
	 * @param string $utf8_encode        	
	 * @throws HeaderException
	 * @throws FileException
	 */
	function initFile($filename, $separator = ",", $utf8_encode = false) {
		if ($separator == "tab")
			$separator = "\t";
		$this->separator = $separator;
		$this->utf8_encode = $utf8_encode;
		/*
		 * Ouverture du fichier
		 */
		if ($this->handle = fopen ( $filename, 'r' )) {
			/*
			 * Lecture de la premiere ligne et affectation des colonnes
			 */
			$data = $this->readLine ();
			$range = 0;
			for($range = 0; $range < count ( $data ); $range ++) {
				$value = $data [$range];
				if (in_array ( $value, $this->colonnes )) {
					$this->fileColumn [$range] = $value;
				} else
					throw new HeaderException ( "Header column $range is not recognized ($value)" );
			}
		} else {
			throw new FichierException ( "$filename not found or not readable" );
		}
	}
	/**
	 * Initialise les classes utilisees pour realiser les imports
	 *
	 * @param Sample $sample        	
	 * @param Container $container        	
	 * @param Storage $storage        	
	 */
	function initClasses(Sample $sample, Container $container, Storage $storage) {
		$this->sample = $sample;
		$this->container = $container;
		$this->storage = $storage;
	}
	
	/**
	 * Lit une ligne dans le fichier
	 *
	 * @return array|NULL
	 */
	function readLine() {
		if ($this->handle) {
			$data = fgetcsv ( $this->handle, 1000, $this->separator );
			if ($data !== false) {
				if ($this->utf8_encode) {
					foreach ( $data as $key => $value )
						$data [$key] = utf8_encode ( $value );
				}
			}
			return $data;
		} else
			return null;
	}
	/**
	 * Ferme le fichier
	 */
	function fileClose() {
		if ($this->handle)
			fclose ( $this->handle );
	}
	/**
	 * Lance l'import des lignes
	 *
	 * @param Sample $sample        	
	 * @param Container $container        	
	 * @param Storage $storage        	
	 * @throws ImportException
	 */
	function importAll() {
		$date = date ( 'd/m/Y H:i:s' );
		$num = 1;
		while ( ($data = $this->readLine ()) !== false ) {
			/*
			 * Preparation du tableau
			 */
			$values = $this->prepareLine ( $data );
			$num ++;
			/*
			 * Controle de la ligne
			 */
			$resControle = $this->controlLine ( $values );
			if ($resControle ["code"] == false) {
				throw new ImportException ( "Line $num : " . $resControle ["message"] );
			}
			/*
			 * Traitement de l'echantillon
			 */
			$sample_uid = 0;
			if (strlen ( $values ["sample_identifier"] ) > 0) {
				$dataSample = $values;
				$dataSample ["sample_creation_date"] = $date;
				$dataSample ["identifier"] = $values ["sample_identifier"];
				try {
					$sample_uid = $this->sample->ecrire ( $dataSample );
				} catch ( PDOException $pe ) {
					throw new ImportException ( "Line $num : error when import sample<br>" . $pe->getMessage () );
				}
			}
			/*
			 * Traitement du conteneur
			 */
			$container_uid = 0;
			if (strlen ( $values ["container_identifier"] ) > 0) {
				$dataContainer = $values;
				$dataContainer ["identifier"] = $values ["container_identifier"];
				try {
					$container_uid = $this->container->ecrire ( $dataContainer );
				} catch ( PDOException $pe ) {
					throw new ImportException ( "Line $num : error when import container<br>" . $pe->getMessage () );
				}
				/*
				 * Traitement du rattachement du container
				 */
				if (strlen ( $values ["container_parent_uid"] ) > 0) {
					try {
						$this->storage->addMovement ( $container_uid, $date, 1, $values ["container_parent_uid"], $_SESSION ["login"], $values ["container_range"] );
					} catch ( Exception $e ) {
						throw new ImportException ( "Line $num : error when create input movement for container<br>" . $e->getMessage () );
					}
				}
			}
			/*
			 * Traitement de l'entree de l'echantillon dans le container
			 */
			if ($sample_uid > 0 && $container_uid > 0) {
				try {
					$this->storage->addMovement ( $sample_uid, $date, 1, $container_uid, $_SESSION ["login"], $values ["sample_range"] );
				} catch ( Exception $e ) {
					throw new ImportException ( "Line $num : error when create input movement for sample (" . $e->getMessage () + ")" );
				}
			}
			$this->nbTreated ++;
		}
	}
	/**
	 * Reecrit une ligne, en placant les bonnes valeurs en fonction de l'entete
	 *
	 * @param array $data        	
	 * @return array[]
	 */
	function prepareLine($data) {
		$nb = count ( $data );
		$values = array ();
		for($i = 0; $i < $nb; $i ++)
			$values [$this->fileColumn [$i]] = $data [$i];
		return $values;
	}
	/**
	 * Initialise les tableaux pour traiter les controles
	 *
	 * @param array $project        	
	 * @param array $sample_type        	
	 * @param array $container_type        	
	 * @param array $container_status        	
	 */
	function initControl($project, $sample_type, $container_type, $container_status) {
		$this->project = $project;
		$this->sample_type = $sample_type;
		$this->container_type = $container_type;
		$this->container_status = $container_status;
	}
	/**
	 * Declenche le controle pour toutes les lignes
	 *
	 * @return array[]["line"=>int, "message"=>string]
	 */
	function controlAll() {
		$num = 1;
		$retour = array ();
		while ( ($data = $this->readLine ()) !== false ) {
			$values = $this->prepareLine ( $data );
			$num ++;
			$controle = $this->controlLine ( $values );
			if ($controle ["code"] == false) {
				$retour [] = array (
						"line" => $num,
						"message" => $controle ["message"] 
				);
			}
		}
		return $retour;
	}
	/**
	 * Controle une ligne
	 *
	 * @param array $data        	
	 * @return array ["code"=>boolean,"message"=>string]
	 */
	function controlLine($data) {
		$retour = array (
				"code" => true,
				"message" => "" 
		);
		$emptyLine = true;
		/*
		 * Traitement de l'echantillon
		 */
		if (strlen ( $data ["sample_identifier"] ) > 0) {
			$emptyLine = false;
			/*
			 * Verification du projet
			 */
			$ok = false;
			foreach ( $this->project as $value ) {
				if ($data ["project_id"] == $value ["project_id"]) {
					$ok = true;
					break;
				}
			}
			if ($ok == false) {
				$retour ["code"] = false;
				$retour ["message"] .= "Le numéro du projet indiqué n'est pas reconnu ou autorisé. ";
			}
			/*
			 * Verification du type d'echantillon
			 */
			$ok = false;
			foreach ( $this->sample_type as $value ) {
				if ($data ["sample_type_id"] == $value ["sample_type_id"]) {
					$ok = true;
					break;
				}
			}
			if ($ok == false) {
				$retour ["code"] = false;
				$retour ["message"] .= "Le type d'échantillon n'est pas connu. ";
			}
		}
		/*
		 * Traitement du container
		 */
		if (strlen ( $data ["container_identifier"] ) > 0) {
			$emptyLine = false;
			/*
			 * Verification du type de container
			 */
			$ok = false;
			foreach ( $this->container_type as $value ) {
				if ($data ["container_type_id"] == $value ["container_type_id"]) {
					$ok = true;
					break;
				}
			}
			if ($ok == false) {
				$retour ["code"] = false;
				$retour ["message"] .= "Le type de container n'est pas connu. ";
			}
			/*
			 * Verification du statut du container
			 */
			if (strlen ( $data ["container_status_id"] ) > 0) {
				$ok = false;
				foreach ( $this->container_status as $value ) {
					if ($data ["container_status_id"] == $value ["container_status_id"]) {
						$ok = true;
						break;
					}
				}
				if ($ok == false) {
					$retour ["code"] = false;
					$retour ["message"] .= "Le statut du container n'est pas connu. ";
				}
			}
			/*
			 * Verification de l'uid du container parent
			 */
			if (strlen ( $data ["container_parent_uid"] ) > 0) {
				$container_id = $this->container->getIdFromUid ( $data ["container_parent_uid"] );
				if (! $container_id > 0) {
					$retour ["code"] = false;
					$retour ["message"] .= "L'UID du conteneur parent n'existe pas. ";
				}
			}
		}
		/*
		 * Traitement de la ligne vierge
		 */
		if ($emptyLine) {
			$retour ["code"] = false;
			$retour ["message"] .= "Aucun échantillon ou container n'est décrit (pas d'identifiant pour l'un ou pour l'autre). ";
		}
		return $retour;
	}
}
?>