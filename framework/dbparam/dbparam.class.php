<?php

/**
 * Created : 6 oct. 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
class DbParam extends ObjetBDD
{
    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "dbparam";
        $this->colonnes = array(
            "dbparam_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "dbparam_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "dbparam_value" => array(
                "type" => 0,
                "requis" => 0
            )
        );
        $this->id_auto = 0;
        parent::__construct($bdd, $param);
    }

    function getParam($name)
    {
        if (strlen($name) > 0) {
            $sql = "select dbparam_value from dbparam where dbparam_name = :name";
            $data = $this->lireParamAsPrepared($sql, array("name" => $name));
            return $data["dbparam_value"];
        }
    }

      /**
   * Update a parameter
   *
   * @param string $name
   * @param string $value
   * @return void
   */
  function setParameter(string $name, string $value)
  {
    $sql = "update dbparam set dbparam_value = :value where dbparam_name = :name";
    $this->executeAsPrepared($sql, array("name" => $name, "value" => $value), true);
  }

    function ecrireGlobal($data)
    {
        $this->colonnes["dbparam_name"]["requis"] = 0;
        foreach ($data as $key => $value) {
            if (substr($key, 0, 2) == "id") {
                $aval = explode(":", $key);
                if (is_numeric($aval[1])) {
                    $d = array("dbparam_id" => $aval[1], "dbparam_value" => $value);
                    $this->ecrire($d);
                }
            }
        }
    }

    /**
     * Affecte les variables stockees dans la base de donnees dans la session
     */
    function sessionSet()
    {
        $listParam = $this->getListe();
        foreach ($listParam as $param) {
            if (strlen($param["dbparam_value"]) > 0) {
                $_SESSION[$param["dbparam_name"]] = $param["dbparam_value"];
            } else {
                /*
                 * parametres obsoletes dans param.inc.php
                 */
                $_SESSION[$param["dbparam_name"]] = $$param["dbparam_name"];
            }
        }
        $_SESSION["dbparamok"] = true;
    }
}
?>
