<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Operation as LibrariesOperation;

class Operation extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesOperation();
    }
    function list()
    {
        return $this->lib->list();
    }
    function change()
    {
        return $this->lib->change();
    }
    function copy()
    {
        return $this->lib->copy();
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
}
