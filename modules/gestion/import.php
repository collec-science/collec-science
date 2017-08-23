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
require_once 'modules/classes/samplingPlace.class.php';
require_once 'modules/classes/identifierType.class.php';
require_once 'modules/classes/objectIdentifier.class.php';
/*
 * Initialisations
 */
$import = new Import();
$sample = new Sample($bdd, $ObjetBDDParam);
$container = new Container($bdd, $ObjetBDDParam);
$storage = new Storage($bdd, $ObjetBDDParam);


$sampleType = new SampleType($bdd, $ObjetBDDParam);
$containerType = new ContainerType($bdd, $ObjetBDDParam);
$objectStatus = new ObjectStatus($bdd, $ObjetBDDParam);
$samplingPlace = new SamplingPlace($bdd, $ObjetBDDParam);
$identifierType = new IdentifierType($bdd, $ObjetBDDParam);
$objectIdentifier = new ObjectIdentifier($bdd, $ObjetBDDParam);
$import->initClasses($sample, $container, $storage, $samplingPlace, $identifierType, $sampleType);
$import->initClass("objectIdentifier", $objectIdentifier);
$import->initControl($_SESSION["projects"], $sampleType->getList(), $containerType->getList(), $objectStatus->getList(), $samplingPlace->getList());
/*
 * Traitement
 */
$vue->set("gestion/import.tpl", "corps");
switch ($t_module["param"]) {
    case "change":
		/*
		 * Affichage du masque de selection du fichier a importer
		 */
		break;
    
    case "control" :
		/*
		 * Lancement des controles
		 */
		unset($_SESSION["filename"]);
        if (file_exists($_FILES['upfile']['tmp_name'])) {
            /*
             * Lancement du controle
             */
            try {
                $import->initFile($_FILES['upfile']['tmp_name'], $_REQUEST["separator"], $_REQUEST["utf8_encode"]);
                $resultat = $import->controlAll();
                if (count($resultat) > 0) {
                    /*
                     * Erreurs decouvertes
                     */
                    $vue->set(1, "erreur");
                    $vue->set($resultat, "erreurs");
                } else {
                    /*
                     * Deplacement du fichier dans le dossier temporaire
                     */
                    $filename = $APPLI_temp . '/' . bin2hex(openssl_random_pseudo_bytes(4));
                    if (! copy($_FILES['upfile']['tmp_name'], $filename)) {
                        $message->set("Impossible de recopier le fichier importé dans le dossier temporaire");
                    } else {
                        $_SESSION["filename"] = $filename;
                        $_SESSION["separator"] = $_REQUEST["separator"];
                        $_SESSION["utf8_encode"] = $_REQUEST["utf8_encode"];
                        $vue->set(1, "controleOk");
                        $vue->set($_FILES['upfile']['name'], "filename");
                    }
                }
            } catch (Exception $e) {
                $message->set($e->getMessage());
            }
        }
        $import->fileClose();
        $module_coderetour = 1;
        $vue->set($_REQUEST["separator"], "separator");
        $vue->set($_REQUEST["utf8_encode"], "utf8_encode");
        break;
    case "import":
        if (isset($_SESSION["filename"])) {
            if (file_exists($_SESSION["filename"])) {
                try {
                    $import->initFile($_SESSION["filename"], $_SESSION["separator"], $_SESSION["utf8_encode"]);
                    $import->importAll();
                    $message->set("Import effectué. " . $import->nbTreated . " lignes traitées");
                    $message->set("Premier UID généré : " . $import->minuid);
                    $message->set("Dernier UID généré : " . $import->maxuid);
                    $module_coderetour = 1;
                } catch (ImportException $ie) {
                    $message->set($ie->getMessage());
                } catch (Exception $e) {
                    $message->set($e->getMessage());
                }
            }
        }
        unset($_SESSION["filename"]);
        break;
}

?>