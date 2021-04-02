<?php

require_once 'modules/classes/samplews.class.php';
require_once "modules/classes/export/datasetTemplate.class.php";
$samplews = new Samplews($bdd, $ObjetBDDParam);
$datasetTemplate = new DatasetTemplate($bdd, $ObjetBDDParam);

$errors = array(
  500 => "Internal Server Error",
  401 => "Unauthorized",
  520 => "Unknown error",
  404 => "Not Found"
);

switch ($t_module["param"]) {
  case "write":
    $searchOrder = array("uid", "uuid", "identifier");
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
      $uid = $samplews->write($dataSent, $searchOrder);
      $retour = array(
        "error_code" => 0,
        "uid" => $uid,
        "error_message" => "processed"
      );
    } catch (Exception $e) {
      $retour = array(
        "error_code" => $error_code,
        "error_message" => $errors[$error_code],
        "error_detail" => $e->getMessage()
      );
      $message->setSyslog($e->getMessage());
    } finally {
      $vue->setJson(json_encode($retour));
    }
    break;
}
