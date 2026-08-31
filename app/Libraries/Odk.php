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
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "odk/odkChange.tpl");
        $this->vue->set($_SESSION["collections"], "collections");
        $campaign = new Campaign;
        $this->vue->set($campaign->getList("campaign_name"), "campaigns");
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
        $this->vue->set($odksampletype->read($_REQUEST["odk_sampletype_id"]), "odksampletype");
        $this->vue->set($odksampletype->getListFromOdk($this->id), "odksampletypes");
        $this->vue->set($_REQUEST["odk_sampletype_id"], "sampletypeCurrent");
        $sampletype = new SampleType;
        $this->vue->set($sampletype->getListFromCollection($data["collection_id"]), "sampletypes");
        /**
         * tables nn
         */
        $this->vue->set( $this->dataclass->getAllIdentifiers($this->id), "identifiers");
        $this->vue->set($this->dataclass->getAllStations($this->id, $data["collection_id"]), "stations");
        $this->vue->set($this->dataclass->getAllReferents($this->id), "referents");
        /**
         * tables used to create ods file
         */
        $odkline = new OdkLine;
        $this->vue->set($odkline->getListFromParent($this->id), "lines");
        $odkchoice = new OdkChoice;
        $this->vue->set($odkchoice->getListFromParent($this->id), "choices");
        /**
         * end
         */
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
        } catch (PpciException) {
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
}
