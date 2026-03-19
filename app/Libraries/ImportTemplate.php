<?php

namespace App\Libraries;

use App\Models\Campaign;
use App\Models\Country;
use App\Models\IdentifierType;
use App\Models\Referent;
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
        $this->vue->set($campaign->getList("campaign_name"),"campaigns");
        $samplingPlace = new SamplingPlace;
        $this->vue->set($samplingPlace->getList("sampling_place_name"), "samplingPlaces");
        $identifiers = new IdentifierType;
        $this->vue->set($identifiers->getList("identifier_type_name"), "identifiers");
        return $this->vue->send();
    }

    function generate() {
        printA($_POST);die;
        $content = [];
        if ($_POST["containerEnable"] == 1) {
            /**
             * import of containers
             */
        }
        if ($_POST["sampleEnable"] == 1) {
            /**
             * Import of samples
             */

        }
        /**
         * Generate the file and send it
         */
        $vue = new CsvView;
        $vue->set($content);
        $vue->regenerateHeader();
        $filename = $_SESSION["dbparams"]["APPLI_code"] . "-importTemplate-" . date('Y-m-d-His') . ".csv";
        return $vue->send($filename);
    }
}
