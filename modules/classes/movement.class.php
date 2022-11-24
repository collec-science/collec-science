<?php

/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/container.class.php';

class MovementException extends Exception
{ }

class Movement extends ObjetBDD
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

    private $where = " where s.uid = :uid";

    function __construct($bdd, $param = array())
    {
        $this->table = "movement";
        $this->colonnes = array(
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
                "defaultValue" => "getLogin"
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
        parent::__construct($bdd, $param);
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
            return $this->getListeParamAsPrepared($this->sql . $this->where . $this->order . " limit 1", array(
                "uid" => $uid
            ));
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
     * Retourne la liste de tous les contenants parents
     *
     * @param int $uid
     * @throws Exception
     * @return array
     */
    function getParents($uid)
    {
        if (is_numeric($uid) && $uid > 0) {
            $retour = array();
            $data["uid"] = $uid;
            $continue = true;
            try {
                /*
                 * Preparation de la requete
                 */
                $stmt = $this->connection->prepare($this->sql . $this->where . $this->order . " limit 1");
                while ($continue) {
                    if ($stmt->execute($data)) {
                        $result = $stmt->fetch(PDO::FETCH_ASSOC);
                        $retour[] = $result;
                        if ($result["parent_uid"] > 0) {
                            $data["uid"] = $result["parent_uid"];
                        } else {
                            $continue = false;
                        }
                    } else {
                        $continue = false;
                    }
                }
                return $retour;
            } catch (PDOException $e) {
                $this->lastResultExec = false;
                if ($this->debug_mode > 0) {
                    $this->addMessage($e->getMessage());
                }
                throw new MovementException($e->getMessage());
            }
        }
    }

    /**
     * Fonction generique permettant de rajouter des mouvements
     *
     * @param int $uid
     * @param DateTime $date
     * @param int $type: 1:entry, 2:exit
     * @param number $container_uid
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
        $controle = true;
        if (!($uid > 0 && is_numeric($uid))) {
            $message = sprintf(_("L'UID n'est pas numérique (%s). "), $uid);
            $controle = false;
        }
        if ($uid == $container_uid) {
            $controle = false;
            $message .= _("Création du mouvement impossible : le numéro de l'objet est égal au numéro du contenant. ");
        }
        $date = $this->encodeData($date);
        if (empty($date)) {
            $date = date($_SESSION["MASKDATELONG"]);
        }
        if ($type != 1 && $type != 2) {
            $controle = false;
            $message .= _("Le type de mouvement n'est pas correct. ");
        }
        $container_uid = $this->encodeData($container_uid);
        if (!is_numeric($container_uid) && strlen($container_uid) > 0) {
            $message .= _("L'UID du contenant n'est pas numérique. ");
            $controle = false;
        }
        if (empty($login) ) {
            if (!empty($_SESSION["login"]) ) {
                $login = $_SESSION["login"];
            } else {
                $controle = false;
                $message .= _("Le login de l'utilisateur n'est pas connu.");
            }
        }
        $storage_location = $this->encodeData($storage_location);
        $comment = $this->encodeData($comment);
        $movement_reason_id = $this->encodeData($movement_reason_id);
        if ($type == 1) {
            /*
             * Recherche de container_id a partir de uid
             */
            $container = new Container($this->connection, $this->param);
            $container_id = $container->getIdFromUid($container_uid);
            if ($container_id > 0) {
                $data["container_id"] = $container_id;
            } else {
                $message .= sprintf(_("Pas de contenant correspondant à l'UID %s. "), $container_uid);
                $controle = false;
            }
        }
        if ($controle) {
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
             * Change the status if it's 6 (lended) and if the movement is an entry
             * disable the borrowing
             */
            if ($data["movement_type_id"] == 1) {
                include_once "modules/classes/object.class.php";
                $object = new ObjectClass($this->connection, $this->paramori);
                $dobject = $object->lire($uid);
                if ($dobject["object_status_id"] == 6) {
                    /**
                     * Add the return date in borrowing
                     */
                    include_once "modules/classes/borrowing.class.php";
                    $borrowing = new Borrowing($this->connection, $this->paramori);
                    $borrowing->setReturn($uid, $data["movement_date"], $object);
                    $object->setStatus($uid, 1);
                }
            }
            return $movement_id;
        } else {
            /*
             * Gestion des erreurs
             */
            throw new MovementException($message);
        }
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
				where c.uid = :uid";
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

        $dateStart = $this->encodeData($values["date_start"]);
        $dateEnd = $this->encodeData($values["date_end"]);
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
            $sql .= "login like :login and ";
            $data["login"] = $login;
        }
        $sql .= "movement_date::date between :date_start and :date_end
        order by movement_date desc";
        $data["date_start"] = $this->formatDateLocaleVersDB($dateStart, 2);
        $data["date_end"] = $this->formatDateLocaleVersDB($dateEnd, 2);
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
        $sql = "delete from movement where container_id = :container_id";
        try {
            $this->executeAsPrepared($sql, array("container_id" => $container_id));
        } catch (Exception $e) {
            global $message;
            $message->setSyslog($e->getMessage());
            throw new ObjetBDDException(sprintf(_("La suppression des mouvements associés au container %s a échoué"), $container_id));
        }
    }
}
