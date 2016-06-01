<?php
/** Fichier cree le 4 mai 07 par quinton
 *
 *UTF-8
 *
 * Classe maîtrisant les aspects identification.
 */

/**
 * @class Identification
 * Gestion de l'identification - récupération du login en fonction du type d'accès
 *
 * @author Eric Quinton - eric.quinton@free.fr
 *        
 */
class Identification {
	var $ident_type = NULL;
	var $CAS_address;
	var $CAS_port;
	var $CAS_uri;
	var $LDAP_address;
	var $LDAP_port;
	var $LDAP_rdn;
	var $LDAP_basedn;
	var $LDAP_user_attrib;
	var $LDAP_v3;
	var $LDAP_tls;
	var $password;
	var $login;
	var $gacl;
	var $aco;
	var $aro;
	var $pagelogin;
	function setpageloginBDD($page) {
		$this->pagelogin = $page;
	}
	/**
	 *
	 * @param $ident_type string        	
	 */
	function setidenttype($ident_type) {
		$this->ident_type = $ident_type;
	}
	/**
	 * initialisation si utilisation d'un CAS
	 *
	 * @param $cas_address adresse
	 *        	du CAS
	 * @param $CAS_port port
	 *        	du CAS
	 * @return none
	 */
	function init_CAS($cas_address, $CAS_port, $CAS_uri) {
		$this->CAS_address = $cas_address;
		$this->CAS_port = $CAS_port;
		$this->CAS_uri = $CAS_uri;
		$this->ident_type = "CAS";
	}
	/**
	 * initialisation si utilisation d'un LDAP
	 *
	 * @param $LDAP_address adresse
	 *        	du CAS
	 * @param $LDAP_port port
	 *        	du serveur LDAP
	 * @param $LDAP_rdn chemin
	 *        	complet de recherche, incluant le login
	 * @param $login login
	 *        	qui sera retourné à l'application
	 * @param $password mot
	 *        	de passe à tester
	 * @return none
	 */
	function init_LDAP($LDAP_address, $LDAP_port, $LDAP_basedn, $LDAP_user_attrib, $LDAP_v3, $LDAP_tls) {
		$this->LDAP_address = $LDAP_address;
		$this->LDAP_port = $LDAP_port;
		$this->LDAP_basedn = $LDAP_basedn;
		$this->LDAP_user_attrib = $LDAP_user_attrib;
		$this->LDAP_v3 = $LDAP_v3;
		$this->LDAP_tls = $LDAP_tls;
		$this->ident_type = "LDAP";
	}
	
