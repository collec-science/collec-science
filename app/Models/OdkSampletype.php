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
            "identifier_prefix" => [
                "type" => 0
            ]
        ];
        parent::__construct();
    }

    function getListFromOdk(int $id)
    {
        $sql = "SELECT odk_sampletype_id, odk_id, sample_type_id, sample_type_name, 
                sampletype_order, image_number, sound_number, video_number,
                identifier_prefix, metadata_schema,
                multiple_type_id, multiple_type_name, multiple_unit
                from odk_sampletype
                join sample_type using (sample_type_id)
                left outer join metadata using (metadata_id)
                left outer join multiple_type using (multiple_type_id)
                where odk_id = :id:
                order by sampletype_order";
        return $this->getListParam($sql, ["id" => $id]);
    }
}
