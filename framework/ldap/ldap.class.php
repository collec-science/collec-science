<?php
/**
 * @author Eric Quinton
 *
 */

/**
 *
 * @author eric.quinton
 *
 */
class Ldap {
	/**
	 * Tableau des informations retournees
	 * @var array
	 */
	var $listegroupe = array();
	/**
	 * Adresse du serveur LDAP
	 * @var string
	 */
	var $LDAP_address;
	/**
	 * Port de connexion (389|636 en general)
	 * @var int
	 */
	var $LDAP_port;
	/**
	 * Chaine complete de connexion
	 * @var string
	 */
	var $LDAP_rdn;
	/**
	 * Base de recherche
	 * @var string
	 */
	var $LDAP_basedn;
	/**
	 * Attribut ldap contenant le login
	 * @var string
	 */
	var $LDAP_user_attrib;
	/**
	 * Version de l'annuaire
	 * @var boolean
	 */
	var $LDAP_v3;
	/**
	 * Connexion cryptee
	 * @var boolean
	 */
	var $LDAP_tls;
	/**
	 * Identifiant de connexion de l'annuaire ldap
	 * @var int
	 */
	var $idldap;
	/**
	 * Message retourne en cas d'anomalie
	 * @var string
	 */
	var $message;


	/**
	 * Constructeur de la classe
	 * @param string $LDAP_address
	 * @param string $LDAP_basedn
	 * @param int $LDAP_port
	 * @param string $LDAP_user_attrib
	 * @param boolean $LDAP_v3
	 * @param boolean $LDAP_tls
	 * @return void;
	 */
	function __construct($LDAP_address, $LDAP_basedn, $LDAP_port=389,$LDAP_user_attrib="uid",$LDAP_v3=1,$LDAP_tls=0) {
		$this->LDAP_address = $LDAP_address;
		$this->LDAP_port = $LDAP_port;
		$this->LDAP_basedn = $LDAP_basedn;
		$this->LDAP_user_attrib = $LDAP_user_attrib;
		$this->LDAP_v3 = $LDAP_v3;
		$this->LDAP_tls = $LDAP_tls;
	}
	/**
	 * Fonction realisant la connexion a l'annuaire
	 * Retourne -1 en cas d'echec
	 * @return int
	 */
	function connect() {
		$this->idldap = @ldap_connect($this->LDAP_address,$this->LDAP_port) ;
		if ($this->idldap > 0) {
			if ($this->LDAP_v3 == 1) {
				ldap_set_option($this->idldap, LDAP_OPT_PROTOCOL_VERSION, 3);
			}
			if ($this->LDAP_tls == 1)
			{
				ldap_start_tls($this->idldap);
			}

		} else {
			$this->message = "Impossible de se connecter au serveur LDAP<br>";
			$this->idldap = -1;
		}
		return $this->idldap;
	}

	/**
	 * Fonction permettant de realiser le bind avec le login/passwd
	 * Permet de verifier le couple login/passwd
	 * Retourne 1 en cas de reussite
	 * @param string $login
	 * @param string $password
	 * @return int
	 */
	function login($login, $password) {
		$login = str_replace(array('\\', '*', '(', ')'), array('\5c', '\2a', '\28', '\29'), $login);
		for ($i = 0; $i<strlen($login); $i++) {
			$char = substr($login, $i, 1);
			if (ord($char)<32) {
				$hex = dechex(ord($char));
				if (strlen($hex) == 1) $hex = '0' . $hex;
				$login = str_replace($char, '\\' . $hex, $login);
			}
		}
		$this->dn = $this->LDAP_user_attrib."=".$login.",".$this->LDAP_basedn;
		$rep=ldap_bind($this->idldap,$this->dn, $password);
		if ($rep <> 1)
		{
			$this->message .= "Connexion refusee avec le login/mot de passe fournis<br>";
			$this->message .= "dn : ".$this->dn."<br>";
		}
		return $rep;
	}

	/**
	 * Fonction retournant les messages d'erreur, si existants
	 * @return string
	 */
	function getMessage() {
		return $this->message;
	}

	/**
	 * Fonction retournant un tableau contenant les attributs demandes
	 * pour une liste d'objets recherches dans l'annuaire
	 *
	 * @param string $basedn : base de recherche
	 * @param string $filtre : filtre de recherche - ex : cn=*
	 * @param array $attribut : tableau contenant en cle les attributs que l'on souhaite retourner
	 * @return array : tableau multiple (avec tableaux imbriques pour chaque attribut : [count] et [0] à [n]
	 */
	function getAttributs($basedn,$filtre,$attribut) {
		// Test si $attribut est un tableau
		$a_attribut = array();
		if (!is_array($attribut)) {
			$a_attribut= array($attribut);
		}else{
			$a_attribut = $attribut;
		}
		if (strlen($basedn) == 0 ) $basedn = $this->LDAP_basedn;
		$sr = ldap_search($this->idldap,$basedn,$filtre,$a_attribut);
		$this->listegroupe = ldap_get_entries($this->idldap, $sr);
		return $this->listegroupe;
	}


	function __destruct(){
		if ($this->idldap > 0) {
			ldap_close($this->idldap);
		}
	}
}
?>