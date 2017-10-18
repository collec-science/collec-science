<?php
/**
 * Created : 6 oct. 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
 class DbParam extends ObjetBDD {
     /**
      *
      * @param PDO $bdd
      * @param array $param
      */
     function __construct($bdd, $param = array()) {
         $this->table = "dbparam";
         $this->colonnes = array (
             "dbparam_id" => array (
                 "type" => 1,
                 "key" => 1,
                 "requis" => 1,
                 "defaultValue" => 0
             ),
             "dbparam_name" => array (
                 "type" => 0,
                 "requis" => 1
             ),
             "dbparam_value" => array (
                 "type" => 0,
                 "requis" => 0
             )
         );
         $this->id_auto = 0;
         parent::__construct ( $bdd, $param );
     }
     
     function getParam($name) {
         if (strlen($name) > 0) {
             $sql = "select dbparam_value from dbparam where dbparam_name = :name";
             $data = $this->lireParamAsPrepared($sql, array("name"=>$name));
             return $data["dbparam_value"];
         }
     }
     
     function ecrireGlobal ($data) {
         $this->colonnes["dbparam_name"]["requis"] = 0;
         foreach ($data as $key=>$value) {
             if (substr($key, 0, 2) == "id") {
                 $aval = explode(":",$key);
                 if (is_numeric($aval[1])) {
                     $d = array("dbparam_id"=>$aval[1], "dbparam_value"=>$value);
                     $this->ecrire($d);
                 }
             }
         }
     }
 }
?>