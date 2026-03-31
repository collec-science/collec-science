<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\ImportTemplate as LibrariesImportTemplate;

class ImportTemplate extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesImportTemplate();
    }

    function change()
    {
        return $this->lib->change();
    }

    function generate()
    {
        return $this->lib->generate();
    }
}
