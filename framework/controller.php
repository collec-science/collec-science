<?php
/**
 * Controleur de l'application (modele MVC)
 * Fichier modifie le 21 mars 2013 par Eric Quinton
 *
 */
/**
 * Lecture des parametres
 */
include_once ("framework/common.inc.php");
/**
 * Verification des donnees entrantes.
 * Codage UTF-8
 */
if (check_encoding ( $_REQUEST ) == false) {
	$message->set ( "Problème dans les données fournies : l'encodage des caractères n'est pas celui attendu" );
	$_REQUEST ["module"] = "default";
	unset ( $_REQUEST ["moduleBase"] );
	unset ( $_REQUEST ["action"] );
}
/**
 * Decodage des variables html
 */
$_REQUEST = htmlDecode ( $_REQUEST );
/**
 * Recuperation du module
 */
unset ( $module );

/**
 * Generation du module a partir de moduleBase et action
 */
if (isset ( $_REQUEST ["moduleBase"] ) && isset ( $_REQUEST ["action"] ))
	$_REQUEST ["module"] = $_REQUEST ["moduleBase"] . $_REQUEST ["action"];
if (isset ( $_REQUEST ["module"] ) && strlen ( $_REQUEST ["module"] ) > 0) {
	$module = $_REQUEST ["module"];
} else {
	/*
	 * Definition du module par defaut
	 */
	$module = "default";
}
$moduleRequested = $module;
/**
 * Gestion des modules
 */
$isHtml = false;
$isAjax = false;
if ($APPLI_modeDeveloppement)
	unset ( $_SESSION ["menu"] );
