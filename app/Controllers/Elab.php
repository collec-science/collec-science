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
    function generateModel() {
        return $this->lib->generateModel();
    }
    function import() {
        $file = $this->request->getFile("csvfile");
        if (! $file->isValid()) {
            $this->message->set($file->getErrorString() . '(' . $file->getError() . ')', true);
            
        } else {
            $this->lib->import($file->gettempName());
        }
        return $this->display();
    }
}
