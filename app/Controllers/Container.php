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
        return $this->returnToOrigin($_SESSION["moduleParent"]);
    }
    function exitMulti()
    {
        $this->lib->exitMulti();
        return $this->returnToOrigin($_SESSION["moduleParent"]);
    }
    function deleteMulti()
    {
        $this->lib->deleteMulti();
        return $this->returnToOrigin($_SESSION["moduleParent"]);
    }
    function setStatus()
    {
        $this->lib->setStatus();
        return $this->returnToOrigin($_SESSION["moduleParent"]);
    }
    function entryMulti()
    {
        $this->lib->entryMulti();
        return $this->returnToOrigin($_SESSION["moduleParent"]);
    }
    function referentMulti()
    {
        $this->lib->referentMulti();
        return $this->returnToOrigin($_SESSION["moduleParent"]);
    }
    function setCollection()
    {
        $this->lib->setCollection();
        return $this->returnToOrigin($_SESSION["moduleParent"]);
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
    function verifyIdentifier()
    {
        return $this->lib->verifyIdentifier();
    }
    function addMultiEvent()
    {
        $this->lib->eventMulti();
        return $this->returnToOrigin($_SESSION["moduleParent"]);
    }

    function returnToOrigin(string $origin)
    {
        $action = "list";
        if (!empty($_REQUEST["moduleFrom"])) {
            if ($_REQUEST["moduleFrom"] == "containerDisplay") {
                $lib = $this;
                $action = "display";
            } else if ($_REQUEST["moduleFrom"] == "containerList") {
                $lib = $this;
            } else if ($_REQUEST["moduleFrom"] == "sampleDisplay") {
                $lib = new Sample;
                $action = "display";
            } else if ($_REQUEST["moduleFrom"] == "sampleList") {
                $lib = new Sample;
                $action = "list";
            } else {
                $lib = $this;
            }
        } else {
            if ($origin == "sample") {
                $lib = new Sample;
            } else {
                $lib = $this;
            }
        }
        return $lib->$action();
    }
}
