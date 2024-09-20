<?php

namespace App\Libraries;

use App\Models\Collection;
use Ppci\Libraries\PpciLibrary;

class PostLogin extends PpciLibrary
{
    static function index()
    {
        $collection = new Collection;
        $collection->initCollections();
    }
}
