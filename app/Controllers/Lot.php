<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Lot as LibrariesLot;

class Lot extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesLot();
    }
    function list()
    {
        return $this->lib->list();
    }
    function create()
    {
        return $this->lib->create();
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
    function deleteSamples()
    {
        return $this->lib->deleteSamples();
    }
}
