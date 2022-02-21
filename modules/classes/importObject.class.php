<?php

/**
 * Created : 17 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
/**
 * Classes d'exception
 *
 * @author quinton
 *
 */
class FichierException extends Exception
{
}

class HeaderException extends Exception
{
}

class ImportObjectException extends Exception
{
}

/**
 * Classe realisant l'import
 *
 * @author quinton
 *
 */
class ImportObject
{

  private $separator = ",";

  private $utf8_encode = false;

  private $colonnes = array(
    "sample_identifier",
    "collection_id",
    "sample_type_id",
    "sample_status_id",
    "wgs84_x",
    "wgs84_y",
    "sampling_date",
    "expiration_date",
    "sample_multiple_value",
    "sample_metadata_json",
    "sample_parent_uid",
    "sampling_place_id",
    "referent_id",
    "container_identifier",
    "container_type_id",
    "container_status_id",
    "container_comment",
    "sample_location",
    "sample_column",
    "sample_line",
    "sample_comment",
    "container_parent_uid",
    "container_location",
    "container_column",
    "container_line",
    "sample_uuid",
    "container_uuid",
    "campaign_id",
    "country_code",
    "country_origin_code",
    "container_type_name",
    "container_status_name",
    "collection_name",
    "sample_type_name",
    "sample_status_name",
    "campaign_name",
    "campaign_uuid",
    "referent_name",
    "sampling_place_name",
    "sample_parent_identifier",
    "container_parent_identifier",
    "dbuid_origin"
  );

  private $colnum = array(
    "sample_multiple_value",
    "sample_column",
    "sample_line",
    "container_column",
    "container_line",
    "container_parent_uid",
    "sample_parent_uid",
    "referent_id",
    "campaign_id"
  );

  private $handle;

  private $fileColumn = array();

  public $nbTreated = 0;

  private $collection = array();

  private $sample_type = array();

  private $container_type = array();

  private $object_status = array();

  private $sampling_place = array();
  private $campaign;
  private $country;
  private $referent;

  private $referents = array();

  private $sample;

  private $container;

  private $movement;

  private $samplingPlace;

  private $identifierType;

  private $sampleType;

  private $objectIdentifier;

  private $initIdentifiers = false;

  private $identifiers = array();

  private $md_columns = array();

  public $minuid, $maxuid;
  public $onlyCollectionSearch = 1;

  /**
   * Initialise la lecture du fichier, et lit la ligne d'entete
   *
   * @param string $filename
   * @param string $separator
   * @param string $utf8_encode
   * @throws HeaderException
   * @throws FileException
   */
  function initFile($filename, $separator = ",", $utf8_encode = false)
  {
    if ($separator == "tab") {
      $separator = "\t";
    }
    $this->separator = $separator;
    $this->utf8_encode = $utf8_encode;
    /**
     * Ouverture du fichier
     */
    if ($this->handle = fopen($filename, 'r')) {
      $this->initIdentifiers();
      /**
       * Lecture de la premiere ligne et affectation des colonnes
       */
      $data = $this->readLine();
      $range = 0;
      for ($range = 0; $range < count($data); $range++) {
        $value = $data[$range];
        /**
         * identification of metadata columns
         */
        if (substr($value, 0, 3) == "md_") {
          $this->md_columns[] = $value;
        }
        /**
         * Traitement du renommage de project_id en collection_id,
         * de sample_date en sampling_date
         * pour la compatibilité ascendante
         */
        if ($value == "project_id") {
          $value = "collection_id";
        }
        if ($value == "sample_date") {
          $value = "sampling_date";
        }
        if (in_array($value, $this->colonnes) || substr($value, 0, 3) == "md_") {
          $this->fileColumn[$range] = $value;
        } else {
          throw new HeaderException(sprintf(_('La colonne %1$s n\'est pas reconnue (%2$s)'), $range, $value));
        }
      }
    } else {
      throw new FichierException(sprintf(_("Le fichier %s n'a pas été trouvé ou n'est pas lisible"), $filename));
    }
  }

