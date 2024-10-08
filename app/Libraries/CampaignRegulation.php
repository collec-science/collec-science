<?php

namespace App\Libraries;

use App\Libraries\Campaign as LibrariesCampaign;
use App\Models\Campaign;
use App\Models\CampaignRegulation as ModelsCampaignRegulation;
use App\Models\Regulation;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class CampaignRegulation extends PpciLibrary
{
    /**
     * @var ModelsCampaignRegulation
     */
    protected PpciModel $dataclass;

    

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsCampaignRegulation();
        $this->keyName = "campaign_regulation_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function change()
    {
        $this->vue = service('Smarty');
        $data = $this->dataRead($this->id, "param/campaignRegulationChange.tpl", $_REQUEST["campaign_id"]);
        $regulation = new Regulation();
        $campaign = new Campaign();
        $this->vue->set($regulation->getListe("regulation_name"), "regulations");
        $this->vue->set($campaign->getListe($data["campaign_id"]), "campaign");
        return $this->vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                $campaign = new LibrariesCampaign;
                return $campaign->display();
            } else {
                return $this->change();
            }
        } catch (PpciException) {
            return false;
        }
    }

    function delete()
    {
        try {
            $this->dataDelete($this->id);
            $campaign = new LibrariesCampaign;
            return $campaign->display();
        } catch (PpciException $e) {
            return $this->change();
        }
    }
}
