<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Booking as LibrariesBooking;

class Booking extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesBooking();
    }
    function change()
    {
        return $this->lib->change();
    }
    function write($origin)
    {
        $res = $this->lib->write();
        return $this->returnToOrigin($origin, $res);
    }
    function delete($origin)
    {
        $res = $this->lib->delete();
        return $this->returnToOrigin($origin, $res);
    }
    function verifyInterval()
    {
        return $this->lib->verifyInterval();
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
