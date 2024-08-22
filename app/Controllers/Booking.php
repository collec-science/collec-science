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
    function write()
    {
        return $this->lib->write();
    }
    function delete()
    {
        return $this->lib->delete();
    }
    function verifyInterval()
    {
        return $this->lib->verifyInterval();
    }
}
