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
}

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

while ( isset ( $module ) ) {
	/*
	 * Recuperation du tableau contenant les attributs du module
	 */
	$t_module = array ();
	$t_module = $navigation->getModule ( $module );
	if (count ( $t_module ) == 0)
		$message->set ( $LANG ["message"] [35] . " ($module)" );
		/*
	 * Preparation de la vue
	 */
	$paramSend = "";
	if (! isset ( $vue ) && isset ( $t_module ["type"] )) {
		switch ($t_module ["type"]) {
			case "ajax" :
				$vue = new VueAjaxJson ();
				break;
			case "csv" :
				$vue = new VueCsv ();
				break;
			case "html" :
			default :
				$vue = new VueHtml ( $smarty );
				$paramSend = $SMARTY_principal;
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
					if (strlen ( $login ) > 0)
						$_SESSION ["login"] = $login;
				} catch ( Exception $e ) {
					$message->set ( $e->getMessage () );
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
						$res = $identification->testLoginLdap ( $_REQUEST ["login"], $_REQUEST ["password"] );
						if ($res == - 1 && $ident_type == "LDAP-BDD") {
							/*
							 * L'identification en annuaire LDAP a echoue : verification en base de donnees
							 */
							$res = $loginGestion->VerifLogin ( $_REQUEST ['login'], $_REQUEST ['password'] );
							if ($res == TRUE) {
								$_SESSION ["login"] = $_REQUEST ["login"];
							}
							/*
							 * Verification de l'identification uniquement en base de donnees
							 */
						}
					} elseif ($ident_type == "BDD") {
						$res = $loginGestion->VerifLogin ( $_REQUEST ['login'], $_REQUEST ['password'] );
						if ($res == TRUE) {
							$_SESSION ["login"] = $_REQUEST ["login"];
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
			 */
			if (isset ( $_SESSION ["login"] )) {
				/*
				 * Regeneration de l'identifiant de session
				 */
				session_regenerate_id ();
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
				include "framework/identification/setDroits.php";
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
			}
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
		$log->setLog ( $_SESSION ["login"], $moduleRequested, $motifErreur );
	} catch ( Exception $e ) {
		if ($OBJETBDD_debugmode > 0) {
			$message->set ( $log->getErrorData ( 1 ) );
		} else
			$message->set ( $LANG ["message"] [38] );
		if ($ERROR_display == 1)
			$message->set ( $e->getMessage () );
	}
	
	/*
	 * fin d'analyse du module
	 */
	if ($t_module ["type"] != "ajax")
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
					$module = $t_module ["retourko"];
					break;
				case 0 :
					$module = $t_module ["retournull"];
					break;
				case 1 :
					$module = $t_module ["retourok"];
					break;
				case 2 :
					$module = $t_module ["retoursuppr"];
					break;
				case 3 :
					$module = $t_module ["retournext"];
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
if ($t_module ["type"] == "html") {
	/*
	 * Traitement particulier de l'affichage html
	 */
	$vue->set ( $message->getAsHtml (), "message" );
	
	/*
	 * Affichage du menu
	 */
	if (! isset ( $_SESSION ["menu"] )) {
		include_once 'framework/navigation/menu.class.php';
		if (! isset ( $menu ))
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
if (isset ( $vue ))
	$vue->send ( $paramSend );
/**
 * Fin de traitement
 */

?>
