<?php

require_once 'modules/classes/sample.class.php';
require_once 'modules/classes/object.class.php';
require_once "modules/classes/export/datasetTemplate.class.php";
require_once "modules/classes/identifierType.class.php";
require_once "modules/classes/objectIdentifier.class.php";
require_once "modules/classes/samplingPlace.class.php";

$sample = new Sample($bdd, $ObjetBDDParam);
$datasetClass = new DatasetTemplate($bdd, $ObjetBDDParam);
$identifierType = new IdentifierType($bdd, $ObjetBDDParam);
$objectIdentifier = new ObjectIdentifier($bdd, $ObjetBDDParam);
$samplingPlace = new SamplingPlace($bdd, $ObjetBDDParam);

$errors = array(
  500 => "Internal Server Error",
  401 => "Unauthorized",
  520 => "Unknown error",
  404 => "Not Found"
);

switch ($t_module["param"]) {
  case "write":
    $searchOrder = array("uid", "uuid", "identifier");
    $sample->auto_date = 0;
    try {
      if (!empty($_POST["template"])) {
        /**
         * Format the data with the dataset template
         */
        $dataset = $datasetTemplate->getTemplateFromName($_POST["template"]);
        $dataSent = $_POST; #TODO
        $searchOrder = $searchOrder; #TODO
      } else {
        $dataSent = $_POST;
      }
      /**
       * metadata
       */
      empty($dataSent["metadata"]) ? $metadata = array() : $metadata = json_decode($dataSent["metadata"], true);
      foreach ($dataSent as $key => $value) {
        if (substr($key, 0, 3) == "md_") {
          $metadata[substr($key, 3)] = $value;
        }
      }
      /**
       * Search for existent sample
       */
      foreach ($searchOrder as $field) {
        if (!empty($dataSent[$field])) {
          $data = $sample->getFromField($field, $dataSent[$field]);
          if (!empty($data)) {
            break;
          }
        }
      }
      /**
       * Search for the parent
       */
      $dataParent = array();
      foreach ($searchOrder as $field) {
        if (!empty($dataSent["parent_" . $field])) {
          $dataParent = $sample->getFromField($field, $dataSent[$field]);
          if (!empty($dataParent)) {
            break;
          }
        }
      }
      /**
       * Search for station
       */
      $sampling_place_id = "";
      if (!empty($dataSent["station_name"])) {
        $sampling_place_id = $samplingPlace->getIdFromName(($dataSent["station_name"]));
        if (!$sampling_place_id > 0) {
          $sampling_place_id = $samplingPlace->ecrire(array("sampling_place_id" => 0, "sampling_place_name" => $dataSent["station_name"]));
        }
      }
      /**
       * Search for country
       */
      # TODO
      $country_id = "";
      $country_origin_id = "";
      if (!empty($dataSent["country_code"])){

      }
      /**
       * Search for campaign
       */
      # TODO
      /**
       * Search for referent
       */

      if (!empty($data)) {
        /**
         * Update
         */
        if (!$sample->verifyCollection($data)) {
          throw new SampleException(_("Droits insuffisants pour modifier l'échantillon"), 401);
        }
        unset($dataSent["collection_id"]);
        foreach ($dataSent as $key => $content) {
          if (array_key_exists($key, $data)) {
            $data[$key] = $content;
          }
        }
        $dm = json_decode($data["metadata"], true);
        foreach ($metadata as $key => $value) {
          $dm[$key] = $value;
        }
        $data["metadata"] = json_encode($dm);
      } else {
        /**
         * insert
         */
        $data = array(
          "sample_id" => 0,
          "uid" => 0,
          "sample_type_id" => $dataSent["sample_type_id"],
          "sample_creation_date" => date("Y-m-d H:i:s"),
          "sampling_date" => $dataSent["sampling_date"],
          "multiple_value" => $dataSent["multiple_value"],
          "sampling_place_id" => "",
          "metadata" => json_encode($metadata),
          "expiration_date" => $dataSent["expiration_date"],
          "country_id" => "",
          "campaign_id" => "",
          "country_origin_id" => "",
          "identifier" => $dataSent["identifier"],
          "wgs84_x" => $dataSent["wgs84_x"],
          "wgs84_y" => $dataSent["wgs84_y"],
          "object_status_id" => 1,
          "referent_id" => "",
          "uuid" => $dataSent["uuid"],
          "trashed" => 0,
          "location_accuracy" => $dataSent["location_accuracy"],
          "object_comment" => $dataSent["object_comment"]
        );
        /**
         * Collection
         */
        if (!empty($dataSent["collection_name"])) {
          foreach ($_SESSION["collections"] as $collection) {
            if ($dataSent["collection_name"] == $collection["collection_name"]) {
              $data["collection_id"] = $collection["collection_id"];
              break;
            }
          }
        } else {
          if (count($_SESSION["collections"]) == 1) {
            /**
             * default collection
             */
            $data["collection_id"] = $_SESSION["collections"][0]["collection_id"];
          }
        }
        if (empty($data["collection_id"])) {
          throw new SampleException(_("La collection n'a pas été fournie ou n'est pas autorisée"), 401);
        }
      }
      /**
       * Add the parent
       */
      if (!empty($dataParent["sample_id"])) {
        $data["parent_sample_id"] = $dataParent["sample_id"];
      }
      /**
       * write
       */
      $uid = $sample->ecrire($data);
      /**
       * Write the secondary identifiers
       */
      $identifiers = $identifierType->getListeWithCode();
      foreach ($identifiers as $identifier) {
        if (!empty($dataSent[$identifier["identifier_type_code"]])) {
          $objectIdentifier->writeOrReplace(array(
            "uid" => $uid,
            "identifier_type_id" => $identifier["identifier_type_id"]
          ));
        }
      }
      $retour = array(
        "error_code" => 0,
        "uid" => $uid,
        "error_message" => "processed"
      );
    } catch (Exception $e) {
      $retour = array(
        "error_code" => $error_code,
        "error_message" => $errors[$error_code]
      );
      $message->setSyslog($e->getMessage());
    } finally {
      $vue->setJson(json_encode($retour));
    }
    break;
}
