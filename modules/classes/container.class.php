<?php

/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
//require_once 'modules/classes/object.class.php';
class ContainerException extends Exception
{
};

class Container extends ObjetBDD
{

  private $sql = "select c.container_id, o.uid, o.identifier, o.wgs84_x, o.wgs84_y,
                    o.change_date, o.uuid, o.trashed, o.location_accuracy, o.object_comment,
					container_type_id, container_type_name, nb_slots_max,
					container_family_id, container_family_name, os.object_status_id, object_status_name,
					storage_product, clp_classification, storage_condition_name,
					document_id, identifiers,
					movement_date, movement_type_name, movement_type_id,
          lines, columns, first_line, first_column, line_in_char, column_in_char,
          column_number, line_number, container_uid, oc.identifier as container_identifier,
          o.referent_id, referent_name, referent_firstname, referent_email, address_name, address_line2, address_line3, address_city, address_country, referent_phone, academical_directory, academical_link,
          borrowing_date, expected_return_date, borrower_id, borrower_name,
          nb_slots_used
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
          left outer join referent r on (o.referent_id = r.referent_id)
          left outer join last_borrowing lb on (o.uid = lb.uid)
          left outer join borrower using (borrower_id)
          left outer join slots_used su on (c.container_id = su.container_id)
            ";
  private $uidMin = 999999999, $uidMax = 0, $numberUid = 0;

  private $movement, $object;

