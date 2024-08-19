<?php 
namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Xx extends PpciLibrary { 
    /**
     * @var xx
     */
    protected PpciModel $dataclass;

    private $keyName;

function __construct()
    {
        parent::__construct();
        $this->dataClass = new XXX();
        $this->keyName = "xxx_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

/**
 * Created : 30 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
function sampleInitDatEntry()
{
    global $this->vue, ;
    /*
     * Recherche des collections
     */
    $this->vue->set($_SESSION["collections"], "collections");
    include_once "modules/classes/collection.class.php";
    $collection = new Collection();
    $this->vue->set($collection->getAllCollections(), "collectionsSearch");
    /*
     * Recherche des types d'échantillons
     */
    include_once 'modules/classes/sampleType.class.php';
    $sampleType = new SampleType();
    $this->vue->set($sampleType->getListe(2), "sample_type");
    include_once 'modules/classes/objectStatus.class.php';
    $objectStatus = new ObjectStatus();
    $this->vue->set($objectStatus->getListe(1), "objectStatus");
    include_once 'modules/classes/samplingPlace.class.php';
    $samplingPlace = new SamplingPlace();
    $this->vue->set($samplingPlace->getListFromCollection(), "samplingPlace");
    include_once 'modules/classes/metadata.class.php';
    $metadata = new Metadata();
    $this->vue->set($metadata->getListSearchable(), "metadatas");
    include_once 'modules/classes/referent.class.php';
    $referent = new Referent();
    $this->vue->set($referent->getListe(2), "referents");
    include_once 'modules/classes/movementReason.class.php';
    $mv = new MovementReason();
    $this->vue->set($mv->getListe(2), "movementReason");
    $this->vue->set($_SESSION["APPLI_code"], "APPLI_code");
    include_once 'modules/classes/borrower.class.php';
    $borrower = new Borrower();
    $this->vue->set($borrower->getListe(2), "borrowers");
    $this->vue->set(date($_SESSION["date"]["maskdate"]), "borrowing_date");
    $this->vue->set(date($_SESSION["date"]["maskdate"]), "expected_return_date");
    include_once 'modules/exportmodel/exportmodel.class.php';
    $exportModel = new ExportModel();
    $this->vue->set($exportModel->getListFromTarget("sample"), "exportModels");
    include_once 'modules/classes/eventType.class.php';
    $eventType = new EventType();
    $this->vue->set($eventType->getListeFromCategory("sample"), "eventType");
    include_once 'modules/classes/campaign.class.php';
    $campaign = new Campaign();
    $this->vue->set($campaign->getListe(2), "campaigns");
    include_once 'modules/classes/containerFamily.class.php';
    $cf = new ContainerFamily();
    $this->vue->set($cf->getListe(2), "containerFamily");
    include_once 'modules/classes/country.class.php';
    $country = new Country();
    $this->vue->set($country->getListe(2), "countries");
}

class SampleInitClassException extends Exception
{
};

/**
 * Fonction d'initialisation globale des tables de reference
 * utilisee pour les imports externes
 * return array
 */
class SampleInitClass
{

    public $classes = array(
        "sampling_place_name" => array(
            "filename" => "samplingPlace.class.php",
            "classname" => "SamplingPlace",
            "field" => "sampling_place_name",
            "id" => "sampling_place_id"
        ),
        "object_status_name" => array(
            "filename" => "objectStatus.class.php",
            "classname" => "ObjectStatus",
            "field" => "object_status_name",
            "id" => "object_status_id"
        ),
        "collection_name" => array(
            "filename" => "collection.class.php",
            "classname" => "Collection",
            "field" => "collection_name",
            "id" => "collection_id"
        ),
        "sample_type_name" => array(
            "filename" => "sampleType.class.php",
            "classname" => "SampleType",
            "field" => "sample_type_name",
            "id" => "sample_type_id"
        ),
        "identifier_type_code" => array(
            "filename" => "identifierType.class.php",
            "classname" => "IdentifierType",
            "field" => "identifier_type_code",
            "id" => "identifier_type_id"
        ),
        "referent_name" => array(
            "filename" => "referent.class.php",
            "classname" => "Referent",
            "field" => "referent_name",
            "id" => "referent_id"
        ),
        "container_type_name" => array(
            "filename" => "containerType.class.php",
            "classname" => "ContainerType",
            "field" => "container_type_name",
            "id" => "container_type_id"
        ),
        "campaign_name" => array(
            "filename" => "campaign.class.php",
            "classname" => "Campaign",
            "field" => "campaign_name",
            "id" => "campaign_id"
        ),
        "country_code" => array(
            "filename" => "country.class.php",
            "classname" => "Country",
            "field" => "country_code2",
            "id" => "country_id"
        )
    );

    /**
     * Si $reverse vaut true, retourne, pour chaque classe, un tableau dont la cle
     * est le libelle et la valeur l'identifiant associe
     *
     * @param boolean $reverse
     * @return array[]
     */
    function init($reverse = false)
    {
        global ;
        /*
         * Recuperation de tous les libelles connus dans la base de donnees
         */

        $dclasse = array();
        try {
            foreach ($this->classes as $classe) {
                include_once 'modules/classes/' . $classe["filename"];
                $instance = new $classe["classname"]();
                switch ($classe["field"]) {
                    function identifier_type_code() {
                        $data = $instance->getListeWithCode();
                        }
                    function collection_name() {
                        $data = $_SESSION["collections"];
                        }
                    function referent_name() {
                        $data = $instance->getListName();
                        }
                    default:
                        $data = $instance->getListe(2);
                }

                if ($reverse) {
                    $donnees = array();
                    foreach ($data as $value) {
                        $donnees[$value[$classe["field"]]] = $value[$classe["id"]];
                    }
                } else {
                    $donnees = $data;
                }
                $dclasse[$classe["field"]] = $donnees;
                unset($instance);
            }
        } catch (Exception $e) {
            $throw(new SampleInitClassException($e->getMessage));
        }
        return $dclasse;
    }
}
