<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\ContainerFamily as LibrariesContainerFamily;

class ContainerFamily extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesContainerFamily();
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
