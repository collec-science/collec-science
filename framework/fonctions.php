<?php
/**
 * Ensemble de fonctions utilisees pour la gestion des fiches
 */

/**
 * Lit un enregistrement dans la base de donnees, affecte le tableau a Smarty,
 * et declenche l'affichage de la page associee
 *
 * @param instance $dataClass        	
 * @param int $id        	
 * @param string $smartyPage        	
 * @param int $idParent        	
 * @return array
 */
function dataRead($dataClass, $id, $smartyPage, $idParent = null) {
	global $vue, $OBJETBDD_debugmode, $message;
	if (isset ( $vue )) {
		if (is_numeric ( $id )) {
			
			try {
				$data = $dataClass->lire ( $id, true, $idParent );
			} catch ( Exception $e ) {
				if ($OBJETBDD_debugmode > 0) {
					$message->set ( $dataClass->getErrorData ( 1 ) );
				} else {
					$message->set ( $LANG ["message"] [37] );
				}
				$message->setSyslog ( $e->getMessage () );
			}
		}
		/*
		 * Affectation des donnees a smarty
		 */
		$vue->set ( $data, "data" );
		$vue->set ( $smartyPage, "corps" );
		return $data;
	} else {
		global $module;
		$message->set ( "Error : vue type not defined for the requested module ($module)" );
	}
}
/**
 * Ecrit un enregistrement en base de donnees
 *
 * @param instance $dataClass        	
 * @param array $data        	
 * @return int
 */
function dataWrite($dataClass, $data) {
	global $message, $LANG, $module_coderetour, $log, $OBJETBDD_debugmode;
	try {
		$id = $dataClass->ecrire ( $data );
		$message->set ( $LANG ["message"] [5] );
		$module_coderetour = 1;
		$log->setLog ( $_SESSION ["login"], get_class ( $dataClass ) . "-write", $id );
	} catch ( Exception $e ) {
		if ($OBJETBDD_debugmode > 0) {
			$message->set ( $dataClass->getErrorData ( 1 ) );
		} else {
			$message->set ( $LANG ["message"] [12] );
		}
		$message->setSyslog ( $e->getMessage () );
		$module_coderetour = - 1;
	}
	return ($id);
}
/**
 * Supprime un enregistrement en base de donnees
 *
 * @param instance $dataClass        	
 * @param int $id        	
 * @return int
 */
function dataDelete($dataClass, $id) {
	global $message, $LANG, $module_coderetour, $log, $OBJETBDD_debugmode;
	$module_coderetour = - 1;
	$ok = true;
	if (is_array ( $id )) {
		foreach ( $id as $value ) {
			if (! (is_numeric ( $value ) && $value > 0)) {
				$ok = false;
			}
		}
	} else {
		if (! (is_numeric ( $id ) && $id > 0)) {
			$ok = false;
		}
	}
	if ($ok ) {
		try {
			$ret = $dataClass->supprimer ( $id );
			$message->set ( $LANG ["message"] [4] );
			$module_coderetour = 1;
			$log->setLog ( $_SESSION ["login"], get_class ( $dataClass ) . "-delete", $id );
		} catch ( Exception $e ) {
			if ($OBJETBDD_debugmode > 0) {
				$message->set ( $dataClass->getErrorData ( 1 ) );
			} else {
				$message->set ( $LANG ["message"] [13] );
			}
			$message->setSyslog ( $e->getMessage () );
			$ret = - 1;
		}
	} else
		$ret = - 1;
	return ($ret);
}
/**
 * Modifie la langue utilisee dans l'application
 *
 * @param string $langue        	
 */
function setlanguage($langue) {
	global $language, $LANG, $APPLI_cookie_ttl, $APPLI_menufile, $menu, $ObjetBDDParam;
	/*
	 * Chargement de la langue par defaut
	 */
	include ('locales/' . $language . ".php");
	/*
	 * On gere le cas ou la langue selectionnee n'est pas la langue par defaut
	 */
	if ($language != $langue) {
		$LANGORI = $LANG;
		/*
		 * Test de l'existence du fichier locales selectionne
		 */
		if (file_exists ( 'locales/' . $langue . '.php' )) {
			include 'locales/' . $langue . '.php';
			$LANGDIFF = $LANG;
			/*
			 * Fusion des deux tableaux
			 */
			$LANG = array ();
			$LANG = array_replace_recursive ( $LANGORI, $LANGDIFF );
		}
	}
	$ObjetBDDParam ["formatDate"] = $FORMATDATE;
	/*
	 * Mise en session de la langue
	 */
	$_SESSION ['LANG'] = $LANG;
	/*
	 * Regeneration du menu
	 */
	include_once 'framework/navigation/menu.class.php';
	$menu = new Menu ( $APPLI_menufile, $LANG );
	$_SESSION ["menu"] = $menu->generateMenu ();
	
	/*
	 * Ecriture du cookie
	 */
	$cookieParam = session_get_cookie_params ();
	$cookieParam ["lifetime"] = $APPLI_cookie_ttl;
	if (! $APPLI_modeDeveloppement) {
		$cookieParam ["secure"] = true;
	}
	$cookieParam ["httponly"] = true;
	
	setcookie ( 'langue', $langue, time () + $APPLI_cookie_ttl, $cookieParam ["path"], $cookieParam ["domain"], $cookieParam ["secure"], $cookieParam ["httponly"] );
}