	/**
	 * Retourne le login en mode CAS ou BDD
	 *
	 * @return login ou -1 - Le login est stocké en variable de session si ok
	 */
	function getLogin() {
		$ident_type = $this->ident_type;
		if (! isset ( $ident_type )) {
			echo "Cette fonction doit être appelée après soit init_LDAP, init_CAS, ou init_BDD";
			die ();
		}
		if (! isset ( $_SESSION ["login"] )) {
			/*
			 * Récupération du login selon le type
			 */
			if ($ident_type == "BDD" || $ident_type == "LDAP-BDD") {
			} elseif ($ident_type == "CAS") {
				
				phpCAS::client ( CAS_VERSION_2_0, $this->CAS_address, $this->CAS_port, $this->CAS_uri );
				// if (phpCAS::isAuthenticated()==FALSE) {
				phpCAS::forceAuthentication ();
				// }
				global $log, $LOG_duree;
				$_SESSION ["login"] = phpCAS::getUser ();
				$log->setLog ( $_SESSION ["login"], "connexion", "cas-ok - ip:" . $_SESSION ["remoteIP"] );
				/*
				 * Purge des anciens enregistrements dans log
				 */
				$log->purge ( $LOG_duree );
			}
		}
		
		if (isset ( $_SESSION ["login"] )) {
			$this->login = $_SESSION ["login"];
			unset ( $_SESSION ["menu"] );
			return $_SESSION ["login"];
		} else {
			return - 1;
		}
	}
	/**
	 * Teste le login et le mot de passe sur un annuaire ldap
	 *
	 * @param string $login        	
	 * @param string $password        	
	 * @return string $password |int -1
	 */
	function testLoginLdap($login, $password) {
		if (strlen ( $login ) > 0 && strlen ( $password ) > 0) {
			if (! isset ( $this->ident_type )) {
				echo "Cette fonction doit être appelee apres init_LDAP";
				die ();
			}
			$login = str_replace(array('\\', '*', '(', ')'), array('\5c', '\2a', '\28', '\29'), $login);
			for ($i = 0; $i<strlen($login); $i++) {
				$char = substr($login, $i, 1);
				if (ord($char)<32) {
					$hex = dechex(ord($char));
					if (strlen($hex) == 1) $hex = '0' . $hex;
					$login = str_replace($char, '\\' . $hex, $login);
				}
			}
			$ldap = @ldap_connect ( $this->LDAP_address, $this->LDAP_port ) or die ( "Impossible de se connecter au serveur LDAP." );
			if ($this->LDAP_v3) {
				ldap_set_option ( $ldap, LDAP_OPT_PROTOCOL_VERSION, 3 );
			}
			if ($this->LDAP_tls) {
				ldap_start_tls ( $ldap );
			}
			$dn = $this->LDAP_user_attrib . "=" . $login . "," . $this->LDAP_basedn;
			$rep = ldap_bind ( $ldap, $dn, $password );
			global $log, $LOG_duree, $message, $LANG;
			if ($rep == 1) {
				$_SESSION ["login"] = $login;
				$log->setLog ( $login, "connexion", "ldap-ok - ip:" . $_SESSION ["remoteIP"] );
				$message = $LANG ["message"] [10];
				/*
				 * Purge des anciens enregistrements dans log
				 */
				$log->purge ( $LOG_duree );
				return $login;
			} else {
				$log->setLog ( $login, "connexion", "ldap-ko - ip:" . $_SESSION ["remoteIP"] );
				$message = $LANG ["message"] [11];
				return - 1;
			}
		} else
			return - 1;
	}
	
	/**
	 * Déconnexion de l'application
	 *
	 * @return 0:1
	 */
	function disconnect($adresse_retour) {
		global $message;
		$LANG;
		if (! isset ( $this->ident_type )) {
			return 0;
		}
		if ($this->ident_type == "CAS") {
			phpCAS::client ( CAS_VERSION_2_0, $this->CAS_address, $this->CAS_port, $this->CAS_uri );
			phpCAS::logout ( $adresse_retour );
		}
		// Détruit toutes les variables de session
		$_SESSION = array ();
		
		// Si vous voulez détruire complètement la session, effacez également
		// le cookie de session.
		// Note : cela détruira la session et pas seulement les données de session !
		if (isset ( $_COOKIE [session_name ()] )) {
			setcookie ( session_name (), '', time () - 42000, '/' );
		}
		$message = $LANG ["message"] [7];
		// Finalement, on détruit la session.
		session_destroy ();
		return 1;
	}
	/**
	 * Initialisation de la classe gacl
	 *
	 * @param $gacl instance
	 *        	gacl
	 * @param $aco nom
	 *        	de la catégorie de base contenant les objets à tester
	 * @param $aro nom
	 *        	de la catégorie contenant les logins à tester
	 */
	function setgacl(&$gacl, $aco, $aro) {
		$this->gacl = $gacl;
		$this->aco = $aco;
		$this->aro = $aro;
	}
	/**
	 * Teste les droits
	 *
	 * @param $aco Catégorie
	 *        	à tester
	 * @return 0 1
	 */
	function getgacl($aco) {
		$login = $this->getLogin ();
		if ($login == - 1)
			return - 1;
		return $this->gacl->acl_check ( $this->aco, $aco, $this->aro, $login );
	}
}

/**
 * Classe permettant de manipuler les logins stockés en base de données locale
 */
