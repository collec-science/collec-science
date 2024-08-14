<?php
namespace Ppci\Models;

use Ppci\Libraries\PpciException;
use Ppci\Models\PpciModel;

/**
 * Created : 24 mai 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
class Dbversion extends PpciModel
{

    public function __construct()
    {
        $this->table = "container_type";
        $this->fields = array(
            "dbversion_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0,
            ),
            "dbversion_number" => array(
                "type" => 0,
                "requis" => 1,
            ),
            "dbversion_date" => array(
                "type" => 2,
                "requis" => 1,
            ),
        );
        parent::__construct();
    }

    /**
     * Verifie si la base de donnees est dans la version demandee
     *
     * @param string $version
     * @return boolean
     */
    public function verifyVersion($version)
    {
        $retour = false;
        $sql = "select dbversion_id from dbversion where dbversion_number = :version:";

        $result = $this->lireParamAsPrepared(
            $sql, array(
                "version" => $version,
            )
        );
        if (!empty($result) && $result["dbversion_id"] > 0) {
            $retour = true;
        }
        return $retour;
    }

    /**
     * Search the current version of the database
     */
    public function getLastVersion()
    {
        $sql = "select * from dbversion order by dbversion_date desc limit 1";
        try {
            $result = $this->lireParam($sql);
        } catch (PpciException $e) {
            $result = array(
                "dbversion_id" => 0,
                "dbversion_number" => "unknown",
                "dbversion_date" => $this->formatDateDBversLocal("1970-01-01", 2),
            );
        }
        return $result;
    }
}
