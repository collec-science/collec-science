<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Protocol as LibrariesProtocol;

class Protocol extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesProtocol();
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
    function file()
    {
        return $this->lib->file();
    }
}
