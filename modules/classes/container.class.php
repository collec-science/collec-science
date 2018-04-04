<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/object.class.php';

class Container extends ObjetBDD
{

    private $sql = "select c.container_id, o.uid, o.identifier, o.wgs84_x, o.wgs84_y, 
					container_type_id, container_type_name,
					container_family_id, container_family_name, os.object_status_id, object_status_name,
					storage_product, clp_classification, storage_condition_name,
					document_id, identifiers,
					movement_date, movement_type_name, movement_type_id,
                    lines, columns, first_line,
                    column_number, line_number, container_uid, oc.identifier as container_identifier
					from container c
					join object o using (uid)
					join container_type using (container_type_id)
					join container_family using (container_family_id)
					left outer join object_status os on (o.object_status_id = os.object_status_id)
					left outer join storage_condition using (storage_condition_id)
					left outer join last_photo using (uid)
					left outer join v_object_identifier using (uid)
					left outer join last_movement using (uid)
                    left outer join object oc on (container_uid = oc.uid)
					left outer join movement_type using (movement_type_id)
			";

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = null)
    {
        $this->table = "container";
        $this->colonnes = array(
            "container_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "uid" => array(
                "type" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "container_type_id" => array(
                "type" => 1,
                "requis" => 1
            )
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Surcharge de lire pour ramener les informations
     * generales (table object, notamment)
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::lire()
     */
    function lire($uid, $getDefault, $parentValue)
    {
        $sql = $this->sql . " where o.uid = :uid";
        $data["uid"] = $uid;
        if (is_numeric($uid) && $uid > 0) {
            $retour = parent::lireParamAsPrepared($sql, $data);
        } else {
            $retour = parent::getDefaultValue($parentValue);
        }
        return $retour;
    }

    /**
     * Surcharge de la fonction ecrire pour
     * enregistrer les informations dans object
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::ecrire()
     */
    function ecrire($data)
    {
        $object = new Object($this->connection, $this->param);
        $uid = $object->ecrire($data);
        if ($uid > 0) {
            $data["uid"] = $uid;
            parent::ecrire($data);
            return $uid;
        }
    }

    /**
     * Surcharge de supprimer pour effacer les donnees liees
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::supprimer()
     */
    function supprimer($uid)
    {
        $data = $this->lire($uid);
        /*
         * suppression de l'echantillon
         */
        parent::supprimer($data["container_id"]);
        /*
         * Suppression de l'objet
         */
        require_once 'modules/classes/object.class.php';
        $object = new Object($this->connection, $this->paramori);
        $object->supprimer($uid);
    }

    /**
     * Retourne tous les échantillons contenus
     * dans le conteneur
     *
     * @param int $uid
     * @return array
     */
    function getContentSample($uid)
    {
        if ($uid > 0 && is_numeric($uid)) {
            $sql = "select o.uid, o.identifier, sa.*,
					movement_date, movement_type_id, identifiers,
					collection_name, sample_type_name, object_status_name,
					sampling_place_name,
					pso.uid as parent_uid, pso.identifier as parent_identifier,
                    column_number, line_number,
                    document_id
					from object o
					join sample sa on (sa.uid = o.uid)
					join last_movement lm on (lm.uid = o.uid and lm.container_uid = :uid)
					join collection using (collection_id)
					join sample_type using (sample_type_id)
					left outer join v_object_identifier voi on (o.uid = voi.uid) 
					left outer join object_status using (object_status_id)
					left outer join sampling_place using (sampling_place_id)
					left outer join sample ps on (sa.parent_sample_id = ps.sample_id)
					left outer join object pso on (ps.uid = pso.uid)
                    left outer join last_photo on (o.uid = last_photo.uid)
					where lm.movement_type_id = 1
					order by o.identifier, o.uid
					";
            $data["uid"] = $uid;
            $this->colonnes["sample_creation_date"] = array(
                "type" => 2
            );
            $this->colonnes["sampling_date"] = array(
                "type" => 2
            );
            $this->colonnes["movement_date"] = array(
                "type" => 3
            );
            return $this->getListeParamAsPrepared($sql, $data);
        }
    }

    /**
     * Retourne tous les conteneurs contenus
     *
     * @param int $uid
     * @return array
     */
    function getContentContainer($uid)
    {
        if ($uid > 0 && is_numeric($uid)) {
            $sql = "select o.uid, o.identifier, container_type_id, container_type_name,
					container_family_id, container_family_name, o.object_status_id,
					storage_product, storage_condition_name, 
					object_status_name, clp_classification,
					movement_date, movement_type_id, column_number, line_number,
                    document_id
					from object o
					join container co on (co.uid = o.uid)
					join container_type using (container_type_id)
					join container_family using (container_family_id)
					join last_movement lm on (lm.uid = o.uid and lm.container_uid = :uid)
					left outer join object_status os on (o.object_status_id = os.object_status_id)
					left outer join storage_condition using (storage_condition_id)
                    left outer join  last_photo on (o.uid = last_photo.uid)
					where lm.movement_type_id = 1
					order by o.identifier, o.uid
					";
            $data["uid"] = $uid;
            /*
             * Rajout de la date de dernier mouvement pour l'affichage
             */
            $this->colonnes["movement_date"] = array(
                "type" => 3
            );
            return $this->getListeParamAsPrepared($sql, $data);
        }
    }

    /**
     * Retourne le conteneur parent
     *
     * @param int $uid
     * @return array
     */
    function getParent($uid)
    {
        if ($uid > 0 && is_numeric($uid)) {
            $sql = "select co.container_id, o.uid, o.identifier, container_type_id, container_type_name
					from object o
					join container co on (co.uid = o.uid)
					join container_type using (container_type_id)
					join last_movement lm on (lm.uid = :uid and lm.container_uid = o.uid) 
					where lm.movement_type_id = 1
					order by o.identifier, o.uid
					";
            $data["uid"] = $uid;
            return $this->lireParamAsPrepared($sql, $data);
        }
    }

    /**
     * Retourne tous les conteneurs parents d'un objet
     *
     * @param int $uid
     * @return array
     */
    function getAllParents($uid)
    {
        $data = array();
        if ($uid > 0 && is_numeric($uid)) {
            $continue = true;
            while ($continue) {
                $parent = $this->getParent($uid);
                if ($parent["uid"] > 0) {
                    $data[] = $parent;
                    $uid = $parent["uid"];
                } else {
                    $continue = false;
                }
            }
        }
        return $data;
    }

    /**
     * Retourne le numero d'un conteneur a partir de son uid
     *
     * @param int $uid
     * @return int;
     */
    function getIdFromUid($uid)
    {
        if (is_numeric($uid) && $uid > 0) {
            $sql = "select container_id from container where uid = :uid";
            $data["uid"] = $uid;
            $row = $this->lireParamAsPrepared($sql, $data);
            return $row["container_id"];
        } else {
            return - 1;
        }
    }

    /**
     * Recherche les conteneurs a partir du tableau de parametres fourni
     *
     * @param array $param
     */
    function containerSearch($param)
    {
        $data = array();
        /* $order = " order by container_family_name, container_type_name, identifier, uid"; */
        $where = "where";
        $and = "";
        if ($param["container_type_id"] > 0) {
            $where .= " container_type_id = :container_type_id";
            $data["container_type_id"] = $param["container_type_id"];
            $and = " and ";
        } elseif ($param["container_family_id"] > 0) {
            $where .= " container_family_id = :container_family_id";
            $data["container_family_id"] = $param["container_family_id"];
            $and = " and ";
        }
        if (strlen($param["name"]) > 0) {
            $where .= $and . "( ";
            $or = "";
            if (is_numeric($param["name"])) {
                $where .= " o.uid = :uid";
                $data["uid"] = $param["name"];
                $or = " or ";
            }
            $identifier = "%" . strtoupper($this->encodeData($param["name"])) . "%";
            $where .= "$or upper(o.identifier) like :identifier ";
            $and = " and ";
            $data["identifier"] = $identifier;
            /*
             * Recherche sur les identifiants externes
             * possibilite de recherche sur cab:valeur, p. e.
             */
            $where .= " or upper(identifiers) like :identifier ";
            $where .= ")";
        }
        if ($param["object_status_id"] > 0) {
            $where .= $and . " os.object_status_id = :object_status_id";
            $and = " and ";
            $data["object_status_id"] = $param["object_status_id"];
        }
        
        if ($param["uid_max"] > 0 && $param["uid_max"] >= $param["uid_min"]) {
            $where .= $and . " o.uid between :uid_min and :uid_max";
            $and = " and ";
            $data["uid_min"] = $param["uid_min"];
            $data["uid_max"] = $param["uid_max"];
        }
        if ($and == "") {
            $where = "";
        }
        
        /*
         * Rajout de la date de dernier mouvement pour l'affichage
         */
        $this->colonnes["movement_date"] = array(
            "type" => 3
        );
        return $this->getListeParamAsPrepared($this->sql . $where /*. $order*/, $data);
    }

    /**
     * Retourne la liste des conteneurs correspondant au type
     *
     * @param int $container_type_id
     * @return array
     */
    function getFromType($container_type_id)
    {
        if (is_numeric($container_type_id) && $container_type_id > 0) {
            $data["container_type_id"] = $container_type_id;
            $where = " where container_type_id = :container_type_id";
            $order = " order by uid desc";
            return $this->getListeParamAsPrepared($this->sql . $where . $order, $data);
        }
    }
    
    /**
     * Genere un tableau permettant d'afficher les objets contenus dans un container
     * a leur emplacement, dans le cas ou le nb de cellules est > 1
     * @param array $dcontainer
     * @param array $dsample
     * @param number $columns
     * @param number $lines
     * @param string $first_line
     * @return array|string|string[]|array[]
     */
    function generateOccupationArray($dcontainer, $dsample, $columns = 1, $lines = 1, $first_line = "T") {
        $data = array();
        /*
         * Generation d'un tableau vide
         */
        for($line = 0; $line < $lines; $line ++) {
            for ($column = 0; $column < $columns; $column ++) {
                $data [$line][$column] = "";
            }
        }
        /*
         * Traitement de chaque tableau pour integrer les informations
         */
        foreach ($dcontainer as $value) {
            if ($value["line_number"] > 0 && $value["column_number"] > 0) {
                $data [$value["line_number"] - 1 ][$value["column_number"] -1] = array("type"=>"C", "uid"=>$value["uid"], "identifier"=>$value["identifier"]);
            }
        }
        foreach ($dsample as $value) {
            if ($value["line_number"] > 0 && $value["column_number"] > 0) {
                $data [$value["line_number"] - 1 ][$value["column_number"] -1] = array("type"=>"S", "uid"=>$value["uid"], "identifier"=>$value["identifier"]);
            }
        }
        /*
         * Tri du tableau
         */
        if ($lines > 1 && $first_line == "B") {
            krsort($data);
        }
        return $data;        
    }
}

?>