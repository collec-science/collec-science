<?php

namespace App\Models;

use Ppci\Libraries\PpciException;
use Ppci\Models\Log;
use Ppci\Models\PpciModel;

/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */


class Movement extends PpciModel
{

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    private $sql = "select s.uid, container_id, movement_type_id, movement_type_name,
					movement_date, storage_location, login, movement_comment,
					identifier, o.uid as parent_uid, o.identifier as parent_identifier,
					container_type_id, container_type_name,
					movement_reason_id, movement_reason_name,
                    column_number, line_number
					from movement s
					join movement_type using (movement_type_id)
					left outer join container c using (container_id)
					left outer join object o on (c.uid = o.uid)
					left outer join container_type using (container_type_id)
					left outer join movement_reason using (movement_reason_id)
					";

    private $order = " order by movement_date desc";

    private $where = " where s.uid = :uid:";
    public object $object;
    public Borrowing $borrowing;
    public Container $container;
    public Log $log;

    function __construct()
    {
        $this->table = "movement";
        $this->fields = array(
            "movement_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "uid" => array(
                "type" => 1,
                "requis" => 1,
                "parentAttrib" => 1
            ),
            "container_id" => array(
                "type" => 1
            ),
            "movement_type_id" => array(
                "type" => 1,
                "requis" => 1
            ),
            "movement_reason_id" => array(
                "type" => 1
            ),
            "movement_date" => array(
                "type" => 3,
                "defaultValue" => "getDateHeure"
            ),
            "login" => array(
                "requis" => 1,
                "defaultValue" => $_SESSION["login"]
            ),
            "storage_location" => array(
                "type" => 0
            ),
            "movement_comment" => array(
                "type" => 0
            ),
            "column_number" => array(
                "type" => 1,
                "requis" => 1,
                "defaultValue" => 1
            ),
            "line_number" => array(
                "type" => 1,
                "requis" => 1,
                "defaultValue" => 1
            )
        );
        $this->log = service ("Log");
        parent::__construct();
    }

    /**
     * Retrouve la derniere position connue de l'objet considere
     *
     * @param int $id
     * @return array
     */
    function getLastPosition($uid)
    {
        if (is_numeric($uid) && $uid > 0) {
            return $this->getListeParamAsPrepared(
                $this->sql . $this->where . $this->order . " limit 1",
                array(
                    "uid" => $uid
                )
            );
        }
    }

    /**
     * Retourne le dernier emplacement connu pour un objet
     *
     * @param int $id
     * @return array
     */
    function getLastEntry($id)
    {
        if (is_numeric($id) && $id > 0) {
            $data["uid"] = $id;
            $where = $this->where . " and movement_type_id = 1";
            return $this->getListeParamAsPrepared($this->sql . $where . $this->order . " limit 1", $data);
        }
    }

    /**
     * Retourne tous les mouvements d'un objet
     *
     * @param int $uid
     * @return array
     */
    function getAllMovements($uid)
    {
        if (is_numeric($uid) && $uid > 0) {
            $data["uid"] = $uid;
            return $this->getListeParamAsPrepared($this->sql . $this->where . $this->order, $data);
        }
    }

    /**
     * Fonction generique permettant de rajouter des mouvements
     *
     * @param int $uid
     * @param DateTime $date
     * @param int $type: 1:entry, 2:exit
     * @param int $container_uid
     * @param string $login
     * @param string $storage_location
     * @param string $comment
     * @return int
     */
    function addMovement($uid, $date, $type, $container_uid = 0, $login = null, $storage_location = null, $comment = null, $movement_reason_id = null, $column_number = 1, $line_number = 1)
    {
        /*
         * Verifications
         */
        if (!($uid > 0 && is_numeric($uid))) {
            throw new PpciException(sprintf(_("L'UID n'est pas numérique (%s). "), $uid));
        }
        if ($uid == $container_uid) {
            throw new PpciException(_("Création du mouvement impossible : le numéro de l'objet est égal au numéro du contenant. "));
        }
        if (empty($date)) {
            $this->autoFormatDate = false;
            $date = date('Y-m-d H:i:s');
        }
        if ($type != 1 && $type != 2) {
            throw new PpciException(_("Le type de mouvement n'est pas correct. "));
        }
        if (!is_numeric($container_uid) && strlen($container_uid) > 0) {
            throw new PpciException(_("L'UID du contenant n'est pas numérique. "));
        }
        if (empty($login)) {
            if (!empty($_SESSION["login"])) {
                $login = $_SESSION["login"];
            } else {
                throw new PpciException(_("Le login de l'utilisateur n'est pas connu."));
            }
        }
        if ($type == 1) {
            /*
             * Recherche de container_id a partir de uid
             */
            if (!isset($this->container)) {
                $this->container = new Container;
            }
            $container_id = $this->container->getIdFromUid($container_uid);
            if ($container_id > 0) {
                $data["container_id"] = $container_id;
            } else {
                throw new PpciException(sprintf(_("Pas de contenant correspondant à l'UID %s. "), $container_uid));
            }
        }
        $data["uid"] = $uid;
        $data["movement_date"] = $date;
        $data["movement_type_id"] = $type;
        $data["login"] = $login;
        $data["movement_reason_id"] = $movement_reason_id;

        if (!empty($storage_location)) {
            $data["storage_location"] = $storage_location;
        }
        if (!empty($comment)) {
            $data["movement_comment"] = $comment;
        }
        if (strlen($column_number) == 0) {
            $column_number = 1;
        }
        if (strlen($line_number) == 0) {
            $line_number = 1;
        }
        $data["column_number"] = $column_number;
        $data["line_number"] = $line_number;
        $movement_id = $this->ecrire($data);
        /**
         * Set the last movement in object table
         */
        if (!isset($this->object)) {
            $this->object = new ObjectClass;
        }
        $this->object->setLastMovement($uid, $movement_id);
        /**
         * Change the status if it's 6 (lended) and if the movement is an entry
         * disable the borrowing
         */
        if ($data["movement_type_id"] == 1) {
            $dobject = $this->object->lire($uid);
            if ($dobject["object_status_id"] == 6) {
                /**
                 * Add the return date in borrowing
                 */
                if (!isset($this->borrowing)) {
                    $this->borrowing = new Borrowing;
                }
                $this->borrowing->setReturn($uid, array_shift(explode(" ", $data["movement_date"])), $this->object);
                $this->object->setStatus($uid, 1);
            }
        }
        /**
         * generate log event
         */
        $this->log->setLog($_SESSION["login"], "movement-write", $movement_id);
        return $movement_id;
    }

    /**
     * Retourne le nombre de mouvements impliques dans le controleur fourni
     *
     * @param int $id
     */
    function getNbFromContainer($uid)
    {
        $sql = "select count (*) as nombre from container c
				join movement using (container_id)
				where c.uid = :uid:";
        $data["uid"] = $uid;
        $result = $this->lireParamAsPrepared($sql, $data);
        return $result["nombre"];
    }

    /**
     * Retourne les mouvements realises par un login
     * pour la recherche d'anomalies potentielles
     *
     * @param array $values
     * @return array
     */
    function search($values)
    {
        if (!empty($values["login"])) {
            $login = "%" . strtolower($this->encodeData($values["login"])) . "%";
            $searchByLogin = true;
        } else {
            $searchByLogin = false;
        }
        $data = array();
        $sql = "select s.login, s.uid, identifier, movement_date, movement_type_id, movement_type_name, storage_location, line_number, column_number, movement_comment,
        case when sample_type_name is not null then sample_type_name else container_type_name end as type_name,
        case when sample_type_name is not null then 'sample' else 'container' end as object_type_name
        from movement s
        join object o on (o.uid = s.uid)
        join movement_type using (movement_type_id)
        left outer join sample sp on (o.uid = sp.uid)
        left outer join sample_type using (sample_type_id)
        left outer join container c on (c.uid = s.uid)
        left outer join container_type ct on (ct.container_type_id = c.container_type_id) where ";
        if ($searchByLogin) {
            $sql .= "login like :login: and ";
            $data["login"] = $login;
        }
        $sql .= "movement_date::date between :date_start: and :date_end:
        order by movement_date desc";
        $data["date_start"] = $this->formatDateLocaleVersDB($values["date_start"], 2);
        $data["date_end"] = $this->formatDateLocaleVersDB($values["date_end"], 2);
        return $this->getListeParamAsPrepared($sql, $data);
    }

    /**
     * Delete all movements attached to a container
     *
     * @param int $container_id
     * @return void
     */
    function deleteFromContainer($container_id)
    {
        $sql = "delete from movement where container_id = :container_id:";
        try {
            $this->executeSql($sql, array("container_id" => $container_id),true);
        } catch (\Exception $e) {
            $this->message->setSyslog($e->getMessage(),true);
            throw new PpciException(sprintf(_("La suppression des mouvements associés au container %s a échoué"), $container_id));
        }
    }
}
