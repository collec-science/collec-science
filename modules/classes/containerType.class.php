<?php

/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class ContainerType extends ObjetBDD
{

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "container_type";
        $this->colonnes = array(
            "container_type_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "container_type_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "container_type_description" => array(
                "type" => 0
            ),
            "storage_condition_id" => array(
                "type" => 1
            ),
            "storage_product" => array(
                "type" => 0
            ),
            "clp_classification" => array(
                "type" => 0
            ),
            "label_id" => array(
                "type" => 1
            ),
            "columns" => array(
                "type" => 1,
                "requis" => 1,
                "defaultValue" => 1
            ),
            "lines" => array(
                "type" => 1,
                "requis" => 1,
                "defaultValue" => 1
            ),
            "first_line" => array(
                "type" => 0,
                "requis" => 1,
                "defaultValue" => "T"
            ),
            "nb_slots_max" => array(
                "type" => 1,
                "defaultValue" => 0
            ),
            "first_column" => array(
                "type" => 0,
                "defaultValue" => "L"
            ),
            "line_in_char" => array("type" => 1, "defaultValue" => 0),
            "column_in_char" => array("type" => 1, "defaultValue" => 0)
        );
        parent::__construct($bdd, $param);
    }
    function getListe($order = "")
    {
        $sql = "select container_type_id, translate(container_type_name, '" . $_SESSION["locale"] . "') as container_type_name
                ,container_type_description
                ,storage_condition_id,storage_product
                ,translate(clp_classification, '" . $_SESSION["locale"] . "') as clp_classification
                ,label_id
                ,columns, lines, first_line, nb_slots_max, first_column, line_in_char, column_in_char
                from container_type";
        if (strlen($order) > 0) {
            $sql .= " order by " . $order;
        }
        return parent::getListeParam($sql);
    }
}
