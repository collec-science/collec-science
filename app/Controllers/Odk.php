<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Odk as LibrariesOdk;
use App\Libraries\OdkSampletype;

class Odk extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesOdk();
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
    function display()
    {
        return $this->lib->display();
    }
    function writeComp() {
        $this->lib->writeComp();
        return $this->display();
    }
    function sampletypeWrite()
    {
        $odkSampletype = new OdkSampletype;
        $odkSampletype->write();
        return $this->display();
    }
    function sampletypeDelete() {
        $odkSampletype = new OdkSampletype;
        $odkSampletype->delete();
        return $this->display();
    }

    function calculate() {
        $this->lib->calculate() ;
        return $this->display();
            }
}