while ( isset ( $module ) ) {
	/*
	 * Recuperation du tableau contenant les attributs du module
	 */
	$t_module = $navigation->getModule ( $module );
	if (count ( $t_module ) == 0)
		$message->set ( $LANG ["message"] [35] . " ($module)" );
		/*
	 * Forcage de l'identification si identification en mode HEADER
	 */
	if ($ident_type == "HEADER")
		$t_module ["loginrequis"] = 1;
		/*
	 * Preparation de la vue
	 */
	if (! isset ( $vue ) && isset ( $t_module ["type"] )) {
		switch ($t_module ["type"]) {
			case "ajax" :
				$vue = new VueAjaxJson ();
				$isAjax = true;
				break;
			case "csv" :
				$vue = new VueCsv ();
				$isAjax = true;
				break;
			case "pdf" :
				$vue = new VuePdf ();
				$isAjax = true;
				break;
			case "binaire" :
				$vue = new vueBinaire ();
				$isAjax = true;
				break;
			case "smarty" :
			case "html" :
			default :
				$isHtml = true;
				$vue = new VueSmarty ( $SMARTY_param, $SMARTY_variables );
		}
	}
	
	/*
	 * Verification si le login est requis
	 */
	if (strlen ( $t_module ["droits"] ) > 1 || $t_module ["loginrequis"] == 1 || isset ( $_REQUEST ["login"] )) {
		/*
		 * Verification du login
		 */
		if (! isset ( $_SESSION ["login"] )) {
			/*
			 * Un cookie d'identification est-il fourni ?
			 */
			if (isset ( $_COOKIE ["tokenIdentity"] )) {
				require_once 'framework/identification/token.class.php';
				$tokenClass = new Token ();
				try {
					$login = $tokenClass->openTokenFromJson ( $_COOKIE ["tokenIdentity"] );
					if (strlen ( $login ) > 0) {
						$_SESSION ["login"] = $login;
						$log->setLog ( $login, $module . "-connexion", "token-ok" );
					}
				} catch ( Exception $e ) {
					$log->setLog ( $login, $module . "-connexion", "token-ko" );
					$message->set ( $e->getMessage () );
				}
			} elseif ($ident_type == "HEADER") {
				/*
				 * Identification via les headers fournis par le serveur web
				 * dans le cas d'une identification derriere un proxy comme LemonLdap
				 */
				$headers = getHeaders ();
				$login = $headers [strtoupper ( $ident_header_login_var )];
				if (strlen ( $login ) > 0) {
					$_SESSION ["login"] = $login;
					$log->setLog ( $login, "connexion", "HEADER-ok" );
				}
			} elseif ($ident_type == "CAS") {
				/*
				 * Verification du login aupres du serveur CAS
				 */
				$identification->getLogin ();
			} else {
				/*
				 * On verifie si on est en retour de validation du login
				 */
				if (isset ( $_REQUEST ["login"] )) {
					$loginGestion = new LoginGestion ( $bdd_gacl );
					/*
					 * Verification de l'identification aupres du serveur LDAP, ou LDAP puis BDD
					 */
					if ($ident_type == "LDAP" || $ident_type == "LDAP-BDD") {
						try {
							$res = $identification->testLoginLdap ( $_REQUEST ["login"], $_REQUEST ["password"] );
							if ($res == - 1 && $ident_type == "LDAP-BDD") {
								/*
								 * L'identification en annuaire LDAP a echoue : verification en base de donnees
								 */
								$res = $loginGestion->controlLogin ( $_REQUEST ['login'], $_REQUEST ['password'] );
								if ($res) {
									$_SESSION ["login"] = $_REQUEST ["login"];
								}
							}
						} catch ( Exception $e ) {
							$message->setSyslog ( $e->getMessage () );
						}
						/*
						 * Verification de l'identification uniquement en base de donnees
						 */
					} elseif ($ident_type == "BDD") {
						try {
							$res = $loginGestion->controlLogin ( $_REQUEST ['login'], $_REQUEST ['password'] );
							if ($res) {
								$_SESSION ["login"] = $_REQUEST ["login"];
							}
						} catch ( Exception $e ) {
							$message->setSyslog ( $e->getMessage () );
						}
					}
				} else {
					/*
					 * Gestion de la saisie du login
					 */
					$vue->set ( "ident/login.tpl", "corps" );
					$vue->set ( $tokenIdentityValidity, "tokenIdentityValidity" );
					if ($t_module ["retourlogin"] == 1)
						$vue->set ( $_REQUEST ["module"], "module" );
					$message->set ( $LANG ["login"] [2] );
				}
			}
			/*
			 * Si le login a ete valide, on definit les droits
			 * $_SESSION["login"] est maintenant defini
			 */
			if (isset ( $_SESSION ["login"] )) {
				/*
				 * Regeneration de l'identifiant de session
				 */
				session_regenerate_id ();
				/*
				 * Recuperation de la derniere connexion et affichage a l'ecran
				 */
				$lastConnect = $log->getLastConnexion ();
				if (isset ( $lastConnect ["log_date"] )) {
					$texte = $LANG ["login"] [48];
					$texte = str_replace ( ":datelog", $lastConnect ["log_date"], $texte );
					$texte = str_replace ( ":iplog", $lastConnect ["ipaddress"], $texte );
					$message->set ( $texte );
				}
				$message->setSyslog ( "connexion ok for " . $_SESSION ["login"] . " from " . getIPClientAddress () );
				/*
				 * Reinitialisation du menu
				 */
				unset ( $_SESSION ["menu"] );
				/*
				 * Recuperation des cookies le cas echeant
				 */
				include 'modules/cookies.inc.php';
				/*
				 * Calcul des droits
				 */
				require_once 'framework/droits/droits.class.php';
				$acllogin = new Acllogin ( $bdd_gacl, $ObjetBDDParam );
				try {
					$_SESSION ["droits"] = $acllogin->getListDroits ( $_SESSION ["login"], $GACL_aco, $LDAP );
				} catch ( Exception $e ) {
					if ($APPLI_modeDeveloppement) {
						$message->set ( $e->getMessage () );
					} else
						$message->setSyslog ( $e->getMessage () );
				}
				
				/*
				 * Integration des commandes post login
				 */
				include "modules/postLogin.php";
				/*
				 * Gestion de l'identification par token
				 */
				if ($_REQUEST ["loginByTokenRequested"] == 1) {
					require_once 'framework/identification/token.class.php';
					$tokenClass = new Token ( $privateKey, $pubKey );
					try {
						$token = $tokenClass->createToken ( $_SESSION ["login"], $tokenIdentityValidity );
						/*
						 * Ecriture du cookie
						 */
						$cookieParam = session_get_cookie_params ();
						$cookieParam ["lifetime"] = $tokenIdentityValidity;
						if ($APPLI_modeDeveloppement == false)
							$cookieParam ["secure"] = true;
						$cookieParam ["httponly"] = true;
						setcookie ( 'tokenIdentity', $token, time () + $tokenIdentityValidity, $cookieParam ["path"], $cookieParam ["domain"], $cookieParam ["secure"], $cookieParam ["httponly"] );
					} catch ( Exception $e ) {
						$message->set ( $e->getMessage () );
					}
				}
			} else
				$message->setSyslog ( "connexion ko from " . getIPClientAddress () );
		}
	}
	$resident = 1;
	$motifErreur = "ok";
	if ($t_module ["loginrequis"] == 1 && ! isset ( $_SESSION ["login"] ))
		$resident = 0;
		/*
	 * Verification des droits
	 */
	if (strlen ( $t_module ["droits"] ) > 1) {
		if (! isset ( $_SESSION ["login"] )) {
			$resident = 0;
			$motifErreur = "nologin";
		} else {
			$droits_array = explode ( ",", $t_module ["droits"] );
			$resident = 0;
			foreach ( $droits_array as $key => $value ) {
				if ($_SESSION ["droits"] [$value] == 1)
					$resident = 1;
			}
			if ($resident == 0)
				$motifErreur = "droitko";
		}
	}
	
	/*
	 * Verification que le module soit bien appele apres le module qui doit le preceder La recherche peut contenir plusieurs noms de modules, separes par le caractere |
	 */
	if (strlen ( $t_module ["modulebefore"] ) > 0) {
		$before = explode ( ",", $t_module ["modulebefore"] );
		$beforeok = false;
		foreach ( $before as $key => $value ) {
			if ($_SESSION ["moduleBefore"] == $value)
				$beforeok = true;
		}
		if ($beforeok == false) {
			$resident = 0;
			if ($APPLI_modeDeveloppement == true)
				$message->set ( "Module precedent enregistre : " . $_SESSION ["moduleBefore"] );
			$motifErreur = "errorbefore";
		}
	}
	/*
	 * Enregistrement de l'acces au module
	 */
	try {
		$log->setLog ( $_SESSION ["login"], $module, $motifErreur );
	} catch ( Exception $e ) {
		if ($OBJETBDD_debugmode > 0) {
			$message->set ( $log->getErrorData ( 1 ) );
		} else
			$message->set ( $LANG ["message"] [38] );
		$message->setSyslog ( $e->getMessage () );
	}
	/*
	 * fin d'analyse du module
	 */
	if (! $isAjax)
		$_SESSION ["moduleBefore"] = $module;
	unset ( $module_coderetour );
	
	/*
	 * Execution du module
	 */
	if ($resident == 1) {
		include $t_module ["action"];
		unset ( $module );
		/*
		 * Recuperation du code de retour et affectation du nom du nouveau module
		 */
		if (isset ( $module_coderetour )) {
			switch ($module_coderetour) {
				case - 1 :
					unset ( $vue );
					$module = $t_module ["retourko"];
					break;
				case 0 :
				case 1 :
				case 2 :
				case 3 :
					$module = $t_module ["retourok"];
					break;
			}
		}
	} else {
		/*
		 * Traitement des erreurs
		 */
		switch ($motifErreur) {
			case "droitko" :
				if (strlen ( $t_module ["droitko"] ) > 1) {
					$module = $t_module ["droitko"];
				} else {
					$module = $APPLI_moduleDroitKO;
				}
				break;
			case "nologin" :
				$module = $APPLI_moduleErrorLogin;
				break;
			case "errorbefore" :
				$module = $APPLI_moduleErrorBefore;
				break;
			default :
				unset ( $module );
		}
	}
}
/*
 * Traitement de l'affichage vers le navigateur
 */
