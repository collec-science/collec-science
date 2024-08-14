<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class Regulation extends PpciModel
{
    /**
     * __construct
     *
     * @param mixed $bdd
     * @param mixed $param
     *
     * @return mixed
     */
    function __construct()
    {
        $this->table = "regulation";
        $this->fields = array(
            "regulation_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "regulation_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "regulation_comment" => array("type" => 0)
        );
        parent::__construct();
    }
}
