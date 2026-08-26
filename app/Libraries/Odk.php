<?php

namespace App\Libraries;

use App\Models\Campaign;
use App\Models\Odk as ModelsOdk;
use App\Models\OdkSampletype;
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
    function display() {
        $this->vue = service('Smarty');
        $this->vue->set("odk/odkDisplay.tpl", "corps");
        $this->vue->set($this->dataclass->getDetail($_REQUEST["odk_id"]),"data");
        /**
         * Treatment of sampletypes
         */
        if (!isset($_REQUEST["odk_sampletype_id"])) {
            $_REQUEST["odk_sampletype_id"] = 0;
        }
        $sampletype = new OdkSampletype;
        $this->vue->set($sampletype->read($_REQUEST["odk_sampletype_id"]),"sampletype");
        $this->vue->set($_REQUEST["odk_sampletype_id"], "sampletypeCurrent");
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
