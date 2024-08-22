<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Movement as LibrariesMovement;

class Movement extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesMovement();
    }
    function input()
    {
        return $this->lib->input();
    }
    function output()
    {
        return $this->lib->output();
    }
    function write()
    {
        return $this->lib->write();
    }
    function list()
    {
        return $this->lib->list();
    }
    function fastInputChange()
    {
        return $this->lib->fastInputChange();
    }
    function fastInputWrite()
    {
        return $this->lib->fastInputWrite();
    }
    function fastOutputChange()
    {
        return $this->lib->fastOutputChange();
    }
    function fastOutputWrite()
    {
        return $this->lib->fastOutputWrite();
    }
    function getLastEntry()
    {
        return $this->lib->getLastEntry();
    }
    function smallMovementChange()
    {
        return $this->lib->smallMovementChange();
    }
    function smallMovementWrite()
    {
        return $this->lib->smallMovementWrite();
    }
    function smallMovementWriteAjax()
    {
        return $this->lib->smallMovementWriteAjax();
    }
    function batchOpen()
    {
        return $this->lib->batchOpen();
    }
    function batchRead()
    {
        return $this->lib->batchRead();
    }
    function batchWrite()
    {
        return $this->lib->batchWrite();
    }
}
