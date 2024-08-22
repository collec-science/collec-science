<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\CampaignRegulation as LibrariesCampaignRegulation;

class CampaignRegulation extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesCampaignRegulation();
    }
    function change()
    {
        return $this->lib->change();
    }
    function write()
    {
        return $this->lib->write();
    }
    function delete()
    {
        return $this->lib->delete();
    }
}
