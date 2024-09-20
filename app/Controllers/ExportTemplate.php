<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\ExportTemplate as LibrariesExportTemplate;

class ExportTemplate extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesExportTemplate();
    }
    function list()
    {
        return $this->lib->list();
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
    function import()
    {
        return $this->lib->import();
    }
}
