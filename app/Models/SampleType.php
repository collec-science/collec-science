<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class SampleType extends PpciModel
{

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    private $sql = "select sample_type_id, sample_type_name,
					container_type_name, sample_type_description, sample_type_code,
					operation_id, operation_name ,operation_version, protocol_name, protocol_year, protocol_version,
					multiple_type_id, multiple_unit, multiple_type_name,
                    metadata_id, metadata_name,
                    identifier_generator_js
					from sample_type
					left outer join container_type using (container_type_id)
					left outer join operation using (operation_id)
					left outer join protocol using (protocol_id)
					left outer join multiple_type using (multiple_type_id)
                    left outer join metadata using (metadata_id)
			";

    function __construct()
    {
        $this->table = "sample_type";
        $this->fields = array(
            "sample_type_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "sample_type_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "container_type_id" => array(
                "type" => 1
            ),
            "operation_id" => array(
                "type" => 1
            ),
            "multiple_type_id" => array(
                "type" => 1
            ),
            "multiple_unit" => array(
                "type" => 0
            ),
            "metadata_id" => array(
                "type" => 0
            ),
            "identifier_generator_js" => array(
                "type" => 0
            ),
            "sample_type_description" => array(
                "type" => 0
            ),
            "sample_type_code" => ["type" => 0]
        );
        parent::__construct();
    }

    /**
     * Ajoute le jeu de métadonnées utilisé
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::getListe()
     */
    function getListe($order = 0): array
    {
        if ($order > 0)
            $tri = " order by $order";
        return $this->getListeParam($this->sql . $tri);
    }
    /**
     * Get the list of sample_types, associated with a collection or orphaned
     *
     * @param integer $collection_id
     * @return array
     */
    function getListFromCollection(int $collection_id = 0): array
    {
        $sql = "select distinct sample_type_id, sample_type_name, multiple_type_id, multiple_type_name, multiple_unit, sample_type_code
                from sample_type
                left outer join multiple_type using (multiple_type_id)";
        $order = " order by sample_type_name";
        $sql1 = $sql . " left outer join collection_sampletype using (sample_type_id)
                         where collection_id = :collection_id:" . $order;
        $sql2 = $sql . " where sample_type_id not in (select distinct sample_type_id from collection_sampletype)" . $order;
        return array_merge(
            $this->getListeParamAsPrepared($sql1, array("collection_id" => $collection_id)),
            $this->getListeParam($sql2)
        );
    }

    /**
     * Retourne le nombre d'échantillons attachés a un echantillon
     *
     * @param int $sample_type_id
     */
    function getNbSample($sample_type_id)
    {
        if ($sample_type_id > 0) {
            $sql = "select count(*) as nb from sample where sample_type_id = :sample_type_id:";
            $var["sample_type_id"] = $sample_type_id;
            $data = $this->lireParamAsPrepared($sql, $var);
            if (count($data) > 0) {
                return $data["nb"];
            } else
                return 0;
        }
    }

    /**
     * Retourne le schéma des métadonnées de l'opération
     *
     * @param int $operation_id
     */
    function getMetadataForm($sample_type_id)
    {
        if ($sample_type_id > 0) {
            $sql = "select metadata_schema
            from sample_type
			join metadata using(metadata_id)
			where sample_type_id = :sample_type_id:";
            $data = $this->lireParamAsPrepared($sql, array(
                "sample_type_id" => $sample_type_id
            ));
            return $data["metadata_schema"];
        }
    }
    function getMetadataSearchable($sample_type_id)
    {
        $data = json_decode($this->getMetadataForm($sample_type_id), true);
        $val = array();
        foreach ($data as $value) {
            if ($value["isSearchable"] == "yes") {
                $val[]["fieldname"] = $value["name"];
            }
        }
        return $val;
    }

    /**
     * Get the metadata form formated as array,
     * with the key of each row is the name of the field
     *
     * @param int $sample_type_id
     * @return array
     */
    function getMetadataAsArray(int $sample_type_id):array {
        $metadata = $this->getMetadataForm($sample_type_id);
        $res = [];
        if (!empty($metadata)) {
            $ma = json_decode($metadata, true);
            foreach ($ma as $v) {
                $res[$v["name"]] = $v;
            }
        }
        return $res;
    }

    function getIdentifierJs($sample_type_id)
    {
        if ($sample_type_id > 0) {
            $sql = "select identifier_generator_js from sample_type
                    where sample_type_id = :sample_type_id:";
            $data = $this->lireParamAsPrepared($sql, array("sample_type_id" => $sample_type_id));
            return $data["identifier_generator_js"];
        }
    }
    /**
     * Get the id of sample_type from its name
     *
     * @param string $name
     * @return integer|null
     */
    function getIdFromName(string $name): ?int
    {
        if (!empty($name)) {
            $sql = "select sample_type_id from sample_type where sample_type_name = :name:";
            $data = $this->lireParamAsPrepared($sql, array("name" => $name));
        }
        if (!empty($data["sample_type_id"])) {
            return ($data["sample_type_id"]);
        } else {
            return (null);
        }
    }
    function getIdFromCode(string $code): ?int
    {
        if (!empty($code)) {
            $sql = "select sample_type_id from sample_type where sample_type_code = :code:";
            $data = $this->lireParam($sql, ["code" => $code]);
        }
        if (!empty($data["sample_type_id"])) {
            return ($data["sample_type_id"]);
        } else {
            return (null);
        }
    }
}
