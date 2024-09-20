<?php

namespace Ppci\Models;

class Template extends PpciModel
{
    function __construct()
    {
        $this->table = "tablename";
        $this->fields = array(
            "tablename_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "field1" => array(
                "requis" => 1
            ),
            "field2text" => array(
                "type" => 0,
            ),
            "field3date" => array("type" => 2),
            "field4datetime" => ["type" => 3],
            "field5geom" => ["type" => 4]
        );
        parent::__construct();
    }
}
