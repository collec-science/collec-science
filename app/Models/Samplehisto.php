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
        "identifiers",
        "collection_id",
        "object_status_id",
        "sample_type_id",
        "multiple_value",
        "referent_id",
        "sampling_date",
        "expiration_date",
        "parent_sample_id",
        "dbuid_origin",
        "object_comment",
        "campaign_id",
        "sampling_place_id",
        "country_id",
        "country_origin_id",
        "wgs84_x",
        "wgs84_y",
        "location_accuracy",
        "uuid",
        "trashed",
    ];
    public $header = [
        "date",
        "login",
        "identifier",
        "identifiers",
        "movements",
        "collection_name",
        "object_status_name",
        "sample_type_name",
        "multiple_value",
        "referent_name",
        "sampling_date",
        "expiration_date",
        "parent_uid",
        "dbuid_origin",
        "object_comment",
        "campaign_name",
        "sampling_place_name",
        "country_name",
        "country_origin_name",
        "wgs84_x",
        "wgs84_y",
        "location_accuracy",
        "uuid",
        "trashed"
    ];
    public Sample $sample;

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
            $sql = "SELECT sample_id, identifier, wgs84_x, wgs84_y, object_status_id, referent_id, uuid, 
                    case when trashed = 't' then '1' else '0' end as trashed, 
                    location_accuracy, object_comment,
                    collection_id, sample_type_id, sample_creation_date, sampling_date,parent_sample_id, multiple_value,
                    sampling_place_id, dbuid_origin, metadata, expiration_date, campaign_id, country_id, country_origin_id
                    FROM object
                    JOIN sample using (uid)
                    where uid = :uid:";
            $this->oldValues = $this->readParam($sql, ["uid" => $uid]);
            /**
             * Get secondary identifiers
             */
            $identifier = new ObjectIdentifier;
            $this->oldValues["identifiers"] = $identifier->getIdentifiers($uid);
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
             * Format dates in db format
             */
            foreach (["sample_creation_date", "sampling_date", "expiration_date"] as $field) {
                if (!empty($data[$field])) {
                    $data[$field] = $this->formatDateTimeLocaleToDB($data[$field]);
                }
            }
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
             * Secundary identifiers
             */
            $identifier = new ObjectIdentifier;
            $ids = $identifier->getIdentifiers($this->uid);
            if ($ids != $this->oldValues["identifiers"]) {
                if (empty($this->oldValues["identifiers"])) {
                    $new["identifiers"] = "new";
                } else {
                    $new["identifiers"] = $this->oldValues["identifiers"];
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
                $metadata = [];
                foreach ($newm as $k => $v) {
                    if ($oldm[$k] != $v) {
                        if (empty($oldm[$k] && !empty($v))) {
                            $metadata[$k] = "new";
                        } else {
                            $metadata[$k] = $oldm[$k];
                        }
                    }
                }
                /**
                 * Treatment of deletion
                 */
                foreach ($oldm as $k => $v) {
                    if (!empty($v) && !isset($newm[$k])) {
                        $metadata[$k] = "deleted";
                    }
                }
                if (!empty($metadata)) {
                    $new["metadata"] = $metadata;
                }
            }
            if (!empty($new)) {
                if (empty($data["sample_id"])) {
                    $sql = "select sample_id from sample where uid = :uid:";
                    $res = $this->readParam($sql, ["uid" => $this->uid]);
                    $data["sample_id"] = $res["sample_id"];
                }
                if (!empty($data["sample_id"])) {
                    $row = $this->getDefaultValues($data["sample_id"]);
                    $row["samplehisto_login"] = $_SESSION["login"];
                    $row["oldvalues"] = json_encode($new);
                    parent::write($row);
                }
            }
        }
    }

    /**
     * Method getHisto: get the content of history from a sample
     *
     * @param array $currentData 
     *
     * @return array
     */
    function getHisto($currentData, array $movements = []): array
    {
        //date_default_timezone_set('Europe/Paris');
        $data = [];
        /**
         * generate the first line, with current data
         */
        $colsRef = [
            "object_status_id" => "object_status_name",
            "referent_id" => "referent_name",
            "collection_id" => "collection_name",
            "parent_sample_id" => "parent_uid",
            "sample_type_id" => "sample_type_name",
            "sampling_place_id" => "sampling_place_name",
            "campaign_id" => "campaign_name",
            "country_id" => "country_name",
            "country_origin_id" => "country_origin_name"
        ];
        $objectStatus = new ObjectStatus;
        $sampleType = new SampleType;
        $samplingPlace = new SamplingPlace;
        $campaign = new Campaign;
        $country = new Country;
        $referent = new Referent;
        $row = [
            "date" => date($_SESSION["date"]["maskdatelong"]),
            "login" => _("Valeurs actuelles")
        ];
        foreach ($this->cols as $col) {
            if (!str_ends_with($col, "_id")) {
                $row[$col] = $currentData[$col];
            } else {
                $row[$colsRef[$col]] = $currentData[$colsRef[$col]];
            }
        }
        /**
         * Add metadata
         */
        if (!empty($currentData["metadata"])) {
            $metadata = json_decode($currentData["metadata"], true);
            foreach ($metadata as $k => $v) {
                $row[$k] = $v;
                $this->header[] = $k;
            }
        }
        /**
         * Add secondary identifiers
         */
        $objectIdentifier = new ObjectIdentifier;
        $row["identifiers"] = $objectIdentifier->getIdentifiers($currentData["uid"]);
        $data[] = $row;
        $sql = "SELECT samplehisto_login, date_trunc('second',samplehisto_date) as samplehisto_date, oldvalues
                from samplehisto
                where sample_id = :id:";
        $histos = $this->getListParam($sql, ["id" => $currentData["sample_id"]]);
        foreach ($histos as $histo) {
            $row = [
                "date" => $histo["samplehisto_date"],
                "login" => $histo["samplehisto_login"]
            ];
            $histodata = json_decode($histo["oldvalues"], true);
            foreach ($histodata as $k => $v) {
                if ($v == "new") {
                    if (array_key_exists($k, $colsRef)) {
                        $row[$colsRef[$k]] = _("Donnée créée");
                    } else {
                        $row[$k] = _("Donnée créée");
                    }
                } else {
                    if (in_array($k, ["sample_creation_date", "sampling_date", "expiration_date"])) {
                        $v = $this->formatDatetimeDBversLocal($v);
                    }
                    if (array_key_exists($k, $colsRef)) {
                        if ($k == "object_status_id") {
                            $tbcontent = $objectStatus->read($v);
                            $row[$colsRef[$k]] = $tbcontent[$colsRef[$k]];
                        } elseif ($k == "referent_id") {
                            $tbcontent = $referent->read($v);
                            $row[$colsRef[$k]] = $tbcontent[$colsRef[$k]];
                        } elseif ($k == "sample_type_id") {
                            $tbcontent = $sampleType->read($v);
                            $row[$colsRef[$k]] = $tbcontent[$colsRef[$k]];
                        } elseif ($k == "sampling_place_id") {
                            $tbcontent = $samplingPlace->read($v);
                            $row[$colsRef[$k]] = $tbcontent[$colsRef[$k]];
                        } elseif ($k == "campaign_id") {
                            $tbcontent = $campaign->read($v);
                            $row[$colsRef[$k]] = $tbcontent[$colsRef[$k]];
                        } elseif ($k == "country_id" || $k == "country_origin_id") {
                            $tbcontent = $country->read($v);
                            $row[$colsRef[$k]] = $tbcontent[$colsRef[$k]];
                        } elseif ($k == "parent_sample_id") {
                            $tbcontent = $this->sample->readFromId($v);
                            $row[$colsRef[$k]] = $tbcontent["uid"];
                        }
                    } elseif ($k != "metadata") {
                        $row[$k] = $v;
                    } else {
                        /**
                         * Treatment of metadata
                         */
                        foreach ($v["metadata"] as $km => $vm) {
                            if ($v == "new") {
                                $row[$k] = _("Donnée créée");
                            } else {
                                $row[$km] = $vm;
                            }
                            if (!in_array($km, $this->header)) {
                                $this->header[] = $km;
                            }
                        }
                    }
                }
            }
            $data[] = $row;
        }
        /**
         * Treatment of movements
         */
        foreach ($movements as $m) {
            $row = ["date" => $m["movement_date"]];
            $m["movement_type_id"] == 1 ? $content = _("Déplacement") : $content = _("Sortie du stock");
            $row["movements"] = $content;
            $data[] = $row;
        }
        return $data;
    }
}