  /**
   * Initialise les classes utilisees pour realiser les imports
   *
   * @param Sample $sample
   * @param Container $container
   * @param Movement $movement
   */
  function initClasses(Sample $sample, Container $container, Movement $movement, SamplingPlace $samplingPlace, IdentifierType $identifierType, Sampletype $sampleType, Referent $referent, Campaign $campaign, Country $country)
  {
    $this->sample = $sample;
    $this->container = $container;
    $this->movement = $movement;
    $this->samplingPlace = $samplingPlace;
    $this->identifierType = $identifierType;
    $this->sampleType = $sampleType;
    $this->referent = $referent;
    $this->campaign = $campaign;
    $this->country = $country;
  }

  /**
   * Fonction d'initialisation d'une instance de classe
   * pour utilisation dans les scripts
   *
   * @param string $name
   *            : nom de l'instance
   * @param Object $instance
   *            : instance a stocker
   */
  function initClass($name, $instance)
  {
    $this->$name = $instance;
  }

  /**
   * Lit une ligne dans le fichier
   *
   * @return array|NULL
   */
  function readLine()
  {
    if ($this->handle) {
      $data = fgetcsv($this->handle, 1000, $this->separator);
      if ($data !== false) {
        if ($this->utf8_encode) {
          foreach ($data as $key => $value) {
            $data[$key] = utf8_encode($value);
          }
        }
      }
      return $data;
    } else {
      return null;
    }
  }

  /**
   * Ferme le fichier
   */
  function fileClose()
  {
    if ($this->handle) {
      fclose($this->handle);
    }
  }

