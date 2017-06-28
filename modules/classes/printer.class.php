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
                "printer_local" => array (
                        "type" => 0,
                        "requis" => 1,
                ),
                "printer_site" => array (
                        "type" => 0
                ),
                "printer_room" => array (
                        "type" => 0
                ),
                "printer_ip" => array (
                        "type" => 0 
                ),
                "printer_port" => array (
                        "type" => 1
                ),
                "printer_ssh_path" => array (
                        "type" => 0
                ),
                "printer_user" => array (
                        "type" => 0 
                ),
                "printer_usage" => array (
                        "type" => 0 
                )
        );
        parent::__construct ( $bdd, $param );
    }
    /**
     * Récupére le nom d'une imprimante à partir de son id
     *
     * @param $id
     */
    function getNameFromId($id) {
        if ($id > 0 && is_numeric ( $id )) {
            $sql = "select printer_name from printer
            where printer_id = :id";
            $var ["id"] = $id;
            $data =$this->lireParamAsPrepared ( $sql, $var );
            return $data["printer_name"];
        }
    }
}