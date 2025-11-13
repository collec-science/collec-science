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
        if ($this->lib->write()) {
            return $this->lib->list();
        } else {
            return $this->lib->change();
        }
    }
    function writeStay() {
        $this->lib->write();
        return $this->lib->change();
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
       if ( $this->lib->copy()) {
        return $this->lib->change();
       } else {
        return $this->lib->list();
       }
    }

    function getLogo() {
        return $this->lib->getLogo();
    }
}
