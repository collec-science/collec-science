<?php

namespace App\Libraries;

use App\Models\Collection;
use Ppci\Libraries\PpciLibrary;

class Elab extends PpciLibrary
{

    function display()
    {
        $this->vue = service('Smarty');
        if (!empty($_POST["collection_id"])) {
            $this->vue->set($_POST["collection_id"], "collection_id");
            $this->vue->set($_POST["event_type_id"], "event_type_id");
        }
        $collection = new Collection;
        $this->vue->set($collection->getCollectionsFromLogin(), "collections");
        $this->vue->set("gestion/elab.tpl", "corps");
        return $this->vue->send();
    }
}
