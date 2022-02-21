<?php

/**
 * Created : 15 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Subsample extends ObjetBDD
{
    private $sql = "select subsample_id, sample_id, subsample_date,
                    movement_type_id, subsample_quantity, subsample_comment,
                    subsample_login,
                    multiple_unit,
                    borrower_id, borrower_name
                    , uid, identifier
            from subsample
            join sample using (sample_id)
            join object using (uid)
            join sample_type using (sample_type_id)
            left outer join borrower using (borrower_id)
            ";

    public function __construct($bdd, $param = array())
    {
        $this->table = "subsample";
        $this->colonnes = array(
            "subsample_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0,
            ),
            "sample_id" => array(
                "type" => 1,
                "requis" => 1,
                "parentAttrib" => 1,
            ),
            "subsample_date" => array(
                "type" => 3,
                "requis" => 1,
                "defaultValue" => "getDateHeure",
            ),
            "movement_type_id" => array(
                "type" => 1,
                "requis" => 1,
                "defaultValue" => 1,
            ),
            "subsample_quantity" => array(
                "type" => 1,
            ),
            "subsample_comment" => array(
                "type" => 0,
            ),
            "subsample_login" => array(
                "type" => 0,
                "defaultValue" => "getLogin",
            ),
            "borrower_id" => array(
                "type" => 1
            )
        );
        parent::__construct($bdd, $param);
    }
    /**
     * Surcharge de la fonction lire pour recuperer l'unite de sous-echantillonnage
     *
     * {@inheritDoc}
     *
     * @see ObjetBDD::lire()
     */
    public function lire($subsample_id, $getDefault, $parentValue)
    {
        $sql = $this->sql . " where subsample_id = :subsample_id";
        $data["subsample_id"] = $subsample_id;
        if (is_numeric($subsample_id) && $subsample_id > 0) {
            $retour = parent::lireParamAsPrepared($sql, $data);
        } else {
            $retour = parent::getDefaultValue($parentValue);
            /*
             * Recherche de l'unite des sous-échantillons
             */
            include_once 'modules/classes/sample.class.php';
            $sample = new Sample($this->connection);
            $dataSample = $sample->lireFromId($parentValue);
            $retour["multiple_unit"] = $dataSample["multiple_unit"];
        }
        return $retour;
    }

    /**
     * Get the list of subsamplings borrowed
     *
     * @param integer $borrower_id
     * @return array|null
     */
    public function getListFromBorrower(int $borrower_id): ?array
    {
        $where = " where borrower_id = :borrower_id";
        $this->colonnes["subsample_date"]["type"] = 2;
        return $this->getListeParamAsPrepared($this->sql . $where, array("borrower_id" => $borrower_id));
    }

    /**
     * Get the list of subsamples from a sample_id
     *
     * @param integer $sample_id
     * @return array|null
     */
    function getListFromSample(int $sample_id): ?array
    {
        $where = " where sample_id = :sample_id";
        return $this->getListeParamAsPrepared($this->sql.$where, array("sample_id" => $sample_id));
    }
}
