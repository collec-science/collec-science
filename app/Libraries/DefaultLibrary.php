<?php

namespace App\Libraries;

use App\Models\Collection;
use Ppci\Libraries\PpciLibrary;

class DefaultLibrary extends PpciLibrary
{

    function index()
    {
        $this->vue = service("Smarty");
        if (isset($_SESSION["login"])) {
            $collection = new Collection();
            $this->vue->set($collection->getNbsampleByCollection(), "collections");
        }
        $this->vue->set("main.tpl", "corps");
        return $this->vue->send();
    }
}
