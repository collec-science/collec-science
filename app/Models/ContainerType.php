<?php 
namespace App\Models;
use Ppci\Models\PpciModel;

/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class ContainerType extends PpciModel
{

    private $sql = "select *
			from container_type
			join container_family using (container_family_id)
			left outer join storage_condition using (storage_condition_id)
			left outer join label using (label_id)
            left outer join product using (product_id)
            left outer join risk using (risk_id)";

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct()
    {
        $this->table = "container_type";
        $this->fields = array(
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
            "container_family_id" => array(
                "type" => 1,
                "requis" => 1,
                "parentAttrib" => 1
            ),
            "container_type_description" => array(
                "type" => 0
            ),
            "storage_condition_id" => array(
                "type" => 1
            ),
            "product_id" => array(
                "type" => 1
            ),
            "risk_id" => array(
                "type" => 1
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
            "column_in_char" => array("type" => 1, "defaultValue" => 0),
            "nbobject_by_slot" => array("type"=>1, "defaultValue" => 0)
        );
        parent::__construct();
    }

    function getListe($field = ""):array
    {
        $order = "";
        if (($field > 0 && is_numeric($field)) || !empty($field)) {
            $order = " order by $field";
        }
        return parent::getListeParam($this->sql . $order);
    }
}
