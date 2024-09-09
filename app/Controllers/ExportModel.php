<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\ExportModel as LibrariesExportModel;

class ExportModel extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesExportModel();
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
    function duplicate()
    {
        return $this->lib->duplicate();
    }
    function exportExec() {
        return $this->lib->exportExec();
    }
    function importExec()
    {
        $this->lib->importExec();
        return $this->list();
    }
}
