<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Country as LibrariesCountry;

class Country extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesCountry();
    }
    function list()
    {
        return $this->lib->list();
    }
}
