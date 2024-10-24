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
        $this->lib->deleteMulti(false);
        return $this->returnToOrigin($_SESSION["moduleParent"]);
    }
    function deleteMultiWithChildren()
    {
        $this->lib->deleteMulti(true);
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
        $this->lib->setCountry();
        return $this->returnToOrigin($_SESSION["moduleParent"]);
    }
    function setCollection()
    {
        $this->lib->setCollection();
        return $this->returnToOrigin($_SESSION["moduleParent"]);
    }
    function setCampaign()
    {
        $this->lib->setCampaign();
        return $this->returnToOrigin($_SESSION["moduleParent"]);
    }
    function setStatus()
    {
        $this->lib->setStatus();
        return $this->returnToOrigin($_SESSION["moduleParent"]);
    }
    function setParent()
    {
        $this->lib->setParent();
        return $this->returnToOrigin($_SESSION["moduleParent"]);
    }
    function getChildren()
    {
        return $this->lib->getChildren();
    }
    function createComposite() {
        $this->lib->createComposite();
        return $this->list();   
    }
    function returnToOrigin($origin)
    {
        if (!empty($_REQUEST["moduleFrom"])) {
            $_SESSION["filterMessages"] = $this->message->get();
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
