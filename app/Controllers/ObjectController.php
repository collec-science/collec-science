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
    function setTrashed($origin)
    {
        $res = $this->lib->setTrashed();
        return $this->returnToOrigin($origin, $res);
    }
    function getDetailAjax()
    {
        return $this->lib->getDetailAjax();
    }
    function printLabel($origin)
    {
        if (! $this->lib->printLabel()) {
            return $this->returnToOrigin($origin);
        }
    }
    function exportCSV($origin)
    {
        if (! $this->lib->exportCSV()) {
            return $this->returnToOrigin($origin);
        }
    }
    function printLabelDirect($origin)
    {
        $this->lib->printLabelDirect();
        return $this->returnToOrigin($origin);
    }

    function returnToOrigin($origin, $res = true)
    {
        if ($origin == "sample") {
            $lib = new Sample;
        } else {
            $lib = new Container;
        }
        $lastModule = $_GET["lastModule"];
        if (in_array($lastModule, ["sampleDisplay", "containerDisplay"])) {
            return $lib->display();
        } else {
            return $lib->list();
        }
    }
}
