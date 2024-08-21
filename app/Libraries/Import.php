<?php

namespace App\Libraries;

use App\Models\Campaign;
use App\Models\Container;
use App\Models\ContainerType;
use App\Models\Country;
use App\Models\IdentifierType;
use App\Models\Import as ModelsImport;
use App\Models\ImportObject;
use App\Models\Movement;
use App\Models\ObjectIdentifier;
use App\Models\ObjectStatus;
use App\Models\Referent;
use App\Models\Sample;
use App\Models\SampleInitClass;
use App\Models\SampleType;
use App\Models\SamplingPlace;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;


/**
 * Import massif d'echantillons ou de containers
 * et creation des mouvements afferents
 * Created : 18 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */

class Import extends PpciLibrary
{

    private $import, $sample, $sampleType, $containerType, $objectStatus, $samplingPlace, $referent, $campaign;

    function __construct()
    {
        parent::__construct();
        /*
        * Initialisations
        */
        $this->import = new ImportObject();
        $this->sample = new Sample();
        $this->sampleType = new SampleType();
        $this->containerType = new ContainerType();
        $this->objectStatus = new ObjectStatus();
        $this->samplingPlace = new SamplingPlace();
        $this->referent = new Referent();
        $this->campaign = new Campaign();


        $this->import->initAllClasses();
        //$import->initClass("objectIdentifier", $objectIdentifier);
        $this->import->initControl(
            $_SESSION["collections"],
            $this->sampleType->getList(),
            $this->containerType->getList(),
            $this->objectStatus->getList(),
            $this->samplingPlace->getList(),
            $this->referent->getListe(),
            $this->campaign->getListe()
        );
        /*
        * Traitement
        */
        $this->vue = service('Smarty');
        $this->vue->set("gestion/import.tpl", "corps");
    }

    function change()
    {
        /*
         * Affichage du masque de selection du fichier a importer
         */
        $this->vue->set(1, "onlyCollectionSearch");
        return $this->vue->send();
    }

    function control()
    {
        /*
         * Lancement des controles
         */
        unset($_SESSION["filename"]);
        if (file_exists($_FILES['upfile']['tmp_name'])) {
            try {
                /**
                 * Verify the encoding
                 */
                $encodings = array("UTF-8", "iso-8859-1", "iso-8859-15");
                $currentEncoding = mb_detect_encoding(file_get_contents($_FILES['upfile']['tmp_name']), $encodings, true);
                if ($currentEncoding != "UTF-8" && $_REQUEST["utf8_encode"] == 0 || $currentEncoding == "UTF-8" && $_REQUEST["utf8_encode"] == 1) {
                    throw new PpciException(_("L'encodage du fichier ne correspond pas à celui que vous avez indiqué"));
                }
                /*
                 * Lancement du controle
                 */
                $this->import->initFile($_FILES['upfile']['tmp_name'], $_REQUEST["separator"], $_REQUEST["utf8_encode"]);
                $resultat = $this->import->controlAll();
                if (count($resultat) > 0) {
                    /*
                     * Erreurs decouvertes
                     */
                    $this->vue->set(1, "erreur");
                    $this->vue->set($resultat, "erreurs");
                } else {
                    /*
                     * Deplacement du fichier dans le dossier temporaire
                     */
                    $filename =  $this->appConfig->APP_temp . '/' . bin2hex(openssl_random_pseudo_bytes(4));
                    if (!copy($_FILES['upfile']['tmp_name'], $filename)) {
                        $this->message->set(_("Impossible de recopier le fichier importé dans le dossier temporaire"), true);
                    } else {
                        $_SESSION["filename"] = $filename;
                        $_SESSION["separator"] = $_REQUEST["separator"];
                        $_SESSION["utf8_encode"] = $_REQUEST["utf8_encode"];
                        $this->vue->set(1, "controleOk");
                        $this->vue->set($_FILES['upfile']['name'], "filename");
                    }
                }
            } catch (PpciException $e) {
                $this->message->set($e->getMessage(), true);
            }
        }
        $this->import->fileClose();
        $this->vue->set($_REQUEST["separator"], "separator");
        $this->vue->set($_REQUEST["utf8_encode"], "utf8_encode");
        $this->vue->set($_REQUEST["onlyCollectionSearch"], "onlyCollectionSearch");
        return $this->vue->send();
    }
    function import()
    {
        if (isset($_SESSION["filename"])) {
            if (file_exists($_SESSION["filename"])) {
                if (is_numeric($_REQUEST["onlyCollectionSearch"])) {
                    $this->import->onlyCollectionSearch = $_REQUEST["onlyCollectionSearch"];
                }
                try {
                    /*
                     * Demarrage d'une transaction
                     */
                    $db = $this->dataClass->db;
                    $db->transBegin();
                    $this->import->initFile($_SESSION["filename"], $_SESSION["separator"], $_SESSION["utf8_encode"]);
                    $this->import->importAll();
                    $this->message->set(sprintf(_("Import effectué. %s lignes traitées"), $this->import->nbTreated));
                    $this->message->set(sprintf(_("Premier UID généré : %s"), $this->import->minuid));
                    $this->message->set(sprintf(_("Dernier UID généré : %s"), $this->import->maxuid));
                    $this->log->setLog($_SESSION["login"], "massImportDone", "first UID:" . $this->import->minuid . ",last UID:" . $this->import->maxuid . ", Nb treated lines:" . $this->import->nbTreated);
                } catch (PpciException $ie) {
                    if ($db->transEnabled) {
                        $db->transRollback();
                    }
                    $this->message->set(_("Une erreur s'est produite pendant l'importation."), true);
                    $this->message->set($ie->getMessage(), true);
                }
            }
            unset($_SESSION["filename"]);
            return $this->vue->send();
        }
    }
    function importExterneExec()
    {
        /*
         * Traitement de l'importation des echantillons provenant d'autres bases de donnees
         */
        if (isset($_SESSION["realfilename"])) {
            if (file_exists($_SESSION["realfilename"])) {
                try {
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
                    $importFile = new ModelsImport($_SESSION["realfilename"], $_REQUEST["separator"], $_REQUEST["utf8_encode"], $fields);
                    $data = $importFile->getContentAsArray();
                } catch (PpciException $ie) {
                    $this->message->set($ie->getMessage(), true);
                }

                /*
                 * Recuperation des classes secondaires necessaires pour les tables de references
                 */
                $sic = new SampleInitClass();
                $this->import->initClass("sample", $this->sample);

                try {
                    /*
                     * Demarrage d'une transaction
                     */
                    $db = $this->dataClass->db;
                    $db->transBegin();
                    $this->import->importExterneExec($data, $sic, $_POST);
                    $this->message->set(sprintf(_("Import effectué. %s lignes traitées"), $this->import->nbTreated));
                    $this->message->set(sprintf(_("Premier UID généré : %s"), $this->import->minuid));
                    $this->message->set(sprintf(_("Dernier UID généré : %s"), $this->import->maxuid));
                    $module_coderetour = 1;
                    $this->log->setLog($_SESSION["login"], "externalImportDone", "first UID:" . $this->import->minuid . ",last UID:" . $this->import->maxuid . ", Nb treated lines:" . $this->import->nbTreated);
                } catch (PpciException $ie) {
                    if ($db->transEnabled) {
                        $db->transRollback();
                    }
                    $this->message->set($ie->getMessage(), true);
                    $module_coderetour = -1;
                }
                unlink($_SESSION["realfilename"]);
                unset($_SESSION["realfilename"]);
            }
        }
        return $this->vue->send();
    }
}