if ($isHtml) {
	/*
	 * Affichage du menu
	 */
	if (! isset ( $_SESSION ["menu"] )) {
		include_once 'framework/navigation/menu.class.php';
		$menu = new Menu ( $APPLI_menufile, $LANG );
		$_SESSION ["menu"] = $menu->generateMenu ();
	}
	
	$vue->set ( $_SESSION ["menu"], "menu" );
	if (isset ( $_SESSION ["login"] ))
		$vue->set ( 1, "isConnected" );
		/*
	 * Affichage de la page
	 */
		/*
	 * Alerte Mode developpement
	 */
	if ($APPLI_modeDeveloppement == true) {
		$texteDeveloppement = $LANG ["message"] [32] . " : " . $BDD_dsn . ' - schema : ' . $BDD_schema;
		$vue->set ( $texteDeveloppement, "developpementMode" );
	}
	$vue->set ( $_SESSION ["moduleListe"], "moduleListe" );
	/*
	 * execution du code generique avant affichage
	 */
	include 'modules/beforeDisplay.php';
	
	/*
	 * Envoi des droits
	 */
	$vue->set ( $_SESSION ["droits"], "droits" );
}
/**
 * Declenchement de l'envoi vers le navigateur
 */
if (isset ( $vue )) {
	try {
		$vue->send ( $paramSend );
	} catch ( Exception $e ) {
		$message->setSyslog ( $e->getMessage () );
	}
}
/**
 * Generation des messages d'erreur pour Syslog
 */
$message->sendSyslog ();
/**
 * Fin de traitement
 */

?>
