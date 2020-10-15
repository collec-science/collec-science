<?php
require_once 'modules/classes/campaign_regulation.class.php';
$dataClass = new CampaignRegulation($bdd, $ObjetBDDParam);
$keyName = "campaign_regulation_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
  case "change":
    $data = dataRead($dataClass, $id, "param/campaignRegulationChange.tpl", $_REQUEST["campaign_id"]);
    require_once "modules/classes/regulation.class.php";
    require_once "modules/classes/campaign.class.php";
    $regulation = new Regulation($bdd, $ObjetBDDParam);
    $campaign = new Campaign($bdd, $ObjetBDDParam);
    $vue->set($regulation->getListe("regulation_name"), "regulations");
    $vue->set($campaign->getListe($data["campaign_id"]), "campaign");
    break;
  case "write":
    /*
   * write record in database
   */
    dataWrite($dataClass, $_REQUEST);
    break;
  case "delete":
    /*
   * delete record
   */
    dataDelete($dataClass, $id);
    break;
}
