<?php
include_once 'modules/classes/movement.class.php';
$dataClass = new Movement($bdd, $ObjetBDDParam);
$errors = array(
  500 => "Internal Server Error",
  400 => "Bad request",
  401 => "Unauthorized",
  403 => "Forbidden",
  520 => "Unknown error",
  404 => "Not Found"
);
if (isset($_REQUEST["locale"])) {
  setlanguage($_REQUEST["locale"]);
}
switch ($t_module["param"]) {
  case "write":
    include_once "modules/classes/object.class.php";
    include_once "modules/classes/movementReason.class.php";
    $object = new ObjectClass($bdd, $ObjetBDDParam);
    try {
      $dataSent = $_POST;
      /**
       * Search the object to move
       */
      $obj = $object->search($dataSent["uid"], $dataSent["identifier"], $dataSent["uuid"]);
      if (!$obj["uid"] > 0) {
        throw new ObjectException(_("Aucun objet n'a été trouvé à partir des identifiants fournis"), 400);
      }
      if (!($dataSent["movement_type"] == 1 || $dataSent["movement_type"] == 2)) {
        throw new ObjectException(_("Le type de mouvement n'a pas été correctement renseigné"), 400);
      }
      /**
       * Search for the container
       */
      if ($dataSent["movement_type"] == 1) {
        $container = $object->search($dataSent["container_uid"], $dataSent["container_identifier"], $dataSent["container_uuid"]);
        if (!$container["container_id"] > 0) {
          throw new ObjectException(_("Le contenant n'a pas été trouvé"), 400);
        }
      } else {
        $container["uid"] = 0;
      }
      /**
       * Verify if the movement reason exists
       */
      if ($dataSent["movement_reason"] > 0) {
        include_once "modules/classes/movementReason.class.php";
        $movementReason = new MovementReason($bdd, $ObjetBDDParam);
        $reason = $movementReason->lire($dataSent["movement_reason"]);
        if (!$reason["movement_reason_id"] > 0) {
          throw new ObjectException(_("Le code du motif de déstockage n'a pas été trouvé"), 400);
        }
      }
      $dataClass->addMovement(
        $obj["uid"],
        null,
        $dataSent["movement_type"],
        $container["uid"],
        null,
        $dataSent["storage_location"],
        $dataSent["comment"],
        $dataSent["movement_reason"],
        $dataSent["column"],
        $dataSent["line"]
      );
      $retour = array(
        "error_code" => 200,
        "error_message" => "processed"
      );
      http_response_code(200);
    } catch (Exception $e) {
      $error_code = $e->getCode();
      if (!isset($errors[$error_code])) {
        $error_code = 520;
      }
      $retour = array(
        "error_code" => $error_code,
        "error_message" => $errors[$error_code],
        "error_detail" => $e->getMessage()
      );
      http_response_code($error_code);
      $message->setSyslog($e->getMessage());
    } finally {
      $vue->setJson(json_encode($retour));
    }
    break;
}
