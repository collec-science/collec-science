<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\ObjectLib;

class ObjectController extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new ObjectLib();
    }
    function setTrashed()
    {
        return $this->lib->setTrashed();
    }
    function getDetailAjax()
    {
        return $this->lib->getDetailAjax();
    }
    function printLabel()
    {
        return $this->lib->printLabel();
    }
    function exportCSV()
    {
        return $this->lib->exportCSV();
    }
    function printLabelDirect()
    {
        return $this->lib->printLabelDirect();
    }
}
