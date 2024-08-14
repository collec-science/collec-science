<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class ExportFormat extends PpciModel
{
    /**
     * Constructor
     *
     * @param PDO $bdd: connection to the database
     * @param array $param: specific parameters
     */
    function __construct()
    {
        $this->table = "export_format";
        $this->fields = array(
            "export_format_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "export_format_name" => array("type" => 0, "requis" => 1)
        );
        parent::__construct();
    }
}
