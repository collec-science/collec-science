<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\MovementWs as LibrariesMovementWs;

class MovementWs extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesMovementWs();
    }
    function write()
    {
        return $this->lib->write();
    }
}
