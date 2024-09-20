<?php

namespace Ppci\Controllers;

use \Ppci\Libraries\PasswordLost as LibraryPasswordlost;
use \Ppci\Controllers\PpciController;

class Passwordlost extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibraryPasswordlost();
    }
    function isLost() {
        return $this->lib->isLost();
    }
    function sendMail() {
        return $this->lib->sendMail();
    }
    function reinitChange() {
        return $this->lib->reinitChange();
    }
    function reinitWrite() {
        return $this->lib->reinitWrite();
    }
}
