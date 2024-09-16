<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * Created : 15 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Subsample extends PpciModel
{
    private $sql = "select subsample_id, s.sample_id, subsample_date,
                    movement_type_id, subsample_quantity, subsample_comment,
                    subsample_login,
                    multiple_unit,
                    borrower_id, borrower_name
                    , s.uid, o.identifier
                    ,co.uid as created_uid, co.identifier as created_identifier
            from subsample ss
            join sample s on (s.sample_id = ss.sample_id)
            join object o on (o.uid = s.uid)
            join sample_type st on (st.sample_type_id = s.sample_type_id)
            left outer join borrower using (borrower_id)
            left outer join sample cs on (cs.sample_id = ss.createdsample_id)
            left outer join object co on (cs.uid = co.uid)
            ";

    public function __construct()
    {
        $this->table = "subsample";
        $this->fields = array(
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
                "defaultValue" => $_SESSION["login"],
            ),
            "borrower_id" => array(
                "type" => 1
            )
        );
        parent::__construct();
    }
    /**
     * Surcharge de la fonction lire pour recuperer l'unite de sous-echantillonnage
     *
     * {@inheritDoc}
     *
     * @see ObjetBDD::lire()
     */
    public function read($subsample_id, $getDefault = true, $parentValue = 0): array
    {
        $sql = $this->sql . " where subsample_id = :subsample_id:";
        $data["subsample_id"] = $subsample_id;
        if (is_numeric($subsample_id) && $subsample_id > 0) {
            $retour = parent::lireParamAsPrepared($sql, $data);
        } else {
            $retour = parent::getDefaultValues($parentValue);
            /*
             * Recherche de l'unite des sous-échantillons
             */
            $sample = new Sample;
            $dataSample = $sample->readFromId($parentValue);
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
        $where = " where borrower_id = :borrower_id:";
        $this->fields["subsample_date"]["type"] = 2;
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
        $where = " where s.sample_id = :sample_id:";
        return $this->getListeParamAsPrepared($this->sql . $where, array("sample_id" => $sample_id));
    }
}
