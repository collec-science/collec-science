<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Elab as LibrariesElab;

class Elab extends PpciController
{
    /**
     * @var LibrariesElab
     */
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesElab;
    }
    function display() {
        return $this->lib->display();
    }
    function generateModel() {}
}
