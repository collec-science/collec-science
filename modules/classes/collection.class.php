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
      ),
      "referent_id" => array(
        "type" => 1
      ),
      "allowed_import_flow" => array(
        "type" => 1,
        "defaultValue" => 0
      ),
      "allowed_export_flow" => array(
        "type" => 1,
        "defaultValue" => 0
      ),
      "public_collection" => array(
        "type" => 1,
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
      "no_localization" => array("type" => 1),
      "external_storage_enabled" => array("type" => 1),
      "external_storage_root" => array("type" => 0)
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
  function getListe($order = 1)
  {
    $sql = "select collection_id, collection_name,
                array_to_string(array_agg(groupe),', ') as groupe,
                referent_name,
                allowed_import_flow, allowed_export_flow, public_collection
                ,collection_keywords,collection_displayname
                ,license_id, license_name, license_url, no_localization
                ,external_storage_enabled, external_storage_root
				from collection
                left outer join collection_group using (collection_id)
                left outer join referent using (referent_id)
                left outer join license using (license_id)
				left outer join aclgroup using (aclgroup_id)
				group by collection_id, collection_name, referent_name, license_name, license_url
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
      foreach ($groups as $value) {
        if (strlen($value["groupe"]) > 0) {
          $comma == true ? $in .= ", " : $comma = true;
          $in .= "'" . $value["groupe"] . "'";
        }
      }
      $in .= ")";
      $sql = "select distinct collection_id, collection_name
          ,allowed_import_flow, allowed_export_flow, public_collection
          ,external_storage_enabled, external_storage_root
					from collection
					join collection_group using (collection_id)
					join aclgroup using (aclgroup_id)
					where groupe in $in";
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
  function ecrire($data)
  {
    /**
     * Verify the external document path
     */
    if (strpos($data["external_storage_root"], "..")) {
      throw new ObjetBDDException(_("La racine des documents externes ne peut pas contenir .."));
    }
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
    require_once 'framework/droits/aclgroup.class.php';
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
  /**
   * Return the list of samples by collection, with the date of last change
   *
   * @return void
   */
  function getNbsampleByCollection()
  {
    if (count($_SESSION["collections"]) > 0) {
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
      $this->colonnes["last_change"] = array("type" => 2);
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
    $sql = "delete from collection_group where aclgroup_id = :group_id";
    $this->executeAsPrepared($sql, array("group_id" => $group_id));
  }
/**
 * Get all collections, the attributed first
 *
 * @return array|null
 */
  function getAllCollections() :?array {
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
    return array_merge($collections, $newCollections);

  }
}
