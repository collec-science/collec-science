<?php

namespace App\Controllers;

use App\Libraries\LexicalLib;
use \Ppci\Controllers\PpciController;

class Lexical extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LexicalLib;
    }
    function index()
    {
        return $this->lib->index();
    }
    function getAjax()
    {
        return $this->lib->getAjax();
    }
}
