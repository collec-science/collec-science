<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Request as LibrariesRequest;

class Request extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesRequest();
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
        $this->lib->write();
        return $this->change();
    }
    function writeExec() {
        if ($this->lib->write()) {
            return $this->exec();
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
    function exec()
    {
        return $this->lib->exec();
    }
    function execList()
    {
        return $this->lib->execList();
    }
    function copy()
    {
        return $this->lib->copy();
    }
}
