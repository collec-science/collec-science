<?php

namespace App\Controllers;

use App\Libraries\Campaign;
use App\Libraries\Collection;
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
        if (!(
            $origin == "collection" &&
            ($_SESSION["userRights"]["param"] == 1 || ($_SESSION["userRights"]["collection"] == 1 && !empty($_SESSION["collections"][$_REQUEST["collection_id"]]))
            )
        )) {
            $this->message->set(_("Vous ne disposez pas des droits suffisants pour cette opération"), true);
            $lib = new Collection;
            return $lib->display();
        }
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
        if ($origin == "sample" or $origin == "samples") {
            $lib = new Sample;
        } elseif ($origin == "container" or $origin == "containers") {
            $lib = new Container;
        } elseif ($origin == "campaign") {
            $lib = new Campaign;
        } elseif ($origin == "sampleevent") {
            $lib = new Event;
            $isEvent = true;
        } elseif ($origin == "containerevent") {
            $lib = new Event;
            $isEvent = true;
        } elseif ($origin == "collection") {
            $lib = new Collection;
        }
        if ($isEvent) {
            if ($res) {
                return $lib->display();
            } else {
                return $lib->change();
            }
        } else {
            if ($origin == "samples" || $origin == "containers") {
                return $lib->list();
            } else {
                return $lib->display();
            }
        }
    }
}