  /**
   * Lance l'import des lignes
   *
   * @throws ImportObjectException
   *
   * @return void
   */
  function importAll()
  {
    $date = date("Y-m-d H:i:s");
    $num = 1;
    $maxuid = 0;
    $minuid = 99999999;
    $this->initIdentifiers();
    $jsonFirstCharArray = array("[", "{");
    /**
     * Inhibition du traitement des dates par la classe
     */
    $this->sample->auto_date = 0;
    $this->movement->auto_date = 0;
    /**
     * Traitement du fichier
     */
    while (($data = $this->readLine()) !== false) {
      /**
       * Preparation du tableau
       */
      $values = $this->prepareLine($data);
      $num++;
      /**
       * Controle de la ligne
       */
      $resControle = $this->controlLine($values);
      if (!$resControle["code"]) {
        throw new ImportObjectException("Line $num : " . $resControle["message"]);
      }
      /**
       * Mise a defaut des champs obligatoires non renseignes
       */
      foreach (array(
        "sample_line",
        "sample_column",
        "container_column",
        "container_line"
      ) as $field) {
        if (empty($values[$field])) {
          $values[$field] = 1;
        }
      }
      /**
       * Traitement de l'echantillon
       */
      $sample_uid = 0;
      if (!empty($values["sample_identifier"])) {
        $dataSample = $values;
        $dataSample["sample_creation_date"] = $date;
        $dataSample["identifier"] = $values["sample_identifier"];
        $dataSample["object_status_id"] = $values["sample_status_id"];
        if (!$dataSample["object_status_id"] > 0) {
          $dataSample["object_status_id"] = 1;
        }
        $dataSample["multiple_value"] = $values["sample_multiple_value"];
        $dataSample["sampling_place_id"] = $values["sampling_place_id"];
        $dataSample["parent_sample_id"] = $values["parent_sample_id"];
        $dataSample["uuid"] = $values["sample_uuid"];
        $dataSample["dbuid_origin"] = $values["dbuid_origin"];
        if (!empty($values["country_code"])) {
          $dataSample["country_id"] = $this->country->getIdFromCode($values["country_code"]);
        }
        if (!empty($values["country_origin_code"])) {
          $dataSample["country_origin_id"] = $this->country->getIdFromCode($values["country_origin_code"]);
        }
        if (!empty($values["sample_comment"])) {
          $dataSample["object_comment"] = $values["sample_comment"];
        }
        /**
         * Traitement des dates - mise au format de base de donnees avant importation
         */
        $fieldDates = array(
          "sampling_date",
          "expiration_date"
        );
        foreach ($fieldDates as $fieldDate) {
          if (!empty($values[$fieldDate])) {
            $dataSample[$fieldDate] = $this->formatDate($values[$fieldDate]);
          }
        }
        /**
         * Metadata preparation
         */
        if (!empty($values["sample_metadata_json"])) {
          $md_array = json_decode($values["sample_metadata_json"], true);
          if (json_last_error() != JSON_ERROR_NONE) {
            throw new ImportObjectException(sprintf(_("Ligne %s : le décodage du champ JSON sample_metadata_json n'a pas abouti"), $num));
          }
        } else {
          $md_array = array();
        }
        foreach ($this->md_columns as $md_col) {
          if (!empty($values[$md_col])) {
            $colname = substr($md_col, 3);
            if (!array_key_exists($colname, $md_array)) {
              if (in_array(substr($values[$md_col], 0, 1), $jsonFirstCharArray)) {
                $md_col_array = json_decode($values[$md_col], true);
                if (json_last_error() != JSON_ERROR_NONE) {
                  throw new ImportObjectException(sprintf(_("Ligne %1s : le décodage du champ JSON %2s n'a pas abouti"), $num, $md_col));
                }
              } else {
                $md_col_array = explode(",", $values[$md_col]);
              }
              if (count($md_col_array) > 1) {
                foreach ($md_col_array as $val) {
                  $md_array[$colname][] = trim($val);
                }
              } else {
                $md_array[$colname] = trim($md_col_array[0]);
              }
            }
          }
        }
        if (count($md_array) > 0) {
          $dataSample["metadata"] = json_encode($md_array);
        }
        /**
         * Debut d'ecriture en table
         */
        try {
          $sample_uid = $this->sample->ecrire($dataSample);

          /**
           * Traitement des identifiants complementaires
           */
          foreach ($this->identifiers as $idcode => $typeid) {
            if (strlen($values[$idcode]) > 0) {
              $dataCode = array(
                "object_identifier_id" => 0,
                "uid" => $sample_uid,
                "identifier_type_id" => $typeid,
                "object_identifier_value" => $values[$idcode]
              );
              $this->objectIdentifier->ecrire($dataCode);
            }
          }
          /**
           * Mise a jour des bornes de l'uid
           */
          if ($sample_uid < $minuid) {
            $minuid = $sample_uid;
          }
          if ($sample_uid > $maxuid) {
            $maxuid = $sample_uid;
          }
        } catch (Exception $pe) {
          throw new ImportObjectException("Line $num : error when import sample - " . $pe->getMessage());
        }
      }
      /**
       * Extract the uid of the parent container from the identifier
       */
      if (empty($values["container_parent_uid"]) && !empty($values["container_parent_identifier"])) {
        $values["container_parent_uid"] = $this->container->getUidFromIdentifier($values["container_parent_identifier"]);
        if (empty($values["container_parent_uid"])) {
          throw new ImportObjectException("Line $num : the container " . $values["container_parent_identifier"] . " don't exists into the database");
        }
      }
      /**
       * Traitement du contenant
       */
      $container_uid = 0;
      if (!empty($values["container_identifier"])) {
        $dataContainer = $values;
        $dataContainer["identifier"] = $values["container_identifier"];
        $dataContainer["object_status_id"] = $values["container_status_id"];
        if (!$dataContainer["object_status_id"] > 0) {
          $dataContainer["object_status_id"] = 1;
        }
        if (!empty($values["container_comment"])) {
          $dataContainer["object_comment"] = $values["container_comment"];
        }
        $dataContainer["uuid"] = $values["container_uuid"];
        try {
          $container_uid = $this->container->ecrire($dataContainer);
          /**
           * Traitement des identifiants complementaires
           */
          foreach ($this->identifiers as $idcode => $typeid) {
            if (strlen($values[$idcode]) > 0) {
              $dataCode = array(
                "object_identifier_id" => 0,
                "uid" => $sample_uid,
                "identifier_type_id" => $typeid
              );
              $this->objectIdentifier->ecrire($dataCode);
            }
          }
          /**
           * Mise a jour des bornes de l'uid
           */
          if ($container_uid < $minuid) {
            $minuid = $container_uid;
          }
          if ($container_uid > $maxuid) {
            $maxuid = $container_uid;
          }
        } catch (Exception $pe) {
          throw new ImportObjectException("Line $num : error when import container - " . $pe->getMessage());
        }
        /**
         * Traitement du rattachement du container
         */
        if (!empty($values["container_parent_uid"])) {
          try {
            $this->movement->addMovement($container_uid, $date, 1, $values["container_parent_uid"], $_SESSION["login"], $values["container_location"], null, null, $values["container_column"], $values["container_line"]);
          } catch (Exception $e) {
            throw new ImportObjectException("Line $num : error when create input movement for container - " . $e->getMessage());
          }
        }
      }
      /**
       * Traitement de l'entree de l'echantillon dans le container
       */
      if ($sample_uid > 0 && $container_uid > 0) {
        try {
          $this->movement->addMovement($sample_uid, $date, 1, $container_uid, $_SESSION["login"], $values["sample_location"], null, null, $values["sample_column"], $values["sample_line"]);
        } catch (Exception $e) {
          throw new ImportObjectException("Line $num : error when create input movement for sample (" . $e->getMessage() . ")");
        }
      }
      if ($values["container_parent_uid"] && $sample_uid > 0 && !($container_uid > 0)) {
        /**
         * Creation du mouvement d'entree de l'echantillon dans le container
         */
        try {
          $this->movement->addMovement($sample_uid, $date, 1, $values["container_parent_uid"], $_SESSION["login"], $values["sample_location"], null, null, $values["sample_column"], $values["sample_line"]);
        } catch (Exception $e) {
          throw new ImportObjectException("Line $num : error when create input movement for sample (" . $e->getMessage() . ")");
        }
      }
      $this->nbTreated++;
    }
    $this->minuid = $minuid;
    $this->maxuid = $maxuid;
  }

