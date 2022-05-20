<?php

/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/object.class.php';
class SampleException extends Exception
{
}

class Sample extends ObjetBDD
{

  /**
   *
   * @param PDO $bdd
   * @param array $param
   */
  private $sql = "select distinct on (s.uid) s.sample_id, s.uid,
					s.collection_id, collection_name, no_localization, s.sample_type_id, s.dbuid_origin,
                    sample_type_name, s.sample_creation_date, s.sampling_date, s.metadata, s.expiration_date,
                    s.campaign_id, campaign_name,camp.uuid as campaign_uuid,
                    s.parent_sample_id,
					st.multiple_type_id, s.multiple_value, st.multiple_unit, mt.multiple_type_name,
          so.identifier,
          case when so.wgs84_x is not null then so.wgs84_x else sp.sampling_place_x end as wgs84_x,
          case when so.wgs84_y is not null then so.wgs84_y else sp.sampling_place_y end as wgs84_y,
          case when s.country_id is not null then sc.country_id else csp.country_id end as country_id,
          case when s.country_id is not null then sc.country_name else csp.country_name end as country_name,
          case when s.country_id is not null then sc.country_code2 else csp.country_code2 end as country_code2,
          s.country_origin_id, sco.country_name as country_origin_name, sco.country_code2 as country_origin_code2,
          so.object_status_id, object_status_name,so.referent_id,
          so.change_date, so.uuid, so.trashed, so.location_accuracy, so.object_comment,
          pso.uid as parent_uid, pso.identifier as parent_identifier, pso.uuid as parent_uuid,
          voip.identifiers as parent_identifiers,
					ct.container_type_name, ct.clp_classification,
					operation_id, protocol_name, protocol_year, protocol_version, operation_name, operation_order,operation_version,
					metadata_schema,
					document_id, voi.identifiers,
					movement_date, movement_type_name, movement_type_id,
					sp.sampling_place_id, sp.sampling_place_name,
          lm.line_number, lm.column_number,
          container_uid, oc.identifier as container_identifier, oc.uuid as container_uuid, lmct.container_type_name as storage_type_name,
          case when ro.referent_name is not null then ro.referent_id else cr.referent_id end as real_referent_id,
          case when ro.referent_name is not null then ro.referent_name else cr.referent_name end as referent_name,
          case when ro.referent_name is not null then ro.referent_email else cr.referent_email end as referent_email,
          case when ro.referent_name is not null then ro.address_name else cr.address_name end as address_name,
          case when ro.referent_name is not null then ro.address_line2 else cr.address_line2 end as address_line2,
          case when ro.referent_name is not null then ro.address_line3 else cr.address_line3 end as address_line3,
          case when ro.referent_name is not null then ro.address_city else cr.address_city end as address_city,
          case when ro.referent_name is not null then ro.address_country else cr.address_country end as address_country,
          case when ro.referent_name is not null then ro.referent_phone else cr.referent_phone end as referent_phone,
          case when ro.referent_name is not null then ro.referent_firstname else cr.referent_firstname end as referent_firstname,
          case when ro.referent_name is not null then ro.academical_directory else cr.academical_directory end as academic_directory,
          case when ro.referent_name is not null then ro.academical_link else cr.academical_link end as academical_link,
          case when ro.referent_name is not null then ro.referent_organization else cr.referent_organization end as referent_organization,
          borrowing_date, expected_return_date, borrower_id, borrower_name,
          vsq.multiple_value + vsq.subsample_more - vsq.subsample_less as subsample_quantity
					from sample s
					join sample_type st on (st.sample_type_id = s.sample_type_id)
					join collection p on (p.collection_id = s.collection_id)
					join object so on (s.uid = so.uid)
					left outer join sampling_place sp on (sp.sampling_place_id = s.sampling_place_id)
					left outer join object_status os on (so.object_status_id = os.object_status_id)
					left outer join sample ps on (s.parent_sample_id = ps.sample_id)
					left outer join object pso on (ps.uid = pso.uid)
					left outer join container_type ct using (container_type_id)
					left outer join operation using (operation_id)
					left outer join protocol using (protocol_id)
					left outer join multiple_type mt on (st.multiple_type_id = mt.multiple_type_id)
					left outer join last_photo on (so.uid = last_photo.uid)
          left outer join v_object_identifier voi on  (s.uid = voi.uid)
          left outer join v_object_identifier voip on (pso.uid = voip.uid)
					left outer join last_movement lm on (s.uid = lm.uid)
          left outer join object oc on (container_uid = oc.uid)
          left outer join container lmc on (oc.uid = lmc.uid)
          left outer join container_type lmct on (lmc.container_type_id = lmct.container_type_id)
					left outer join movement_type using (movement_type_id)
          left outer join metadata using (metadata_id)
          left outer join referent ro on (so.referent_id = ro.referent_id)
          left outer join referent cr on (p.referent_id = cr.referent_id)
          left outer join last_borrowing lb on (so.uid = lb.uid)
          left outer join borrower using (borrower_id)
          left outer join campaign camp on (s.campaign_id = camp.campaign_id)
          left outer join campaign_regulation campreg on (camp.campaign_id = campreg.campaign_id)
          left outer join country sc on (s.country_id = sc.country_id)
          left outer join country csp on (sp.country_id = csp.country_id)
          left outer join country sco on (s.country_origin_id = sco.country_id)
          left outer join v_subsample_quantity vsq on (s.sample_id = vsq.sample_id)
          ";
  private $object, $container, $event, $country;

