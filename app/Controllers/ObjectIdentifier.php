<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\ObjectIdentifier as LibrariesObjectIdentifier;

class ObjectIdentifier extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesObjectIdentifier();
    }
    function change()
    {
        return $this->lib->change();
    }
    function write($origin)
    {
        return $this->returnToOrigin($origin,  $this->lib->write());
    }
    function delete($origin)
    {
        return $this->returnToOrigin($origin,  $this->lib->delete());
    }
    function returnToOrigin($origin, $res)
    {
        if ($origin == "sample") {
            $lib = new Sample;
        } else {
            $lib = new Container;
        }
        if ($res) {
            return $lib->display();
        } else {
            return $this->lib->change();
        }
    }
}