  /**
   * Fonction reformatant la date en testant le format francais, puis standard
   *
   * @param string $date
   * @return string
   */
  function formatDate($date)
  {
    $val = "";
    /**
     * Verification du format de date
     */
    $date1 = explode(" ", $date);
    $timeLength = strlen($date1[1]);
    if ($timeLength > 0) {
      /**
       * Reformate the time
       */
      if ($timeLength == 5) {
        /**
         * Add seconds
         */
        $date1[1] .= ":00";
      }
      /**
       * Regenerate the date
       */
      $date = $date1[0] . " " . $date1[1];
      $mask = $_SESSION["MASKDATELONG"];
    } else {
      $mask = $_SESSION["MASKDATE"];
    }
    $result = date_parse_from_format($mask, $date);
    if ($result["warning_count"] > 0) {
      /**
       * La date est attendue avec le format yyyy-mm-dd
       */
      $date2 = explode("-", $date1[0]);
      $result = date_parse($date);
      if ($result["year"] != $date2[0] || str_pad($result["month"], 2, "0", STR_PAD_LEFT) != $date2[1] || str_pad($result["day"], 2, "0", STR_PAD_LEFT) != $date2[2]) {
        $result["warning_count"] = 1;
      }
    }
    if ($result["warning_count"] == 0) {
      $val = $result["year"] . "-" . str_pad($result["month"], 2, "0", STR_PAD_LEFT) . "-" . str_pad($result["day"], 2, "0", STR_PAD_LEFT);
      if (strlen($result["hour"]) > 0 && strlen($result["minute"]) > 0) {
        $val .= " " . str_pad($result["hour"], 2, "0", STR_PAD_LEFT) . ":" . str_pad($result["minute"], 2, "0", STR_PAD_LEFT);
        if (strlen($result["second"]) == 0) {
          $result["second"] = 0;
        }
        $val .= ":" . str_pad($result["second"], 2, "0", STR_PAD_LEFT);
      }
    }
    return $val;
  }

