<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Document as LibrariesDocument;

class Document extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesDocument();
    }
    function write()
    {
        return $this->lib->write();
    }
    function delete()
    {
        return $this->lib->delete();
    }
    function get()
    {
        return $this->lib->get();
    }
    function getSW()
    {
        return $this->lib->getSW();
    }
    function getSWerror()
    {
        return $this->lib->getSWerror();
    }
    function externalGetList()
    {
        return $this->lib->externalGetList();
    }
    function externalAdd()
    {
        return $this->lib->externalAdd();
    }
    function getExternal()
    {
        return $this->lib->getExternal();
    }
}
