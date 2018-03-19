<?php

/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Collection extends ObjetBDD
{

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "collection";
        $this->colonnes = array(
            "collection_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "collection_name" => array(
                "type" => 0,
                "requis" => 1
            )
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Ajoute la liste des groupes a la liste des collections
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::getListe()
     */
    function getListe($order = 0)
    {
        $sql = "select collection_id, collection_name, array_to_string(array_agg(groupe),', ') as groupe
				from collection
				left outer join collection_group using (collection_id)
				left outer join aclgroup using (aclgroup_id)
				group by collection_id, collection_name
				order by $order";
        return $this->getListeParam($sql);
    }

    /**
     * Retourne la liste des collections autorises pour un login
     *
     * @param string $login
     * @param PDO $aclconnexion
     * @return array
     */
    function getCollectionsFromLogin()
    {
       return $this->getCollectionsFromGroups($_SESSION["groupes"]);
    }

    /**
     * Retourne la liste des collections correspondants aux groupes indiques
     *
     * @param array $groups
     * @return array
     */
    function getCollectionsFromGroups(array $groups)
    {
        if (count($groups) > 0) {
            /*
             * Preparation de la clause in
             */
            $comma = false;
            $in = "(";
            foreach ($groups as $value) {
                if (strlen($value["groupe"]) > 0) {
                    $comma == true ? $in .= ", " : $comma = true;
                    $in .= "'" . $value["groupe"] . "'";
                }
            }
            $in .= ")";
            $sql = "select distinct collection_id, collection_name
					from collection
					join collection_group using (collection_id)
					join aclgroup using (aclgroup_id)
					where groupe in $in";
            $order = " order by collection_name";
            return $this->getListeParam($sql . $order);
        } else {
            return array();
        }
    }

    /**
     * Surcharge de la fonction ecrire, pour enregistrer les groupes autorises
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::ecrire()
     */
    function ecrire($data)
    {
        $id = parent::ecrire($data);
        if ($id > 0) {
            /*
             * Ecriture des groupes
             */
            $this->ecrireTableNN("collection_group", "collection_id", "aclgroup_id", $id, $data["groupes"]);
        }
        return $id;
    }

    /**
     * Supprime une collection
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::supprimer()
     */
    function supprimer($id)
    {
        if ($id > 0 && is_numeric($id)) {
            /*
             * Recherche si aucun echantillon n'est reference
             */
            require_once 'modules/classes/sample.class.php';
            $sample = new Sample($this->connection);
            if ($sample->getNbFromCollection($id) == 0) {
                $sql = "delete from collection_group where collection_id = :collection_id";
                $data["collection_id"] = $id;
                $this->executeAsPrepared($sql, $data);
                return parent::supprimer($id);
            }
        }
    }

    /**
     * Retourne la liste de tous les groupes, en indiquant s'ils sont ou non presents
     * dans le projet (attribut checked a 1)
     *
     * @param int $collection_id
     * @return array
     */
    function getAllGroupsFromCollection($collection_id)
    {
        if ($collection_id > 0 && is_numeric($collection_id)) {
            $data = $this->getGroupsFromCollection($collection_id);
            $dataGroup = array();
            foreach ($data as $value) {
                $dataGroup[$value["aclgroup_id"]] = 1;
            }
        }
        require_once 'framework/droits/droits.class.php';
        $aclgroup = new Aclgroup($this->connection);
        $groupes = $aclgroup->getListe(2);
        foreach ($groupes as $key => $value) {
            $groupes[$key]["checked"] = $dataGroup[$value["aclgroup_id"]];
        }
        return $groupes;
    }

    /**
     * Retourne la liste des groupes attaches a un projet
     *
     * @param int $collection_id
     * @return array
     */
    function getGroupsFromCollection($collection_id)
    {
        $data = array();
        if ($collection_id > 0 && is_numeric($collection_id)) {
            $sql = "select aclgroup_id, groupe from collection_group
					join aclgroup using (aclgroup_id)
					where collection_id = :collection_id";
            $var["collection_id"] = $collection_id;
            $data = $this->getListeParamAsPrepared($sql, $var);
        }
        return $data;
    }

    /**
     * Initialise la liste des connexions rattachees au login
     */
    function initCollections()
    {
        $_SESSION["collections"] = $this->getCollectionsFromLogin();
        /*
         * Attribution des droits de gestion si attache a un projet
         */
        if (count($_SESSION["collections"]) > 0) {
            $_SESSION["droits"]["gestion"] = 1;
        }
    }
}

?>