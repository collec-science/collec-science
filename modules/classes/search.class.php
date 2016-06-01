<?php
/**
 * Classe de base pour gerer des parametres de recherche
 * Classe non instanciable, a heriter
 * L'instance doit etre conservee en variable de session
 * @author Eric Quinton
 *
 */
class SearchParam {
	/**
	 * Tableau des parametres geres par la classe
	 * La liste des parametres doit etre declaree dans la fonction construct
	 *
	 * @var array
	 */
	public $param;
	public $paramNum;
	/**
	 * Indique si la lecture des parametres a ete realisee au moins une fois
	 * Permet ainsi de declencher ou non la recherche
	 *
	 * @var int
	 */
	public $isSearch;
	/**
	 * Constructeur de la classe
	 * A rappeler systematiquement pour initialiser isSearch
	 */
	function __construct() {
		if (! is_array ( $this->param ))
			$this->param = array ();
		$this->isSearch = 0;
		$this->param ["isSearch"] = 0;
		if (is_array ( $this->paramNum ))
			$this->paramNum = array_flip ( $this->paramNum );
	}
	/**
	 * Stocke les parametres fournis
	 *
	 * @param array $data
	 *        	: tableau des valeurs, ou non de la variable
	 * @param string $valeur
	 *        	: valeur a renseigner, dans le cas ou la donnee est unique
	 */
	function setParam($data, $valeur = NULL) {
		if (is_array ( $data )) {
			/*
			 * Les donnees sont fournies sous forme de tableau
			 */
			foreach ( $this->param as $key => $value ) {
				/*
				 * Recherche si une valeur de $data correspond a un parametre
				 */
				if (isset ( $data [$key] )) {
					/*
					 * Recherche si la valeur doit etre numerique
					 */
					if (isset ( $this->paramNum [$key] )) {
						if (! is_numeric ( $data [$key] ))
							$data [$key] = "";
					}
					$this->param [$key] = $data [$key];
				}
			}
		} else {
			/*
			 * Une donnee unique est fournie
			 */
			if (isset ( $this->param [$data] ) && ! is_null ( $valeur )) {
				if (isset ( $this->paramNum [$data] )) {
					if (! is_numeric ( $valeur ))
						$valeur = "";
				}
				$this->param [$data] = $valeur;
			}
		}
		/*
		 * Gestion de l'indicateur de recherche
		 */
		if ($data ["isSearch"] == 1)
			$this->isSearch = 1;
	}
	/**
	 * Retourne les parametres existants
	 */
	function getParam() {
		// return $this->encodeData($this->param);
		return $this->param;
	}
	/**
	 * Indique si la recherche a ete deja lancee
	 *
	 * @return int
	 */
	function isSearch() {
		if ($this->isSearch == 1) {
			return 1;
		} else {
			return 0;
		}
	}
	
	/**
	 * Encode les donnees avant de les envoyer au navigateur
	 *
	 * @param unknown $data        	
	 * @return string|array
	 */
	function encodeData($data) {
		if (is_array ( $data )) {
			foreach ( $data as $key => $value ) {
				$data [$key] = $this->encodeData ( $value );
			}
		} else {
			$data = htmlspecialchars ( $data );
		}
		return $data;
	}
}
/**
 * Exemple d'instanciation
 * 
 * @author Eric Quinton
 *        
 */
class SearchExample extends SearchParam {
	function __construct() {
		$this->param = array (
				"comment" => "",
				"numero" => 0,
				"numero1" => "",
				"dateExample" => date ( 'd/m/Y' ) 
		);
		$this->paramNum = array (
				"numero",
				"numero1" 
		);
		parent::__construct ();
	}
}

?>