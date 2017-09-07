<?php

/**
 * Created : 04 mai 2017
 * Creator : hlinyer
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
class Metadata extends ObjetBDD
{

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "metadata";
        $this->colonnes = array(
            "metadata_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "metadata_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "metadata_schema" => array(
                "type" => 0,
                "requis" => 0
            )
        );
        parent::__construct($bdd, $param);
    }

    function getListFromIds($ids)
    {
        $comma = "";
        $sql = "select metadata_id, metadata_name, metadata_schema from metadata";
        $where = " where metadata_id in (";
        foreach ($ids as $id) {
            if (is_numeric($id) && $id > 0) {
                $where .= $comma . $id;
                $comma = ",";
            }
        }
        $where .= ")";
        return $this->getListeParam($sql . $where);
    }
}
?>