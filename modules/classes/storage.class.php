<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/container.class.php';

class StorageException extends Exception
{
}

class Storage extends ObjetBDD
{

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    private $sql = "select s.uid, container_id, movement_type_id, movement_type_name,
					storage_date, storage_location, login, storage_comment,
					identifier, o.uid as parent_uid, o.identifier as parent_identifier,
					container_type_id, container_type_name,
					storage_reason_id, storage_reason_name,
                    column_number, line_number
					from storage s
					join movement_type using (movement_type_id)
					left outer join container c using (container_id)
					left outer join object o on (c.uid = o.uid)
					left outer join container_type using (container_type_id)
					left outer join storage_reason using (storage_reason_id)
					";

    private $order = " order by storage_date desc";

    private $where = " where s.uid = :uid";

    function __construct($bdd, $param = array())
    {
        $this->table = "storage";
        $this->colonnes = array(
            "storage_id" => array(
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
            "storage_reason_id" => array(
                "type" => 1
            ),
            "storage_date" => array(
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
            "storage_comment" => array(
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
        if (is_numeric($id) && $id > 0) {
            $data["uid"] = $id;
            return $this->getListeParamAsPrepared($this->sql . $this->where . $this->order . " limit 1", $data);
        }
    }

    /**
     * Retourne le dernier emplacement connu pour un objet
     * @param int $id
     * @return array
     */
    function getLastEntry($id) {
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
     * Retourne la liste de tous les containers parents
     *
     * @param int $uid
     * @throws Exception
     * @return array
     */
    function getParents($uid)
    {
        if (is_numeric($id) && $id > 0) {
            $retour = array();
            $data["uid"] = $uid;
            $continue = true;
            try {
                /*
                 * Preparation de la requete
                 */
                $stmt = $this->connection->prepare($this->sql . $this->where . $this->order . " limit 1");
                while ($continue == true) {
                    if ($stmt->execute($data)) {
                        $result = $stmt->fetch(PDO::FETCH_ASSOC);
                        $retour[] = $result;
                        if ($result["parent_uid"] > 0) {
                            $data["uid"] = $result["parent_uid"];
                        } else
                            $continue = false;
                    } else
                        $continue = false;
                }
                return $retour;
            } catch (PDOException $e) {
                $this->lastResultExec = false;
                if ($this->debug_mode > 0)
                    $this->addMessage($e->getMessage());
                throw new StorageException($e->getMessage());
            }
        }
    }

    /**
     * Fonction generique permettant de rajouter des mouvements
     *
     * @param int $uid
     * @param DateTime $date
     * @param int $type
     * @param number $container_uid
     * @param string $login
     * @param string $storage_location
     * @param string $comment
     * @return int
     */
    function addMovement($uid, $date, $type, $container_uid = 0, $login = null, $storage_location = null, $comment = null, $storage_reason_id = null, $column_number = 1, $line_number = 1)
    {
        global $LANG;
        /*
         * Verifications
         */
        $controle = true;
        $message = $LANG["appli"][5];
        if (! ($uid > 0 && is_numeric($uid)))
            $controle = false;
        if ($uid == $container_uid) {
            $controle = false;
            $message .= "Création du mouvement impossible : le numéro de l'objet est égal au numéro du conteneur. ";
        }
        $date = $this->encodeData($date);
        if (strlen($date) == 0) {
            $date = date('d/m/Y H:i:s');
        }
        if ($type != 1 && $type != 2)
            $controle = false;
        $container_uid = $this->encodeData($container_uid);
        if (! is_numeric($container_uid) && strlen($container_uid) > 0)
            $controle = false;
        if (strlen($login) == 0)
            strlen($_SESSION["login"]) > 0 ? $login = $_SESSION["login"] : $controle = false;
        $storage_location = $this->encodeData($storage_location);
        $comment = $this->encodeData($comment);
        $storage_reason_id = $this->encodeData($storage_reason_id);
        if ($type == 1) {
            /*
             * Recherche de container_id a partir de uid
             */
            $container = new Container($this->connection, $this->param);
            $container_id = $container->getIdFromUid($container_uid);
            if ($container_id > 0) {
                $data["container_id"] = $container_id;
            } else {
                $message .= "Pas de container correspondant à l'UID " . $container_uid . ". ";
                $controle = false;
            }
        }
        if ($controle) {
            $data["uid"] = $uid;
            $data["storage_date"] = $date;
            $data["movement_type_id"] = $type;
            $data["login"] = $login;
            $data["storage_reason_id"] = $storage_reason_id;
            
            if (strlen($storage_location) > 0)
                $data["storage_location"] = $storage_location;
            if (strlen($comment) > 0)
                $data["storage_comment"] = $comment;
            $data["column_number"] = $column_number;
            $data["line_number"] = $line_number;
            return $this->ecrire($data);
        } else
            /*
             * Gestion des erreurs
             */
            throw new StorageException($message);
    }

    /**
     * Retourne le nombre de mouvements impliques dans le controleur fourni
     *
     * @param int $id
     */
    function getNbFromContainer($uid)
    {
        $sql = "select count (*) as nombre from container c
				join storage using (container_id)
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
        if (strlen($values["login"]) > 0) {
            $login = "%" . strtolower($this->encodeData($values["login"])) . "%";
            $searchByLogin = true;
        } else {
            $searchByLogin = false;
        }
        
        $dateStart = $this->encodeData($values["date_start"]);
        $dateEnd = $this->encodeData($values["date_end"]);
        $data = array();
        $sql = "select s.login, s.uid, identifier, storage_date, movement_type_id, movement_type_name, storage_location, line_number, column_number,
        case when sample_type_name is not null then sample_type_name else container_type_name end as type_name
        from storage s
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
        $sql .= "storage_date between :date_start and :date_end
        order by storage_date desc";
        //$data["date_start"] = $dateStart;
        //$data["date_end"] = $dateEnd;
        $data["date_start"] = $this->formatDateLocaleVersDB($dateStart, 3);
        $data["date_end"] = $this->formatDateLocaleVersDB($dateEnd, 3);
        return $this->getListeParamAsPrepared($sql, $data);
    }
}

?>