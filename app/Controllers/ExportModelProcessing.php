<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\ExportModelProcessing as LibrariesExportModelProcessing;

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
        return $this->lib->importExec();
    }
}
