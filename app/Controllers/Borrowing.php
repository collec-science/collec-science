<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Borrowing as LibrariesBorrowing;

class Borrowing extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesBorrowing();
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
}
