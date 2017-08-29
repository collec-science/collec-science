<?php

/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class SampleType extends ObjetBDD
{

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    private $sql = "select sample_type_id, sample_type_name, 
					container_type_name,
					operation_id, operation_name ,operation_version, protocol_name, protocol_year, protocol_version,
					multiple_type_id, multiple_unit, multiple_type_name,
                    metadata_id, metadata_name
					from sample_type
					left outer join container_type using (container_type_id)
					left outer join operation using (operation_id)
					left outer join protocol using (protocol_id)
					left outer join multiple_type using (multiple_type_id)
                    left outer join metadata using (metadata_id)
			";

    function __construct($bdd, $param = array())
    {
        $this->table = "sample_type";
        $this->colonnes = array(
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
            )
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Ajoute le jeu de métadonnées utilisé
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::getListe()
     */
    function getListe($order = 0)
    {
        if ($order > 0)
            $tri = " order by $order";
        return $this->getListeParam($this->sql . $tri);
    }

    /**
     * Retourne le nombre d'échantillons attachés a un echantillon
     *
     * @param int $sample_type_id
     */
    function getNbSample($sample_type_id)
    {
        if ($sample_type_id > 0) {
            $sql = "select count(*) as nb from sample where sample_type_id = :sample_type_id";
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
			where sample_type_id = :sample_type_id";
            $data = $this->lireParamAsPrepared($sql, array(
                "sample_type_id" => $sample_type_id
            ));
            return $data["metadata_schema"];
        }
    }
}
?>