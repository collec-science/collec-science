<?php
/**
 * Import massif d'echantillons ou de containers
 * et creation des mouvements afferents
 * Created : 18 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/import.class.php';
require_once 'modules/classes/sample.class.php';
require_once 'modules/classes/container.class.php';
require_once 'modules/classes/storage.class.php';
require_once 'modules/classes/sampleType.class.php';
require_once 'modules/classes/containerType.class.php';
require_once 'modules/classes/objectStatus.class.php';
/*
 * Initialisations
 */
$import = new Import ();
$sample = new Sample ( $bdd, $ObjetBDDParam );
$container = new Container ( $bdd, $ObjetBDDParam );
$storage = new Storage ( $bdd, $ObjetBDDParam );
$import->initClasses ( $sample, $container, $storage );
$sampleType = new SampleType ( $bdd, $ObjetBDDParam );
$containerType = new ContainerType ( $bdd, $ObjetBDDParam );
$containerStatus = new ContainerStatus ( $bdd, $ObjetBDDParam );
$import->initControl ( $_SESSION ["projects"], $sampleType->getList(), $containerType->getList(), $containerStatus->getList() );
/*
 * Traitement
 */
$smarty->assign("corps", "gestion/import.tpl");
switch ($t_module ["param"]) {
	case "change":
		/*
		 * Affichage du masque de selection du fichier a importer
		 */
		break;
	
	case "control" :
		/*
		 * Lancement des controles
		 */
		unset ( $_SESSION ["filename"] );
		if (file_exists ( $_FILES ['upfile'] ['tmp_name'] )) {
			/*
			 * Lancement du controle
			 */
			try {
				$import->initFile ( $_FILES ['upfile'] ['tmp_name'], $_REQUEST ["separator"], $_REQUEST ["utf8_encode"] );
				$resultat = $import->controlAll ();
				if (count ( $resultat ) > 0) {
					/*
					 * Erreurs decouvertes
					 */
					$smarty->assign ( "erreur", 1 );
					$smarty->assign ( "erreurs", $resultat );
				} else {
					/*
					 * Deplacement du fichier dans le dossier temporaire
					 */
					$filename = $APPLI_nomDossierStockagePhotoTemp . '/' . bin2hex ( openssl_random_pseudo_bytes ( 4 ) );
					if (! copy ( $_FILES ['upfile'] ['tmp_name'], $filename )) {
						$message->set(  "Impossible de recopier le fichier importé dans le dossier temporaire");
					} else {
						$_SESSION ["filename"] = $filename;
						$_SESSION ["separator"] = $_REQUEST ["separator"];
						$_SESSION ["utf8_encode"] = $_REQUEST ["utf8_encode"];
						$smarty->assign ( "controleOk", 1 );
						$smarty->assign("filename", $_FILES['upfile']['name']);
					}
				}
			} catch ( Exception $e ) {
				$message->set(  $e->getMessage ());
			}
		}
		$import->fileClose();
		$module_coderetour = 1;
		$smarty->assign ( "separator", $_REQUEST ["separator"]);
		$smarty->assign ( "utf8_encode", $_REQUEST ["utf8_encode"] );
		break;
	case "import" :
		if (isset ( $_SESSION ["filename"] )) {
			if (file_exists ( $_SESSION ["filename"] )) {
				try {
					$import->initFile ( $_SESSION ["filename"], $_SESSION["separator"], $_SESSION["utf8_encode"] );
					$import->importAll();
					$message->set(  "Import effectué. ". $import->nbTreated . " lignes traitées");
					$module_coderetour = 1;
				} catch ( Exception $e ) {
					$message->set(  $e->getMessage ());
				}
			}
		}
		unset ( $_SESSION ["filename"] );
		break;
}

?>