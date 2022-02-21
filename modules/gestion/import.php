<?php

/**
 * Import massif d'echantillons ou de containers
 * et creation des mouvements afferents
 * Created : 18 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/importObject.class.php';
require_once 'modules/classes/sample.class.php';
require_once 'modules/classes/container.class.php';
require_once 'modules/classes/movement.class.php';
require_once 'modules/classes/sampleType.class.php';
require_once 'modules/classes/containerType.class.php';
require_once 'modules/classes/objectStatus.class.php';
require_once 'modules/classes/samplingPlace.class.php';
require_once 'modules/classes/identifierType.class.php';
require_once 'modules/classes/objectIdentifier.class.php';
require_once 'modules/classes/referent.class.php';
require_once 'modules/classes/campaign.class.php';
require_once 'modules/classes/country.class.php';
/*
 * Initialisations
 */
$import = new ImportObject();
$sample = new Sample($bdd, $ObjetBDDParam);
$container = new Container($bdd, $ObjetBDDParam);
$movement = new Movement($bdd, $ObjetBDDParam);

$sampleType = new SampleType($bdd, $ObjetBDDParam);
$containerType = new ContainerType($bdd, $ObjetBDDParam);
$objectStatus = new ObjectStatus($bdd, $ObjetBDDParam);
$samplingPlace = new SamplingPlace($bdd, $ObjetBDDParam);
$identifierType = new IdentifierType($bdd, $ObjetBDDParam);
$objectIdentifier = new ObjectIdentifier($bdd, $ObjetBDDParam);
$referent = new Referent($bdd, $ObjetBDDParam);
$campaign = new Campaign($bdd, $ObjetBDDParam);
$country = new Country($bdd, $ObjetBDDParam);
$import->initClasses($sample, $container, $movement, $samplingPlace, $identifierType, $sampleType, $referent, $campaign, $country);
$import->initClass("objectIdentifier", $objectIdentifier);
$import->initControl($_SESSION["collections"], $sampleType->getList(), $containerType->getList(), $objectStatus->getList(), $samplingPlace->getList(), $referent->getListe(), $campaign->getListe());
/*
 * Traitement
 */
$vue->set("gestion/import.tpl", "corps");

switch ($t_module["param"]) {
    case "change":
        /*
         * Affichage du masque de selection du fichier a importer
         */
        $vue->set(1,"onlyCollectionSearch");
        break;

    case "control":
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
                    if (!copy($_FILES['upfile']['tmp_name'], $filename)) {
                        $message->set(_("Impossible de recopier le fichier importé dans le dossier temporaire"), true);
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
        $vue->set($_REQUEST["onlyCollectionSearch"], "onlyCollectionSearch");
        break;
    case "import":
        if (isset($_SESSION["filename"])) {
            if (file_exists($_SESSION["filename"])) {
                if (is_numeric($_REQUEST["onlyCollectionSearch"])) {
                    $import->onlyCollectionSearch = $_REQUEST["onlyCollectionSearch"];
                }
                try {
                    /*
                     * Demarrage d'une transaction
                     */
                    $bdd->beginTransaction();
                    $import->initFile($_SESSION["filename"], $_SESSION["separator"], $_SESSION["utf8_encode"]);
                    $import->importAll();
                    $message->set(sprintf(_("Import effectué. %s lignes traitées"), $import->nbTreated));
                    $message->set(sprintf(_("Premier UID généré : %s"), $import->minuid));
                    $message->set(sprintf(_("Dernier UID généré : %s"), $import->maxuid));
                    $log->setLog($_SESSION["login"], "massImportDone", "first UID:" . $import->minuid . ",last UID:" . $import->maxuid . ", Nb treated lines:" . $import->nbTreated);
                    $module_coderetour = 1;
                    $bdd->commit();
                } catch (ImportObjectException $ie) {
                    $bdd->rollBack();
                    $message->set(_("Une erreur s'est produite pendant l'importation."), true);
                    $message->set($ie->getMessage(), true);
                    $module_coderetour = -1;
                } catch (Exception $e) {
                    $bdd->rollBack();
                    $message->set(_("Une erreur s'est produite pendant l'importation."), true);
                    $message->set($e->getMessage(), true);
                    $module_coderetour = -1;
                }
            }
        }
        unset($_SESSION["filename"]);
        break;
    case "importExterneExec":
        /*
         * Traitement de l'importation des echantillons provenant d'autres bases de donnees
         */
        if (isset($_SESSION["realfilename"])) {
            if (file_exists($_SESSION["realfilename"])) {
                try {
                    require_once 'modules/classes/import.class.php';
                    $fields = array(
                        "dbuid_origin",
                        "identifier",
                        "sample_type_name",
                        "collection_name",
                        "object_status_name",
                        "wgs84_x",
                        "wgs84_y",
                        "sample_creation_date",
                        "sampling_date",
                        "expiration_date",
                        "multiple_value",
                        "sampling_place_name",
                        "metadata",
                        "identifiers",
                        "dbuid_parent",
                        "referent_name",
                        "uuid",
                        "location_accuracy",
                        "campaign_name",
                        "comment",
                        "country_code",
                        "country_origin_code"
                    );
                    $importFile = new Import($_SESSION["realfilename"], $_REQUEST["separator"], $_REQUEST["utf8_encode"], $fields);
                    $data = $importFile->getContentAsArray();
                } catch (ImportException $ie) {
                    $message->set($ie->getMessage(), true);
                    $module_coderetour = -1;
                }

                /*
                 * Recuperation des classes secondaires necessaires pour les tables de references
                 */
                require_once 'modules/gestion/sample.functions.php';
                $sic = new SampleInitClass();
                $import->initClass("sample", $sample);

                try {
                    /*
                     * Demarrage d'une transaction
                     */
                    $bdd->beginTransaction();
                    $import->importExterneExec($data, $sic, $_POST);
                    $message->set(sprintf(_("Import effectué. %s lignes traitées"), $import->nbTreated));
                    $message->set(sprintf(_("Premier UID généré : %s"), $import->minuid));
                    $message->set(sprintf(_("Dernier UID généré : %s"), $import->maxuid));
                    $module_coderetour = 1;
                    $log->setLog($_SESSION["login"], "externalImportDone", "first UID:" . $import->minuid . ",last UID:" . $import->maxuid . ", Nb treated lines:" . $import->nbTreated);
                    $bdd->commit();
                } catch (ImportObjectException $ie) {
                    $bdd->rollBack();
                    $message->set($ie->getMessage(), true);
                    $module_coderetour = -1;
                } catch (Exception $e) {
                    $bdd->rollBack();
                    $message->set($e->getMessage(), true);
                    $module_coderetour = -1;
                }
                unlink($_SESSION["realfilename"]);
                unset($_SESSION["realfilename"]);
            }
        }
        break;
}
