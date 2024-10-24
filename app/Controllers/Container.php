<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Container as LibrariesContainer;
use App\Models\SearchContainer;

class Container extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesContainer();
        if (!isset($_SESSION["searchContainer"])) {
            $_SESSION["searchContainer"] = new SearchContainer;
        }
    }
    function list()
    {
        return $this->lib->list();
    }
    function display()
    {
        return $this->lib->display();
    }
    function change()
    {
        return $this->lib->change();
    }
    function write()
    {
        if ($this->lib->write()) {
            return $this->display();
        } else {
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->lib->delete()) {
            return $this->list();
        } else {
            return $this->change();
        }
    }
    function getChildren()
    {
        return $this->lib->getChildren();
    }
    function getFromType()
    {
        return $this->lib->getFromType();
    }
    function getFromUid()
    {
        return $this->lib->getFromUid();
    }
    function getOccupationAjax()
    {
        return $this->lib->getOccupationAjax();
    }
    function importStage1()
    {
        return $this->lib->importStage1();
    }
    function importStage2()
    {
        return $this->lib->importStage2();
    }
    function importStage3()
    {
        $this->lib->importStage3();
        return $this->lib->importStage1();
    }
    function lendingMulti()
    {
        $this->lib->lendingMulti();
        return $this->lib->list();
    }
    function exitMulti()
    {
        $this->lib->exitMulti();
        return $this->lib->list();
    }
    function deleteMulti()
    {
        $this->lib->deleteMulti();
        return $this->lib->list();
    }
    function setStatus()
    {
        $this->lib->setStatus();
        return $this->lib->list();
    }
    function entryMulti()
    {
        $this->lib->entryMulti();
        return $this->lib->list();
    }
    function referentMulti()
    {
        $this->lib->referentMulti();
        return $this->lib->list();
    }
    function setCollection()
    {
        $this->lib->setCollection();
        return $this->lib->list();
    }
    function verifyCyclic()
    {
        return $this->lib->verifyCyclic();
    }
    function verifyCyclicExec()
    {
        return $this->lib->verifyCyclicExec();
    }
    function exportGlobal()
    {
        return $this->lib->exportGlobal();
    }
    function isSlotFull()
    {
        return $this->lib->isSlotFull();
    }
}
