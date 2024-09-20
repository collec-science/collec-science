<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Export as LibrariesExport;

class Export extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesExport();
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
    function exec()
    {
        return $this->lib->exec();
    }
}
