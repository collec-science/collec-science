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

    private $sql = "select label_id, label_name, label_xsl,
			metadata_id, metadata_schema, metadata_name,
            case when logo is not null then 1 else 0 end as has_logo
			from label
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
            "metadata_id" => array(
                "type" => 1
            ),
            "logo" => ["type" => 0]
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
        $sql = "select label_id, label_name, label_xsl,
			metadata_id,  metadata_name,
            case when logo is not null then 1 else 0 end as has_logo,
            count(barcode_name) as nb_optical,
            array_to_string(array_agg(barcode_name),',') as type_optical
			from label
			left outer join metadata using(metadata_id)
			left outer join label_optical using (label_id)
			left outer join barcode using (barcode_id)
			group by label_id, label_name, label_xsl, metadata_id,  metadata_name, has_logo";
        return $this->getListeParam($sql . $order);
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
        $sql = $this->sql . " where label_id = :label_id:";
        $data["label_id"] = $label_id;
        if (is_numeric($label_id) && $label_id > 0) {
            return parent::lireParamAsPrepared($sql, $data);
        } else {
            return $this->getDefaultValues();
        }
    }
    function readRaw(int $label_id) {
        return $this->readParam("select * from label where label_id = :id:", ["id"=>$label_id]);
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
        return $this->getListeParam($sql, array("label_id" => $label_id));
    }
    /**
     * Method writeLogo
     *
     * @param int $label_id
     * @param array $file
     *
     * @return void
     */
    function writeLogo(int $label_id, array $file)
    {
        $dataBinary = fread(fopen($file["tmp_name"], "r"), $file["size"]);
        $image = new \Imagick();
        $image->readImageBlob($dataBinary);
        //$image->setiteratorindex(0);
        $image->setformat("png");
        $sql = "update label set logo = '" . pg_escape_bytea($this->db->connID, $image->getimageblob()) .
            "' where label_id = :id:";
        $this->executeSQL($sql, ["id" => $label_id], true);
    }

    /**
     * get the logo in binary format
     *
     * @param  mixed $label_id
     * @return string:false
     */
    function getLogo(int $label_id)
    {
        $sql = "select logo from label where label_id = :id:";
        $data = $this->readParam($sql, ["id" => $label_id]);
        if (!empty($data["logo"])) {
            return pg_unescape_bytea($data["logo"]);
        } else {
            return false;
        }
    }
}