class LoginGestion extends ObjetBDD {
	//
	function LoginGestion($link, $param = NULL) {
		$this->paramori = $param;
		$this->param = $param;
		if (is_array ( $param ) == false)
			$param = array ();
		$this->table = "LoginGestion";
		$this->id_auto = 1;
		$this->colonnes = array (
				"id" => array (
						"type" => 1,
						"key" => 1 
				),
				"datemodif" => array (
						"type" => 2,
						"defaultValue" => "getDateJour" 
				),
				"mail" => array (
						"pattern" => "#^.+@.+\.[a-zA-Z]{2,6}$#" 
				),
				"login" => array (
						'requis' => 1 
				),
				"nom" => array ("type"=>0),
				"prenom" => array ("type"=>0),
				"actif" => array (
						'type' => 1,
						'defaultValue' => 1 
				),
				"password" => array (
						'type' => 0,
						'longueur' => 256 
				) 
		);
		$param ["fullDescription"] = 1;
		parent::__construct ( $link, $param );
	}
	/**
	 * Vérification du login en mode base de données
	 * 
	 * @param string $login        	
	 * @param string $password        	
	 * @return boolean
	 */
	function VerifLogin($login, $password) {
		if (strlen ( $login ) > 0 && strlen ( $password ) > 0) {
			$login = $this->encodeData ( $login );
			// $password = md5($password);
			$password = hash ( "sha256", $password.$login );
			$sql = "select login from LoginGestion where login ='" . $login . "' and password = '" . $password . "' and actif = 1";
			$res = ObjetBDD::lireParam ( $sql );
			global $log, $LOG_duree, $message, $LANG;
			if ($res ["login"] == $login) {
				$log->setLog ( $login, "connexion", "db-ok" );
				$message = $LANG ["message"] [10];
				/*
				 * Purge des anciens enregistrements dans log
				 */
				$log->purge ( $LOG_duree );
				return TRUE;
			} else {
				$log->setLog ( $login, "connexion", "db-ko" );
				$message = $LANG ["message"] [11];
				return FALSE;
			}
		} else
			return false;
	}
	/**
	 * Retourne la liste des logins existants, triee par nom-prenom
	 *
	 * @return array
	 */
	function getListeTriee() {
		$sql = 'select id,login,nom,prenom,mail,actif from LoginGestion order by nom,prenom, login';
		return ObjetBDD::getListeParam ( $sql );
	}
	/**
	 * Preparation de la mise en table, avec verification du motde passe
	 * (non-PHPdoc)
	 *
	 * @see ObjetBDD::ecrire()
	 */
	function ecrire($liste) {
		if (isset ( $liste ["pass1"] ) && isset ( $liste ["pass2"] ) && $liste ["pass1"] == $liste ["pass2"] && strlen ( $liste ["pass1"] ) > 3) {
			$liste ["password"] = hash ( "sha256", $liste ["pass1"].$liste["login"] );
		}
		$liste ["datemodif"] = date ( 'd-m-y' );
		return parent::ecrire ( $liste );
	}

