<?php

/**
 * Created : 24 mai 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
class DbVersion extends ObjetBDD
{

    function __construct($bdd, $param = array())
    {
        $this->table = "container_type";
        $this->colonnes = array(
            "dbversion_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "dbversion_number" => array(
                "type" => 0,
                "requis" => 1
            ),
            "dbversion_date" => array(
                "type" => 2,
                "requis" => 1
            )
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Verifie si la base de donnees est dans la version demandee
     *
     * @param string $version
     * @return boolean
     */
    function verifyVersion($version)
    {
        $retour = false;
        $sql = "select dbversion_id from dbversion where dbversion_number = :version";
        try {
            $result = $this->lireParamAsPrepared($sql, array(
                "version" => $version
            ));
            if ($result["dbversion_id"] > 0) {
                $retour = true;
            }
        } catch (Exception $e) {}
        return $retour;
    }

    /**
     * Recherche la version courante de la base de donnees
     */
    function getLastVersion()
    {
        $sql = "select * from dbversion order by dbversion_date desc limit 1";
        try {
            $result = $this->lireParam($sql);
        } catch (Exception $e) {
            $result = array(
                "dbversion_id" => 0,
                "dbversion_number" => "unknown",
                "dbversion_date" => $this->formatDateDBversLocal("1970-01-01", 2)
            );
        }
        return $result;
    }
}
?>