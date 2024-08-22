<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\DatasetColumn as LibrariesDatasetColumn;

class DatasetColumn extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesDatasetColumn();
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
