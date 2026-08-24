<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class OdkSampletype extends PpciModel
{
    function __construct()
    {
        $this->table = "odk_sampletype";
        $this->fields = [
            "odk_sampletype_id" => [
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
            "sample_type_id" => [
                "type" => 1,
                "requis" => 1
            ],
            "parent_sampletype_id" => [
                "type" => 1,
            ],
            "sampletype_order" => [
                "type" => 1,
                "requis" => 1,
                "defaultValue" => 1
            ],
            "image_number" => [
                "type" => 1,
                "defaultValue" => -1
            ],
            "sound_number" => [
                "type" => 1,
                "defaultValue" => -1
            ],
            "video_number" => [
                "type" => 1,
                "defaultValue" => -1
            ],
        ];
    }
}
