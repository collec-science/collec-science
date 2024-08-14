<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * ORM for table barcode
 */
class Barcode extends PpciModel
{
    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct()
    {
        $this->table = "barcode";
        $this->fields = array(
            "barcode_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "barcode_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "barcode_code" => array(
                "type" => 0,
                "requis" => 1
            )
        );
        parent::__construct();
    }
}