  /**
   * Reecrit une ligne, en placant les bonnes valeurs en fonction de l'entete
   *
   * @param array $data
   * @return array[]
   */
  function prepareLine($data)
  {
    $nb = count($data);
    $values = array();
    for ($i = 0; $i < $nb; $i++) {
      $values[$this->fileColumn[$i]] = $data[$i];
    }

    /**
     * Search for the code of the country
     */
    if (!empty($values["country_code"])) {
      $values["country_id"] = $this->country->getIdFromCode($values["country_code"]);
    }
    if (!empty($values["country_origin_code"])) {
      $values["country_origin_id"] = $this->country->getIdFromCode($values["country_origin_code"]);
    }
    /**
     * Search the ids from the names
     */
    if (!empty($values["collection_name"])) {
      $values["collection_id"] = -1;
      foreach ($this->collection as $value) {
        if ($values["collection_name"] == $value["collection_name"]) {
          $values["collection_id"] = $value["collection_id"];
          break;
        }
      }
    }
    /**
     * Recherche de la valeur de l'id du sample_parent
     */
    if ($values["sample_parent_uid"] > 0) {
      $dp = $this->sample->lire($values["sample_parent_uid"]);
      $values["parent_sample_id"] = $dp["sample_id"];
    } else {
      if (!empty($values["sample_parent_identifier"])) {
        if ($this->onlyCollectionSearch == 1) {
          $values["parent_sample_id"] = $this->sample->getIdFromIdentifier($values["sample_parent_identifier"], $values["collection_id"]);
        } else {
        $values["parent_sample_id"] = $this->sample->getIdFromIdentifier($values["sample_parent_identifier"]);
        }
      }
    }
    if (!empty($values["container_type_name"])) {
      $values["container_type_id"] = -1;
      foreach ($this->container_type as $value) {
        if ($values["container_type_name"] == $value["container_type_name"]) {
          $values["container_type_id"] = $value["container_type_id"];
          break;
        }
      }
    }
    if (!empty($values["sample_type_name"])) {
      $values["sample_type_id"] = -1;
      foreach ($this->sample_type as $value) {
        if ($values["sample_type_name"] == $value["sample_type_name"]) {
          $values["sample_type_id"] = $value["sample_type_id"];
          break;
        }
      }
    }
    if (!empty($values["campaign_name"])) {
      $values["campaign_id"] = -1;
      foreach ($this->campaign as $value) {
        if ($values["campaign_name"] == $value["campaign_name"] || $values["campaign_uuid"] == $value["uuid"]) {
          $values["campaign_id"] = $value["campaign_id"];
          break;
        }
      }
    }
    if (!empty($values["referent_name"])) {
      foreach ($this->referents as $value) {
        $values["referent_id"] = -1;
        if (trim($values["referent_name"]) == trim($value["referent_name"] . " " . $value["referent_firstname"])) {
          $values["referent_id"] = $value["referent_id"];
          break;
        }
      }
    }
    if (!empty($values["sample_status_name"])) {
      $values["sample_status_id"] = -1;
      foreach ($this->object_status as $value) {
        if ($values["sample_status_name"] == $value["object_status_name"]) {
          $values["sample_status_id"] = $value["object_status_id"];
          break;
        }
      }
    }
    if (!empty($values["container_status_name"])) {
      $values["container_status_id"] = -1;
      foreach ($this->object_status as $value) {
        if ($values["container_status_name"] == $value["object_status_name"]) {
          $values["container_status_id"] = $value["object_status_id"];
          break;
        }
      }
    }
    return $values;
  }

  /**
   * Initialise les tableaux pour traiter les controles
   *
   * @param array $collection
   * @param array $sample_type
   * @param array $container_type
   * @param array $container_status
   */
  function initControl($collection, $sample_type, $container_type, $object_status, $sampling_place, $referent, $campaign)
  {
    $this->collection = $collection;
    $this->sample_type = $sample_type;
    $this->container_type = $container_type;
    $this->object_status = $object_status;
    $this->sampling_place = $sampling_place;
    $this->referents = $referent;
    $this->campaign = $campaign;
  }

  /**
   * Declenche le controle pour toutes les lignes
   *
   * @return array[]["line"=>int, "message"=>string]
   */
  function controlAll()
  {
    $num = 1;
    $retour = array();
    $this->initIdentifiers();
    while (($data = $this->readLine()) !== false) {
      $values = $this->prepareLine($data);
      $num++;
      $controle = $this->controlLine($values);
      if (!$controle["code"]) {
        $retour[] = array(
          "line" => $num,
          "message" => $controle["message"]
        );
      }
    }
    return $retour;
  }

