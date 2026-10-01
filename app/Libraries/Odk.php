<?php

namespace App\Libraries;

use App\Models\Campaign;
use App\Models\Odk as ModelsOdk;
use App\Models\OdkChoice;
use App\Models\OdkLine;
use App\Models\OdkSampletype;
use App\Models\SampleType;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Libraries\Views\FileView;
use Ppci\Models\PpciModel;

class Odk extends PpciLibrary
{
    /**
     * @var ModelsOdk
     */
    protected PpciModel $dataclass;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsOdk();
        $this->keyName = "odk_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function list()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->getList(), "data");
        $this->vue->set("odk/odkList.tpl", "corps");
        $this->vue->help(_("odk/utiliser-odk-pour-importer-des-échantillons.html"));
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "odk/odkChange.tpl");
        $this->vue->set($_SESSION["collections"], "collections");
        $campaign = new Campaign;
        $this->vue->set($campaign->getList("campaign_name"), "campaigns");
        $this->vue->help(_("odk/générer-le-formulaire-odk.html"));
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        $this->vue->set("odk/odkDisplay.tpl", "corps");
        $this->vue->set($data = $this->dataclass->getDetail($_REQUEST["odk_id"]), "data");
        /**
         * Treatment of sampletypes
         */
        if (!isset($_REQUEST["odk_sampletype_id"])) {
            $_REQUEST["odk_sampletype_id"] = 0;
        }
        $odksampletype = new OdkSampletype;
        $this->vue->set($odksampletype->read($_REQUEST["odk_sampletype_id"], true, $this->id), "odksampletype");
        $this->vue->set($odksampletype->getListFromOdk($this->id), "odksampletypes");
        $this->vue->set($_REQUEST["odk_sampletype_id"], "sampletypeCurrent");
        $sampletype = new SampleType;
        $this->vue->set($sampletype->getListFromCollection($data["collection_id"]), "sampletypes");
        /**
         * tables nn
         */
        $this->vue->set($this->dataclass->getAllIdentifiers($this->id), "identifiers");
        $this->vue->set($this->dataclass->getAllStations($this->id, $data["collection_id"]), "stations");
        $this->vue->set($this->dataclass->getAllReferents($this->id), "referents");
        /**
         * tables used to create ods file
         */
        $odkline = new OdkLine;
        $this->vue->set($odkline->getListFromParent($this->id, "line_order"), "lines");
        $odkchoice = new OdkChoice;
        $this->vue->set($odkchoice->getListFromParent($this->id), "choices");
        /**
         * end
         */
        $this->vue->help(_("odk/générer-le-formulaire-odk.html"));
        return $this->vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return true;
            } else {
                return false;
            }
        } catch (PpciException) {
            return false;
        }
    }

    /**
     * Method writeComp
     * write tables nn
     */
    function writeComp()
    {
        try {
            $this->dataclass->writeComp($_POST["odk_id"], $_POST);
            return true;
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            return false;
        }
    }
    function delete()
    {
        /*
         * delete record
         */
        try {
            $this->dataDelete($this->id);
            return true;
        } catch (PpciException $e) {
            return false;
        }
    }
    function calculate()
    {
        $odkGenerate = new OdkGenerate;
        $odkGenerate->calculate($this->id);
    }
    function createSpreadsheet()
    {
        $odkGenerate = new OdkGenerate;
        try {
            $realfilename = $odkGenerate->createSpreadsheet($this->id);
            $this->vue = new FileView;
            $dataOdk = $this->dataclass->read($this->id);
            $filename = $dataOdk["odk_name"] . ".xlsx";
            $this->vue->setParam(["tmp_name" => $realfilename, "filename" => $filename]);
            return $this->vue->send();
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            return false;
        }
    }

    function duplicate()
    {
        $db = $this->dataclass->db;
        try {
            if (!is_numeric($this->id) || $this->id == 0) {
                throw new PpciException(_("L'identifiant du formulaire n'a pas été fourni"));
            }
            /**
             * get data
             */
            $data = $this->dataclass->read($this->id);
            if (empty($data)) {
                throw new PpciException(_("Le formulaire n'existe pas"));
            }
            $odksampletype = new OdkSampletype;
            $odkline = new OdkLine;
            $odkchoice = new OdkChoice;
            /**
             * related tables 
             */
            $identifiers = $this->dataclass->getIdentifiers($this->id);
            $stations = $this->dataclass->getStations($this->id);
            $referents = $this->dataclass->getReferents($this->id);
            $sampletypes = $odksampletype->getListFromParent($this->id);
            $lines = $odkline->getListFromParent($this->id);
            $choices = $odkchoice->getListFromParent($this->id);
            /**
             * create new form
             */
            $data["odk_id"] = 0;
            $data["odk_author"] = $_SESSION["login"];
            /**
             * generate new version number
             */
            $version = explode(".", $data["odk_version"]);
            if (count($version) > 1) {
                $dec = array_last($version);
                if (is_numeric($dec)) {
                    $version[count($version) - 1] = $dec + 1;
                    $data["odk_version"] = implode(".", $version);
                } else {
                    $data["odk_version"] .= ".1";
                }
            } else {
                $data["odk_version"] .= ".1";
            }
            $id = $this->dataclass->write($data);
            /**
             * create items in tables n-n
             */
            $new = [];
            foreach ($identifiers as $row) {
                $new[] = $row["identifier_type_id"];
            }
            if (!empty($new)) {
                $this->dataclass->writeTableNN("odk_identifier", "odk_id", "identifier_type_id", $id, $new);
            }
            $new = [];
            foreach ($stations as $row) {
                $new[] = $row["sampling_place_id"];
            }
            if (!empty($new)) {
                $this->dataclass->writeTableNN("odk_station", "odk_id", "sampling_place_id", $id, $new);
            }
            $new = [];
            foreach ($referents as $row) {
                $new[] = $row["referent_id"];
            }
            if (!empty($new)) {
                $this->dataclass->writeTableNN("odk_referent", "odk_id", "referent_id", $id, $new);
            }
            /**
             * create item in others related tables
             */
            foreach ($sampletypes as $row) {
                $row["odk_sampletype_id"] = 0;
                $row["odk_id"] = $id;
                $odksampletype->write($row);
            }
            foreach ($lines as $row) {
                $row["odk_line_id"] = 0;
                $row["odk_id"] = $id;
                $odkline->write($row);
            }
            foreach ($choices as $row) {
                $row["odk_choice_id"] = 0;
                $row["odk_id"] = $id;
                $odkchoice->write($row);
            }
            $db->transCommit();

        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            if ($db->transEnabled) {
                $db->transRollback();
            }
        }
    }
}