	/**
	 * Surcharge de la fonction supprimer pour effacer les traces des anciens mots de passe
	 * {@inheritDoc}
	 * @see ObjetBDD::supprimer()
	 */
	function supprimer($id) {
		/*
		 * Suppression le cas echeant des anciens logins enregistres
		 */
		$loginOP = new LoginOldPassword($this->connection, $this->paramori);
		$loginOP->supprimerChamp($id, "id");
		return parent::supprimer($id);
	}
	/**
	 * Fonction de validation de changement du mot de passe
	 *
	 * @param string $oldpassword        	
	 * @param string $pass1        	
	 * @param string $pass2        	
	 * @return number
	 */
	function changePassword($oldpassword, $pass1, $pass2) {
		$retour = 0;
		if (isset ( $_SESSION ["login"] )) {
			global $LANG;
			$oldData = $this->lireByLogin ( $_SESSION ["login"] );
			if ($oldData ["id"] > 0) {
				$oldpassword_hash = hash ( "sha256", $oldpassword.$_SESSION["login"] );
				if ($oldpassword_hash == $oldData ["password"]) {
					
					$data = $oldData;
					/*
					 * Verification que le mot de passe soit identique
					 */
					if ($pass1 == $pass2) {
						/*
						 * Verification de la longueur - minimum : 8 caracteres
						 */
						if (strlen ( $pass1 ) > 7) {
							/*
							 * Verification de la complexite du mot de passe
							 */
							if ($this->controleComplexite ( $pass1 ) >= 3) {
								/*
								 * calcul du sha256 du mot de passe
								 */
								$password_hash = hash ( "sha256", $pass1.$_SESSION["login"] );
								/*
								 * Verification que le mot de passe n'a pas deja ete employe
								 */
								$loginOldPassword = new LoginOldPassword ( $this->connection, $this->paramori );
								$nb = $loginOldPassword->testPassword ( $_SESSION ["login"], $password_hash );
								if ($nb == 0) {
									/*
									 * Lecture de l'ancien enregistrement
									 */
									$oldData = $this->lireByLogin ( $_SESSION ["login"] );
									if ($oldData ["id"] > 0) {
										$data = $oldData;
										$data ["password"] = $password_hash;
										$data ["datemodif"] = date ( 'd-m-y' );
										if ($this->ecrire ( $data ) > 0) {
											$retour = 1;
											global $log;
											$log->setLog ( $login, "password_change", "ip:" . $_SESSION ["remoteIP"] );
											/*
											 * Ecriture de l'ancien mot de passe dans la table des anciens mots de passe
											 */
											$loginOldPassword->setPassword ( $oldData ["id"], $oldData ["password"] );
										}
										$message = $LANG ["login"] [20];
									}
								} else {
									$message = $LANG ["login"] [14];
								}
							} else {
								$message = $LANG ["login"] [15];
							}
						} else {
							$message = $LANG ["login"] [16];
						}
					} else {
						$message = $LANG ["login"] [17];
					}
				} else {
					$message = $LANG ["login"] [19];
				}
			} else {
				$message = $LANG ["login"] [18];
			}
		}
		$this->errorData [] = array (
				"code" => 0,
				"message" => $message 
		);
		return $retour;
	}
	/**
	 * Fonction verifiant la complexite d'un mot de passe
	 * Retourne le nombre de jeux de caracteres differents utilises
	 *
	 * @param string $password        	
	 * @return number
	 */
	function controleComplexite($password) {
		$long = strlen ( $password );
		$type = array (
				"min" => 0,
				"maj" => 0,
				"chiffre" => 0,
				"other" => 0 
		);
		for($i = 0; $i < $long; $i ++) {
			$car = substr ( $password, $i, 1 );
			if ($type ["min"] == 0)
				$type ["min"] = preg_match ( "/[a-z]/", $car );
			if ($type ["maj"] == 0)
				$type ["maj"] = preg_match ( "/[A-Z]/", $car );
			if ($type ["chiffre"] == 0)
				$type ["chiffre"] = preg_match ( "/[0-9]/", $car );
			if ($type ["other"] == 0)
				$type ["other"] = preg_match ( "/[^0-9a-zA-Z]/", $car );
		}
		$complexite = $type ["min"] + $type ["maj"] + $type ["chiffre"] + $type ["other"];
		return $complexite;
	}
	/**
	 * Retourne un enregistrement a partir du login
	 *
	 * @param string $login        	
	 * @return array
	 */
	function lireByLogin($login) {
		$login = $this->encodeData ( $login );
		$sql = "select * from " . $this->table . "
				where login = '" . $login . "'";
		return $this->lireParam ( $sql );
	}
}

/**
 * Classe permettant d'enregistrer toutes les operations effectuees dans la base
 *
 * @author quinton
 *        
 */
