<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Sample as LibrariesSample;
use App\Models\SearchSample;

class Sample extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesSample();
        if (!isset($_SESSION["searchSample"])) {
            $_SESSION["searchSample"] = new SearchSample;
        }
    }
    function list()
    {
        return $this->lib->list();
    }
    function searchAjax()
    {
        return $this->lib->searchAjax();
    }
    function getFromId()
    {
        return $this->lib->getFromId();
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
    function export()
    {
        return $this->lib->export();
    }
    function importStage1()
    {
        return $this->lib->importStage1();
    }
    function importStage2()
    {
        return $this->lib->importStage2();
    }
    function deleteMulti()
    {
        $this->lib->deleteMulti();
        return $this->returnToOrigin($_SESSION["moduleParent"]);
    }
    function referentAssignMulti()
    {
        $this->lib->referentAssignMulti();
        return $this->returnToOrigin($_SESSION["moduleParent"]);
    }
    function eventAssignMulti()
    {
        $this->lib->eventAssignMulti();
        return $this->returnToOrigin($_SESSION["moduleParent"]);
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
    function entryMulti()
    {
        $this->lib->entryMulti();
        return $this->returnToOrigin($_SESSION["moduleParent"]);
    }
    function setCountry()
    {
        return $this->lib->setCountry();
    }
    function setCollection()
    {
        return $this->lib->setCollection();
    }
    function setCampaign()
    {
        return $this->lib->setCampaign();
    }
    function setStatus()
    {
        return $this->lib->setStatus();
    }
    function setParent()
    {
        return $this->lib->setParent();
    }
    function getChildren()
    {
        return $this->lib->getChildren();
    }
    function returnToOrigin($origin)
    {
        if (!empty($_REQUEST["moduleFrom"])) {
            return redirect()->route($_REQUEST["moduleFrom"])->withHeaders()->withInput()->withCookies();
        } else {
            if ($origin == "sample") {
                $lib = $this;
            } else {
                $lib = new Container;
            }
            return $lib->list();
        }
    }
}
