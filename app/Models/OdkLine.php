<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class OdkLine extends PpciModel
{
    function __construct()
    {
        $this->table = "odk_line";
        $this->fields = [
            "odk_line_id" => [
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ],
            "odk_id" => [
                "type" => 1,
                "requis" => 1,
                "parentAttrib" => 1
            ],
            "line_order" => [
                "type" => 1,
                "requis" => 1,
                "defaultValue" => 1
            ],
            "line_type" => [
                "type" => 0,
                "requis" => 1,
            ],
            "line_name" => [
                "type" => 0,
            ],
            "line_label" => [
                "type" => 0
            ],
            "line_default" => [
                "type" => 0
            ],
            "line_required" => [
                "type" => 0
            ],
            "line_relevant" => [
                "type" => 0
            ],
            "line_constraint" => [
                "type" => 0
            ],
            "line_constraint_message" => [
                "type" => 0
            ],
            "line_appearance" => [
                "type" => 0
            ],
            "line_calculation" => [
                "type" => 0
            ],
            "line_hint" => [
                "type" => 0
            ],
            "line_read_only" => [
                "type" => 0
            ],
            "line_choice_filter" => [
                "type" => 0
            ],
            "line_repeat_count" => [
                "type" => 0
            ],
            "line_parameters" => [
                "type" => 0
            ],

        ];
        parent::__construct();
    }

    function createLine(array $data): int
    {
        $content = [];
        foreach ($this->fields as $k => $v) {
            /**
             * add line_ to $data fields if necessary
             */
            if (substr($k, 0, 5) == "line_") {
                $key = substr($k,  5);
            } else {
                $key = $k;
            }
            $content[$k] = $data[$key];
        }
        return parent::write($content);
    }
}
