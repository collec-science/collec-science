<?php

namespace App\Libraries;

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

    private $keyName;

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
        require_once "modules/classes/regulation.class.php";
        require_once "modules/classes/campaign.class.php";
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
                return ZZZ;
            } else {
                return $this->change();
            }
        } catch (PpciException) {
            return $this->change();
        }
    }

    function delete()
    {
        try {
            $this->dataDelete($this->id);
            return ZZZ;
        } catch (PpciException $e) {
            return $this->change();
        }
    }
}
