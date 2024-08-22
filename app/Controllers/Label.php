<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Label as LibrariesLabel;

class Label extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesLabel();
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
    function copy()
    {
        return $this->lib->copy();
    }
}
