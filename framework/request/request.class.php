<?php

/**
 * Created : 11 déc. 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
/**
 * ORM de gestion de la table request
 * @author quinton
 *
 */
class Request extends ObjetBDD
{
    function __construct($bdd, $param = null)
    {
        $this->table = "request";
        $this->id_auto = 1;
        $this->colonnes = array(
            "request_id" => array(
                "key" => 1,
                "type" => 1,
                "requis" => 1
            ),
            "create_date" => array(
                "type" => 3,
                "defaultValue" => "getDateHeure",
                "requis" => 1
            ),
            "last_exec" => array(
                "type" => 3
            ),
            "title" => array(
                "requis" => 1
            ),
            "body" => array(
                "requis" => 1
            ),
            "login" => array(
                "requis" => 1,
                "defaultValue" => "getLogin"
            ),
            "datefields" => array(
                "type" => 0
            )
        );
        if (! is_array($param)) {
            $param = array();
        }
        parent::__construct($bdd, $param);
    }

    function ecrire($data)
    {
        /*
         * Suppression des contenus dangereux dans la commande SQL
         */
        $data["body"] = str_replace(";", "", $data["body"]);
        $data["body"] = str_replace("--", "", $data["body"]);
        $data["body"] = str_replace("/*", "", $data["body"]);
        return parent::ecrire($data);
    }

    /**
     * Execute a request
     * 
     * @param int $request_id
     * @return array
     */
    function exec($request_id)
    {
        if ($request_id > 0 && is_numeric($request_id)) {
            $req = $this->lire($request_id);
            if (strlen($req["body"]) > 0) {
                $sql = "SELECT " . $req["body"];
                /*
                 * Preparation des dates pour encodage
                 */
                $df = explode(",", $req["datefields"]);
                foreach ($df as $val) {
                    $this->colonnes[$val]["type"] = 3;
                }
                /*
                 * Ecriture de l'heure d'execution
                 */
                $req["last_exec"] = $this->getDateHeure();
                $this->ecrire($req);
                return $this->getListeParam($sql);
            }
        }
    }
}
?>