  public function __construct($bdd, $param = array())
  {
    $this->table = "sample";
    $this->colonnes = array(
      "sample_id" => array(
        "type" => 1,
        "key" => 1,
        "requis" => 1,
        "defaultValue" => 0,
      ),
      "uid" => array(
        "type" => 1,
        "parentAttrib" => 1,
        "requis" => 1,
        "defaultValue" => 0,
      ),
      "collection_id" => array(
        "type" => 1,
        "requis" => 1,
      ),
      "sample_type_id" => array(
        "type" => 1,
        "requis" => 1,
      ),
      "sample_creation_date" => array(
        "type" => 3,
        "requis" => 1,
        "defaultValue" => "getDateHeure",
      ),
      "parent_sample_id" => array(
        "type" => 1,
      ),
      "sampling_date" => array(
        "type" => 3,
        "defaultValue" => "getDateHeure",
      ),
      "multiple_value" => array(
        "type" => 1,
      ),
      "sampling_place_id" => array(
        "type" => 1,
      ),
      "dbuid_origin" => array(
        "type" => 0,
      ),
      "metadata" => array(
        "type" => 0,
      ),
      "expiration_date" => array(
        "type" => 2,
      ),
      "campaign_id" => array("type" => 1),
      "country_id" => array("type" => 1),
      "country_origin_id" => array("type" => 1)
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
  public function lire($uid, $getDefault = true, $parentValue = null)
  {
    $sql = $this->sql . " where s.uid = :uid";
    $data["uid"] = $uid;
    if (is_numeric($uid) && $uid > 0) {
      $this->colonnes["borrowing_date"] = array("type" => 2);
      $this->colonnes["expected_return_date"] = array("type" => 2);
      $this->colonnes["change_date"] = array("type" => 3);
      $retour = parent::lireParamAsPrepared($sql, $data);
    } else {
      $retour = parent::getDefaultValue($parentValue);
    }
    unset($this->colonnes["borrowing_date"]);
    unset($this->colonnes["expected_return_date"]);
    unset($this->colonnes["change_date"]);
    return $retour;
  }

  public function lireFromId($sample_id)
  {
    $sql = $this->sql . " where s.sample_id = :sample_id";
    $data["sample_id"] = $sample_id;
    $this->colonnes["borrowing_date"] = array("type" => 2);
    $this->colonnes["exepected_return_date"] = array("type" => 2);
    $this->colonnes["change_date"] = array("type" => 3);
    $list = parent::lireParamAsPrepared($sql, $data);
    unset($this->colonnes["borrowing_date"]);
    unset($this->colonnes["expected_return_date"]);
    unset($this->colonnes["change_date"]);
    return $list;
  }

  /**
   * Get the id of the sample from the identifier
   *
   * @param [type] $identifier
   * @return void
   */
  public function getIdFromIdentifier(string $identifier, int $collection_id = 0)
  {
    $sql = "select sample_id from sample
    join object using (uid)
    where lower(identifier) = lower(:identifier)";
    $data =  array("identifier" => $identifier);
    if ($collection_id > 0) {
      $sql .= " and collection_id = :collection_id";
      $data["collection_id"] = $collection_id;
    }
    $data = $this->lireParamAsPrepared($sql, $data);
    return $data["sample_id"];
  }

  /**
   * Transform the list of uids into a list of sample_id
   *
   * @param array $uids
   * @param integer $collection_id
   * @return array
   */
  public function getIdsFromUids($uids, int $collection_id = 0)
  {
    $sql = "select sample_id from sample where uid in (";
    $ids = array();
    $multiple = false;
    $comma = "";
    foreach ($uids as $uid) {
      if (is_numeric($uid) && $uid > 0) {
        $sql .= $comma . $uid;
        if (!$multiple) {
          $comma = ",";
          $multiple = true;
        }
      }
    }
    if ($multiple) {
      $sql .= ")";
      if ($collection_id > 0 && is_numeric($collection_id)) {
        $sql .= " and collection_id = $collection_id";
      }
      $data = $this->getListeParam($sql);
      foreach ($data as $row) {
        $ids[] = $row["sample_id"];
      }
    }
    return $ids;
  }

  /**
   * Surcharge de la fonction ecrire pour verifier si l'echantillon est modifiable
   *
   * {@inheritdoc}
   *
   * @see ObjetBDD::ecrire()
   */
  public function ecrire($data)
  {
    $ok = $this->verifyCollection($data);
    /*
         * Verification complementaire par rapport aux donnees deja stockees
         */
    if ($ok && $data["uid"] > 0) {
      $ok = $this->verifyCollection($this->lire($data["uid"]));
    }
    if ($ok) {
      $firstUid = $data["uid"];
      $object = new ObjectClass($this->connection, $this->param);
      $uid = $object->ecrire($data);

      if ($uid > 0) {
        $data["uid"] = $uid;
        if (parent::ecrire($data) > 0) {
          if (strlen($data["metadata"]) > 0) {
            /**
             * Recherche des échantillons derives pour mise a jour
             * des metadonnees
             */
            $childs = $this->getSampleassociated($uid);
            $md = json_decode($data["metadata"], true);
            foreach ($childs as $child) {
              $cmd = json_decode($child["metadata"], true);
              foreach ($md as $k => $v) {
                $cmd[$k] = $v;
              }
              $child["metadata"] = json_encode($cmd);
              $this->ecrire($child);
            }
          }
          /**
           * Add the creation of the subsample movement on new sample from parent sample
           */
          if ($firstUid == 0 && $data["parent_sample_id"] > 0 && $data["multiple_value"] > 0) {
            $parentData = $this->lireFromId($data["parent_sample_id"]);
            if ($parentData["multiple_value"] > 0) {
              if (!isset($this->subsample)) {
                $this->subsample = $this->classInstanciate("Subsample", "subsample.class.php");
              }
              $dataSubsample = $this->subsample->getDefaultValue();
              $dataSubsample["movement_type_id"] = 2;
              $dataSubsample["subsample_quantity"] = $data["multiple_value"];
              $dataSubsample["sample_id"] = $parentData["sample_id"];
              $dataSubsample["subsample_comment"] = sprintf(_("Création de l'échantillon dérivé %s"), $uid);
              $this->subsample->ecrire($dataSubsample);
            }
          }
          return $uid;
        } else {
          throw new SampleException(_("Un problème est survenu lors de l'écriture de l'échantillon"));
        }
      } else {
        throw new SampleException(_("Un problème est survenu lors de l'écriture de l'objet"));
      }
    } else {
      throw new SampleException(_("Vous ne disposez pas des droits pour modifier cet échantillon"));
    }
  }

  /**
   * Surcharge de la fonction supprimer pour verifier si l'utilisateur peut supprimer l'echantillon
   *
   * {@inheritdoc}
   *
   * @see ObjetBDD::supprimer()
   */
  public function supprimer($uid)
  {
    $data = $this->lire($uid);
    if ($this->verifyCollection($data)) {
      /**
       * delete from subsample
       */
      $sql = "delete from subsample where sample_id = :sample_id";
      $this->executeAsPrepared($sql, array("sample_id"=>$data["sample_id"]), true);
      /**
       * suppression de l'echantillon
       */
      parent::supprimer($data["sample_id"]);
      /**
       * Suppression de l'objet
       */
      if (!isset($this->object)) {
        require_once 'modules/classes/object.class.php';
        $this->object = new ObjectClass($this->connection, $this->paramori);
      }
      $this->object->supprimer($uid);
    } else {
      throw new SampleException(sprintf(_("Vous ne disposez pas des droits nécessaires pour supprimer l'échantillon %1s"), $uid));
    }
  }

  /**
   * Fonction permettant de verifier si l'echantillon peut etre modifie ou non
   * par l'utilisateur
   *
   * @param array $data
   * @return boolean
   */
  public function verifyCollection($data)
  {
    $retour = false;
    foreach ($_SESSION["collections"] as $value) {
      if ($data["collection_id"] == $value["collection_id"]) {
        $retour = true;
        break;
      }
    }
    return $retour;
  }

  /**
   * Verify if user is granted to modify the sample identified by uid
   *
   * @param int $uid
   *
   * @return boolean
   */
  public function verifyCollectionFromUid($uid)
  {
    if ($uid > 0) {
      $data = $this->lire($uid);
      return $this->verifyCollection($data);
    }
    return true;
  }

  /**
   * Retourne le nombre d'echantillons attaches a un projet
   *
   * @param int $collection_id
   *
   * @return int
   */
  public function getNbFromCollection($collection_id)
  {
    if ($collection_id > 0) {
      $sql = "select count(*)as nb from sample
            where collection_id = :collection_id";
      $var["collection_id"] = $collection_id;
      $data = $this->lireParamAsPrepared($sql, $var);
      if (count($data) > 0) {
        return $data["nb"];
      } else {
        return 0;
      }
    }
  }

  /**
   * Fonction de recherche des échantillons
   *
   * @param array $param
   *
   * @return array
   */
  public function sampleSearch($param)
  {
    /**
     * Verification de la presence des parametres
     */
    $searchOk = false;
    $paramName = array("name",  "sample_type_id", "collection_id", "sampling_place_id", "referent_id", "movement_reason_id", "select_date", "campaign_id", "country_id", "event_type_id", "subsample_quantity");
    if ($param["object_status_id"] > 1 || $param["trashed"] == 1 || $param["uid_min"] > 0 || $param["uid_max"] > 0 || $param["booking_type"] != 0) {
      $searchOk = true;
    } else {
      foreach ($paramName as $name) {
        if (strlen($param[$name]) > 0) {
          $searchOk = true;
          break;
        }
      }
    }
    /**
     * Search for  geographic zone
     */
    $geoFields = array("SouthWestlon", "SouthWestlat", "NorthEastlon", "NorthEastlat");
    $geoSearch = true;
    foreach ($geoFields as $field) {
      if (strlen($param[$field]) == 0) {
        $geoSearch = false;
      }
    }
    if ($geoSearch) {
      $searchOk = true;
    }
    if ($searchOk) {
      $data = array();
      $where = "where";
      $and = "";
      if ($param["sample_type_id"] > 0) {
        $where .= " s.sample_type_id = :sample_type_id";
        $data["sample_type_id"] = $param["sample_type_id"];
        $and = " and ";
      }
      if (strlen($param["name"]) > 0) {
        $where .= $and . "( ";
        $or = "";
        if (is_numeric($param["name"])) {
          $where .= " s.uid = :uid";
          $data["uid"] = $param["name"];
          $or = " or ";
        }
        if (strlen($param["name"]) == 36) {
          $where .= "so.uuid = :uuid";
          $data["uuid"] = $param["name"];
          $or = " or ";
        }
        $name = $this->encodeData($param["name"]);
        $identifier = "%" . strtoupper($name) . "%";
        $where .= "$or upper(so.identifier) like :identifier or upper(s.dbuid_origin) = upper(:dbuid_origin)";
        $and = " and ";
        $data["identifier"] = $identifier;
        $data["dbuid_origin"] = $name;
        /*
             * Recherche sur les identifiants externes
             * possibilite de recherche sur cab:valeur, p. e.
             */
        $where .= " or upper(voi.identifiers) like :identifier ";
        $where .= ")";
      }
      if ($param["collection_id"] > 0) {
        $where .= $and . " s.collection_id = :collection_id";
        $and = " and ";
        $data["collection_id"] = $param["collection_id"];
      }
      if ($param["object_status_id"] > 0) {
        $where .= $and . " so.object_status_id = :object_status_id";
        $and = " and ";
        $data["object_status_id"] = $param["object_status_id"];
      }
      if (strlen($param["trashed"]) > 0) {
        $where .= $and . " so.trashed = :trashed";
        $and = " and ";
        $data["trashed"] = $param["trashed"];
      }
      if ($param["sampling_place_id"] > 0) {
        $where .= $and . " s.sampling_place_id = :sampling_place_id";
        $and = " and ";
        $data["sampling_place_id"] = $param["sampling_place_id"];
      }
      if ($param["referent_id"] > 0) {
        $where .= $and . "(ro.referent_id = :referent_id1 or cr.referent_id = :referent_id2)";
        $and = " and ";
        $data["referent_id1"] = $param["referent_id"];
        $data["referent_id2"] = $param["referent_id"];
      }
      if ($param["campaign_id"] > 0) {
        $where .= $and . " s.campaign_id = :campaign_id";
        $and = " and ";
        $data["campaign_id"] = $param["campaign_id"];
      }
      if (!empty($param["authorization_number"])) {
        $where .= $and . "upper(campreg.authorization_number) like upper(:authorization_number)";
        $and = " and ";
        $data["authorization_number"] = "%" . $param["authorization_number"] . "%";
      }
      if ($param["country_id"] > 0) {
        $where .= $and . " (s.country_id = :country_id or sp.country_id = :country_id)";
        $and = " and ";
        $data["country_id"] = $param["country_id"];
      }
      if ($param["country_origin_id"] > 0) {
        $where .= $and . " (s.country_origin_id = :country_origin_id)";
        $and = " and ";
        $data["country_origin_id"] = $param["country_origin_id"];
      }

      if ($param["uid_max"] > 0 && $param["uid_max"] >= $param["uid_min"]) {
        $where .= $and . " s.uid between :uid_min and :uid_max";
        $and = " and ";
        $data["uid_min"] = $param["uid_min"];
        $data["uid_max"] = $param["uid_max"];
      }
      if (strlen($param["select_date"]) > 0) {
        $tablefield = "s";
        switch ($param["select_date"]) {
          case "cd":
            $field = "sample_creation_date";
            break;
          case "sd":
            $field = "sampling_date";
            break;
          case "ed":
            $field = "expiration_date";
            break;
          case "ch":
            $field = "change_date";
            $tablefield = "so";
            break;
        }
        $where .= $and . " $tablefield.$field::date between :date_from and :date_to";
        $data["date_from"] = $this->formatDateLocaleVersDB($param["date_from"], 2);
        $data["date_to"] = $this->formatDateLocaleVersDB($param["date_to"], 2);
        $and = " and ";
      }
      /**
       * Recherche dans les metadonnees
       */
      if (strlen($param["metadata_field"][0]) > 0 && strlen($param["metadata_value"][0]) > 0) {
        $where .= $and . " ";
        /**
         * Traitement des divers champs de metadonnees (3 maxi)
         * ajout des parentheses si necessaire
         * si le meme field est utilise, operateur or, sinon operateur and
         */
        if ($param["metadata_field"][0] == $param["metadata_field"][1]) {
          $is_or = true;
        } else {
          $is_or = false;
        }
        if (strlen($param["metadata_field"][1]) > 0 && $param["metadata_field"][2] == $param["metadata_field"][1] && strlen($param["metadata_value"][2]) > 0) {
          $is_or1 = true;
        } else {
          $is_or1 = false;
        }
        if ($is_or) {
          $where .= "(";
        }
        $where .= "lower(s.metadata->>:metadata_field0) like lower (:metadata_value0)";
        $data["metadata_field0"] = $param["metadata_field"][0];
        $data["metadata_value0"] = "%" . $param["metadata_value"][0] . "%";
        if (strlen($param["metadata_field"][1]) > 0 && strlen($param["metadata_value"][1]) > 0) {
          if ($is_or) {
            $where .= " or ";
          } else {
            $where .= " and ";
          }
          $where .= " lower(s.metadata->>:metadata_field1) like lower (:metadata_value1)";
          $data["metadata_field1"] = $param["metadata_field"][1];
          $data["metadata_value1"] = "%" . $param["metadata_value"][1] . "%";
        }
        if ($is_or && !$is_or1) {
          $where .= ")";
          $is_or = false;
        }
        if (!$is_or && $is_or1) {
          $where .= " (";
        }

        if (strlen($param["metadata_field"][2]) > 0 && strlen($param["metadata_value"][2]) > 0) {
          if ($is_or1) {
            $where .= " or ";
          } else {
            $where .= " and ";
          }
          $where .= " lower(s.metadata->>:metadata_field2) like lower (:metadata_value2)";
          $data["metadata_field2"] = $param["metadata_field"][2];
          $data["metadata_value2"] = "%" . $param["metadata_value"][2] . "%";
        }
        if ($is_or || $is_or1) {
          $where .= ")";
        }
        $and = " and ";
      }
      /**
       * Recherche sur le motif de destockage
       */
      if ($param["movement_reason_id"] > 0) {
        $where .= $and . " movement_reason_id = :movement_reason_id";
        $data["movement_reason_id"] = $param["movement_reason_id"];
        $and = " and ";
      }
      /**
       * Search by geographic zone
       */
      if ($geoSearch) {
        $where .= $and . " st_contains (st_setsrid (st_makebox2d(
                    st_makepoint(:southwestlon, :southwestlat),
                    st_makepoint(:northeastlon, :northeastlat))
                    ,4326), so.geom::geometry) = true ";
        $data["southwestlon"] = $param["SouthWestlon"];
        $data["southwestlat"] = $param["SouthWestlat"];
        $data["northeastlon"] = $param["NorthEastlon"];
        $data["northeastlat"] = $param["NorthEastlat"];
        $and = " and ";
      }
      /**
       * Search on an event_type
       */
      if ($param["event_type_id"] > 0) {
        $this->sql .= " left outer join event oe on (so.uid = oe.uid) ";
        $where .= $and . " event_type_id = :event_type_id";
        $data["event_type_id"] = $param["event_type_id"];
        $and = " and ";
      }
      /**
       * Search on minimal subsample quantity
       */
      if ($param["subsample_quantity_min"] > 0) {
        $where .= $and . "(vsq.multiple_value + vsq.subsample_more - vsq.subsample_less) >= :subsample_quantity_min";
        $data["subsample_quantity_min"] = $param["subsample_quantity_min"];
        $and = " and ";
      }
      /**
       * Search on minimal subsample quantity
       */
      if (!empty($param["subsample_quantity_max"])) {
        $where .= $and . "(vsq.multiple_value + vsq.subsample_more - vsq.subsample_less) <= :subsample_quantity_max";
        $data["subsample_quantity_max"] = $param["subsample_quantity_max"];
        $and = " and ";
      }
      /**
       * Search on booking
       */
      if ($param["booking_type"] != 0) {
        $data["booking_from"] = $this->formatDateLocaleVersDB($param["booking_from"], 2) . " 00:00:00";
        $data["booking_to"] = $this->formatDateLocaleVersDB($param["booking_to"], 2) . " 23:59:59";
        $where .= $and . " (select count(*) from booking b where ((:booking_from ::timestamp, :booking_to ::timestamp) overlaps (date_from::timestamp, date_to::timestamp)) = true
        and b.uid = so.uid)  ";
        $param["booking_type"] == 1 ? $where .= " > 0 " : $where .= " = 0 ";
        $and = " and ";
      }
      /**
       * Fin de traitement des criteres de recherche
       */
      if ($where == "where") {
        $where = "";
      }
      /**
       * Rajout de la date de dernier mouvement pour l'affichage
       */
      $this->colonnes["movement_date"] = array(
        "type" => 3,
      );
      $this->colonnes["borrowing_date"] = array("type" => 2);
      $this->colonnes["expected_return_date"] = array("type" => 2);
      $this->colonnes["change_date"] = array("type" => 3);
      /*printr($this->sql);
      printr($where);
      printA($data);*/

