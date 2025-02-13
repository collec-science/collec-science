<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Metadata as LibrariesMetadata;
use Ppci\Libraries\PpciException;

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
        if ($this->lib->write()) {
            return $this->display();
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
        $this->lib->import();
        return $this->list();
    }
    function fieldChange() {
        try {
            return $this->lib->fieldChange();
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(),true);
            return $this->lib->display();
        }
        
    }
    function fieldWrite() {
        if ( $this->lib->fieldWrite()) {
            return $this->lib->display();
        } else {
            return $this->lib->change();
        }
    }
    function fieldDelete() {
        $this->lib->fieldDelete();
        return $this->lib->display();
    }

    function fieldMove() {
        $this->lib->move();
        return $this->lib->display();
    }
}
