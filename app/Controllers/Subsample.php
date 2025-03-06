<?php

namespace App\Controllers;

use App\Libraries\Sample;
use \Ppci\Controllers\PpciController;
use App\Libraries\Subsample as LibrariesSubsample;

class Subsample extends PpciController
{
    protected $lib;
    protected $sample;
    function __construct()
    {
        $this->lib = new LibrariesSubsample();
        $this->sample = new Sample;
    }
    function change()
    {
        return $this->lib->change();
    }
    function write()
    {
        if ($this->lib->write()) {
            return $this->sample->display();
        } else {
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->lib->delete()) {
            return $this->sample->display();
        } else {
            return $this->change();
        }
    }
}
