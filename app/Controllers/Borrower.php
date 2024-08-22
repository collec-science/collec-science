<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Borrower as LibrariesBorrower;

class Borrower extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesBorrower();
    }
    function list()
    {
        return $this->lib->list();
    }
    function display()
    {
        return $this->lib->display();
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
