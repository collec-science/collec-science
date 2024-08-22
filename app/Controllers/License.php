<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\License as LibrariesLicense;

class License extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesLicense();
    }
    function list()
    {
        return $this->lib->list();
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
