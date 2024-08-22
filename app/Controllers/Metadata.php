<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Metadata as LibrariesMetadata;

class Metadata extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesMetadata();
    }
    function list()
    {
        return $this->lib->list();
    }
    function display()
    {
        return $this->lib->display();
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
    function copy()
    {
        return $this->lib->copy();
    }
    function getSchema()
    {
        return $this->lib->getSchema();
    }
    function export()
    {
        return $this->lib->export();
    }
    function import()
    {
        return $this->lib->import();
    }
}
