<?php

/**
 * Created : 2 févr. 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
class SamplingPlace extends ObjetBDD
{
    private $sql = "select sampling_place_id, sampling_place_name, collection_id, collection_name
                    , sampling_place_code, sampling_place_x, sampling_place_y
                    ,country_id, country_name
                    from sampling_place
                    left outer join collection using (collection_id)
                    left outer join country using (country_id)";
    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "sampling_place";
        $this->colonnes = array(
            "sampling_place_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "sampling_place_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "collection_id" => array(
                "type" => 1
            ),
            "sampling_place_code" => array(
                "type" => 0
            ),
            "sampling_place_x" => array(
                "type" => 1
            ),
            "sampling_place_y" => array(
                "type" => 1
            ),
            "country_id"=>array("type"=>1)
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Teste si un libelle existe deja dans la base
     *
     * @param string $name
     * @return boolean
     */
    function isExists($name)
    {
        $id = 0;
        $name = $this->encodeData($name);
        if (strlen($name) > 0) {
            $sql = "select sampling_place_id from sampling_place where sampling_place_name = :name";
            $id = $this->lireParamAsPrepared($sql, array(
                "name" => $name
            ));
        }
        if ($id > 0) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * Recherche l'identifiant a partir du nom de la station
     *
     * @param string $name
     * @return int
     */
    function getIdFromName($name)
    {
        $id = 0;
        if (strlen($name) > 0) {
            $sql = "select sampling_place_id from sampling_place where sampling_place_name = :name";
            $data = $this->lireParamAsPrepared($sql, array(
                "name" => $name
            ));
            if ($data["sampling_place_id"] > 0) {
                $id = $data["sampling_place_id"];
            }
        }
        return $id;
    }

    /**
     * Retourne la liste des lieux de prelevement attaches a une collection
     *
     * @param int $collection_id
     * @param boolean $with_noaffected
     *            : if true, all non-affected places are associated
     *            at the collection places
     * @return array
     */
    function getListFromCollection($collection_id = 0, $with_noaffected = true)
    {
        $where = "";
        $order = " order by sampling_place_code, sampling_place_name";
        if ( $with_noaffected ) {
            $where = " where collection_id is null";
        }
        if ($with_noaffected && $collection_id > 0) {
            $where .= " or ";
        }
        if ($collection_id > 0) {
            if ($where == "") {
                $where = " where ";
            }
            $where .= " collection_id = :collection_id";
            return $this->getListeParamAsPrepared($this->sql . $where . $order, array(
                "collection_id" => $collection_id
            ));
        } else {
            return $this->getListeParam($this->sql . $where . $order);
        }
    }

    /**
     * Recupere les coordonnees geographiques du lieu de prelevement
     * @param int $sampling_place_id
     * @return array
     */
    function getCoordinates($sampling_place_id) {
        if ($sampling_place_id > 0) {
            $sql = "select sampling_place_x, sampling_place_y from sampling_place
                    where sampling_place_id = :sampling_place_id";
            return $this->lireParamAsPrepared($sql, array("sampling_place_id"=>$sampling_place_id));
        }
    }
}
?>
