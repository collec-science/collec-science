<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Event as LibrariesEvent;

class Event extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesEvent();
    }
    function change()
    {
        return $this->lib->change();
    }
    function display()
    {
        return $this->lib->display();
    }
    function write($origin)
    {
        $res = $this->lib->write();
        $this->returnToOrigin($origin, $res);
    }
    function delete($origin)
    {
        $res = $this->lib->delete();
        $this->returnToOrigin($origin, $res);
    }
    function search()
    {
        return $this->lib->search();
    }
    function deleteList()
    {
        return $this->lib->deleteList();
    }
    function changeList()
    {
        return $this->lib->changeList();
    }
    function returnToOrigin($origin, $res)
    {
        $isSearch = false;
        if ($origin == "sample") {
            $lib = new Sample;
        } elseif ($origin == "container") {
            $lib = new Container;
        } else {
            $isSearch = true;
        }
        if ($isSearch) {
            if ($res) {
                return $this->search();
            } else {
                return $this->lib->change();
            }
        } else {
            if ($res) {
                return $lib->display();
            } else {
                return $this->lib->change();
            }
        }
    }
}