  /**
   * Controle une ligne
   *
   * @param array $data
   * @return array ["code"=>boolean,"message"=>string]
   */
  function controlLine($data)
  {
    $retour = array(
      "code" => true,
      "message" => ""
    );
    $emptyLine = true;
    /**
     * Traitement de l'echantillon
     */
    if (strlen($data["sample_identifier"]) > 0) {
      $emptyLine = false;
      /**
       * Verification de la collection
       */
      $ok = false;
      foreach ($this->collection as $value) {
        if ($data["collection_id"] == $value["collection_id"]) {
          $ok = true;
          break;
        }
      }
      if (!$ok) {
        $retour["code"] = false;
        $retour["message"] .= _("Le numéro de la collection indiqué n'est pas reconnu ou autorisé.");
      }
      /**
       * Verification du type d'echantillon
       */
      $ok = false;
      foreach ($this->sample_type as $value) {
        if ($data["sample_type_id"] == $value["sample_type_id"]) {
          $ok = true;
          break;
        }
      }
      if (!$ok) {
        $retour["code"] = false;
        $retour["message"] .= _("Le type d'échantillon n'est pas connu.");
      }

      /**
       * Verification du statut
       */
      $ok = false;
      if (!empty($data["sample_status_id"])) {
        foreach ($this->object_status as $value) {
          if ($data["sample_status_id"] == $value["object_status_id"]) {
            $ok = true;
            break;
          }
        }
        if (!$ok) {
          $retour["code"] = false;
          $retour["message"] .= _("Le statut de l'échantillon n'est pas connu.");
        }
      }
      /**
       * Verification du lieu de collecte
       */
      $ok = false;
      if (!empty($data["sampling_place_id"])) {
        foreach ($this->sampling_place as $value) {
          if ($data["sampling_place_id"] == $value["sampling_place_id"]) {
            $ok = true;
            break;
          }
        }
        if (!$ok) {
          $retour["code"] = false;
          $retour["message"] .= _("L'emplacement de collecte de l'échantillon n'est pas connu.");
        }
      }
      /**
       * Verification du pays
       */
      if (!empty($data["country_code"]) && empty($data["country_id"])) {
        $retour["code"] = false;
        $retour["message"] .= _("Le code pays est inconnu.");
      }
      if (!empty($data["country_origin_code"]) && empty($data["country_origin_id"])) {
        $retour["code"] = false;
        $retour["message"] .= _("Le code pays est inconnu.");
      }
      /**
       * Verification du referent
       */
      $ok = false;
      if (!empty($data["referent_id"])) {
        foreach ($this->referents as $value) {
          if ($data["referent_id"] == $value["referent_id"]) {
            $ok = true;
            break;
          }
        }
        if (!$ok) {
          $retour["code"] = false;
          $retour["message"] .= _("Le référent de l'échantillon n'est pas connu.");
        }
      }
      /**
       * Control of the campaign
       */
      if (!empty($data["campaign_id"])) {
        foreach ($this->campaign as $value) {
          if ($data["campaign_id"] == $value["campaign_id"]) {
            $ok = true;
            break;
          }
        }
        if (!$ok) {
          $retour["code"] = false;
          $retour["message"] .= _("La campagne de prélèvement de l'échantillon n'est pas connue.");
        }
      }
      /**
       * Verification des dates
       */
      $fieldDates = array(
        "sampling_date",
        "expiration_date"
      );
      foreach ($fieldDates as $fieldDate) {
        if (strlen($data[$fieldDate]) > 0) {
          /**
           * Verification du format de date
           */
          $date = $data[$fieldDate];
          $date1 = explode(" ", $date);
          $timeLength = strlen($date1[1]);
          if ($timeLength > 0) {
            /**
             * Reformate the time
             */
            if ($timeLength == 5) {
              /**
               * Add seconds
               */
              $date1[1] .= ":00";
            }
            /**
             * Regenerate the date
             */
            $date = $date1[0] . " " . $date1[1];
            $mask = $_SESSION["MASKDATELONG"];
          } else {
            $mask = $_SESSION["MASKDATE"];
          }
          strlen($data[$fieldDate]) > 10 ? $mask = $_SESSION["MASKDATELONG"] : $mask = $_SESSION["MASKDATE"];
          $result = date_parse_from_format($mask, $date);
          if ($result["warning_count"] > 0 || $result["error_count"] > 0) {
            /**
             * Test du format general
             */
            $result1 = date_parse($date);
            if ($result1["warning_count"] > 0 || $result1["error_count"] > 0) {
              $retour["code"] = false;
              $retour["message"] .= sprintf(_("Le format de date de %s n'est pas reconnu."), $fieldDate);
            }
          }
        }
      }

      /**
       * Verification des metadonnees
       * Elles doivent correspondre a celles definies dans l'operation
       */
      if (strlen($data["sample_metadata_json"]) > 0) {
        $metadataSchema = json_decode($this->sampleType->getMetadataForm($data["sample_type_id"]), true);

        $metadataSchemaNames = array();
        $valuesMetadataJson = json_decode($data["sample_metadata_json"], true);
        if (json_last_error() != JSON_ERROR_NONE) {
          $retour["message"] .= _("Les métadonnées n'ont pas pu être décodées (champ sample_metadata_json)");
          $retour["code"] = false;
        }
        /**
         * Verification de la colonne metadata
         */
        if (count($valuesMetadataJson) == 0) {
          $retour["code"] = false;
          $retour["message"] .= _("Les métadonnées ne sont pas correctement formatées (champ sample_metadata_json)");
        }
        foreach ($metadataSchema as $field) {
          $metadataSchemaNames[] = $field["name"];
        }
        foreach ($valuesMetadataJson as $key => $field) {
          if (!in_array($key, $metadataSchemaNames)) {
            $retour["code"] = false;
            $retour["message"] .= sprintf(_("Les métadonnées ne correspondent pas au type d'échantillon (%s inconnu). "), $key);
          }
        }
      }
      /**
       * Verification de l'echantillon parent
       */
      if ($data["sample_parent_uid"] > 0) {
        if (!$data["parent_sample_id"] > 0) {
          $retour["code"] = false;
          $retour["message"] .= sprintf(_("L'échantillon parent défini n'existe pas (%s)"), $data["sample_parent_uid"]);
        }
      }
    }
    /**
     * Traitement du container
     */
    if (strlen($data["container_identifier"]) > 0) {
      $emptyLine = false;
      /**
       * Verification du type de container
       */
      $ok = false;
      foreach ($this->container_type as $value) {
        if ($data["container_type_id"] == $value["container_type_id"]) {
          $ok = true;
          break;
        }
      }
      if (!$ok) {
        $retour["code"] = false;
        $retour["message"] .= _("Le type de contenant n'est pas connu.");
      }
      /**
       * Verification du statut du container
       */
      if (strlen($data["container_status_id"]) > 0) {
        $ok = false;
        foreach ($this->object_status as $value) {
          if ($data["container_status_id"] == $value["object_status_id"]) {
            $ok = true;
            break;
          }
        }
        if (!$ok) {
          $retour["code"] = false;
          $retour["message"] .= _("Le statut du contenant n'est pas connu.");
        }
      }
    }
    /**
     * Verification de l'uid du container parent
     */
    if (strlen($data["container_parent_uid"]) > 0) {
      $container_id = $this->container->getIdFromUid($data["container_parent_uid"]);
      if (!$container_id > 0) {
        $retour["code"] = false;
        $retour["message"] .= sprintf(_("L'UID du contenant parent (%s) n'existe pas. "), $data["container_parent_uid"]);
      }
    }

    /**
     * Verification des champs numeriques
     */
    foreach ($this->colnum as $key) {
      if (strlen($data[$key]) > 0) {
        if (!is_numeric($data[$key])) {
          $retour["code"] = false;
          $retour["message"] .= sprintf(_("Le champ %s n'est pas numérique."), $key);
        }
      }
    }
    /**
     * Traitement de la ligne vierge
     */
    if ($emptyLine) {
      $retour["code"] = false;
      $retour["message"] .= _("Aucun échantillon ou contenant n'est décrit (pas d'identifiant pour l'un ou pour l'autre).");
    }
    return $retour;
  }

