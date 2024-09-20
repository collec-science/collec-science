<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class DatasetType extends PpciModel
{
    /**
     * Constructor
     *
     * @param PDO $bdd: connection to the database
     * @param array $param: specific parameters
     */
    function __construct()
    {
        $this->table = "dataset_type";
        $this->fields = array(
            "dataset_type_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "dataset_type_name" => array("type" => 0, "requis" => 1),
            "fields" => array("type" => 0)
        );
        parent::__construct();
    }
}
