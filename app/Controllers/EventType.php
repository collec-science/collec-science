<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\EventType as LibrariesEventType;

class EventType extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesEventType();
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
