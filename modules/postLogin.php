<?php
/**
 * @author Eric Quinton
 * @copyright Copyright (c) 2014, IRSTEA / Eric Quinton
 * @license http://www.cecill.info/licences/Licence_CeCILL-C_V1-fr.html LICENCE DE LOGICIEL LIBRE CeCILL-C
 *  Creation 7 avr. 2014
 *  Programme execute si necessaire apres identification
 */

/*
 * Suppression des documents de plus de 24 heures dans le dossier temporaire
 */
if (strlen ( $APPLI_nomDossierStockagePhotoTemp ) > 0) {
	$dureeVie = 3600 * 24; // Suppression de tous les fichiers de plus de 24 heures
	                       // $dureeVie = 30;
	/*
	 * Ouverture du dossier
	 */
	$dossier = opendir ( $APPLI_nomDossierStockagePhotoTemp );
	while ( false !== ($entry = readdir ( $dossier )) ) {
		$path = $APPLI_nomDossierStockagePhotoTemp . "/" . $entry;
		$file = fopen ( $path, 'r' );
		$stat = fstat ( $file );
		$atime = $stat ["atime"];
		fclose ( $file );
		$infos = pathinfo ( $path );
		if (! is_dir ( $path ) && ($infos ["basename"] != ".htaccess")) {
			$age = time () - $atime;
			if ($age > $dureeVie) {
				unlink ( $path );
			}
		}
	}
	closedir ( $dossier );
}
require_once 'modules/classes/project.class.php';
$project = new Project ( $bdd, $ObjetBDDParam );
/*
 * Recherche des groupes LDAP
 */
if ($APPLI_ldapGroupSupport) {
	
	/*
	 * Recuperation des attributs depuis l'annuaire LDAP
	 */
	include_once "framework/ldap/ldap.class.php";
	$ldap = new Ldap ( $LDAP_address, $LDAP_basedn );
	$conn = $ldap->connect ();
	if ($conn > 0) {
		$attribut = array (
				"$LDAP_commonNameAttrib",
				"$LDAP_mailAttrib",
				"$LDAP_groupAttrib" 
		);
		$filtre = "(" . $LDAP_user_attrib . "=" . $_SESSION ["login"] . ")";
		$data = $ldap->getAttributs ( "", $filtre, $attribut );
		printr($data);
		if ($data ["count"] == 0) {
			$message .= "Les données de l'utilisateur n'ont pu être lues dans l'annuaire LDAP";
		} else {
			$_SESSION ["loginNom"] = $data [0] ["$LDAP_commonNameAttrib"] [0];
			$_SESSION ["mail"] = $data [0] ["$LDAP_mailAttrib"] [0];
			/*
			 * Affectation des projets
			 */
			$groupesLdap =  $data [0] ["$LDAP_groupAttrib"] ;
			$groups = array();
			foreach ($groupesLdap as $key=>$value) {
				if (is_numeric($key))
					$groups [] = $value;
			}
			printr($groups);
			$_SESSION["projects"] = $project->getProjectsFromGroups($groups);
		}
	} else 
		$message.="Connexion à l'annuaire LDAP impossible";
} else
	/*
	 * Cas sans utiliser l'annuaire ldap
	 */
	$_SESSION ["projects"] = $project->getProjectsFromLogin ( $_SESSION ["login"] );
/*
 * Attribution des droits dans l'application
 */
if (isset($_SESSION["login"]))
	$_SESSION["droits"]["consult"] = 1;
if (count($_SESSION["projects"]) > 0)
	$_SESSION["droits"]["gestion"] = 1;
?>