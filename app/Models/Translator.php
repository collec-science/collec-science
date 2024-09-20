<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class Translator extends PpciModel
{
    /**
     * Constructor
     *
     * @param PDO $bdd: connection to the database
     * @param array $param: specific parameters
     */
    function __construct()
    {
        $this->table = "translator";
        $this->fields = array(
            "translator_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "translator_name" => array("type" => 0, "requis" => 1),
            "translator_data" => array("type" => 0)
        );
        parent::__construct();
    }
}
