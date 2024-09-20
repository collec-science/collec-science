<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\MultipleType as LibrariesMultipleType;

class MultipleType extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesMultipleType();
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
