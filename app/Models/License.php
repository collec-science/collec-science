<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class License extends PpciModel
{
    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct()
    {
        $this->table = "license";
        $this->fields = array(
            "license_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "license_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "license_url" => array(
                "type" => 0,
                "requis" => 0
            )
        );
        parent::__construct();
    }
}
