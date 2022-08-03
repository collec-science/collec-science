<?php

require_once 'modules/classes/samplews.class.php';
require_once "modules/classes/export/datasetTemplate.class.php";
$samplews = new Samplews($bdd, $ObjetBDDParam);
$datasetTemplate = new DatasetTemplate($bdd, $ObjetBDDParam);

$errors = array(
  500 => "Internal Server Error",
  400 => "Bad request",
  401 => "Unauthorized",
  403 => "Forbidden",
  520 => "Unknown error",
  404 => "Not Found"
);

switch ($t_module["param"]) {
  case "write":
  $searchOrder = "";
    try {
      $dataSent = $_POST;
      //$dataSent = $_GET;
      if (!empty($_POST["template"])) {
        /**
         * Format the data with the dataset template
         */
        $dataset = $datasetTemplate->getTemplateFromName($_POST["template"]);
        $dataSent = $datasetTemplate->formatDataForImport($dataset["dataset_template_id"],$dataSent);
        $searchOrder = $datasetTemplate->getSearchOrder($dataset["dataset_template_id"]);
      }
      if (empty ($searchOrder)) {
        $searchOrder = array("uid", "uuid", "identifier");
      }
      $uid = $samplews->write($dataSent, $searchOrder);
      $retour = array(
        "error_code" => 200,
        "uid" => $uid,
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
