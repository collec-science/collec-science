<?php

namespace App\Controllers;

use App\Libraries\Campaign;
use App\Libraries\Container;
use \Ppci\Controllers\PpciController;
use App\Libraries\Document as LibrariesDocument;
use App\Libraries\Event;
use App\Libraries\Sample;

class Document extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesDocument();
    }
    function write($origin)
    {
        return $this->returnToOrigin($origin,  $this->lib->write());
    }
    function delete($origin)
    {
        return $this->returnToOrigin($origin,  $this->lib->delete());
    }
    function get()
    {
        return $this->lib->get();
    }
    function externalGetList()
    {
        return $this->lib->externalGetList();
    }
    function externalAdd()
    {
        return $this->lib->externalAdd();
    }
    function getExternal()
    {
        return $this->lib->getExternal();
    }
    function returnToOrigin($origin, $res)
    {
        $isEvent = false;
        if ($origin == "sample") {
            $lib = new Sample;
        } elseif ($origin == "container") {
            $lib = new Container;
        } elseif ($origin == "campaign") {
            $lib = new Campaign;
        } elseif ($origin == "sampleevent") {
            $lib = new Event;
            $isEvent = true;
        } elseif ($origin == "containerevent") {
            $lib = new Event;
            $isEvent = true;
        }
        if ($isEvent) {
            if ($res) {
                return $lib->display();
            } else {
                return $lib->change();
            }
        } else {
            return $lib->display();
        }
    }
}
