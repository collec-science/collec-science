<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * Created : 28 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class IdentifierType extends PpciModel
{

    function __construct()
    {
        $this->table = "identifier_type";
        $this->fields = array(
            "identifier_type_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "identifier_type_name" => array(
                "requis" => 1
            ),
            "identifier_type_code" => array(
                "type" => 0
            ),
            "used_for_search" => array(
                "type" => 0,
                "requis" => 1
            )
        );
        parent::__construct();
    }

    /**
     * Retourne uniquement la cle et le code associe
     *
     * @return array
     */
    function getListeWithCode()
    {
        $sql = "select identifier_type_id, identifier_type_code
            from identifier_type
            where identifier_type_code is not null
            order by identifier_type_code";
        return $this->getListeParam($sql);
    }
}
