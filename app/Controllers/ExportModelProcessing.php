<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\ExportModelProcessing as LibrariesExportModelProcessing;
use App\Models\ExportModel;

class ExportModelProcessing extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesExportModelProcessing();
    }
    function exec()
    {
        return $this->lib->exec();
    }
    function importExec()
    {
        $this->lib->importExec();
        $em = new ExportModel;
        return $em->display();
    }
}
