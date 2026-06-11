<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * Created : 14 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Operation extends PpciModel
{

    private $sql = "select operation_id, operation_name, operation_order,operation_version,last_edit_date, operation_code,
					protocol_id, protocol_name, protocol_year, protocol_version
					from operation
					join protocol using (protocol_id)";

    private $order = " order by protocol_year desc, protocol_name, protocol_version,
					operation_order, operation_name";

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct()
    {
        $this->table = "operation";
        $this->fields = array(
            "operation_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "protocol_id" => array(
                "type" => 1,
                "requis" => 1,
                "parentAttrib" => 1
            ),
            "operation_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "operation_order" => array(
                "type" => 1
            ),
            "operation_version" => array(
                "type" => 0
            ),
            "last_edit_date" => array(
                "type" => 3
            ),
            "operation_code" => ["type"=>1]
        );
        parent::__construct();
    }

    /**
     * Retourne la liste des operations associees aux protocoles
     *
     * {@inheritdoc}
     * @see ObjetBDD::getListe()
     */
    function getListe($order = ""): array
    {
        return $this->getListeParam($this->sql . $this->order);
    }

    /**
     * Retourne le nombre d'échantillons attachés a une opération
     *
     * @param int $operation_id
     */
    function getNbSample($operation_id)
    {
        if ($operation_id > 0) {
            $sql = "select count(*) as nb from sample s
            where s.operation_id = :operation_id:";
            $data = $this->lireParamAsPrepared($sql, array(
                "operation_id" => $operation_id
            ));
            if (count($data) > 0) {
                return $data["nb"];
            } else {
                return 0;
            }
        }
    }

    /**
     * Surcharge de la fonction ecrire pour integrer la date de derniere modification
     * 
     * {@inheritdoc}
     * @see ObjetBDD::ecrire()
     */
    function write($data): int
    {
        /*
         * integration de l'heure de modification
         */
        $data["last_edit_date"] = date("Y-m-d H:i:s");
        $this->autoFormatDate = false;
        return parent::write($data);
    }
    
    /**
     * Method getIdFromCode
     * 
     * get the operationId from operationCode
     *
     * @param string $code 
     *
     * @return int|null
     */
    function getIdFromCode (string $code) {
        $sql = "SELECT operation_id from operation where operation_code = :code:";
        $res = $this->readParam($sql, ["code"=>$code]);
        return $res["operation_id"];
    }
}