  /**
   * Initialise la liste des identifiants secondaires possibles
   */
  function initIdentifiers()
  {
    if (!$this->initIdentifiers) {

      $dit = $this->identifierType->getListe();
      /**
       * Rajout des codes dans les colonnes autorisees
       */
      foreach ($dit as $value) {
        $this->colonnes[] = $value["identifier_type_code"];
        $this->identifiers[$value["identifier_type_code"]] = $value["identifier_type_id"];
      }
      $this->initIdentifiers = true;
    }
  }

  /**
   * Execution de l'importation d'echantillons provenant d'une base externe
   *
   * @param array $data
   *            : tableau contenant les donnees a importer
   * @param SampleInitClass $sic
   *            : liste des valeurs des tables de reference
   * @param array $post
   *            : tableau des valeurs fournies par le formulaire
   */
  function importExterneExec($data, SampleInitClass $sic, $post)
  {
    $simpleFields = array(
      "identifier",
      "wgs84_x",
      "wgs84_y",
      "multiple_value",
      "dbuid_origin",
      "metadata",
      "dbuid_parent",
      "uuid"
    );
    $refFields = array(
      "sampling_place_name",
      "collection_name",
      "object_status_name",
      "sample_type_name",
      "referent_name",
      "campaign_name"
    );
    $this->sample->auto_date = 0;
    $dclass = $sic->init(true);
    $this->maxuid = 0;
    $this->minuid = 99999999;
    foreach ($data as $row) {
      /**
       * Preparation de l'echantillon a importer dans la base
       */
      $dataSample = array();
      /**
       * Champs simples, sans transcodage
       */
      foreach ($simpleFields as $field) {
        if (strlen($row[$field]) > 0) {
          if ($field == "metadata") {
            /**
             * Ajout d'un decodage/encodage pour les champs json, pour
             * eviter les problemes potentiels et verifier la structure
             */
            $dataSample[$field] = json_encode(json_decode($row[$field]));
          } else {
            $dataSample[$field] = $row[$field];
          }
        }
      }
      /**
       * Comment
       */
      if (!empty($row["comment"])) {
        $dataSample["object_comment"] = $row["comment"];
      }
      /**
       * countries
       */
      if (!empty($row["country_code"])) {
        $dataSample["country_id"] = $this->country->getIdFromCode($row["country_code"]);
      }
      if (!empty($row["country_origin_code"])) {
        $dataSample["country_origin_id"] = $this->country->getIdFromCode($row["country_origin_code"]);
      }
      $fieldDates = array(
        "sampling_date",
        "expiration_date",
        "sample_creation_date"
      );
      foreach ($fieldDates as $fieldDate) {
        if (strlen($row[$fieldDate]) > 0) {
          $dataSample[$fieldDate] = $this->formatDate($row[$fieldDate]);
        }
      }
      /**
       * Champs transcodes
       */
      foreach ($refFields as $field) {
        if (strlen($row[$field]) > 0) {
          /**
           * Recheche de la valeur a appliquer dans les donnees post
           */
          $value = $row[$field];
          /**
           * Transformation des espaces en underscore,
           * pour tenir compte du transcodage opere par le navigateur
           */
          $fieldHtml = str_replace(" ", "_", $value);
          $newval = $post[$field . "-" . $fieldHtml];
          /**
           * Recherche de la cle correspondante
           */
          $id = $dclass[$field][$newval];
          if ($id > 0) {
            $key = $sic->classes[$field]["id"];
            $dataSample[$key] = $id;
          }
        }
      }
      /**
       * Recherche des metadonnees
       */
      if (strlen($row["metadata"]) > 0) {
        $metadata = json_decode($row["metadata"], true);
      } else {
        $metadata = array();
      }
      foreach ($row as $fieldname => $fieldvalue) {
        if (substr($fieldname, 0, 3) == "md_" && strlen($fieldvalue) > 0) {
          $colname = substr($fieldname, 3);
          if (!array_key_exists($colname, $metadata)) {
            $md_col_array = explode(",", $fieldvalue);
            if (count($md_col_array) > 1) {
              foreach ($md_col_array as $val) {
                $metadata[$colname][] = trim($val);
              }
            } else {
              $metadata[$colname] = trim($fieldvalue);
            }
          }
        }
      }
      if (count($metadata) > 0) {
        $dataSample["metadata"] = json_encode($metadata);
      }

      /**
       * Declenchement de l'ecriture en base
       */
      try {
        $uid = $this->sample->ecrireImport($dataSample);
        if ($uid > 0) {
          if ($uid < $this->minuid) {
            $this->minuid = $uid;
          }
          $this->maxuid = $uid;
          $this->nbTreated++;
          /**
           * Traitement des identifiants complementaires
           */
          if (strlen($row["identifiers"]) > 0) {
            $idents = explode(",", $row["identifiers"]);
            foreach ($idents as $ident) {
              $idvalue = explode(":", $ident);
              $dataIdent = array();
              $dataIdent["uid"] = $uid;
              /**
               * Recherche de la valeur a appliquer dans les donnees post
               */
              $value = $row[$field];
              $newval = $_POST["identifier_type_code-" . $idvalue[0]];
              $dataIdent["identifier_type_id"] = $dclass["identifier_type_code"][$newval];
              $dataIdent["object_identifier_value"] = $idvalue[1];
              $this->objectIdentifier->writeOrReplace($dataIdent);
            }
          }
        } else {
          throw new ImportObjectException("Problem when importing - line " . $this->nbTreated + 1);
        }
      } catch (Exception $e) {
        throw new ImportObjectException($e->getMessage());
      }
    }
  }
}