/**
 * Fonction testant si la donnee fournie est de type UTF-8 ou non
 *
 * @param array|string $data        	
 * @return boolean
 */
function check_encoding($data) {
	$result = true;
	if (is_array ( $data )) {
		foreach ( $data as $value ) {
			if (check_encoding ( $value ) == false)
				$result = false;
		}
	} else {
		if (strlen ( $data ) > 0) {
			if (mb_check_encoding ( $data, "UTF-8" ) == false) {
				$result = false;
			}
		}
	}
	return $result;
}

/**
 * Retourne l'adresse IP du client, en tenant compte le cas echeant du reverse-proxy
 *
 * @return string
 */
function getIPClientAddress() {
	/*
	 * Recherche si le serveur est accessible derriere un reverse-proxy
	 */
	if (isset ( $_SERVER ["HTTP_X_FORWARDED_FOR"] )) {
		return $_SERVER ["HTTP_X_FORWARDED_FOR"];
		/*
		 * Cas classique
		 */
	} else if (isset ( $_SERVER ["REMOTE_ADDR"] )) {
		return $_SERVER ["REMOTE_ADDR"];
	} else {
		return - 1;
	}
}
/**
 * Fonction recursive decodant le html en retour de navigateur
 *
 * @param array|string $data        	
 * @return array|string
 */
function htmlDecode($data) {
	if (is_array ( $data )) {
		foreach ( $data as $key => $value )
			$data [$key] = htmlDecode ( $value );
	} else {
		$data = htmlspecialchars_decode ( $data );
	}
	return $data;
}

/**
 * Fonction d'analyse des virus avec clamav
 *
 * @author quinton
 *        
 *         Exemple d'usage :
 *        
 *         $nomfiletest = "/tmp/eicar.com.txt";
 *         try {
 *         echo "analyse antivirale de $nomfiletest";
 *         testScan ( $nomfiletest );
 *         echo "Fichier sans virus reconnu par Clamav<br>";
 *         } catch ( FileException $f ) {
 *         echo $f->getMessage () . "<br>";
 *         } catch ( VirusException $v ) {
 *         echo $v->getMessage () . "<br>";
 *         } finally {
 *         echo "Fin du test";
 *         }
 */
class VirusException extends Exception {
}

class FileException extends Exception {
}

function testScan($file) {
	if (file_exists ( $file )) {
		if (extension_loaded ( 'clamav' )) {
			$retcode = cl_scanfile ( $file ["tmp_name"], $virusname );
			if ($retcode == CL_VIRUS) {
				$message = $file ["name"] . " : " . cl_pretcode ( $retcode ) . ". Virus found name : " . $virusname;
				throw new VirusException ( $message );
			}
		} else {
			/*
			 * Test avec clamscan
			 */
			$clamscan = "/usr/bin/clamscan";
			$clamscan_options = "-i --no-summary";
			if (file_exists ( $clamscan )) {
				exec ( "$clamscan $clamscan_options $file", $output );
				if (count ( $output ) > 0) {
					$message = $file ["name"] . " : ";
					foreach ( $output as $value ) {
						$message .= $value . " ";
					}
					throw new VirusException ( $message );
				}
			} else {
				throw new FileException ( "clamscan not found" );
			}
		}
	} else {
		throw new FileException ( "$file not found" );
	}
}
function getHeaders() {
	$header = array ();
	foreach ( $_SERVER as $key => $value ) {
		if (substr ( $key, 0, 4 ) == "HTTP") {
			$header [substr ( $key, 5 )] = $value;
		}
	}
	return $header;
	
	// if (!function_exists('apache_request_headers')) {
	/*
	 * Fonction equivalente pour NGINX
	 */
	/*
	 * function apache_request_headers() {
	 * foreach($_SERVER as $key=>$value) {
	 * if (substr($key,0,5)=="HTTP_") {
	 * $key=str_replace(" ","-",ucwords(strtolower(str_replace("_"," ",substr($key,5)))));
	 * $out[$key]=$value;
	 * }else{
	 * $out[$key]=$value;
	 * }
	 * }
	 * return $out;
	 * }
	 * }
	 * printr($_SERVER);
	 * return apache_request_headers();
	 */
}
?>
