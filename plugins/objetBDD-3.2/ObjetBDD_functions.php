<?php
/**
 * Experimental : utilisable uniquement avec les dernieres vesrsions de php (> 5.3)
 * @author Eric Quinton
 * 18 aout 2009
 */
if(!isset($DEFAULT_formatdate)) $DEFAULT_formatdate = "fr";
if (!isset($OBJETBDD_debugmode)) $OBJETBDD_debugmode = 1;
if (!isset($LANG)) {
	$LANG["ObjetBDDError"][0] = "Le champ ";
	$LANG["ObjetBDDError"][1] = " n'est pas numerique.";
	$LANG["ObjetBDDError"][2] = " est trop grand. Longueur maximale autorisée : ";
	$LANG["ObjetBDDError"][3] = " Valeur saisie : ";
	$LANG["ObjetBDDError"][4] = " caractères";
	$LANG["ObjetBDDError"][5] = "Le contenu du champ ";
	$LANG["ObjetBDDError"][6] = " ne correspond pas au format attendu. Masque autorisé : ";
	$LANG["ObjetBDDError"][7] = " est obligatoire, mais n'a pas été renseigné.";
}
/**
 * Preparation des parametres pour les classes heritees de ObjetBDD
 */
if (!isset($ObjetBDDParam)) $ObjetBDDParam = array ();
if (is_array($ObjetBDDParam)==false) $ObjetBDDParam = array ();
if (defined("FORMATDATE")) {
	$ObjetBDDParam["formatDate"]=FORMATDATE;
} else {
	$ObjetBDDParam["formatDate"]=$DEFAULT_formatdate;
}
/*if (isset($BDD_utf8)) {
	$ObjetBDDParam["utf8"] = $BDD_utf8;
} else {
	$ObjetBDDParam["utf8"] = false;
}*/
$ObjetBDDParam["debug_mode"]=$OBJETBDD_debugmode;

/**
 * function _new
 * initialisation d'une classe basee sur ObjetBDD,
 * avec passage des parametres adequats
 * @param $classe
 * @return instance
 */
function _new($classe) {
	$instance = new $classe($bdd,$ObjetBDDParam);
	return $instance;
}

/**
 * _ecrire
 * execution de la fonction ecrire sur l'instance $instance,
 * declaree precedemment avec la fonction _new.
 * Affiche les messages d'erreur le cas echeant
 * Retourne le resultat de la fonction d'ecriture.
 * @param $instance
 * @param $data
 * @return unknown_type
 */
function _ecrire($instance,$data) {
	$rep = $instance->ecrire($data);
	$instance->getErrorData(1);
	return $rep;
}
/**
 * function formatErrorData
 * Formate les erreurs d'analyse des donnees avant mise en fichier,
 * en tenant compte des parametres de langue
 * @param $data
 * @return unknown_type
 */
function formatErrorData($data) {
	$LANG = & $GLOBALS['LANG'];
	$res = "";
	foreach ($data as $key => $value) {
		$data[$key]["valeur"] = htmlentities($data[$key]["valeur"]);
		if ($data[$key]["code"]==0) {
			$res .= $data[$key]["message"]."<br>";
		}elseif ($data[$key]["code"]==1) {
			$res .= $LANG["ObjetBDDError"][0].$data[$key]["colonne"].$LANG["ObjetBDDError"][1].$LANG["ObjetBDDError"][3].
			$data[$key]["valeur"]."<br>";
		}elseif ($data[$key]["code"]==2) {
			$res .= $LANG["ObjetBDDError"][0].$data[$key]["colonne"].$LANG["ObjetBDDError"][2].
			$data[$key]["demande"].$LANG["ObjetBDDError"][3].$data[$key]["valeur"].
					" (".strlen($data[$key]["valeur"]).$LANG["ObjetBDDError"][4].")<br>";
		}elseif ($data[$key]["code"]==3) {
			$res .= $LANG["ObjetBDDError"][5].$data[$key]["colonne"].$LANG["ObjetBDDError"][6].
			$data[$key]["demande"].$LANG["ObjetBDDError"][3].$data[$key]["valeur"]."<br>";
		}elseif ($data[$key]["code"]==4) {
			$res .= "Le champ ".$data[$key]["colonne"].$LANG["ObjetBDDError"][7]."<br>";
		}
	}
	return $res;
}
?>