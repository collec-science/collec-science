<?php
namespace Ppci\Models;
/**
 * Created : 6 oct. 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
class DbParam extends PpciModel
{
    public $params = [];
    /**
     *
     */
    function __construct()
    {
        $this->table = "dbparam";
        $this->fields = array(
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
            ),
            "dbparam_description" => array(
                "type"=>0
            ),
            "dbparam_description_en" => array(
                "type"=>0
            )
        );
        $this->id_auto = 0;
        parent::__construct();
        $this->readParams();
    }

    function getParam($name)
    {
        if (!empty($name)) {
            return $this->params[$name];
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
    $sql = "update dbparam set dbparam_value = :value: where dbparam_name = :name:";
    $this->executeQuery($sql, array("name" => $name, "value" => $value), true);
    $this->readParams();
  }

    function ecrireGlobal($data)
    {
        $this->disableMandatoryField("dbparam_name");
        $this->disableMandatoryField("dbparam_value");
        foreach ($data as $key => $value) {
            if (substr($key, 0, 2) == "id") {
                $aval = explode(":", $key);
                if (is_numeric($aval[1])) {
                    $d = array("dbparam_id" => $aval[1], "dbparam_value" => $value);
                    $this->ecrire($d);
                }
            }
        }
        $this->readParams();
    }

    function readParams() {
        $data = $this->getList();
        $this->params = [];
        foreach ($data as $param) {
            $this->params[$param["dbparam_name"]] = $param["dbparam_value"] ;
        }
        $_SESSION["dbparams"] = $this->params;
    }
}
