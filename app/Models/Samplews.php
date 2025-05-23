<?php

namespace App\Models;

use Ppci\Libraries\PpciException;
use Ppci\Models\PpciModel;

class Samplews
{
    public Sample $sample;
    public IdentifierType $identifierType;
    public ObjectIdentifier $objectIdentifier;
    public SamplingPlace $samplingPlace;
    public Country $country;
    public Campaign $campaign;
    public Referent $referent;
    public SampleType $sampleType;
    public $result;

    /**
     * Constructor
     *
     * @param PDO $bdd
     * @param array $ObjetBDDParam
     */
    function __construct()
    {
        /**
         * init the orm classes
         */
        $this->sample = new Sample;
        $this->identifierType = new IdentifierType;
        $this->objectIdentifier = new ObjectIdentifier;
        $this->samplingPlace = new SamplingPlace;
        $this->country = new Country;
        $this->campaign = new Campaign;
        $this->referent = new Referent;
        $this->sampleType = new SampleType;
    }
    /**
     * insert or update a sample
     * Create campaign, referent or samplingPlace if necessary
     * @param array $dataSent: data to insert
     * @param array $searchOrder: order to search a sample
     * @return int: UID of the sample
     */
    function write(array $dataSent, array $searchOrder = array("uid", "uuid", "identifier")): int
    {
        $this->sample->autoFormatDate = false;
        $collection_id = 0;
        /**
         * Replace null by empty
         */
        foreach ($dataSent as $k => $v) {
            if ($v == "null") {
                $dataSent[$k] = "";
            }
        }
        /**
         * Collection
         */
        if (!empty($dataSent["collection_name"])) {
            foreach ($_SESSION["collections"] as $collection) {
                if ($dataSent["collection_name"] == $collection["collection_name"]) {
                    if (!$collection["allowed_import_flow"]) {
                        throw new PpciException(_("La collection n'est pas paramétrée pour accepter les flux entrants"), 403);
                    }
                    $collection_id = $collection["collection_id"];
                    break;
                }
            }
        } else {
            if (!empty($_SESSION["collections"]) && count($_SESSION["collections"]) == 1) {
                /**
                 * default collection
                 */
                if (!$_SESSION["collections"][0]["allowed_import_flow"]) {
                    throw new PpciException(_("La collection n'est pas paramétrée pour accepter les flux entrants"), 403);
                }
                $collection_id = $_SESSION["collections"][0]["collection_id"];
            }
        }
        if (empty($collection_id)) {
            throw new PpciException(_("La collection n'a pas été fournie ou n'est pas autorisée"), 403);
        }
        /**
         * Search for existent sample
         */
        $data = [];
        $isUpdate = false;
        foreach ($searchOrder as $field) {
            if (!empty($dataSent[$field])) {
                $data = $this->sample->getFromField($field, $dataSent[$field], $collection_id);
                if (!empty($data)) {
                    $isUpdate = true;
                    break;
                }
            }
        }
        /**
         * Default values
         */
        if (empty($dataSent["trashed"] && !$isUpdate)) {
            $dataSent["trashed"] = 0;
        }
        if (empty($dataSent["object_status_id"]) && !$isUpdate) {
            $dataSent["object_status_id"] = 1;
        }
        /**
         * Search for the parent
         */
        $dataParent = array();
        $hasparent = false;
        foreach ($searchOrder as $field) {
            if (strlen($dataSent["parent_" . $field]) > 0) {
                $hasparent = true;
                $dataParent = $this->sample->getFromField($field, $dataSent["parent_" . $field]);
                if (!empty($dataParent)) {
                    break;
                }
            }
        }
        if ($hasparent && empty($dataParent)) {
            throw new PpciException(_("Le parent n'a pas été trouvé"), 400);
        }
        /**
         * Search for station and create it if unknown
         */
        $dataSent["sampling_place_id"] = "";
        if (!empty($dataSent["station_name"])) {
            $dataSent["sampling_place_id"] = $this->samplingPlace->getIdFromName(($dataSent["station_name"]));
            if (empty($dataSent["sampling_place_id"])) {
                $dataSent["sampling_place_id"] = $this->samplingPlace->ecrire(array("sampling_place_id" => 0, "sampling_place_name" => $dataSent["station_name"]));
            }
        }
        /**
         * Search for sample_type
         */
        if (empty($dataSent["sample_type_name"]) && empty($dataSent["sample_type_code"])) {
            if ($isUpdate) {
                $dataSent["sample_type_id"] = $data["sample_type_id"];
            } else {
                throw new PpciException(_("Le type d'échantillon n'a pas été fourni"), 400);
            }
        } else {
            if (!empty($dataSent["sample_type_code"])) {
                $dataSent["sample_type_id"] = $this->sampleType->getIdFromCode($dataSent["sample_type_code"]);
            } else {
                $dataSent["sample_type_id"] = $this->sampleType->getIdFromName($dataSent["sample_type_name"]);
            }
            if (empty($dataSent["sample_type_id"])) {
                throw new PpciException(_("Le type d'échantillon est inconnu"), 400);
            }
        }
        /**
         * metadata
         */
        $metadataTemplate = $this->sampleType->getMetadataAsArray($dataSent["sample_type_id"]);
        empty($dataSent["metadata"]) ? $metadata = array() : $metadata = json_decode($dataSent["metadata"], true);
        foreach ($dataSent as $key => $value) {
            if (substr($key, 0, 3) == "md_") {
                $metadata[substr($key, 3)] = $value;
            }
        }
        /**
         * Search for multiple values in metadata
         */
        foreach ($metadataTemplate as $k=>$v) {
            if ($v["type"] == "array" && strlen($metadata[$k]) > 0) {
                $md_col_array = explode(",", $metadata[$k]);
                if (count($md_col_array) > 1) {
                    $metadata[$k] = [];
                    foreach ($md_col_array as $val) {
                        $metadata[$k][] = trim($val);
                    }
                } else {
                    $metadata[$k] = trim($md_col_array[0]);
                }
            }
        } 

        /**
         * Search for country
         */
        if (!empty($dataSent["country_code"])) {
            $dataSent["country_id"] = $this->country->getIdFromCode($dataSent["country_code"]);
            if (empty($dataSent["country_id"])) {
                throw new PpciException(sprintf(_("Le code pays %s est inconnu"), $dataSent["country_code"]), 400);
            }
        }
        if (!empty($dataSent["country_origin_code"])) {
            $dataSent["country_origin_id"] = $this->country->getIdFromCode($dataSent["country_origin_code"]);
            if (empty($dataSent["country_origin_id"])) {
                throw new PpciException(sprintf(_("Le code pays %s est inconnu"), $dataSent["country_origin_code"]), 400);
            }
        }
        /**
         * Search for campaign and create id if unknown
         */
        if (!empty($dataSent["campaign_uuid"])) {
            $dataSent["campaign_id"] = $this->campaign->getIdFromUuid($dataSent["campaign_uuid"]);
            if (empty($dataSent["campaign_id"])) {
                throw new PpciException(sprintf(_("Aucune campagne ne correspond à l'UUID %s"), $dataSent["campaign_uuid"]));
            }
        } else if (!empty($dataSent["campaign_name"])) {
            $dataSent["campaign_id"] = $this->campaign->getIdFromName($dataSent["campaign_name"]);
            if (empty($dataSent["campaign_id"])) {
                $dataSent["campaign_id"] = $this->campaign->ecrire(array("campaign_id" => 0, "campaign_name" => $dataSent["campaign_name"]));
            }
        }

        /**
         * Search for referent and create if if unknown
         */
        if (!empty($dataSent["referent_name"])) {
            $dataSent["referent_id"] = $this->referent->getFromName($dataSent["referent_name"], $dataSent["referent_firstname"])["referent_id"];
            if (empty($dataSent["referent_id"])) {
                $dataSent["referent_id"] = $this->referent->ecrire(array("referent_id" => 0, "referent_name" => $dataSent["referent_name"], "referent_firstname" => $dataSent["referent_firstname"]));
            }
        }
        if ($isUpdate) {
            /**
             * Update
             */
            unset($dataSent["collection_id"]);
            foreach ($dataSent as $key => $content) {
                if (array_key_exists($key, $data)) {
                    $data[$key] = $content;
                }
            }
            $dm = json_decode($data["metadata"], true);
            foreach ($metadata as $key => $value) {
                $dm[$key] = $value;
            }
            $data["metadata"] = json_encode($dm);
        } else {
            /**
             * insert
             */
            $data = array(
                "sample_id" => 0,
                "uid" => 0,
                "sample_type_id" => $dataSent["sample_type_id"],
                "sample_creation_date" => date("Y-m-d H:i:s"),
                "sampling_date" => $dataSent["sampling_date"],
                "multiple_value" => $dataSent["multiple_value"],
                "sampling_place_id" => $dataSent["sampling_place_id"],
                "metadata" => json_encode($metadata),
                "expiration_date" => $dataSent["expiration_date"],
                "country_id" => $dataSent["country_id"],
                "campaign_id" => $dataSent["campaign_id"],
                "country_origin_id" => $dataSent["country_origin_id"],
                "identifier" => $dataSent["identifier"],
                "wgs84_x" => $dataSent["wgs84_x"],
                "wgs84_y" => $dataSent["wgs84_y"],
                "object_status_id" => 1,
                "referent_id" => $dataSent["referent_id"],
                "uuid" => $dataSent["uuid"],
                "trashed" => 0,
                "location_accuracy" => $dataSent["location_accuracy"],
                "object_comment" => $dataSent["object_comment"],
                "collection_id" => $collection_id,
                "dbuid_origin" => $dataSent["dbuid_origin"]
            );
            if (empty($data["collection_id"])) {
                throw new PpciException(_("La collection n'a pas été fournie ou n'est pas autorisée"), 403);
            }
        }
        /**
         * Add the parent
         */
        if (!empty($dataParent["sample_id"])) {
            $data["parent_sample_id"] = $dataParent["sample_id"];
        }
        /**
         * write
         */
        try {
            $uid = $this->sample->ecrire($data);
        } catch (\Exception $oe) {
            throw new PpciException($oe->getMessage(), 520);
        }
        /**
         * Write the secondary identifiers
         */
        $identifiers = $this->identifierType->getListeWithCode();
        foreach ($identifiers as $identifier) {
            if (!empty($dataSent[$identifier["identifier_type_code"]])) {
                $this->objectIdentifier->writeOrReplace(
                    array(
                        "uid" => $uid,
                        "identifier_type_id" => $identifier["identifier_type_id"]
                    )
                );
            }
        }
        return $uid;
    }
}
