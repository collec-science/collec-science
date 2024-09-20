<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\DefaultLibrary;

class DefaultController extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new DefaultLibrary();
    }
    function index()
    {
        return $this->lib->index();
    }
}
