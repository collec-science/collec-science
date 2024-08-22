<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Campaign as LibrariesCampaign;

class Campaign extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesCampaign();
    }
    function list()
    {
        return $this->lib->list();
    }
    function change()
    {
        return $this->lib->change();
    }
    function display()
    {
        return $this->lib->display();
    }
    function write()
    {
        return $this->lib->write();
    }
    function delete()
    {
        return $this->lib->delete();
    }
    function import()
    {
        return $this->lib->import();
    }
}
