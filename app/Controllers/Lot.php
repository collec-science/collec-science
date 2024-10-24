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
        if ($this->lib->write()) {
            return $this->display();
        } else {
            return $this->list();
        }
    }
    function delete()
    {
        if ($this->lib->delete()) {
            return $this->list();
        } else {
            return $this->list();
        }
    }
    function deleteSamples()
    {
        $this->lib->deleteSamples();
        return $this->list();
    }
}
