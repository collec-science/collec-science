<?php

namespace App\Models;

use Ppci\Libraries\PpciException;
use Ppci\Models\PpciModel;

/**
 * ORM de gestion de la table request
 * @author quinton
 *
 */
class Request extends PpciModel
{
    private $sql = "select request_id, create_date, last_exec, title, body, login, datefields,
            collection_id, collection_name
            from request
            left outer join collection using (collection_id)";
    function __construct()
    {
        $this->table = "request";
        $this->fields = array(
            "request_id" => array(
                "key" => 1,
                "type" => 1,
                "requis" => 1,
                "defaultValue" => 0
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
                "defaultValue" => $_SESSION["login"]
            ),
            "datefields" => array(
                "type" => 0
            ),
            "collection_id" => array("type" => 1)
        );
        parent::__construct();
    }

    /**
     * Get the content of a request, with the collection, if occured
     *
     * @param [type] $id
     * @param boolean $getDefault
     * @param integer $parent_id
     * @return array
     */
    function lire($id, $getDefault = true, $parent_id = 0): array
    {
        if ($id > 0) {
            $where = " where request_id = :request_id:";
            $data = $this->lireParamAsPrepared($this->sql . $where, array("request_id" => $id));
        } else {
            if ($getDefault) {
                $data = $this->getDefaultValues();
            } else {
                $data = array();
            }
        }
        return $data;
    }

    /**
     * Add the collections to the generic function getliste
     *
     * @param string $order
     * @return array
     */
    function getListe($order = ""): array
    {
        !empty($order) ? $orderby = " order by " . $order : $orderby = "";
        return $this->getListeParam($this->sql . $orderby);
    }

    function write($data): int
    {
        /**
         * Search the terms forbiden into the request
         */
        if (preg_match("/(insert)|(update)|(delete)|(grant)|(revoke)|(create)|(drop)|(alter)|(analyze)|(call)|(copy)|(cluster)|(comment)|(describe)|(execute)|(import)|(load)|(lock)|(prepare)|(reassign)|(reindex)|(refresh)|(security)|(set)|(show)|(vacuum)|(explain)|(truncate)|(log)|(logingestion)|(passwordlost)|(acllogin)/i", $data["body"]) == 1) {
            throw new PpciException(_("La requête ne peut pas contenir d'ordres de modification de la base de données ni porter sur des tables contenant des informations confidentielles"));
        }
        /*
         * Suppression des contenus dangereux dans la commande SQL
         */
        $data["body"] = str_replace(";", "", $data["body"]);
        $data["body"] = str_replace("--", "", $data["body"]);
        $data["body"] = str_replace("/*", "", $data["body"]);
        return parent::write($data);
    }

    /**
     * Get the list of requests attached to the list of authorized collections
     *
     * @param array $collections
     * @return array|null
     */
    function getListFromCollections(array $collections): ?array
    {
        $data = array();
        $comma = "";
        if (count($collections) > 0) {
            $where = " where collection_id in (";
            foreach ($collections as $collection) {
                $where .= $comma . $collection["collection_id"];
                $comma = ",";
            }
            $where .= ")";
            $data = $this->getListeParam($this->sql . $where);
        }
        return $data;
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
            if (!empty($req["body"])) {
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
                return $this->getListeParam($req["body"]);
            }
        }
    }
}
