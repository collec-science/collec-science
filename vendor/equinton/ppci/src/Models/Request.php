<?php
namespace Ppci\Models;
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
class Request extends PpciModel
{
    function __construct()
    {
        $this->table = "request";
        $this->fields = array(
            "request_id" => array(
                "key" => 1,
                "type" => 1,
                "requis" => 1,
                "defaultValue"=>0
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
        parent::__construct();
    }

    function ecrire(array $data):int
    {
        /**
         * Search the terms forbiden into the request
         */
        if (preg_match("/(insert)|(update)|(delete)|(grant)|(revoke)|(create)|(drop)|(alter)|(analyze)|(call)|(copy)|(cluster)|(comment)|(describe)|(execute)|(import)|(load)|(lock)|(prepare)|(reassign)|(reindex)|(refresh)|(security)|(set)|(show)|(vacuum)|(explain)|(truncate)|(log)|(logingestion)|(passwordlost)|(acllogin)/i", $data["body"]) == 1) {
            throw new \Ppci\Libraries\PpciException(_("La requête ne peut pas contenir d'ordres de modification de la base de données ni porter sur des tables contenant des informations confidentielles"));
        }
        /*
         * Suppression des contenus dangereux dans la commande SQL
         */
        /*$data["body"] = str_replace(";", "", $data["body"]);
        $data["body"] = str_replace("--", "", $data["body"]);
        $data["body"] = str_replace("/*", "", $data["body"]);*/
        return parent::ecrire($data);
    }

    /**
     * Execute a request
     *
     * @param int $request_id
     * @return array
     */
    function exec(int $request_id)
    {
        $result = array();
        if ($request_id > 0) {
            $req = $this->lire($request_id);
            if (!empty($req["body"])) {
                /*
                 * Preparation des dates pour encodage
                 */
                $df = explode(",", $req["datefields"]);
                foreach ($df as $val) {
                    $this->fields[$val]["type"] = 3;
                }
                /*
                 * Ecriture de l'heure d'execution
                 */
                $req["last_exec"] = $this->getDateHeure();
                $this->ecrire($req);
                $result = $this->getListeParam($req["body"]);
            }
        }
        return $result;
    }
    function getLogin() {
        return $_SESSION["login"];
    }
}