      $list = $this->getListeParamAsPrepared($this->sql . $where, $data);
      /**
       * Destroy foreign fields used in the request
       */
      unset($this->colonnes["movement_date"]);
      unset($this->colonnes["borrowing_date"]);
      unset($this->colonnes["expected_return_date"]);
      unset($this->colonnes["change_date"]);
      return $list;
    } else {
      return array();
    }
  }

  /**
   * Retourne les echantillons associes a un parent
   *
   * @param int $uid
   *            : uid du parent
   */
  public function getSampleassociated($uid)
  {
    if ($uid > 0 && is_numeric($uid)) {
      $data["uid"] = $uid;
      $where = " where pso.uid = :uid";
      $order = " order by s.uid";
      return $this->getListeParamAsPrepared($this->sql . $where . $order, $data);
    }
  }

  /**
   * Retourne la liste des informations pour des echantillons
   * script d'export pour import
   *
   * @param string $uids
   * @return array
   */
  public function getForExport($uids)
  {
    if (strlen($uids) == 0) {
      throw new SampleException("Pas d'échantillons sélectionnés");
    } else {
      $this->auto_date = 0;
      $sql = "select o.uid, identifier, object_status_name, wgs84_x, wgs84_y, location_accuracy
            , object_comment as comment,
             c.collection_id, collection_name, sample_type_name, sample_creation_date, sampling_date, expiration_date,
             multiple_value, sampling_place_name, metadata::varchar,
            voi.identifiers, dbuid_origin, parent_sample_id, '' as dbuid_parent,
            campaign_name,
            case when ro.referent_name is not null then trim(ro.referent_name || ' ' || coalesce(ro.referent_firstname, '')) else trim(cr.referent_name || ' ' || coalesce(cr.referent_firstname, '')) end as referent_name
            ,o.uuid
            ,ctry.country_code2 as country_code, ctryo.country_code2 as country_origin_code
            from sample
            join object o using(uid)
            join collection c using (collection_id)
            left outer join v_object_identifier voi on (o.uid = voi.uid)
            left outer join sampling_place using (sampling_place_id)
            left outer join sample_type using (sample_type_id)
            left outer join object_status using (object_status_id)
            left outer join referent ro on (o.referent_id = ro.referent_id)
            left outer join referent cr on (c.referent_id = cr.referent_id)
            left outer join campaign using (campaign_id)
            left outer join country ctry on (sample.country_id = ctry.country_id)
            left outer join country ctryo on (sample.country_origin_id = ctryo.country_id)
             where o.uid in (" . $uids . ")";
      $d = $this->getListeParam($sql);
      $this->auto_date = 1;
      /*
             * genere le dbuid pour import dans base externe
             */
      $data = array();
      foreach ($d as $value) {
        if ($this->verifyCollection($value)) {
          if (strlen($value["dbuid_origin"]) == 0) {
            $value["dbuid_origin"] = $_SESSION["APPLI_code"] . ":" . $value["uid"];
          }
          /*
                     * Generation du dbuid du parent dans le cas d'un echantillon derive
                     */
          if ($value["parent_sample_id"] > 0) {
            $dparent = $this->lireFromId($value["parent_sample_id"]);
            $value["dbuid_parent"] = $_SESSION["APPLI_code"] . ":" . $dparent["uid"];
          }
          unset($value["parent_sample_id"]);
          unset($value["collection_id"]);
          unset($value["uid"]);
          /*
                     * Traitement des metadonnees - ajout de colonnes prefixees avec md_
                     */
          $metadata = json_decode($value["metadata"], true);
          foreach ($metadata as $kmd => $md) {
            if (is_array($md)) {
              $val = "";
              $comma = "";
              foreach ($md as $v) {
                $val .= $comma . $v;
                $comma = ", ";
              }
            } else {
              $val = $md;
            }
            $value["md_" . $kmd] = $val;
          }
          /*
                     * Fin de traitement - rajout de la ligne reformatee
                     */
          $data[] = $value;
        }
      }
      if (count($data) > 0) {
        return $data;
      } else {
        throw new SampleException(_("Droits insuffisants pour exporter les échantillons"));
      }
    }
  }

  /**
   * Genere une liste des uids separes par une virgule, a partir d'un
   * tableau contenant la liste des uid
   * (retour de formulaire a choix multiple)
   *
   * @param array $uids
   */
  public function generateArrayUidToString($uids)
  {
    if (count($uids) > 0) {
      /*
             * Verification que les uid sont numeriques
             * preparation de la clause where
             */
      $comma = false;
      $val = "";
      foreach ($uids as $value) {
        if (is_numeric($value) && $value > 0) {
          $comma ? $val .= "," : $comma = true;
          $val .= $value;
        }
      }
      return $val;
    }
  }

  /**
   * Recupere tous les libelles des tables de reference utilises dans le fichier a importer
   * import de donnees externes
   *
   * @param array $data
   * @return mixed[][]
   */
  public function getAllNamesFromReference($data)
  {
    $names = array();
    $fields = array(
      "sampling_place_name",
      "object_status_name",
      "collection_name",
      "sample_type_name",
      "referent_name",
      "campaign_name"
    );
    foreach ($data as $line) {
      foreach ($fields as $field) {
        if (strlen($line[$field]) > 0) {
          if (!in_array($line[$field], $names[$field])) {
            $names[$field][] = $line[$field];
          }
        }
      }
      /*
             * Traitement des identifiants secondaires
             */
      if (strlen($line["identifiers"]) > 0) {
        $idents = explode(",", $line["identifiers"]);
        foreach ($idents as $ident) {
          $idvalue = explode(":", $ident);
          if (!in_array($idvalue[0], $names["identifier_type_code"])) {
            $names["identifier_type_code"][] = $idvalue[0];
          }
        }
      }
    }
    return $names;
  }

  /**
   * Verifie que l'echantillon peut etre importe
   *
   * @param array $row
   * @throws SampleException
   * @return boolean
   */
  public function verifyBeforeImport($row)
  {
    if (count($row) > 0) {
      if (strlen($row["dbuid_origin"]) == 0) {
        throw new SampleException(_("L'identifiant de la base de données d'origine n'a pas été fourni"));
      }
      /*
             * Verification de l'existence de la collection
             */
      if (strlen($row["collection_name"]) == 0) {
        throw new SampleException(_("Le nom de la collection n'a pas été renseigné"));
      }
      /*
             * Verification de l'existence d'un type d'echantillon
             */
      if (strlen($row["sample_type_name"]) == 0) {
        throw new SampleException(_("Le type d'échantillon n'a pas été renseigné"));
      }
      /*
             * Verification de la coherence des dates
             */
      $fieldDates = array(
        "sampling_date",
        "expiration_date",
        "sample_creation_date",
      );
      foreach ($fieldDates as $fieldDate) {
        if (strlen($row[$fieldDate]) > 0) {
          /*
                     * Verification du format de date
                     */
          $result = date_parse_from_format($_SESSION["MASKDATE"], $row[$fieldDate]);
          if ($result["warning_count"] > 0) {
            /*
                         * Test du format general
                         */
            $result = date_parse($row[$fieldDate]);
            if ($result["warning_count"] > 0) {
              throw new SampleException(sprintf(_("Le format de date de %s n'est pas reconnu. "), $fieldDate));
            }
          }
          if ($result["warning_count"] == 0) {
            /*
                         * Verification que la date contienne bien une annee, mois, jour
                         */
            if (strlen($result["year"]) == 0 || strlen($result["month"]) == 0 || strlen($result["day"]) == 0) {
              throw new SampleException(sprintf(_("La date de %s est incomplète ou incohérente. "), $fieldDate));
            }
          }
        }
      }
      /**
       * Control of the numeric values
       */
      $numFields = array("location_accuracy");
      foreach ($numFields as $numField) {
        if (strlen($row[$numField]) > 0 && !is_numeric($row[$numField])) {
          throw new SampleException(sprintf(_("Le champ %s n'est pas numérique"), $numField));
        }
      }
      /**
       * Verification de la colonne metadata
       */
      if (strlen($row["metadata"]) > 2) {
        $a_m = json_decode($row["metadata"], true);
        if (count($a_m) == 0) {
          throw new SampleException(_("Les métadonnées ne sont pas correctement formatées (champ metadata)"));
        }
      }
      /**
       * Verification du pays
       */
      foreach (array("country_code", "country_origin_code") as $field) {
        if (!empty($row[$field])) {
          if (!isset($this->country)) {
            $this->country = $this->classInstanciate("Country", "country.class.php");
          }
          $country_id = $this->country->getIdFromCode($row[$field]);
          if (!$country_id > 0) {
            throw new SampleException(sprintf(_("Le code de pays %s n'est pas connu"), $row[$field]));
          }
        }
      }
    }
    return true;
  }

  /**
   * Fonction d'ecriture dans le cadre d'un import externe
   *
   * @param array $data
   * @throws SampleException
   * @return number
   */
  public function ecrireImport($data)
  {
    $object = new ObjectClass($this->connection, $this->param);
    /*
         * Ajout des informations manquantes
         */
    if (strlen($data["object_status_id"]) == 0) {
      $data["object_status_id"] = 1;
    }
    if (strlen($data["sample_creation_date"]) == 0) {
      $data["sample_creation_date"] = date(DATE_ATOM);
    }
    /*
         * Search from uuid
         */
    $uuidFound = false;
    if (strlen($data["uuid"]) == 36) {
      $uid = $this->getUidFromUUID($data["uuid"]);
      if ($uid > 0) {
        $data["uid"] = $uid;
        $uuidFound = true;
      }
    }
    /**
     * Recherche de l'uid existant a partir de dbuid_origin
     */
    if (strlen($data["dbuid_origin"]) > 0 && !$uuidFound) {
      /**
       * Recherche si c'est une reintegration dans la base d'origine
       */
      $field = explode(":", $data["dbuid_origin"]);
      if ($field[0] == $_SESSION["APPLI_code"]) {
        $uid = $field[1];
        $data["dbuid_origin"] = "";
      } else {
        $uid = $this->getUidFromDbuidOrigin($data["dbuid_origin"]);
      }
      if ($uid > 0) {
        $data["uid"] = $uid;
      }
    }
    /**
     * Reformatage des données diverses
     */
    if (!empty($data["comment"])) {
      $data["object_comment"] = $data["comment"];
    }
    if (!empty($data["country_code"])) {
      if (!isset($this->country)) {
        $this->country = $this->classInstanciate("Country", "country.class.php");
      }
      $data["country_id"] = $this->country->getIdFromCode($data["country_code"]);
    }

    /**
     * Recuperation de l'echantillon parent, si existant
     */
    if (strlen($data["dbuid_parent"]) > 0) {
      $dbuidparent = explode(":", $data["dbuid_parent"]);
      if ($dbuidparent[0] == $_SESSION["APPLI_code"]) {
        $dataParent = $this->lire($dbuidparent[1]);
      } else {
        $dataParent = $this->lireParamAsPrepared(
          "select sample_id from sample where dbuid_origin = :dbuidorigin",
          array(
            "dbuidorigin" => $data["dbuid_parent"],
          )
        );
      }
      if ($dataParent["sample_id"] > 0) {
        $data["parent_sample_id"] = $dataParent["sample_id"];
      }
    }
    $uid = $object->ecrire($data);
    if ($uid > 0) {
      $data["uid"] = $uid;
      /**
       * Recherche de l'identifiant d'origine (sample_id)
       */
      $dataOrigine = $this->lire($uid);
      if ($dataOrigine["sample_id"] > 0) {
        $data["sample_id"] = $dataOrigine["sample_id"];
      }
      parent::ecrire($data);
      return $uid;
    } else {
      throw new SampleException(_("Impossible d'écrire dans la table Object"));
    }
  }

  /**
   * Recherche l'uid a partir du dbuid_origin
   *
   * @param string $dbuidorigin
   * @return number
   */
  public function getUidFromDbuidOrigin($dbuidorigin)
  {
    $uid = 0;
    if (strlen($dbuidorigin) > 0) {
      /*
             * Recherche si l'echantillon provient de la base de donnees courante
             * cas de la reintegration d'un echantillon modifie a l'exterieur
             */

      $sql = "select uid from sample where dbuid_origin = :dbuid_origin";
      $data = $this->lireParamAsPrepared(
        $sql,
        array(
          "dbuid_origin" => $dbuidorigin,
        )
      );
      if ($data["uid"] > 0) {
        $uid = $data["uid"];
      }
    }
    return $uid;
  }

  /**
   * Assign the referent at the sample
   * Verify before if the user is unable to modify the sample
   *
   * @param int         $uid
   * @param ObjectClass $objectClass
   * @param id          $referent_id
   *
   * @return void
   */
  public function setReferent($uid, $objectClass, $referent_id)
  {
    if ($uid > 0) {
      if ($this->verifyCollectionFromUid($uid)) {
        $objectClass->setReferent($uid, $referent_id);
      } else {
        throw new SampleException(
          sprintf(
            _("Vous ne disposez pas des droits nécessaires pour modifier l'échantillon %1s"),
            $uid
          )
        );
      }
    }
  }
  /**
   * Get the uuid of a sample from the uuid
   *
   * @param string $uuid
   * @return void
   */
  public function getUidFromUUID($uuid)
  {
    $sql = "select uid from object
                join sample using (uid)
                where uuid = :uuid";
    $data = $this->lireParamAsPrepared($sql, array("uuid" => $uuid));
    return ($data["uid"]);
  }

  /**
   * Get a sample with its containers, identifiers and events
   * in raw format
   *
   * @param int $uid
   * @param boolean $withContainers
   * @return array
   */
  function getRawDetail($uid, $withContainers = false, $withEvents = false)
  {
    $this->auto_date = 0;
    if (strlen($uid) == 36) {
      /**
       * Search by uuid
       */
      $where = " where so.uuid = :uid";
    } else {
      $where = " where s.uid = :uid";
    }
    $data = $this->lireParamAsPrepared($this->sql . $where, array("uid" => $uid));
    /**
     * Purge the metadata_schema to keep the type and the unit
     */
    $metadata_schema = json_decode($data["metadata_schema"], true);

    unset($data["metadata_schema"]);
    /**
     * Encode in array the metadata content
     */
    $data["metadata"] = json_decode($data["metadata"], true);
    foreach ($data["metadata"] as $k => $v) {
      foreach ($metadata_schema as $schema) {
        if ($schema["name"] == $k) {
          if ($schema["type"] == "number") {
            $data["md_" . $schema["name"] . "_unit"] = $schema["measureUnit"];
          }
          break;
        }
      }
    }
    /**
     * Get the events
     */
    if ($withEvents) {
      if (!isset($this->event)) {
        require_once 'modules/classes/event.class.php';
        $this->event = new Event($this->connection, $this->paramori);
      }
      $this->event->auto_date = 0;
      $data["events"] = $this->event->getListeFromUid($data["uid"]);
      $this->event->auto_date = 1;
    }
    /**
     * Get the hierarchy of containers
     */
    if ($withContainers) {
      if (!isset($this->container)) {
        require_once "modules/classes/container.class.php";
        $this->container = new Container($this->connection, $this->paramori);
      }
      $data["container"] = $this->container->getAllParents($data["uid"]);
    }
    $this->auto_date = 1;
    return $data;
  }
  /**
   * Get all informations of  samples from a list of uid
   * The list must be under the form: 1,4,25 and ready to use with "where uid in( )";
   *
   * @param string $uids
   * @return array
   */
  function getListFromUids($uids)
  {
    $where = " where s.uid in ($uids)";
    return $this->getListeParam($this->sql . $where);
  }
  /**
   * Set the country for an array of uids
   *
   * @param array $uids
   * @param integer $country_id
   * @return void
   */
  function setCountry(array $uids, int $country_id)
  {
    $sql = "update sample set country_id = :country_id where uid = :uid";
    $data = array("country_id" => $country_id);
    foreach ($uids as $uid) {
      $data["uid"] = $uid;
      $this->executeAsPrepared($sql, $data);
    }
  }
  /**
   * Set the collection for an array of uids
   *
   * @param array $uids
   * @param integer $collection_id
   * @return void
   */
  function setCollection(array $uids, int $collection_id)
  {
    $sql = "update sample set collection_id = :collection_id where uid = :uid";
    $data = array("collection_id" => $collection_id);
    foreach ($uids as $uid) {
      $data["uid"] = $uid;
      $this->executeAsPrepared($sql, $data);
    }
  }
  /**
   * Set the campaign for an array of uids
   *
   * @param array $uids
   * @param integer $campaign_id
   * @return void
   */
  function setcampaign(array $uids, int $campaign_id)
  {
    $sql = "update sample set campaign_id = :campaign_id where uid = :uid";
    $data = array("campaign_id" => $campaign_id);
    foreach ($uids as $uid) {
      $data["uid"] = $uid;
      $this->executeAsPrepared($sql, $data);
    }
  }
  /**
   * Get a sample from an identifier (uid, uuid, etc.)
   *
   * @param string $fieldname
   * @param string $id
   * @return array|null
   */
  function getFromField(string $fieldname, string $id, int $collection_id = 0): ?array
  {
    $sql = "select * from sample join object using (uid) ";
    $param = array("id" => $id);
    switch ($fieldname) {
      case "uid":
        $sql .= " where uid = :id";
        break;
      case "uuid":
        $sql .= " where uuid::varchar = lower(:id)";
        break;
      case "identifier":
        $sql .= " where identifier = :id";
        if ($collection_id > 0) {
          $sql .= " and collection_id = :collection_id";
          $param["collection_id"] = $collection_id;
        }
        break;
      default:
        $sql .= " join object_identifier using (uid)
                join identifier_type using (identifier_type_id)
                where identifier_type_code = :fieldname and object_identifier_value = :id
        ";
        $param["fieldname"] = $fieldname;
        if ($collection_id > 0) {
          $sql .= " and collection_id = :collection_id";
          $param["collection_id"] = $collection_id;
        }
        break;
    }
    return $this->lireParamAsPrepared($sql, $param);
  }
  /**
   * Get the list of samples contained into a container and its children
   *
   * @param integer $uid
   * @return array
   */
  function getAllSamplesFromContainer(int $uid): array
  {
    /**
     * Get the list of samples
     */
    $sql = "with recursive containers as (
      select c.container_id
      from last_movement
      join object using (uid)
      left outer join container c using (uid)
      left outer join container_type using (container_type_id)
      where uid = :uid and movement_type_id = 1
      union all
      select cl.container_id
      from object o
      join container cl using (uid)
      join container_type ct using (container_type_id)
      left outer join last_movement lm on (lm.uid = o.uid and lm.movement_type_id =1)
       join containers on (containers.container_id = lm.container_id)
       )
       select s.uid
       from sample s
       join object so using (uid)
       join sample_type using (sample_type_id)
       join last_movement lm on (lm.uid = so.uid and lm.movement_type_id = 1)
       where lm.container_id in (select container_id from containers)";
    $listUids = $this->getListeParamAsPrepared($sql, array("uid" => $uid));
    if (count($listUids) > 0) {
      $uids = "";
      $comma = "";
      foreach ($listUids as $item) {
        $uids .= $comma . $item["uid"];
        $comma = ",";
      }
      return $this->getListFromUids($uids);
    } else {
      return array();
    }
  }
}
