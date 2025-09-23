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
            "optical_content" => array(
                "requis" => 1,
                "defaultValue" => 'uuid'
            ),
        );
        parent::__construct();
    }
    function getListToChange(int $label_id)
    {
        $list = $this->getListFromParent($label_id, "label_optical_id");
        for ($i = count($list); $i < 2; $i++) {
            $list[] = $this->getDefaultValues($label_id);
        }
        return $list;
    }
}
