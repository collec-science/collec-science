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
    /**
     * Surcharge de la fonction ecrire pour rajouter la creation de l'index
     * pour les attributs cherchables
     * {@inheritDoc}
     * @see ObjetBDD::ecrire()
     */
    function ecrire($data) {
        $metadata_id = parent::ecrire($data);
        if ($metadata_id > 0) {
            $data=$this->encodeData($data);
            /*
             * Generation des index si un champ est searchable
             */
            $mdata = json_decode($data["metadata_schema"], true);
            foreach ($mdata as $item) {
                if ($item["isSearchable"] == "yes") {
                    /*
                     * Generation de l'index correspondant
                     */
                    $sql = "
                    CREATE INDEX if not exists sample_metadata_lower_".$item["name"]."_idx
                    ON sample using gist(lower((metadata->>'".$item["name"]."')) gist_trgm_ops)";
                    $this->executeSQL($sql);
                }
            }
        }
        return $metadata_id;
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
    
    /**
     * Retourne la liste des metadonnees utilisables pour la recherche
     * @return array
     */
    function getListSearchable() {
        $sql = "with js as 
                (select json_array_elements(metadata_schema::json) elements from metadata)
                select distinct elements->>'name' fieldname
                from js
                where elements->>'isSearchable' = 'yes'
                order by fieldname";
        return $this->getListeParam($sql);
    }
}
?>