  /**
   *
   * @param PDO   : $bdd
   * @param array : $param
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
  function lire($uid, $getDefault = false, $parentValue = "")
  {
    $sql = $this->sql . " where o.uid = :uid";
    $data["uid"] = $uid;
    $this->colonnes["borrowing_date"] = array("type" => 2);
    $this->colonnes["expected_return_date"] = array("type" => 2);
    $this->colonnes["change_date"] = array("type" => 3);
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
    $object = new ObjectClass($this->connection, $this->param);
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
    /**
     * Find out if objects are stored in the container
     */
    $sql = "select count(*) as nb from last_movement
                where movement_type_id = 1 and container_id = :container_id";
    $result = $this->lireParamAsPrepared($sql, array("container_id" => $data["container_id"]));
    if ($result["nb"] > 0) {
      throw new ObjetBDDException(_("Le contenant contient des objets, il ne peut être supprimé"));
    } else {
      /**
       * Delete the movements attached to the container
       */
      if (!isset($this->movement)) {
        require_once 'modules/classes/movement.class.php';
        $this->movement = new Movement($this->connection, $this->paramori);
      }
      $this->movement->deleteFromContainer($data["container_id"]);
      /**
       * delete the container
       */
      parent::supprimer($data["container_id"]);
      /**
       * Delete the object
       */
      if (!isset($this->object)) {
        require_once 'modules/classes/object.class.php';
        $this->object = new ObjectClass($this->connection, $this->paramori);
      }
      $this->object->supprimer($uid);
    }
  }

  /**
   * Retourne tous les échantillons contenus
   * dans le contenant
   *
   * @param int : $uid
   * @return array
   */
  function getContentSample($uid)
  {
    if ($uid > 0 && is_numeric($uid)) {
      $sql = "select o.uid, o.identifier, sa.*,
					movement_date, movement_type_id, identifiers,
                    collection_name, sample_type_name, object_status_name, o.trashed, o.uuid, o.location_accuracy,
                    o.object_comment,
					sampling_place_name,
					pso.uid as parent_uid, pso.identifier as parent_identifier,
                    lm.column_number, lm.line_number,
                    case when ro.referent_name is not null then ro.referent_name else cr.referent_name end as referent_name
                    ,lm.container_uid
					from object o
					join sample sa on (sa.uid = o.uid)
					join last_movement lm on (lm.uid = o.uid and lm.container_uid = :uid)
					join collection c using (collection_id)
					join sample_type using (sample_type_id)
					left outer join v_object_identifier voi on (o.uid = voi.uid)
					left outer join object_status using (object_status_id)
					left outer join sampling_place using (sampling_place_id)
					left outer join sample ps on (sa.parent_sample_id = ps.sample_id)
					left outer join object pso on (ps.uid = pso.uid)
                    left outer join referent ro on (o.referent_id = ro.referent_id)
                    left outer join referent cr on (c.referent_id = cr.referent_id)
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
   * Retourne tous les contenants contenus
   *
   * @param int $uid
   * @return array
   */
  function getContentContainer($uid)
  {
    if ($uid > 0 && is_numeric($uid)) {
      $sql = "select o.uid, o.identifier, container_type_id, container_type_name,
                    container_family_id, container_family_name, o.object_status_id, o.trashed,
                    o.location_accuracy, o.uuid, o.object_comment,
					  storage_product, storage_condition_name,
					  object_status_name, clp_classification,
					  movement_date, movement_type_id, column_number, line_number,
            document_id
            ,lm.container_uid
            ,nb_slots_used, nb_slots_max
					from object o
					join container co on (co.uid = o.uid)
					join container_type using (container_type_id)
					join container_family using (container_family_id)
					join last_movement lm on (lm.uid = o.uid and lm.container_uid = :uid)
					left outer join object_status os on (o.object_status_id = os.object_status_id)
					left outer join storage_condition using (storage_condition_id)
          left outer join  last_photo on (o.uid = last_photo.uid)
          left outer join slots_used su on (co.container_id = su.container_id)
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
   * Retourne le contenant parent
   *
   * @param int $uid
   * @return array
   */
  function getParent($uid)
  {
    if ($uid > 0 && is_numeric($uid)) {
      $sql = "select co.container_id, o.uid, o.identifier, container_type_id, container_type_name, o.uuid
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
   * Retourne tous les contenants parents d'un objet
   *
   * @param int $uid
   * @return array
   */
  function getAllParents($uid)
  {
    $sql = "with recursive containers as (
            select uid, container_uid, identifier, container_type_name, uuid, c.container_id
            from last_movement
            join object using (uid)
            left outer join container c using (uid)
            left outer join container_type using (container_type_id)
            where uid = :uid and movement_type_id = 1
            union all
            select o.uid, lm.container_uid, o.identifier, ct.container_type_name, o.uuid, cl.container_id
            from object o
            join container cl using (uid)
            join container_type ct using (container_type_id)
            left outer join last_movement lm on (lm.uid = o.uid and lm.movement_type_id =1)
             join containers on (containers.container_uid = o.uid)
             )
             select *
              from containers
              where uid <> :uid";
    return $this->getListeParamAsPrepared($sql, array("uid" => $uid));
  }

  /**
   * Retourne le numero d'un contenant a partir de son uid
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
      return -1;
    }
  }
  /**
   * Get the container_id from the identifier
   *
   * @param string $identifier
   * @return int
   */
  function getUidFromIdentifier($identifier)
  {
    $sql = "select uid from container
            join object using (uid)
            where lower(identifier) = lower(:identifier)";
    $data = $this->lireParamAsPrepared($sql, array("identifier" => $identifier));
    return $data["uid"];
  }

  /**
   * Recherche les contenants a partir du tableau de parametres fourni
   *
   * @param array $param
   */
  function containerSearch($param)
  {
    /**
     * Verification de la presence des parametres
     */
    $searchOk = false;
    $paramName = array(
      "name", "container_family_id", "container_type_id",  "select_date", "referent_id"
    );
    if ($param["object_status_id"] > 1 || $param["trashed"] == 1 || $param["uid_min"] > 0 || $param["uid_max"] > 0 || $param["event_type_id"] > 0 || $param["movement_reason_id"] > 0) {
      $searchOk = true;
    } else {
      foreach ($paramName as $name) {
        if (strlen($param[$name]) > 0) {
          $searchOk = true;
          break;
        }
      }
    }
    if ($searchOk) {
      $data = array();
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
        if (strlen($param["name"]) == 36) {
          $where .= "o.uuid = :uuid";
          $data["uuid"] = $param["name"];
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
      if (strlen($param["trashed"]) > 0) {
        $where .= $and . " o.trashed = :trashed";
        $and = " and ";
        $data["trashed"] = $param["trashed"];
      }
      if ($param["referent_id"] > 0) {
        $where .= $and . "o.referent_id = :referent_id";
        $and = " and ";
        $data["referent_id"] = $param["referent_id"];
      }
      if ($param["uid_max"] > 0 && $param["uid_max"] >= $param["uid_min"]) {
        $where .= $and . " o.uid between :uid_min and :uid_max";
        $and = " and ";
        $data["uid_min"] = $param["uid_min"];
        $data["uid_max"] = $param["uid_max"];
      }
      if (strlen($param["select_date"]) > 0) {
        $tablefield = "c";
        switch ($param["select_date"]) {
          case "ch":
            $field = "change_date";
            $tablefield = "o";
            break;
        }
        $where .= $and . " $tablefield.$field::date between :date_from and :date_to";
        $data["date_from"] = $this->formatDateLocaleVersDB($param["date_from"], 2);
        $data["date_to"] = $this->formatDateLocaleVersDB($param["date_to"], 2);
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
       * Search on event type
       */
      if ($param["event_type_id"] > 0) {
        $this->sql .= " left outer join event oe on (o.uid = oe.uid) ";
        $where .= $and . " event_type_id = :event_type_id";
        $data["event_type_id"] = $param["event_type_id"];
        $and = " and ";
      }
      if ($and == "") {
        $where = "";
      }

      /**
       * Rajout de la date de dernier mouvement pour l'affichage
       */
      $this->colonnes["movement_date"] = array(
        "type" => 3
      );
      $this->colonnes["change_date"] = array("type" => 3);
      return $this->getListeParamAsPrepared($this->sql . $where /*. $order*/, $data);
    } else {
      return array();
    }
  }

  /**
   * Retourne la liste des contenants correspondant au type
   *
   * @param int $container_type_id
   * @return array
   */
  function getFromType($container_type_id, $trashed = 0)
  {
    if (is_numeric($container_type_id) && $container_type_id > 0) {
      $where = " where container_type_id = :container_type_id and o.trashed = :trashed";
      $order = " order by o.identifier,o.uid";
      return $this->getListeParamAsPrepared($this->sql . $where . $order, array("container_type_id" => $container_type_id, "trashed" => $trashed));
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
  function generateOccupationArray($dcontainer, $dsample, $columns = 1, $lines = 1, $first_line = "T", $first_column = "L")
  {
    $data = array();
    /*
         * Generation d'un tableau vide
         */
    for ($line = 0; $line < $lines; $line++) {
      for ($column = 0; $column < $columns; $column++) {
        $data[$line][$column] = array();
      }
    }
    /*
         * Traitement de chaque tableau pour integrer les informations
         */
    foreach ($dcontainer as $value) {
      if ($value["line_number"] > 0 && $value["column_number"] > 0) {
        $data[$value["line_number"] - 1][$value["column_number"] - 1][] = array("type" => "C", "uid" => $value["uid"], "identifier" => $value["identifier"]);
      }
    }
    foreach ($dsample as $value) {
      if ($value["line_number"] > 0 && $value["column_number"] > 0) {
        $data[$value["line_number"] - 1][$value["column_number"] - 1][] = array("type" => "S", "uid" => $value["uid"], "identifier" => $value["identifier"]);
      }
    }
    /**
     * Table sort
     */
    if ($lines > 1 && $first_line == "B") {
      krsort($data);
    }
    if ($first_column == "R") {
      $dataSorted = array();
      foreach ($data as $key => $row) {
        krsort($row);
        $dataSorted[$key] = $row;
      }
      $data = $dataSorted;
    }
    return $data;
  }
  /**
   * Generate an array with all contents of all containers included
   *
   * @param array $uids
   * @return array
   */
  function generateExportGlobal($uids)
  {
    global $APPLI_version;
    $data = array();
    /**
     * Inhibit the date encoding
     */
    $this->auto_date = 0;
    /**
     * Add reference of the export
     */
    $data["collec-science_version"] = $APPLI_version;
    $data["export_version"] = 1.0;
    if (!is_array($uids)) {
      $uids = array($uids);
    }
    foreach ($uids as $uid) {
      $data[] = $this->getContainerWithObjects($uid);
    }
    return $data;
  }
  /**
   * Get a container with all objects included
   *
   * @param int $uid
   * @return array
   */
  function getContainerWithObjects($uid)
  {
    $row = $this->lire($uid);
    /**
     * Explode the list of secondary identifiers
     */
    if (strlen($row["identifiers"]) > 0) {
      $row["identifiers"] = explode(",", $row["identifiers"]);
    }
    /**
     * Get all samples in the container
     */
    $dataSamples = $this->getContentSample($uid);
    if (count($dataSamples) > 0) {
      $row["samples"] = array();
      /**
       * generate the dbuid_origin
       */
      foreach ($dataSamples as $dataSample) {
        if (strlen($dataSample["dbuid_origin"]) == 0) {
          $dataSample["dbuid_origin"] = $_SESSION["APPLI_code"] . ":" . $dataSample["uid"];
        }
        /**
         * Explode the list of secondary identifiers
         */
        if (strlen($dataSample["identifiers"]) > 0) {
          $dataSample["identifiers"] = explode(",", $dataSample["identifiers"]);
        }
        $row["samples"][] = $dataSample;
      }
    }
    /**
     * Get containers
     */
    $containers = $this->getContentContainer($uid);
    foreach ($containers as $container) {
      $row["containers"][] = $this->getContainerWithObjects($container["uid"]);
    }
    return $row;
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
      "container_type_name"
    );
    foreach ($data as  $df) {
      $names = $this->extractUniqueReference($names, $fields, $df);
    }
    return $names;
  }
  /**
   * Recursive treatment of the data for extract unique references
   *
   * @param array $names
   * @param array $fields
   * @param array $data
   * @return array
   */
  private function extractUniqueReference($names, $fields, $data)
  {
    foreach ($data as $key => $df) {
      if (is_array($df) && $key != "identifiers") {
        foreach ($df as $objet) {
          $names = $this->extractUniqueReference($names, $fields, $objet);
        }
      } else {
        if (strlen($df) > 0 && in_array($key, $fields)) {
          if (!in_array($df, $names[$key])) {
            $names[$key][] = $df;
          }
        }
        /**
         * Traitement des identifiants secondaires
         */
        if ($key == "identifiers") {
          foreach ($df as $ident) {
            $idvalue = explode(":", $ident);
            if (!in_array($idvalue[0], $names["identifier_type_code"])) {
              $names["identifier_type_code"][] = $idvalue[0];
            }
          }
        }
      }
    }
    return $names;
  }

  /**
   * import containers and embedded objects from
   * a JSON file transformed in array
   *
   * @param array $data
   * @param SampleInitClass $sic
   * @param array $post
   * @return void
   */
  function importExternal($data, SampleInitClass $sic, $post)
  {
    $this->auto_date = 0;
    $object = new ObjectClass($this->connection, $this->param);
    include_once 'modules/classes/movement.class.php';
    $movement = new Movement($this->connection, $this->paramori);
    include_once 'modules/classes/sample.class.php';
    $sample = new Sample($this->connection, $this->paramori);
    $sample->auto_date = 0;
    include_once 'modules/classes/objectIdentifier.class.php';
    $objectIdentifier = new ObjectIdentifier($this->connection, $this->paramori);
    $dclass = $sic->init(true);
    $this->uidMin = 999999999;
    $this->uidMax = 0;
    $this->numberUid = 0;
    foreach ($data as $row) {
      $this->importContainer($row, $dclass, $sic, $post, $object, $movement, $objectIdentifier, $sample, 0);
    }
  }

  /**
   * Import a container with embedded objects
   *
   * @param array $data
   * @param array $dclass
   * @param SampleInitClass $sic
   * @param array $post
   * @param ObjectClass $object
   * @param Movement $movement
   * @param Sample $sampleClass
   * @param integer $uid_parent
   * @return int
   */
  function importContainer($data, $dclass, $sic, $post, $object, $movement, $objectIdentifier, $sampleClass, $uid_parent = 0)
  {
    if (is_array($data)) {
      $staticFields = array(
        "identifier",
        "wgs84_x",
        "wgs84_y",
        "identifiers"
      );
      $dynamicFields = array(
        "object_status_name",
        "referent_name",
        "container_type_name"
      );
      $dcontainer = array();
      foreach ($staticFields as $field) {
        $dcontainer[$field] = $data[$field];
      }
      foreach ($dynamicFields as $field) {
        if (strlen($data[$field]) > 0) {
          /*
                 * Search the value from post data
                 */
          $value = $data[$field];
          /*
                 * Transformation of spaces in underscore,
                 * to take into encoding realized by the browser
                 */
          $fieldHtml = str_replace(" ", "_", $value);
          $newval = $post[$field . "-" . $fieldHtml];
          /*
                 * Recherche de la cle correspondante
                 */
          $id = $dclass[$field][$newval];
          if ($id > 0) {
            $key = $sic->classes[$field]["id"];
            $dcontainer[$key] = $id;
          }
        }
      }
      /**
       * Writing the container
       */
      $dcontainer["uid"] = 0;
      $uid = $object->ecrire($dcontainer);
      if ($uid > 0) {
        $dcontainer["uid"] = $uid;
        parent::ecrire($dcontainer);
        /**
         * Add secondary identifiers
         */
        foreach ($data["identifiers"] as $ident) {
          $aident = explode(":", $ident);
          $newkey = $dclass["identifier_type_code"][$post["identifier_type_code-" . str_replace(" ", "_", $aident[0])]];
          $didentifiers = array(
            "object_identifier_id" => 0,
            "uid" => $uid,
            "identifier_type_id" => $newkey,
            "object_identifier_value" => $aident[1]
          );
          $objectIdentifier->ecrire($didentifiers);
        }
      } else {
        throw new ContainerException(sprintf(_("Échec d'écriture de l'objet dans Container.importData : l'UID n'a pas été généré (identifier : %s)"), $data["identifier"]));
      }
      /**
       * Generate the movement if necessary
       */
      if ($uid_parent > 0) {
        $movement->addMovement($uid, null, 1, $uid_parent, null, null, null, null, $data["column_number"], $data["line_number"]);
      }
      /**
       * Create embedded samples
       */
      foreach ($data["samples"] as $sample) {
        try {
          $this->importSample($sample, $dclass, $sic, $post, $movement, $objectIdentifier, $sampleClass, $uid);
        } catch (Exception $e) {
          throw (new ContainerException(sprintf(_("Erreur d'importation de l'échantillon %s. "), $sample["uid"]) . _("Message d'erreur : ") . $e->getMessage()));
        }
      }
      /**
       * create embedded containers
       */
      foreach ($data["containers"] as $container) {
        $this->importContainer($container, $dclass, $sic, $post, $object, $movement, $objectIdentifier, $sampleClass, $uid);
      }
      $this->calculateUidMinMax($uid);
    }
  }

  /**
   * Import a sample and create the movement
   *
   * @param array $data
   * @param array $dclass
   * @param SampleInitClass $sic
   * @param array $post
   * @param ObjectClass $object
   * @param Movement $movement
   * @param Sample $sampleClass
   * @param integer $uid_parent
   * @return void
   */
  function importSample($data, $dclass, $sic, $post, $movement, $objectIdentifier, $sampleClass, $uid_parent = 0)
  {
    $staticFields = array(
      "identifier",
      "wgs84_x",
      "wgs84_y",
      "multiple_value",
      "dbuid_origin",
      "metadata",
      "dbuid_parent",
      "sample_creation_date",
      "sampling_date",
      "expiration_date"
    );
    $dynamicFields = array(
      "sampling_place_name",
      "collection_name",
      "object_status_name",
      "sample_type_name",
      "referent_name"
    );
    $dsample = array();
    foreach ($staticFields as $field) {
      if (strlen($data[$field]) > 0) {
        if ($field == "metadata") {
          /*
                     * Ajout d'un decodage/encodage pour les champs json, pour
                     * eviter les problemes potentiels et verifier la structure
                     */
          $dsample[$field] = json_encode(json_decode($data[$field]));
        } else {
          $dsample[$field] = $data[$field];
        }
      }
    }
    foreach ($dynamicFields as $field) {
      if (strlen($data[$field]) > 0) {
        /*
             * Search the value from post data
             */
        $value = $data[$field];
        /*
             * Transformation of spaces in underscore,
             * to take into encoding realized by the browser
             */
        $fieldHtml = str_replace(" ", "_", $value);
        $newval = $post[$field . "-" . $fieldHtml];
        /*
             * Recherche de la cle correspondante
             */
        $id = $dclass[$field][$newval];
        if ($id > 0) {
          $key = $sic->classes[$field]["id"];
          $dsample[$key] = $id;
        }
      }
    }
    /**
     * Writing the sample
     */
    $dsample["uid"] = 0;
    $uid = $sampleClass->ecrire($dsample);
    /**
     * Add secondary identifiers
     */
    foreach ($data["identifiers"] as $ident) {
      $aident = explode(":", $ident);
      $newkey = $dclass["identifier_type_code"][$post["identifier_type_code-" . str_replace(" ", "_", $aident[0])]];
      $didentifiers = array(
        "object_identifier_id" => 0,
        "uid" => $uid,
        "identifier_type_id" => $newkey,
        "object_identifier_value" => $aident[1]
      );
      $objectIdentifier->ecrire($didentifiers);
    }
    /**
     * Generate the movement
     */
    if ($uid_parent > 0) {
      $movement->addMovement($uid, null, 1, $uid_parent, null, null, null, null, $data["column_number"], $data["line_number"]);
    }
    $this->calculateUidMinMax($uid);
  }

  /**
   * Calculate the uid min and max generated, and the total number of uid generated
   *
   * @param int $uid
   * @return void
   */
  function calculateUidMinMax($uid)
  {
    if ($uid > $this->uidMax) {
      $this->uidMax = $uid;
    }
    if ($uid < $this->uidMin) {
      $this->uidMin = $uid;
    }
    $this->numberUid++;
  }

  /**
   * Get the limits of uid generated
   *
   * @return array
   */
  function getUidMinMax()
  {
    return (array(
      "min" => $this->uidMin,
      "max" => $this->uidMax,
      "number" => $this->numberUid
    ));
  }

  /**
   * Search for containers contained into a contained container
   *
   * @return array[]["first","second"]
   */
  function getCyclicMovements(): array
  {
    $found = array();
    /**
     * Prepare the list of all containers into a container
     */
    $sql = "select distinct uid, c.container_id
            from container c
            join last_movement using (uid)
            where movement_type_id = 1";
    $containers = $this->getListeParam($sql);
    foreach ($containers as $container) {
      $cyclical = $this->verifyChild($container["uid"], $container);
      if (!empty($cyclical)) {
        $found[] = array("first" => $container["uid"], "second" => $cyclical);
      }
    }
    return ($found);
  }
  /**
   * Search if a contained container contains the uid
   *
   * @param integer $uid
   * @param array $containerChild
   * @return integer|null
   */
  function verifyChild(int $uid, array $containerChild): ?int
  {
    $cyclical = null;
    $containers = $this->getContentContainer($containerChild["uid"]);
    foreach ($containers as $container) {
      if ($container["uid"] == $uid) {
        $cyclical = $container["container_uid"];
        break;
      } else {
        $cyclical = $this->verifyChild($uid, $container);
        if (!empty($cyclical)) {
          break;
        }
      }
    }
    return $cyclical;
  }
}
