<?php
/**
 * Created : 17 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/sample.class.php';
require_once 'modules/classes/container.class.php';
/**
 * Classes d'exception
 * 
 * @author quinton
 *        
 */
class FileException extends Exception {
}
class HeaderException extends Exception {
}
class ImportException extends Exception {
	
}

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
	
	/**
	 * Initialise la lecture du fichier, et lit la ligne d'entete
	 * 
	 * @param string $filename        	
	 * @param string $separator        	
	 * @param string $utf8_encode        	
	 * @throws HeaderException
	 * @throws FileException
	 */
	function init($filename, $separator = ",", $utf8_encode = false) {
		$this->separator = $separator;
		$this->utf8_encode = $utf8_encode;
		/*
		 * Ouverture du fichier
		 */
		try {
			$this->handle = fopen ( $filename, 'r' );
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
		} catch ( Exception $e ) {
			throw new FileException ( "$filename not found or not readable" );
		}
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
	 * @param Sample $sample
	 * @param Container $container
	 * @param Storage $storage
	 * @throws ImportException
	 */
	function importAll(Sample $sample, Container $container, Storage $storage) {
		$date = new Date('d/m/Y H:i:s');
		
		while ( ($data = $this->readLine ()) !== false ) {
			/*
			 * Preparation du tableau
			 */
			$nb = count ( $data );
			for($i = 0; $i < $nb; $i ++)
				$values [$this->fileColumn [$i]] = $data [$i];
			$num = $this->nbTreated + 1;
			/*
			 * Traitement de l'echantillon
			 */
			$sample_uid = 0;
			if (strlen($values["sample_identifier"]) > 0) {
				$dataSample = $values;
				$dataSample["identifier"] = $values["sample_identifier"];
				$sample_uid = $sample->ecrire($dataSample);
				if ( ! $sample_uid > 0) 				
					throw new ImportException("Line $num : error when import sample");
			}
			/*
			 * Traitement du conteneur
			 */
			$container_uid = 0;
			if (strlen($values["container_identifier"]) > 0) {
				$dataContainer = $values;
				$dataContainer["identifier"] = $values["container_identifier"];
				$container_uid = $container->ecrire($dataContainer);
				if ( ! $container_uid > 0)
					throw new ImportException("Line $num : error when import container");
				/*
				 * Traitement du rattachement du container
				 */
					if (strlen($values["container_parent_uid"])>0) {
						try {
							$storage->addMovement($container_uid, $date, 1, $values["container_parent_uid"], $_SESSION["login"], $values["container_range"]);
						} catch (Exception $e) {
							throw new ImportException("Line $num : error when create input movement for container (".$e->getMessage()+")");
						}
					}
					
			}
			/*
			 * Traitement de l'entree de l'echantillon dans le container
			 */
			if ($sample_uid > 0 && $container_uid > 0) {
				try {
					$storage->addMovement($sample_uid, $date, 1, $container_uid, $_SESSION["login"], $values["sample_range"]);
				} catch (Exception $e) {
					throw new ImportException("Line $num : error when create input movement for sample (".$e->getMessage()+")");
				}
			}
			$this->nbTreated ++;
		}
	}
}
?>