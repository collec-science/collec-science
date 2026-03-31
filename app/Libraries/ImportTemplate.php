<?php

namespace App\Libraries;

use App\Models\Campaign;
use App\Models\ContainerFamily;
use App\Models\Country;
use App\Models\IdentifierType;
use App\Models\Metadata;
use App\Models\Referent;
use App\Models\SampleType;
use App\Models\SamplingPlace;
use Ppci\Libraries\PpciLibrary;
use Ppci\Libraries\Views\CsvView;

class ImportTemplate extends PpciLibrary
{
    function change()
    {
        $this->vue = service('Smarty');
        $this->vue->set("gestion/importTemplate.tpl", "corps");
        $this->vue->set($_SESSION["collections"], "collections");
        $referent = new Referent;
        $this->vue->set($referent->getListName(), "referents");
        $country = new Country;
        $this->vue->set($country->getList("country_name"), "countries");
        $campaign = new Campaign;
        $this->vue->set($campaign->getList("campaign_name"), "campaigns");
        $samplingPlace = new SamplingPlace;
        $this->vue->set($samplingPlace->getList("sampling_place_name"), "samplingPlaces");
        $identifiers = new IdentifierType;
        $this->vue->set($identifiers->getList("identifier_type_name"), "identifiers");
        $cf = new ContainerFamily;
        $this->vue->set($cf->getListe(2), "containerFamily");
        $this->vue->help("gestion/générer-le-modèle-pour-les-importations-de-masse.html");
        return $this->vue->send();
    }

    function generate()
    {
        $content = [];
        $container = [];

        if ($_POST["containerEnable"] == 1) {
            /**
             * import of containers
             */
            $container["container_status_id"] = 1;
            $container["container_identifier"] = _("Contenant exemple");
            $container["container_type_name"] = $_POST["containerTypeName"];
            if (!empty($_POST["containerCollection"])) {
                $container["container_collection_name"] = $_POST["containerCollection"];
            }
            foreach ($_POST["containerFields"] as $field) {
                if ($field == "containerLocation") {
                    $container["container_parent_identifier"] = "";
                    $container["container_column"] = "";
                    $container["container_line"] = "";
                } else {
                    $container[$field] = "";
                }
            }
            $container = $this->addSecondaryIdentifiers($container);
            $content[] = $container;
        }
        if ($_POST["sampleEnable"] == 1) {
            /**
             * Import of samples
             */
            $sampleType = new SampleType;
            $metadata = new Metadata;
            $selectFields = ["referent_name", "country_name", "country_origin_name", "campaign_name", "sampling_place_name"];
            $i = 1;
            $sampleParent = "";
            foreach ($_POST["sampleTypes"] as $sampleTypeId) {
                $sample = [];
                $sample["sample_identifier"] = _("Échantillon exemple") . " $i";
                if ($i == 1) {
                    $sampleParent = $sample["sample_identifier"];
                }
                $sample["collection_name"] = $_SESSION["collections"][$_POST["sampleCollection"]]["collection_name"];
                $sample["sample_status_id"] = 1;
                $sample["sampling_date"] = date($_SESSION["date"]["maskdate"]);
                foreach ($selectFields as $field) {
                    if (!empty($_POST[$field])) {
                        $sample[$field] = $_POST[$field];
                    }
                }
                foreach ($_POST["sampleFields"] as $field) {
                    if ($field == "sampleLocation") {
                        $sample["container_parent_identifier"] = $container["container_identifier"];
                        $sample["sample_column"] = "";
                        $sample["sample_line"] = "";
                    } elseif ($field == "sampleGps") {
                        $sample["wgs84_x"] = "";
                        $sample["wgs84_y"] = "";
                    } elseif ($field == "sample_parent_identifier" && $i > 1) {
                        $sample["sample_parent_identifier"] = $sampleParent;
                    } elseif ($field == "sampleComposite") {
                        $sample["composite_parents_identifiers"] = "parent1,parent2";
                        $sample["composite_multiple_value"] = "";
                    } else {
                        $sample[$field] = "";
                    }
                }
                $sample = $this->addSecondaryIdentifiers($sample);
                /**
                 * Treatment of sample_type
                 */
                $stype = $sampleType->read($sampleTypeId);
                $sample["sample_type_name"] = $stype["sample_type_name"];
                if ($stype["multiple_type_id"] > 0) {
                    $sample["sample_multiple_value"] = "";
                    $sample["sample_multiple_real"] = "";
                }
                if ($stype["metadata_id"] > 0) {
                    $tmetadata = $metadata->read($stype["metadata_id"]);
                    $mfields = json_decode($tmetadata["metadata_schema"], true);
                    foreach ($mfields as $mfield) {
                        $mfield["required"] == 1 ? $required = _("obligatoire") : $required = "";
                        $sample["md_" . $mfield["name"]] = $required;
                    }
                }
                $content[] = $sample;
                $i++;
            }
        }
        /**
         * Generate the file and send it
         */
        $vue = new CsvView;
        $vue->setDelimiter(",");
        $vue->set($content);
        $vue->regenerateHeader();
        $filename = $_SESSION["dbparams"]["APPLI_code"] . "-importTemplate-" . date('Y-m-d-His') . ".csv";
        return $vue->send($filename);
    }
    private function addSecondaryIdentifiers(array $row): array
    {
        foreach ($_POST["identifiers"] as $id) {
            $row[$id] = "";
        }
        return $row;
    }
}
