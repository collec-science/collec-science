<?php

namespace App\Models;

use Ppci\Models\PpciModel;
use Ppci\Libraries\PpciException;

class Odk extends PpciModel
{
    function __construct()
    {
        $this->table = "odk";
        $this->fields = array(
            "odk_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "collection_id" => array(
                "type" => 1,
                "requis" => 1
            ),
            "campaign_id" => array(
                "type" => 1,
            ),
            "odk_project" => array(
                "type" => 0
            ),
            "odk_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "odk_author" => array(
                "type" => 0,
                "requis" => 1,
                "defaultValue" => $_SESSION["login"]
            ),
            "odk_description" => array(
                "type" => 0
            ),
            "odk_version" => array(
                "type" => 0,
                "defaultValue" => "1.0",
                "requis" => 1
            ),
            "with_subsampling" => array (
                "type" => 1,
                "defaultValue" => 0
            )
        );
        parent::__construct();
    }

    function getList(string $order = ""): array
    {
        $sql = "SELECT odk_id, collection_id, campaign_id, odk_project, odk_name, odk_author, odk_description, odk_version,
        collection_name, campaign_name, with_subsampling
        from odk
        join collection using (collection_id)
        left outer join campaign using (campaign_id)";
        $where = " WHERE collection_id in (";
        $comma = "";
        $i = 0;
        $param = [];
        foreach ($_SESSION["collections"] as $collection) {
            $where .= $comma . ":colid$i:";
            $comma = ",";
            $param["colid$i"] = $collection["collection_id"];
            $i++;
        }
        $where .= ")";
        return $this->getListParam($sql . $where, $param);
    }
    function write($data): int
    {
        if (empty($data["odk_author"])) {
            $data["odk_author"] = $_SESSION["login"];
        }
        return parent::write($data);
    }

    function writeComp(int $id, array $data)
    {
        /**
         * write tables of referents and stations
         */
        $this->writeTableNN("odk_referent", "odk_id", "referent_id", $id, $data["referents"]);
        $this->writeTableNN("odk_station", "odk_id", "sampling_place_id", $id, $data["stations"]);
        $this->writeTableNN("odk_identifier", "odk_id", "identifier_type_id", $id, $data["identifiers"]);
    }

    function supprimer($id)
    {
        $db = $this->container->db;
        try {
            $db->transBegin();
            $tables = ["odk_referent", "odk_station", "odk_sampletype", "odk_line", "odk_choice"];
            $data = ["id" => $id];
            foreach ($tables as $table) {
                $sql = "DELETE from $table where odk_id = :id:";
                $this->executeSQL($sql, $data, true);
            }
            parent::supprimer($id);
            $db->transCommit();
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            $db->transRollback();
        }
    }

    function getReferents(int $id)
    {
        $sql = "SELECT referent_id, referent_firstname, referent_name
        from odk_referent
        join  referent using (referent_id)
        where odk_id = :id:
        order by referent_name, referent_firstname";
        return $this->getListParam($sql, ["id" => $id]);
    }

    function getAllReferents(int $id)
    {
        $sql = "SELECT r.referent_id, referent_firstname, referent_name,
        case when o.referent_id > 0 then 1 else 0 end as checked
        from referent r
        left outer join odk_referent o on (r.referent_id = o.referent_id and o.odk_id = :id:)
        order by referent_name, referent_firstname
        ";
        return $this->getListParam($sql, ["id" => $id]);
    }

    function getStations(int $id)
    {
        $sql = "SELECT sampling_place_id, sampling_place_name
        from sampling_place
        join odk_station using (sampling_place_id)
        where odk_id = :id:
        order by sampling_place_name";
        return $this->getListParam($sql, ["id" => $id]);
    }

    function getAllStations(int $id, int $collection_id)
    {
        $sql = "
        WITH req as (
        select sampling_place_id, sampling_place_name
        from sampling_place
        where collection_id = :col_id: or collection_id is null)
        select r.sampling_place_id, r.sampling_place_name,
        case when o.sampling_place_id > 0 then 1 else 0 end as checked
        from req r
        left outer join odk_station o on (r.sampling_place_id = o.sampling_place_id and o.odk_id = :id:)
        order by sampling_place_name
        ";
        return $this->getListParam($sql, ["id" => $id, "col_id" => $collection_id]);
    }
    function getIdentifiers(int $id)
    {
        $sql = "SELECT identifier_type_id, identifier_type_name, identifier_type_code
        from identifier_type
        join odk_identifier using (identifier_type_id)
        where odk_id = :id:
        order by identifier_type_name";
        return $this->getListParam($sql, ["id" => $id]);
    }

    function getAllIdentifiers(int $id)
    {
        $sql = "SELECT i.identifier_type_id, identifier_type_name, identifier_type_code,
    case when o.identifier_type_id > 0 then 1 else 0 end as checked
        from identifier_type i
        left outer join odk_identifier o on (i.identifier_type_id = o.identifier_type_id and odk_id = :id:)
        order by identifier_type_name";
        return $this->getListParam($sql, ["id" => $id]);
    }

    function getDetail(int $id)
    {
        $sql = "SELECT odk_id, odk_name, collection_id, collection_name,
        campaign_id, campaign_name, odk_description, odk_version, odk_author, with_subsampling
        from odk 
        join collection using (collection_id)
        left outer join campaign using (campaign_id)
        where odk_id = :id:";
        return $this->readParam($sql, ["id" => $id]);
    }
}
