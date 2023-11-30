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
        $vue->set("campaign", "moduleParent");
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

    case "import":
        if (file_exists($_FILES['upfile']['tmp_name'])) {
            require_once 'modules/classes/import.class.php';
            try {
                /**
                 * Verify the encoding
                 */
                $encodings = array("UTF-8", "iso-8859-1", "iso-8859-15");
                $currentEncoding = mb_detect_encoding(file_get_contents($_FILES['upfile']['tmp_name']), $encodings, true);
                if ($currentEncoding != "UTF-8" && $_REQUEST["utf8_encode"] == 0 || $currentEncoding == "UTF-8" && $_REQUEST["utf8_encode"] == 1) {
                    throw new CampaignException(_("L'encodage du fichier ne correspond pas à celui que vous avez indiqué"));
                }
                $import = new Import(
                    $_FILES['upfile']['tmp_name'],
                    ";",
                    false,
                    array(
                        "campaign_name",
                        "campaign_from",
                        "campaign_to",
                        "referent_name",
                        "referent_firstname",
                        "uuid"
                    )
                );
                $rows = $import->getContentAsArray();
                $nb = 0;
                $dataClass->formatDate = 0;
                $bdd->beginTransaction();
                foreach ($rows as $row) {
                    if (!empty($row)) {
                        $dataClass->import($row);
                        $nb++;
                    }
                }
                $message->set(sprintf(_("%s campagnes importées"), $nb));
                $module_coderetour = 1;
                $bdd->commit();
            } catch (Exception $e) {
                $message->set(_("Impossible d'importer les campagnes"), true);
                $message->set($e->getMessage());
                $module_coderetour = -1;
                if ($bdd->inTransaction()){
                     $bdd->rollBack();
                }
            } finally {
                $dataClass->formatDate = 1;
            }
        } else {
            $message->set(_("Impossible de charger le fichier à importer"));
            $module_coderetour = -1;
        }
        break;
}