class Log extends ObjetBDD {
	/**
	 * Constructeur
	 *
	 * @param connecteur $p_connection        	
	 * @param array $param        	
	 */
	function __construct($bdd, $param = NULL) {
		$this->param = $param;
		$this->table = "log";
		$this->id_auto = "1";
		$this->colonnes = array (
				"log_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"login" => array (
						"type" => 0,
						"requis" => 0 
				),
				"nom_module" => array (
						"type" => 0 
				),
				"log_date" => array (
						"type" => 3,
						"requis" => 1 
				),
				"commentaire" => array (
						"type" => 0 
				),
				"ipaddress" => array (
						"type" => 0
				)
		);
		if (! is_array ( $param ))
			$param == array ();
		$param ["fullDescription"] = 1;
		parent::__construct ( $bdd, $param );
	}
	/**
	 * Fonction enregistrant un evenement dans la table
	 *
	 * @param string $module        	
	 * @param string $comment        	
	 * @return integer
	 */
	function setLog($login, $module, $commentaire = NULL) {
		global $GACL_aco;
		$data = array (
				"log_id" => 0,
				"commentaire" => $commentaire 
		);
		if (is_null ( $login )) {
			if (! is_null ( $_SESSION ["login"] ))
				$login = $_SESSION ["login"];
			else
				$login = "unknown";
		}
		$data ["login"] = $login;
		if (is_null ( $module ))
			$module = "unknown";
		$data ["nom_module"] = $GACL_aco."-".$module;
		$data ["log_date"] = date ( "d/m/Y H:i:s" );
		$data ["ipaddress"] = $this->getIPClientAddress();
		return $this->ecrire ( $data );
	}
	/**
	 * Fonction de purge du fichier de traces
	 *
	 * @param int $nbJours
	 *        	: nombre de jours de conservation
	 * @return int
	 */
	function purge($nbJours) {
		if ($nbJours > 0) {
			$sql = "delete from " . $this->table . " 
					where log_date < current_date - interval '" . $nbJours . " day'";
			return $this->executeSQL ( $sql );
		}
	}
	/**
	 * Recupere l'adresse IP de l'agent
	 */
	function getIPClientAddress(){
		/*
		 * Recherche si le serveur est accessible derriere un reverse-proxy
		 */
		if (isset($_SERVER["HTTP_X_FORWARDED_FOR"])){
			return  $_SERVER["HTTP_X_FORWARDED_FOR"];
			/*
			 * Cas classique
			 */
		}else if (isset ($_SERVER["REMOTE_ADDR"])) {
			return $_SERVER["REMOTE_ADDR"];
		} else
			return -1;
	}
}
/**
 * Classe de gestion de l'enregistrement des anciens mots de passe
 *
 * @author quinton
 *        
 */
class LoginOldPassword extends ObjetBDD {
	/**
	 * Constructeur
	 *
	 * @param connexion $bdd        	
	 * @param array $ObjetBDDParam        	
	 */
	function __construct($bdd, $ObjetBDDParam) {
		$this->param = $param;
		$this->table = "login_oldpassword";
		$this->id_auto = "1";
		$this->colonnes = array (
				"login_oldpassword_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"id" => array (
						"type" => 1,
						"requis" => 1,
						"parentAttrib" => 1 
				),
				"password" => array (
						"type" => 0 
				) 
		);
		
		if (! is_array ( $param ))
			$param == array ();
		$param ["fullDescription"] = 1;
		parent::__construct ( $bdd, $param );
	}
	/**
	 * Fonction retournant le nombre de mots de passe deja utilises pour le hash fourni
	 *
	 * @param string $login        	
	 * @param string $password_hash        	
	 * @return number
	 */
	function testPassword($login, $password_hash) {
		$login = $this->encodeData ( $login );
		$sql = 'select count(o.login_oldpassword_id) as "nb" 
				from ' . $this->table . " o 
				join logingestion on logingestion.id = o.id
				where login = '" . $login . "'
					and o.password = '" . $password_hash . "'";
		$res = $this->lireParam ( $sql );
		return $res ["nb"];
	}
	/**
	 * Enregistre un mot de passe dans la base des anciens mots de passe utilises
	 *
	 * @param int $id        	
	 * @param string $password_hash        	
	 * @return int
	 */
	function setPassword($id, $password_hash) {
		if ($id > 0) {
			$data = array (
					"id" => $id,
					"password" => $password_hash 
			);
			return $this->ecrire ( $data );
		}
	}
}
?>