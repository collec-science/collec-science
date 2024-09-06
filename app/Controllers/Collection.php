<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Collection as LibrariesCollection;

class Collection extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesCollection();
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
    function getAjax()
    {
        return $this->lib->getAjax();
    }
}
