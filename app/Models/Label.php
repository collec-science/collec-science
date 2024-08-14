<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * Created : 8 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Label extends PpciModel
{

    private $sql = "select label_id, label_name, label_xsl, label_fields, identifier_only,
			metadata_id, metadata_schema, metadata_name
            ,barcode_id, barcode_name, barcode_code
			from label
            join barcode using (barcode_id)
			left outer join metadata using(metadata_id)
		";

    function __construct()
    {
        $this->table = "label";
        $this->fields = array(
            "label_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "label_name" => array(
                "requis" => 1
            ),
            "label_xsl" => array(
                "type" => 0,
                "requis" => 1
            ),
            "label_fields" => array(
                "requis" => 1,
                "defaultValue" => 'uid,id,clp,db'
            ),
            "metadata_id" => array(
                "type" => 1,
                "requis" => 0
            ),
            "identifier_only" => array(
                "type" => 1,
                "requis" => 1
            ),
            "barcode_id" => array(
                "type" => 1,
                "requis" => 1,
                "defaultValue" => 1
            )
        );
        parent::__construct();
    }

    function getListe($order = ""): array
    {
        if (!empty($order)) {
            $order = " order by $order";
        } else {
            $order = " order by 1";
        }
        return $this->getListeParam($this->sql . $order);
    }

    /**
     * Surcharge de lire pour ramener le schéma de métadonnées
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::lire()
     */
    function read($label_id, $getDefault = true, $parentValue = 0): array
    {
        $sql = $this->sql . " where label_id = :label_id";
        $data["label_id"] = $label_id;
        if (is_numeric($label_id) && $label_id > 0) {
            return parent::lireParamAsPrepared($sql, $data);
        } else {
            return $this->getDefaultValue();
        }
    }
    /**
     * Get the list of types of containers referenced by the label
     * @param int $label_id
     * @return array
     */
    function getReferencedContainers(int $label_id): array
    {
        $sql = "select container_type_id, container_type_name
                from container_type
                where label_id = :label_id:
                order by container_type_name";
        return $this->executeAsPrepared($sql, array("label_id" => $label_id));
    }
}
