<?php

namespace App\Models;

use Ppci\Libraries\PpciException;
use Ppci\Models\Aclgroup;
use Ppci\Models\PpciModel;

/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */

class Collection extends PpciModel
{

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct()
    {
        $this->table = "collection";
        $this->fields = array(
            "collection_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "collection_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "referent_id" => array(
                "type" => 1
            ),
            "allowed_import_flow" => array(
                "type" => 0,
                "defaultValue" => 0
            ),
            "allowed_export_flow" => array(
                "type" => 0,
                "defaultValue" => 0
            ),
            "public_collection" => array(
                "type" => 0,
                "defaultValue" => 0
            ),
            "collection_keywords" => array(
                "type" => 0
            ),
            "collection_displayname" => array(
                "type" => 0
            ),
            "license_id" => array(
                "type" => 1
            ),
            "no_localization" => array("type" => 0),
            "external_storage_enabled" => array("type" => 0),
            "external_storage_root" => array("type" => 0),
            "sample_name_unique" => array("type" => 0),
            "notification_enabled" => array("type" => 0, "defaultValue" => 0),
            "notification_mails" => array("type" => 0),
            "expiration_delay" => array("type" => 1),
            "event_due_delay" => array("type" => 1)
        );
        parent::__construct();
    }

    /**
     * Ajoute la liste des groupes a la liste des collections
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::getListe()
     */
    function getListe(string $order = "1"): array
    {
        $sql = "select collection_id, collection_name,
                getgroupsfromcollection(collection_id) as groupe,
                getsampletypesfromcollection(collection_id) as sampletypes,
                geteventtypesfromcollection(collection_id) as eventtypes,
                referent_name,
                allowed_import_flow, allowed_export_flow, public_collection
                ,collection_keywords,collection_displayname
                ,license_id, license_name, license_url, no_localization
                ,external_storage_enabled, external_storage_root
                ,notification_enabled, notification_mails, expiration_delay, event_due_delay
                ,sample_name_unique
				    from collection
                left outer join referent using (referent_id)
                left outer join license using (license_id)
				    order by $order";
        return $this->getListeParam($sql);
    }

    /**
     * Retourne la liste des collections autorises pour un login
     *
     * @return array
     */
    function getCollectionsFromLogin()
    {
        if (is_array($_SESSION["groupes"])) {
            return $this->getCollectionsFromGroups($_SESSION["groupes"]);
        } else {
            return array();
        }
    }

    /**
     * Retourne la liste des collections correspondants aux groupes indiques
     *
     * @param array $groups
     *
     * @return array
     */
    function getCollectionsFromGroups(array $groups): array
    {
        $data = array();
        if (count($groups) > 0) {
            /**
             * Preparation de la clause in
             */
            $comma = false;
            $in = "(";
            foreach ($groups as $group) {
                $comma == true ? $in .= ", " : $comma = true;
                $in .= $group["aclgroup_id"];
            }
            $in .= ")";
            $sql = "select distinct collection_id, collection_name
          ,allowed_import_flow, allowed_export_flow, public_collection
          ,external_storage_enabled, external_storage_root
					from collection
					join collection_group using (collection_id)
					join aclgroup using (aclgroup_id)
					where aclgroup_id in $in";
            $order = " order by collection_name";
            $dataSql = $this->getListeParam($sql . $order);
            foreach ($dataSql as $row) {
                $data[$row["collection_id"]] = $row;
            }
        }
        return $data;
    }

