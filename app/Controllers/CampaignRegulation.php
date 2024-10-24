<?php

namespace App\Controllers;

use App\Libraries\Campaign;
use \Ppci\Controllers\PpciController;
use App\Libraries\CampaignRegulation as LibrariesCampaignRegulation;

class CampaignRegulation extends PpciController
{
    protected $lib;
    protected $campaign;
    function __construct()
    {
        $this->lib = new LibrariesCampaignRegulation();
        $this->campaign = new Campaign;
    }
    function change()
    {
        return $this->lib->change();
    }
    function write()
    {
        
        if ($this->lib->write()) {
            return $this->campaign->display();
        } else {
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->lib->delete()) {
            return $this->campaign->display();
        } else {
            return $this->change();
        }
    }
}
