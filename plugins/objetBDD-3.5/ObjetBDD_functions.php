<?php
/**
 * Experimental : utilisable uniquement avec les dernieres vesrsions de php (> 5.3)
 * @author Eric Quinton
 * 18 aout 2009
 */
function objetBDDparamInit() {
    global $ObjetBDDParam, $DEFAULT_formatdate, $OBJETBDD_debugmode, $FORMATDATE;
if(!isset($DEFAULT_formatdate)) $DEFAULT_formatdate = "fr";
if (!isset($OBJETBDD_debugmode)) $OBJETBDD_debugmode = 1;

/**
 * Preparation des parametres pour les classes heritees de ObjetBDD
 */
if (!isset($ObjetBDDParam)) $ObjetBDDParam = array ();
if (is_array($ObjetBDDParam)==false) $ObjetBDDParam = array ();
if (isset($FORMATDATE)) {
	$ObjetBDDParam["formatDate"]=$FORMATDATE;
} else {
	$ObjetBDDParam["formatDate"]=$DEFAULT_formatdate;
}
/*if (isset($BDD_utf8)) {
	$ObjetBDDParam["utf8"] = $BDD_utf8;
} else {
	$ObjetBDDParam["utf8"] = false;
}*/
$ObjetBDDParam["debug_mode"]=$OBJETBDD_debugmode;
$_SESSION["ObjetBDDParam"] = $ObjetBDDParam;
}

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
 * en utilisant la solution gettext (alias _()) pour la traduction.
 * Le paramétrage de gettext et les traductions restent à faire en dehors de ce plugin.
 * @param $data
 * @return unknown_type
 */
function formatErrorData($data) {
	$res = "";
	foreach ($data as $key => $value) {
		$data[$key]["valeur"] = htmlentities($data[$key]["valeur"]);
		if ($data[$key]["code"]==0) {
			$res .= $data[$key]["message"]."<br>";
		}elseif ($data[$key]["code"]==1) {
			// traduction: bien conserver inchangées les chaînes %1$s, %2$s...
			$res .= sprintf(_('Le champ %1$s n\'est pas numérique. Valeur saisie : %2$s'),
				                        $data[$key]["colonne"],                   $data[$key]["valeur"])."<br>";
		}elseif ($data[$key]["code"]==2) {
			// traduction: bien conserver inchangées les chaînes %1$s, %2$s...
			$res .= sprintf(_('Le champ %1$s est trop grand. Longueur maximale autorisée : %2$s Valeur saisie : %3$s (%4$s caractères)'),
				                       $data[$key]["colonne"],$data[$key]["demande"],$data[$key]["valeur"],strlen($data[$key]["valeur"]))."<br>"; 
		}elseif ($data[$key]["code"]==3) {
			// traduction: bien conserver inchangées les chaînes %1$s, %2$s...
			$res .= sprintf(_('Le contenu du champ %1$s ne correspond pas au format attendu. Masque autorisé : %2$s Valeur saisie : %3$s'),
				                                    $data[$key]["colonne"],                $data[$key]["demande"],$data[$key]["valeur"])."<br>"; 
		}elseif ($data[$key]["code"]==4) {
			// traduction: bien conserver inchangées les chaînes %1$s, %2$s...
			$res .= sprintf(_('Le champ %1$s est obligatoire, mais n\'a pas été renseigné.'),
				                        $data[$key]["colonne"])."<br>"; 
		}
	}
	return $res;
}
?>
