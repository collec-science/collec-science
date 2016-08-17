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
	global $smarty, $OBJETBDD_debugmode, $ERROR_display;
	if (is_numeric ( $id )) {
		if ($id > 0) {
			try {	
				$data = $dataClass->lire ( $id );
			} catch ( Exception $e ) {
				if ($OBJETBDD_debugmode > 0) {
					$message = $dataClass->getErrorData ( 1 );
				} else
					$message = $LANG ["message"] [37];
				if ($ERROR_display == 1)
					$message .= "<br>" . $e->getMessage ();
			}
			/*
			 * Gestion des valeurs par defaut
			 */
		} else {
			if (is_numeric ( $idParent ) || $idParent == null)
				$data = $dataClass->getDefaultValue ( $idParent );
		}
		/*
		 * Affectation des donnees a smarty
		 */
		$smarty->assign ( "data", $data );
		$smarty->assign ( "corps", $smartyPage );
		return $data;
	}
	;
}
/**
 * Ecrit un enregistrement en base de donnees
 *
 * @param instance $dataClass        	
 * @param array $data        	
 * @return int
 */
function dataWrite($dataClass, $data) {
	global $message, $LANG, $module_coderetour, $log, $OBJETBDD_debugmode, $ERROR_display;
	if (strlen ( $message ) > 0)
		$message .= '<br>';
	try {
		$id = $dataClass->ecrire ( $data);
		$message .= $LANG ["message"] [5];
		$module_coderetour = 1;
		$log->setLog ( $_SESSION ["login"], get_class ( $dataClass ) . "-write", $id );
	} catch ( Exception $e ) {
		if ($OBJETBDD_debugmode > 0) {
			$message .= $dataClass->getErrorData ( 1 );
		} else
			$message .= $LANG ["message"] [12];
		if ($ERROR_display == 1)
			$message .= "<br>" . $e->getMessage ();
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
	global $message, $LANG, $module_coderetour, $log, $OBJETBDD_debugmode, $ERROR_display;
	$module_coderetour = - 1;
	$ok = true;
	if (is_array ( $id )) {
		foreach ( $id as $key => $value ) {
			if (! (is_numeric ( $value ) && $value > 0))
				$ok = false;
		}
	} else {
		if (! (is_numeric ( $id ) && $id > 0))
			$ok = false;
	}
	if ($ok == true) {
		if (strlen ( $message ) > 0)
			$message .= '<br>';
		try {
			$ret = $dataClass->supprimer ( $id );
			$message = $LANG ["message"] [4];
			$module_coderetour = 2;
			$log->setLog ( $_SESSION ["login"], get_class ( $dataClass ) . "-delete", $id );
		} catch ( Exception $e ) {
			if ($OBJETBDD_debugmode > 0) {
				$message .= $dataClass->getErrorData ( 1 );
			} else
				$message .= $LANG ["message"] [13];
			if ($ERROR_display == 1)
				$message .= "<br>" . $e->getMessage ();
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
	global $language, $LANG, $APPLI_cookie_ttl, $APPLI_menufile, $menu;
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
	/*
	 * Mise en session de la langue
	 */
	$_SESSION ['LANG'] = $LANG;
	/*
	 * Regeneration du menu
	 */
	include_once 'framework/navigation/menu.class.php';
	$menu = new Menu($APPLI_menufile, $LANG);
	$_SESSION["menu"]=$menu->generateMenu();
	/*
	 * Ecriture du cookie
	 */
	$cookieParam = session_get_cookie_params ();
	$cookieParam ["lifetime"] = $APPLI_cookie_ttl;
	if ($APPLI_modeDeveloppement == false)
		$cookieParam ["secure"] = true;
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
	if (is_array ( $data ) == true) {
		foreach ( $data as $key => $value ) {
			if (check_encoding ( $value ) == false)
				$result = false;
		}
	} else {
		if (strlen ( $data ) > 0) {
			if (mb_check_encoding ( $data, "UTF-8" ) == false)
				$result = false;
		}
	}
	return $result;
}

/**
 * Encode les donnees en html avant envoi vers le navigateur
 *
 * @param unknown $data        	
 * @return string
 */
function encodehtml($data) {
	if (is_array ( $data )) {
		foreach ( $data as $key => $value ) {
			$data [$key] = encodehtml ( $value );
		}
	} else {
		$data = htmlspecialchars ( $data );
	}
	return $data;
}
/**
 * Retourne l'adresse IP du client, en tenant compte le cas echeant du reverse-proxy
 * @return string
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
/**
 * Fonction d'analyse des virus avec clamav
 * @author quinton
 *
 * Exemple d'usage :
 * 
$nomfiletest = "/tmp/eicar.com.txt";
try {
	echo "analyse antivirale de $nomfiletest";
	testScan ( $nomfiletest );
	echo "Fichier sans virus reconnu par Clamav<br>";
} catch ( FileException $f ) {
	echo $f->getMessage () . "<br>";
} catch ( VirusException $v ) {
	echo $v->getMessage () . "<br>";
} finally {
	echo "Fin du test";
}
 */
class VirusException extends Exception {
}
;
class FileException extends Exception {
}
;
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
					foreach ( $output as $value )
						$message .= $value . " ";
						throw new VirusException ( $message );
				}
			} else
				throw new FileException ( "clamscan not found" );
		}
	} else
		throw new FileException ( "$file not found" );
}
?>