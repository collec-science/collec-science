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
        $this->lib->write();
        return $this->lib->change();
    }
    function delete()
    {
        $this->lib->delete();
        return $this->change();
    }
}
