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
            "list_name"=> [
                "type"=>0,
                "requis"=>1,
            ],
            "choice_name"=> [
                "type"=>0,
                "requis"=>1,
            ],
            "choice_label"=> [
                "type"=>0,
                "requis"=>1,
            ],
            "choice_filter"=> [
                "type"=>0
            ],
        ];
    }
}