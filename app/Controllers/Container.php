<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Container as LibrariesContainer;

class Container extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesContainer();
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
        return $this->lib->write();
    }
    function delete()
    {
        return $this->lib->delete();
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
        return $this->lib->importStage3();
    }
    function lendingMulti()
    {
        return $this->lib->lendingMulti();
    }
    function exitMulti()
    {
        return $this->lib->exitMulti();
    }
    function deleteMulti()
    {
        return $this->lib->deleteMulti();
    }
    function setStatus()
    {
        return $this->lib->setStatus();
    }
    function entryMulti()
    {
        return $this->lib->entryMulti();
    }
    function referentMulti()
    {
        return $this->lib->referentMulti();
    }
    function setCollection()
    {
        return $this->lib->setCollection();
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
}
