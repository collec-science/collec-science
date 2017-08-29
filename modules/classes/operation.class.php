<?php

/**
 * Created : 14 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Operation extends ObjetBDD
{

    private $sql = "select operation_id, operation_name, operation_order,operation_version,last_edit_date,
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
    function __construct($bdd, $param = array())
    {
        $this->table = "operation";
        $this->colonnes = array(
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
            )
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Retourne la liste des operations associees aux protocoles
     *
     * {@inheritdoc}
     * @see ObjetBDD::getListe()
     */
    function getListe()
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
            $sql = "select count(*) as nb from sample s, sample_type st where s.sample_type_id = st.sample_type_id and st.operation_id = :operation_id";
            $data = $this->lireParamAsPrepared($sql, array("operation_id"=>$operation_id));
            if (count($data) > 0) {
                return $data["nb"];
            } else
                return 0;
        }
    }

     /**
     * Surcharge de la fonction ecrire pour integrer la date de derniere modification
     * {@inheritDoc}
     * @see ObjetBDD::ecrire()
     */
    function ecrire($data) {
        /*
         * integration de l'heure de modification
         */
        $data["last_edit_date"] = date ("Y-m-d H:i:s");
        $this->auto_date = 0;
        return parent::ecrire($data);
    }
}
?>