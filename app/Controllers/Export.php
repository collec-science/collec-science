<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Export as LibrariesExport;
use App\Libraries\Lot;

class Export extends PpciController
{
    protected $lib;
    protected Lot $lot;
    function __construct()
    {
        $this->lib = new LibrariesExport();
        $this->lot = new Lot;
    }
    function change()
    {
        return $this->lib->change();
    }
    function write()
    {
        if ($this->lib->write()) {
            return $this->lot->display();
        } else {
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->lib->delete()) {
            return $this->lot->display();
        } else {
            return $this->change();
        }
    }
    function exec()
    {
        $this->lib->exec();
        return $this->lot->display();
    }
}
