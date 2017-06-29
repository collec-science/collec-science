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
			"sample_status_id",
			"wgs84_x",
			"wgs84_y",
			"sample_date",
			"sample_multiple_value",
			"sample_metadata_json",
			"sampling_place",
			"container_identifier",
			"container_type_id",
			"container_status_id",
			"sample_location",
			"container_parent_uid",
			"container_location" 
	);
	private $colnum = array (
			"sample_multiple_value" 
	);
	private $handle;
	private $fileColumn = array ();
	public $nbTreated = 0;
	private $project = array ();
	private $sample_type = array ();
	private $container_type = array ();
	private $object_status = array ();
	private $sampling_place = array();
	private $sample;
	private $container;
	private $storage;
	private $initIdentifiers = false;
	private $identifiers = array ();
	public $minuid, $maxuid;
	
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
			$this->initIdentifiers ();
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
		$maxuid = 0;
		$minuid = 99999999;
		require_once 'modules/classes/objectIdentifier.class.php';
		global $bdd;
		$oi = new ObjectIdentifier ( $bdd );
		require_once 'modules/classes/sampleMetadata.class.php';
		$metadata = new SampleMetadata($bdd);
		require_once 'modules/classes/samplingPlace.class.php';
		$samplingPlace = new SamplingPlace($bdd);
		require_once 'modules/classes/sampleType.class.php';
		$sampleType = new SampleType($bdd);
		$this->initIdentifiers ();
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
				$dataSample ["object_status_id"] = $values ["sample_status_id"];
				if (! $dataSample ["object_status_id"] > 0)
					$dataSample ["object_status_id"] = 1;
				$dataSample ["multiple_value"] = $values ["sample_multiple_value"];
				/*
				* Traitement du lieu de prélevement
				*/
				if (strlen ( $values ["sampling_place"]) > 0) {
					$exists=false;
					$sampling_place_id=0;
					foreach ( $this->sampling_place as $list ) {
						if (strtoupper ($dataSample ["sampling_place"]) == strtoupper ($list["sampling_place_name"])) {
							$exists = true;
							$sampling_place_id = $list["sampling_place_id"];
							break;
						}
					}
					if(!$exists){
						$dataSamplingPlace = array(
							"sampling_place_name" => $values["sampling_place"]
						);
						$sampling_place_id = $samplingPlace->ecrire($dataSamplingPlace);
					}
					$dataSample["sampling_place_id"] = $sampling_place_id;
				}

				/*
				* Traitement des métadonnées
				*/
				if (strlen ($values["sample_metadata_json"]) > 0){
					$dataMetadata = array(
							"data" => $values["sample_metadata_json"]
					);
					//on vérifie que les données sont cohérentes avec le schéma de métadonnées
					$metadataSchema = json_decode($sampleType->getMetadataForm($dataSample["sample_type_id"]),true);
					$metadataSchemaNames=array();
					$valuesMetadataJson = json_decode($values["sample_metadata_json"],true);
					$valuesMetadataJsonNames=array();
					foreach ($metadataSchema as $field) {
						$metadataSchemaNames[] = $field["nom"];
					}
					foreach ($valuesMetadataJson as $key => $field) {
						$valuesMetadataJsonNames[] = $key;
					}
					foreach ($valuesMetadataJsonNames as $name) {
						if (!in_array ( $name, $metadataSchemaNames )) {
							throw new FichierException("Les métadonnées ne correspondent pas au type d'échantillon");
						}
					}
					$sample_metadata_id = $metadata->ecrire($dataMetadata);
					$dataSample["sample_metadata_id"] = $sample_metadata_id;
				}
				try {
					$sample_uid = $this->sample->ecrire ( $dataSample );
					/*
					 * Traitement des identifiants complementaires
					 */
					foreach ( $this->identifiers as $idcode => $typeid ) {
						if (strlen ( $values [$idcode] ) > 0) {
							$dataCode = array (
									"object_identifier_id" => 0,
									"uid" => $sample_uid,
									"identifier_type_id" => $typeid,
									"object_identifier_value" => $values [$idcode] 
							);
							$oi->ecrire ( $dataCode );
						}
					}
					/*
					 * Mise a jour des bornes de l'uid
					 */
					if ($sample_uid < $minuid)
						$minuid = $sample_uid;
					if ($sample_uid > $maxuid)
						$maxuid = $sample_uid;
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
				$dataContainer ["object_status_id"] = $values ["container_status_id"];
				if (! $dataContainer ["object_status_id"] > 0)
					$dataContainer ["object_status_id"] = 1;
				try {
					$container_uid = $this->container->ecrire ( $dataContainer );
					/*
					 * Traitement des identifiants complementaires
					 */
					foreach ( $this->identifiers as $idcode => $typeid ) {
						if (strlen ( $values [$idcode] ) > 0) {
							$dataCode = array (
									"object_identifier_id" => 0,
									"uid" => $sample_uid,
									"identifier_type_id" => $typeid 
							);
							$oi->ecrire ( $dataCode );
						}
					}
					/*
					 * Mise a jour des bornes de l'uid
					 */
					if ($container_uid < $minuid)
						$minuid = $container_uid;
					if ($container_uid > $maxuid)
						$maxuid = $container_uid;
				} catch ( PDOException $pe ) {
					throw new ImportException ( "Line $num : error when import container<br>" . $pe->getMessage () );
				}
				/*
				 * Traitement du rattachement du container
				 */
				if (strlen ( $values ["container_parent_uid"] ) > 0) {
					try {
						$this->storage->addMovement ( $container_uid, $date, 1, $values ["container_parent_uid"], $_SESSION ["login"], $values ["container_location"] );
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
					$this->storage->addMovement ( $sample_uid, $date, 1, $container_uid, $_SESSION ["login"], $values ["sample_location"] );
				} catch ( Exception $e ) {
					throw new ImportException ( "Line $num : error when create input movement for sample (" . $e->getMessage () + ")" );
				}
			}
			if ($values ["container_parent_uid"] && $sample_uid > 0 && ! ($container_uid > 0)) {
				/*
				 * Creation du mouvement d'entree de l'echantillon dans le container
				 */
				try {
					$this->storage->addMovement ( $sample_uid, $date, 1, $values ["container_parent_uid"], $_SESSION ["login"], $values ["sample_location"] );
				} catch ( Exception $e ) {
					throw new ImportException ( "Line $num : error when create input movement for sample (" . $e->getMessage () + ")" );
				}
			}
			$this->nbTreated ++;
		}
		$this->minuid = $minuid;
		$this->maxuid = $maxuid;
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
	function initControl($project, $sample_type, $container_type, $object_status,$sampling_place) {
		$this->project = $project;
		$this->sample_type = $sample_type;
		$this->container_type = $container_type;
		$this->object_status = $object_status;
		$this->sampling_place = $sampling_place;
	}
	/**
	 * Declenche le controle pour toutes les lignes
	 *
	 * @return array[]["line"=>int, "message"=>string]
	 */
	function controlAll() {
		$num = 1;
		$retour = array ();
		$this->initIdentifiers ();
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
			/*
			 * Verification du statut
			 */
			$ok = false;
			if ($data ["sample_status_id"] > 0) {
				foreach ( $this->object_status as $value ) {
					if ($data ["sample_status_id"] == $value ["object_status_id"]) {
						$ok = true;
						break;
					}
				}
				if ($ok == false) {
					$retour ["code"] = false;
					$retour ["message"] .= "Le statut de l'échantillon n'est pas connu. ";
				}
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
				foreach ( $this->object_status as $value ) {
					if ($data ["container_status_id"] == $value ["object_status_id"]) {
						$ok = true;
						break;
					}
				}
				if ($ok == false) {
					$retour ["code"] = false;
					$retour ["message"] .= "Le statut du container n'est pas connu. ";
				}
			}
		}
		/*
		 * Verification de l'uid du container parent
		 */
		if (strlen ( $data ["container_parent_uid"] ) > 0) {
			$container_id = $this->container->getIdFromUid ( $data ["container_parent_uid"] );
			if (! $container_id > 0) {
				$retour ["code"] = false;
				$retour ["message"] .= "L'UID du conteneur parent (".$data["container_parent_uid"].") n'existe pas. ";
			}
		}
		
		/*
		 * Verification des champs numeriques
		 */
		foreach ( $this->colnum as $key ) {
			if (strlen ( $data [$key] ) > 0) {
				if (! is_numeric ( $data [$key] )) {
					$retour ["code"] = false;
					$retour ["message"] .= "Le champ $key n'est pas numérique. ";
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
	/**
	 * Initialise la liste des identifiants secondaires possibles
	 */
	function initIdentifiers() {
		if (! $this->initIdentifiers) {
			global $bdd;
			require_once 'modules/classes/identifierType.class.php';
			$it = new IdentifierType ( $bdd );
			$dit = $it->getListe ();
			/*
			 * Rajout des codes dans les colonnes autorisees
			 */
			foreach ( $dit as $value ) {
				$this->colonnes [] = $value ["identifier_type_code"];
				$this->identifiers [$value ["identifier_type_code"]] = $value ["identifier_type_id"];
			}
			$this->initIdentifiers = true;
		}
	}
}
?>