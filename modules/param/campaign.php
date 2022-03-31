<?php
require_once 'modules/classes/campaign.class.php';
$dataClass = new Campaign($bdd, $ObjetBDDParam);
$keyName = "campaign_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        /*
         * Display the list of all records of the table
         */
        $vue->set($dataClass->getListe(2), "data");
        $vue->set("param/campaignList.tpl", "corps");
        break;
    case "display":
        $vue->set($dataClass->getDetail($id), "data");
        require_once "modules/classes/campaign_regulation.class.php";
        $campaignRegulation = new CampaignRegulation($bdd, $ObjetBDDParam);
        $vue->set($campaignRegulation->getListFromCampaign($id), "regulations");
        $vue->set("param/campaignDisplay.tpl", "corps");
        /**
         * Documents
         */
        include_once 'modules/classes/document.class.php';
        $document = new Document($bdd, $ObjetBDDParam);
        $vue->set($document->getListFromField("campaign_id", $id), "dataDoc");
        $vue->set($document->getMaxUploadSize(), "maxUploadSize");
        if ($_SESSION["droits"]["param"] == 1) {
            $vue->set(1, "modifiable");
        }
        $vue->set("campaign","moduleParent");
        $vue->set("campaign_id", "parentKeyName");
        /**
         * Get the list of authorized extensions
         */
        $mimeType = new MimeType($bdd, $ObjetBDDParam);
        $vue->set($mimeType->getListExtensions(false), "extensions");
        break;
    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        dataRead($dataClass, $id, "param/campaignChange.tpl");
        require_once "modules/classes/regulation.class.php";
        require_once "modules/classes/referent.class.php";
        $referent = new Referent($bdd, $ObjetBDDParam);
        $vue->set($referent->getListe(2), "referents");
        break;
    case "write":
        /*
         * write record in database
         */
        $id = dataWrite($dataClass, $_REQUEST);
        if ($id > 0) {
            $_REQUEST[$keyName] = $id;
        }
        break;
    case "delete":
        /*
         * delete record
         */
        dataDelete($dataClass, $id);
        break;
}
