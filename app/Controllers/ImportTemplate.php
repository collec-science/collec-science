<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\ImportTemplate as LibrariesImportTemplate;
use Ppci\Libraries\PpciException;

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
        try {
            return $this->lib->generate();
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            return $this->change();
        }
        
    }
}
