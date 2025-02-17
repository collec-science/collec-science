<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\ContainerType as LibrariesContainerType;

class ContainerType extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesContainerType();
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
    function getFromFamily()
    {
        return $this->lib->getFromFamily();
    }
    function listAjax()
    {
        return $this->lib->listAjax();
    }
}
