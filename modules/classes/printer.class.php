<?php
/**
*Created : 27 Juin 2017
*/
class Printer extends ObjetBDD {
    private $sql = "select * from printer";

    /**
     *
     * @param PDO $bdd          
     * @param array $param          
     */
    function __construct($bdd, $param = array()) {
        $this->table = "printer";
        $this->colonnes = array (
            "printer_id" => array(
                        "type"=>1,
                        "key"=>1,
                        "requis"=>1,
                        "defaultValue"=>0
                ),
                "printer_name" => array (
                        "type" => 0,
                        "requis" => 1
                ),
                "printer_queue" => array (
                        "type" => 0,
                        "requis" => 1,
                ),
                "printer_server" => array (
                        "type" => 0
                ),
                "printer_user" => array (
                        "type" => 0
                ),
                "printer_comment" => array (
                        "type" => 0
                )
        );
        parent::__construct ( $bdd, $param );
    }
 }