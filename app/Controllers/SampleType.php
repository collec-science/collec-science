<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\SampleType as LibrariesSampleType;

class SampleType extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesSampleType();
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
    function metadata()
    {
        return $this->lib->metadata();
    }
    function metadataSearchable()
    {
        return $this->lib->metadataSearchable();
    }
    function generator()
    {
        return $this->lib->generator();
    }
    function getListAjax()
    {
        return $this->lib->getListAjax();
    }
}
