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
        if ($this->lib->write()) {
            return $this->list();
        } else {
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->lib->delete()) {
            return $this->list();
        } else {
            return $this->change();
        }
    }
    function getAjax()
    {
        return $this->lib->getAjax();
    }
}
