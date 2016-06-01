<?php
/**
 * Classe permettant de parametrer les imports
 * @author quinton
 *
 */
class Import {
	public $nomFichierDesc ;
	public $contenuFichier;
	public $descriptionImport;
	public $handle;
	public $separateur;
	public $ligneDebut;
	public $typeFichier;
	public $spreadsheet;
	public $utf8encode;
	/*
	 * Variables utilisees pour l'export CSV
	*/
	public $fichierExport;
	public $nomFichierExport;
	public $separateurExport;
	/*
	 * Variables utilisees pour le traitement d'un fichier XLS
	*/
	public $nbRows;
	public $nbCols;
	public $currentRow;

	/**
	 * Lecture des parametres d'import
	 * @param string $nomFichierDesc
	 */
	function __construct($nomFichierDesc,$nomImport) {
		$this->nomFichierDesc = $nomFichierDesc;
		$this->ligneDebut = 1;
		$this->contenuFichier = parse_ini_file($this->nomFichierDesc,true);
		$this->descriptionImport = $this->contenuFichier[$nomImport];

		if (isset($this->descriptionImport["ligneDebut"])) {
			$this->ligneDebut=$this->descriptionImport["ligneDebut"];
			unset ($this->descriptionImport["ligneDebut"]);
		}
		if (isset($this->descriptionImport["separateur"])) {
			$this->separateur=$this->descriptionImport["separateur"];
			unset ($this->descriptionImport["separateur"]);
		}
		if (isset($this->descriptionImport["typeFichier"])) {
			$this->typeFichier = $this->descriptionImport["typeFichier"];
			unset ($this->descriptionImport["typeFichier"]);
		}
		if (isset($this->descriptionImport["utf8encode"])) {
			$this->utf8encode = $this->descriptionImport["utf8encode"];
			unset ($this->descriptionImport["utf8encode"]);
		}
		
		/*
		 * Gestion de la classe de manipulation XLS
		*/
		if ($this->typeFichier == "xls") {
			if (class_exists("Spreadsheet_Excel_Reader")) {
				$this->spreadsheet = new Spreadsheet_Excel_Reader();
			}else{
				echo "La classe Spreadsheet_Excel_Reader n'est pas decrite - arret de l'application";
				die;
			}
		}
	}
	/**
	 * Retourne le contenu des champs decrits dans le fichier
	 * @param string $nomImport
	 * @return array
	 */
	function getListeColonne() {
		return $this->descriptionImport;
	}
	/**
	 * Ouvre le fichier specifie
	 * @param array $nomFichier
	 * @param string $separateur
	 */
	function ouvrirFichier($nomFichier,$separateur="") {
		if ($this->typeFichier == "csv") {
			/*
			 * Reformatage du separateur, le cas echeant
			*/
			if (strlen($separateur)==0) {
				/*
				 * Recherche du separateur defini dans le fichier de parametres
			 */
				if (strlen($this->separateur)>0) {
					$separateur = $this->separateur;
				} else {
					$separateur = ",";
				}
			}

			if ($separateur == "tab")  {
				$separateur = "\t";
			}elseif ($separateur == "virgule") {
				$separateur = ",";
			}elseif ($separateur == "point") {
				$separateur = ".";
			}
			$this->separateur = $separateur;
			$this->handle = fopen($nomFichier,'r');
			$this->currentRow = 1;
			if ($this->handle) return true ; else return false;
		}elseif ($this->typeFichier=="xls") {
			$this->spreadsheet->read($nomFichier,'r');
			$this->nbCols = $this->spreadsheet->sheets[0]['numCols'];
			$this->nbRows = $this->spreadsheet->sheets[0]['numRows'];
			$this->currentRow = $this->ligneDebut;
			if ($this->nbRows > 0) return true ; else return false;
		}

	}
	/**
	 * Ferme le fichier
	 */
	function fermerFichier() {
		if ($this->handle) {
			fclose($this->handle);
		}
	}

	/**
	 * Retourne la premiere ligne a partir de laquelle le traitement doit etre realise
	 * @return int
	 */
	function getLigneDebut() {
		return $this->ligneDebut;
	}

	/**
	 * Retourne le contenu de la ligne courante
	 * @return Ambigous <array, boolean>
	 */
	function getLigneCourante() {
		if ($this->typeFichier == "csv") {
			$data = $this->getDataCsv();
		} elseif ($this->typeFichier == "xls") {
			$data = $this->getDataXls();
		}
		if ($this->utf8encode == 1) {
			/*
			 * Encodage en utf8 des donnees textes
			 */
			foreach ($data as $key => $value) {
				if (is_string ($value)) $data[$key] = utf8_encode($value);
			}
		}
		return $data;
	}

	/**
	 * Retourne le contenu de la ligne courante, dans le cas d'un fichier xls
	 * @return array, boolean
	 */
	function getDataXls() {
		if ($this->currentRow < $this->nbRows) {
			$data = array();
			for ($i=0;$i<=$this->nbCols;$i++) {
				$data[$i] = $this->spreadsheet->sheets[0]['cells'][$this->currentRow][$i+1];
			}
			$this->currentRow ++;
			return $data;
		}else{
			return false;
		}

	}
	/**
	 * Recupere les donnees au format CSV pour l'enregistrement courant
	 */
	function getDataCsv() {
		if ($this->handle) {
			/*
			 * Lecture "a vide" des premieres lignes du fichier
			*/
			$j = $this->currentRow;
			for ($i = $j;$i < $this->ligneDebut;$i++) {
				$data = fgetcsv($this->handle,1000,$this->separateur);
				$this->currentRow ++;
			}
			
			/*
			 * Lecture de la ligne a importer
			*/
			$data = fgetcsv($this->handle,1000,$this->separateur);
			$this->currentRow ++;
			return $data;
		}
	}
	/**
	 * Initialise l'export CSV
	 * @param string $nomFichierExport
	 * @param string $separateur
	 */
	function exportCSVinit($nomFichierExport,$separateur=",") {
		$this->nomFichierExport=$nomFichierExport."-".date('d-m-Y').".csv";
		if ($separateur == "tab") $separateur = "\t";
		$this->separateurExport = $separateur;
	}
	/**
	 * Ecrit une ligne dans le fichier CSV
	 * @param array $data
	 */
	function setLigneCSV ($tableau) {
		foreach ($tableau as $cle=>$data) {
			if (strlen($this->fichierExport)>0)
				$this->fichierExport .= "\n";
			$nbItem = count ($data);
			$compteur = 1;
			foreach ($data as $key=>$value) {
				$this->fichierExport .= $value;
				if ($compteur < $nbItem) $this->fichierExport .= $this->separateurExport;
				$compteur ++;
			}
		}
	}
	/**
	 * Declenche l'envoi du fichier CSV au navigateur
	 */
	function exportCSV() {
		header("content-type: text/csv");
		header('Content-Disposition: attachment; filename="'.$this->nomFichierExport.'"');
		header('Pragma: no-cache');
		header('Cache-Control:must-revalidate, post-check=0, pre-check=0');
		header('Expires: 0');
		echo $this->fichierExport;
	}
}
?>