<?php

namespace App\Libraries;

use App\Models\Campaign as ModelsCampaign;
use App\Models\CampaignRegulation;
use App\Models\Document;
use App\Models\Import;
use App\Models\MimeType;
use App\Models\Referent;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Campaign extends PpciLibrary
{
    /**
     * @var ModelsCampaign
     */
    protected PpciModel $dataclass;

    

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsCampaign();
        $this->keyName = "campaign_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function list()
    {
        $this->vue = service('Smarty');
        /*
         * Display the list of all records of the table
         */
        $this->vue->set($this->dataclass->getListe(2), "data");
        $this->vue->set("param/campaignList.tpl", "corps");
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->getDetail($this->id), "data");
        $campaignRegulation = new CampaignRegulation();
        $this->vue->set($campaignRegulation->getListFromCampaign($this->id), "regulations");
        $this->vue->set("param/campaignDisplay.tpl", "corps");
        /**
         * Rights
         */
        $this->vue->set($this->dataclass->getRights($this->id), "groupes");
        /**
         * Documents
         */
        $document = new Document();
        $this->vue->set($document->getListFromField("campaign_id", $this->id), "dataDoc");
        $this->vue->set($document->getMaxUploadSize(), "maxUploadSize");
        if ($_SESSION["userRights"]["param"] == 1) {
            $this->vue->set(1, "modifiable");
        }
        $this->vue->set("campaign", "moduleParent");
        $this->vue->set("campaign_id", "parentKeyName");
        /**
         * Get the list of authorized extensions
         */
        $mimeType = new MimeType();
        $this->vue->set($mimeType->getListExtensions(false), "extensions");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->dataRead($this->id, "param/campaignChange.tpl");
        $referent = new Referent();
        $this->vue->set($referent->getListe(2), "referents");
        /**
         * Recuperation des groupes
         */
        $this->vue->set($this->dataclass->getAllGroupsFromCampaign($this->id), "groupes");
        return $this->vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return true;
            } else {
                return false;
            }
        } catch (PpciException) {
            return false;
        }
    }

    function delete()
    {
        /*
         * delete record
         */
        try {
            $this->dataDelete($this->id);
            return true;
        } catch (PpciException $e) {
            return false;
        }
    }

    function import()
    {
        if (file_exists($_FILES['upfile']['tmp_name'])) {
            try {
                /**
                 * Verify the encoding
                 */
                $encodings = array("UTF-8", "iso-8859-1", "iso-8859-15");
                $currentEncoding = mb_detect_encoding(file_get_contents($_FILES['upfile']['tmp_name']), $encodings, true);
                if ($currentEncoding != "UTF-8" && $_REQUEST["utf8_encode"] == 0 || $currentEncoding == "UTF-8" && $_REQUEST["utf8_encode"] == 1) {
                    throw new PpciException(_("L'encodage du fichier ne correspond pas à celui que vous avez indiqué"));
                }
                $import = new Import(
                    $_FILES['upfile']['tmp_name'],
                    ";",
                    $_REQUEST["utf8_encode"],
                    array(
                        "campaign_name",
                        "campaign_from",
                        "campaign_to",
                        "referent_name",
                        "referent_firstname",
                        "uuid",
                        "campaign_description"
                    )
                );
                $rows = $import->getContentAsArray();
                $nb = 0;
                $this->dataclass->autoFormatDate = false;
                $db = $this->dataclass->db;
                $db->transBegin();
                foreach ($rows as $row) {
                    if (!empty($row)) {
                        $this->dataclass->import($row);
                        $nb++;
                    }
                }
                $db->transCommit();
                $this->message->set(sprintf(_("%s campagnes importées"), $nb));
            } catch (PpciException $e) {
                $this->message->set(_("Impossible d'importer les campagnes"), true);
                $this->message->set($e->getMessage());
                if ($db->transEnabled) {
                    $db->transRollback();
                }
            } finally {
                $this->dataclass->autoFormatDate = true;
                return true;
            }
        } else {
            $this->message->set(_("Impossible de charger le fichier à importer"));
            return true;
        }
    }
}
