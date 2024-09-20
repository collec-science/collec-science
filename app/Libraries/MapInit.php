<?php

namespace App\Libraries;

class MapInit
{
    static function setDefault($vue)
    {
        foreach (array("mapDefaultX", "mapDefaultY", "mapDefaultZoom") as $field) {
            $vue->set($_SESSION["dbparams"][$field], $field);
        }
    }
}
