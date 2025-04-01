<?php

namespace Ppci\Models;

use Ppci\Libraries\PpciException;

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
                "defaultValue" => "getLogin"
            ),
            "datefields" => array(
                "type" => 0
            )
        );
        parent::__construct();
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

            $body = trim($req["body"]);
            $body = preg_replace("/[\t\s]+/", " ", $body);
            $words = [
                'insert',
                'update',
                'delete',
                'grant',
                'revoke',
                'create',
                'drop',
                'alter',
                'analyze',
                'call',
                'copy',
                'cluster',
                'comment on',
                'describe',
                'execute',
                'import',
                'load',
                'lock',
                'prepare',
                'reassign',
                'reindex',
                'refresh',
                'security',
                'set',
                'show',
                'vacuum',
                'explain',
                'truncate',
                'gacl\.log',
                ' log',
                ',log',
                '"log',
                'logingestion',
                'passwordlost',
                'acllogin'
            ];
            foreach ($words as $word) {
                if (preg_match("/$word/i", $body) == 1) {
                    throw new PpciException(sprintf(_("La requête ne peut pas contenir le terme %s"), $word));
                }
            }
            if (!empty($req["body"])) {
                /*
                 * Preparation des dates pour encodage
                 */
                $df = explode(",", $req["datefields"]);
                foreach ($df as $val) {
                    $this->datetimeFields[] = $val;
                }
                /*
                 * Ecriture de l'heure d'execution
                 */
                $req["last_exec"] = $this->getDateTime();
                $this->write($req);
                $result = $this->getListParam($req["body"]);
            }
        }
        return $result;
    }
    function getLogin()
    {
        return $_SESSION["login"];
    }
}
