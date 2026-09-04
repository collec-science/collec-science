<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class OdkChoice extends PpciModel
{
    function __construct()
    {
        $this->table = "odk_choice";
        $this->fields = [
            "odk_choice_id" => [
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
            "list_name" => [
                "type" => 0,
                "requis" => 1,
            ],
            "choice_name" => [
                "type" => 0,
                "requis" => 1,
            ],
            "choice_label" => [
                "type" => 0,
                "requis" => 1,
            ],
            "choice_filter" => [
                "type" => 0
            ],
        ];
        parent::__construct();
    }
    function createChoice(array $data): int
    {
        $content = [];
        foreach ($this->fields as $k => $v) {
            /**
             * add line_ to $data fields if necessary
             */
            if (substr($k, 0, 7) == "choice_") {
                $key = substr($k, 7);
            } else {
                $key = $k;
            }
            $content[$k] = $data[$key];
        }
        return parent::write($content);
    }
}
