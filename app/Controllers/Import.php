<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Import as LibrariesImport;

class Import extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesImport();
    }
    function importExterneExec()
    {
        $this->lib->importExterneExec();
        $sample = new Sample;
        return $sample->importStage1();
    }
    function change()
    {
        return $this->lib->change();
    }
    function control()
    {
        return $this->lib->control();
    }
    function import()
    {
        return $this->lib->import();
    }
}
