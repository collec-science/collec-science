<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class LabelOptical extends PpciModel
{
    function __construct()
    {
        $this->table = "label_optical";
        $this->fields = array(
            "label_optical_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "label_id" => [
                "type" => 1,
                "requis" => 1,
                "parentAttrib" => 1
            ],
            "barcode_id" => array(
                "type" => 1,
                "requis" => 1,
                "defaultValue" => 1
            ),
            "content_type" => array(
                "type" => 1,
                "requis" => 1,
                "defaultValue" => 2
            ),
            "radical" => array(
                "type" => 0
            ),
            "label_content" => array(
                "requis" => 1,
                "defaultValue" => 'uuid'
            ),
        );
        parent::__construct();
    }
}