    /**
     * Surcharge de la fonction ecrire, pour enregistrer les groupes autorises
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::ecrire()
     */
    function write(array $data): int
    {
        /**
         * Verify the external document path
         */
        if (strpos($data["external_storage_root"], "..")) {
            throw new PpciException(_("La racine des documents externes ne peut pas contenir .."));
        }
        $id = parent::write($data);
        if ($id > 0) {
            /**
             * Ecriture des groupes
             */
            $this->ecrireTableNN("collection_group", "collection_id", "aclgroup_id", $id, $data["groupes"]);
            $this->ecrireTableNN("collection_sampletype", "collection_id", "sample_type_id", $id, $data["sampletypes"]);
            $this->ecrireTableNN("collection_eventtype", "collection_id", "event_type_id", $id, $data["eventtypes"]);
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
            $sample = new Sample();
            if ($sample->getNbFromCollection($id) == 0) {
                $sql = "delete from collection_group where collection_id = :collection_id:";
                $data["collection_id"] = $id;
                $this->executeQuery($sql, $data, true);
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
        $aclgroup = new Aclgroup();
        $groupes = $aclgroup->getListe(2);
        foreach ($groupes as $key => $value) {
            $groupes[$key]["checked"] = $dataGroup[$value["aclgroup_id"]];
        }
        return $groupes;
    }

    /**
     * Get all sample types, attached or not to a collection
     *
     * @param integer $collection_id
     * @return array
     */
    function getAllSampletypesFromCollection(int $collection_id)
    {
        if ($collection_id > 0) {
            $data = $this->getSampletypesFromCollection($collection_id);
            $dataGroup = array();
            foreach ($data as $value) {
                $dataGroup[$value["sample_type_id"]] = 1;
            }
        }
        $sampleType = new SampleType($this->connection);
        $sampletypes = $sampleType->getListe(2);
        foreach ($sampletypes as $key => $value) {
            $sampletypes[$key]["checked"] = $dataGroup[$value["sample_type_id"]];
        }
        return $sampletypes;
    }

    /**
     * Get the list of sample types attached to a collection
     *
     * @param integer $collection_id
     * @return array
     */
    function getSampletypesFromCollection(int $collection_id)
    {
        $data = array();
        if ($collection_id > 0) {
            $sql = "select sample_type_id, sample_type_name
          from collection_sampletype
					join sample_type using (sample_type_id)
					where collection_id = :collection_id:
          order by sample_type_name";
            $var["collection_id"] = $collection_id;
            $data = $this->getListeParamAsPrepared($sql, $var);
        }
        return $data;
    }

    /**
     * Retourne la liste des groupes attaches a un projet
     *
     * @param int $collection_id
     * @return array
     */
    function getGroupsFromCollection(int $collection_id)
    {
        $data = array();
        if ($collection_id > 0) {
            $sql = "select aclgroup_id, groupe from collection_group
					join aclgroup using (aclgroup_id)
					where collection_id = :collection_id:";
            $var["collection_id"] = $collection_id;
            $data = $this->getListeParamAsPrepared($sql, $var);
        }
        return $data;
    }

    /**
     * Get the list of event types attached to a collection
     *
     * @param integer $collection_id
     * @return array
     */
    function getEventtypesFromCollection(int $collection_id)
    {
        $data = array();
        if ($collection_id > 0) {
            $sql = "select event_type_id, event_type_name
          from collection_eventtype
					join event_type using (event_type_id)
					where collection_id = :collection_id:
          order by event_type_name";
            $var["collection_id"] = $collection_id;
            $data = $this->getListeParamAsPrepared($sql, $var);
        }
        return $data;
    }
    /**
     * Get all event types, attached or not to a collection
     *
     * @param integer $collection_id
     * @return array
     */
    function getAllEventtypesFromCollection(int $collection_id)
    {
        if ($collection_id > 0) {
            $data = $this->getEventtypesFromCollection($collection_id);
            $dataGroup = array();
            foreach ($data as $value) {
                $dataGroup[$value["event_type_id"]] = 1;
            }
        }
        $eventType = new EventType($this->connection);
        $eventtypes = $eventType->getListForSamples();
        foreach ($eventtypes as $key => $value) {
            $eventtypes[$key]["checked"] = $dataGroup[$value["event_type_id"]];
        }
        return $eventtypes;
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
            $_SESSION["userRights"]["manage"] = 1;
        }
    }
    /**
     * Return the list of samples by collection, with the date of last change
     *
     * @return void
     */
    function getNbsampleByCollection()
    {
        if (!empty($_SESSION["collections"])) {
            $sql = "select collection_id, collection_name, count(*) as samples_number, max(change_date) as last_change
        from sample
        join collection using (collection_id)
        join object using (uid)";
            $groupby = "group by collection_id, collection_name";
            $where = " where collection_id in (";
            $comma = "";
            foreach ($_SESSION["collections"] as $colid) {
                $where .= $comma . $colid["collection_id"];
                $comma = ",";
            }
            $where .= ")";
            $this->dateFields[] = "last_change";
            return ($this->getListParam($sql . $where . $groupby));
        }
    }
    /**
     * Return the common collection to a list of uid
     * Function used for the exports
     *
     * @param string $uids
     * @return array|null
     */
    function getCollectionFromUids(string $uids): ?array
    {
        $sql = "select distinct collection_id, collection_name,
            referent_name,referent_email,
            address_name,address_line2,address_line3,address_city,address_country,referent_phone
            ,referent_firstname,academical_directory,academical_link
            ,collection_keywords,collection_displayname
            ,license_name,license_url
            from collection
            left outer join referent using (referent_id)
            left outer join license using (license_id)
            join sample using (collection_id)
            where uid in ($uids)";
        return $this->getListeParam($sql);
    }
    /**
     * Delete the group in all collections
     *
     * @param integer $group_id
     * @return void
     */
    function deleteGroup(int $group_id)
    {
        $sql = "delete from collection_group where aclgroup_id = :group_id:";
        $this->executeAsPrepared($sql, array("group_id" => $group_id));
    }
    /**
     * Get all collections, the attributed first
     *
     * @return array|null
     */
    function getAllCollections(): ?array
    {
        $collections = $_SESSION["collections"];
        /**
         * Get the others collections
         */
        $in = " where collection_id not in (";
        $comma = false;
        foreach ($collections as $collection) {
            $comma ? $in .= "," : $comma = true;
            $in .= $collection["collection_id"];
        }
        $in .= ")";
        $sql = "select collection_id, collection_name from collection";
        if ($comma) {
            $sql .= $in;
        }
        $sql .= " order by collection_name";
        $newCollections = $this->getListeParam($sql);
        if (empty($collections)) {
            $collections = array();
        }
        return array_merge($collections, $newCollections);
    }
    /**
     * Get the list of collections where notifications are enabled
     *
     * @return array
     */
    function getNotificationDetails(): array
    {
        $sql = "select collection_id, collection_name, notification_mails, expiration_delay, event_due_delay
                from collection
                where notification_enabled = true";
        return $this->getListeParam($sql);
    }
}
