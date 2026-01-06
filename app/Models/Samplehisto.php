<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * Classe de gestion de la table referent
 *
 * @var mixed
 */
class Samplehisto extends PpciModel
{

    public array $oldValues = [];
    public int $uid = 0;
    private array $cols = [
        "identifier",
        "wgs84_x",
        "wgs84_y",
        "object_status_id",
        "referent_id",
        "uuid",
        "trashed",
        "location_accuracy",
        "object_comment",
        "collection_id",
        "sample_type_id",
        "sample_creation_date",
        "sampling_date",
        "parent_sample_id",
        "multiple_value",
        "sampling_place_id",
        "dbuid_origin",
        "expiration_date",
        "campaign_id",
        "country_id",
        "country_origin_id"
    ];

    function __construct()
    {
        $this->table = "samplehisto";
        $this->fields = [
            "samplehisto_id" => [
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ],
            "samplehisto_login" => ["requis" => 1],
            "samplehisto_date" => ["type" => 3],
            "sample_id" => ["type" => 1, "parentAttrib" => 1],
            "oldvalues" => ["type" => 0]
        ];
        parent::__construct();
    }
    function initOldValues(int $uid = 0)
    {
        if ($uid > 0) {
            $sql = "SELECT sample_id, identifier, wgs84_x, wgs84_y, object_status_id, referent_id, uuid, trashed, 
                    location_accuracy, object_comment,
                    collection_id, sample_type_id, sample_creation_date, sampling_date,parent_sample_id, multiple_value,
                    sampling_place_id, dbuid_origin, metadata, expiration_date, campaign_id, country_id, country_origin_id
                    FROM object
                    JOIN sample using (uid)
                    where uid = :uid:";
            $this->oldValues = $this->readParam($sql, ["uid" => $uid]);
        } else {
            $this->oldValues = [];
        }
        $this->uid = $uid;
    }
    function generateHisto($data)
    {
        if ($this->uid > 0) {
            $new = [];
            /**
             * general columns
             */
            foreach ($this->cols as $col) {
                if (isset($data[$col]) && $this->oldValues[$col] != $data[$col]) {
                    if (!empty($data[$col]) && empty($this->oldValues[$col])) {
                        $new[$col] = "new";
                    } else {
                        $new[$col] = $this->oldValues[$col];
                    }
                }
            }
            /**
             * metadata columns
             */
            if (isset($data["metadata"])) {
                if (!empty($this->oldValues["metadata"])) {
                    $oldm = json_decode($this->oldValues["metadata"], true);
                } else {
                    $oldm = [];
                }
                $newm = json_decode($data["metadata"], true);
                foreach ($newm as $k => $v) {
                    if ($oldm[$k] != $v) {
                        if (empty($oldm[$k] && !empty($v))) {
                            $new[$k] = "new";
                        } else {
                            $new[$k] = $oldm[$k];
                        }
                    }
                }
                /**
                 * Treatment of deletion
                 */
                foreach ($oldm as $k=>$v) {
                    if (!empty ($v) && !isset($newm[$k])) {
                        $new[$k] = "deleted";
                    }
                }
            }
            $row = $this->getDefaultValues($data["sample_id"]);
            $row["samplehisto_login"] = $_SESSION["login"];
            $row["oldvalues"] = json_encode($new);
            parent::write($row);
        }
    }
}
