<?php

namespace App\Libraries;

use App\Models\Collection as ModelsCollection;
use App\Models\Document;
use App\Models\Event;
use App\Models\License;
use App\Models\Referent;
use App\Models\Sample;
use Ppci\Libraries\Mail;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\Dbparam;
use Ppci\Models\PpciModel;

class Collection extends PpciLibrary
{
    /**
     * @var ModelsCollection
     */
    protected PpciModel $dataclass;



    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsCollection();
        $this->keyName = "collection_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function list()
    {
        $this->vue = service('Smarty');
        /***
         * Display the list of all records of the table
         */
        $this->vue->set($this->dataclass->getListe(2), "data");
        $this->vue->set("param/collectionList.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "param/collectionChangeTab.tpl");
        /**
         * Recuperation des groupes
         */
        $this->vue->set($this->dataclass->getAllGroupsFromCollection($this->id), "groupes");
        /**
         * Get the list of all samples types
         */
        $this->vue->set($this->dataclass->getAllsampletypesFromCollection($this->id), "sampletypes");
        $this->vue->set($this->dataclass->getAlleventtypesFromCollection($this->id), "eventtypes");
        /**
         * Recuperation des referents
         */
        $referent = new Referent();
        $this->vue->set($referent->getListe(2), "referents");
        $license = new License();
        $this->vue->set($license->getListe(2), "licenses");
        $this->vue->help(_("parametres/les-collections.html"));
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        $this->vue->set( "param/collectionDisplay.tpl", "corps");
        $this->vue->set($this->dataclass->getDetail($this->id), "data");
        $this->vue->set($this->dataclass->getSampletypesFromCollection($this->id),"sampletypes");
        $this->vue->set($this->dataclass->getEventtypesFromCollection($this->id),"eventtypes");
        $this->vue->set($this->dataclass->getGroupsFromCollection($this->id), "groups");
        /**
         * Documents
         */
        $document = new Document;
        $this->vue->set($document->getListFromField("collection_id", $this->id), "dataDoc");
        $this->vue->set($document->getMaxUploadSize(), "maxUploadSize");
        if ($_SESSION["userRights"]["param"] == 1) {
            $this->vue->set(1, "modifiable");
        }
        $this->vue->set("collection", "moduleParent");
        $this->vue->set("collection_id", "parentKeyName");
        return $this->vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
            $this->dataclass->initCollections();

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
        /**
         * delete record
         */
        try {
            $this->dataclass->supprimer($this->id);
            $this->message->set(_("Suppression effectuée"));
            return true;
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            return false;
        }
    }
    function getAjax()
    {
        $this->vue = service('AjaxView');
        $this->vue->set($this->dataclass->lire($_REQUEST["collection_id"]));
        return $this->vue->send();
    }
    /**
     * Function used to generate emails for collections
     * This function must be executed as client (CLI)
     *
     * @return void
     */
    function generateMails()
    {
        /**
         * Search if it's necessary to generate notifications
         */
        if ($this->appConfig->MAIL_enabled) {
            $dbparam = new Dbparam;
            $dbparam->readParams();
            $notification = false;
            $currentDate = date_create();
            if ($_SESSION["dbparams"]["notificationDelay"] > 0) {
                if (empty($_SESSION["dbparams"]["notificationLastDate"])) {
                    $notification = true;
                } else {
                    $lastDate = date_create($_SESSION["dbparams"]["notificationLastDate"]);
                    $interval = date_diff($lastDate, $currentDate)->format("%a");
                    if ($interval >= $_SESSION["dbparams"]["notificationDelay"]) {
                        $notification = true;
                    }
                }
            }
            if ($notification) {
                $sample = new Sample();
                $event = new Event();
                $mail = new Mail();
                $collections = $this->dataclass->getNotificationDetails();
                foreach ($collections as $col) {
                    $data = array();
                    /**
                     * Search expired_samples
                     */
                    if ($col["expiration_delay"] > 0) {
                        $dateTo = new $currentDate;
                        $dateTo->add(new \DateInterval("P" . $col["expiration_delay"] . "D"));
                        $data["samples"] = $sample->getExpirationSamples($col["collection_id"], $currentDate->format("Y-m-d"), $dateTo->format("Y-m-d"));
                    }
                    /**
                     * Search for due events
                     */
                    if ($col["event_due_delay"] > 0) {
                        $dateTo = new $currentDate;
                        $dateTo->add(new \DateInterval("P" . $col["event_due_delay"] . "D"));
                        $data["events"] = $event->getEventsDueDate($col["collection_id"], $currentDate->format("Y-m-d"), $dateTo->format("Y-m-d"));
                    }

                    if (!empty($data["samples"]) || !empty($data["events"])) {
                        $data["collection_name"] = $col["collection_name"];

                        $mail->SendMailSmarty(
                            $col["notification_mails"],
                            $_SESSION["dbparams"]["APP_title"] . " - " . _(sprintf("Notifications concernant la collection %s", $col["collection_name"])),
                            "param/collectionMail.tpl",
                            $data,
                            $_SESSION["locale"]
                        );
                    }
                }
                /**
                 * Update the date of the last mail send
                 */
                $dbparam->setParameter("notificationLastDate", date('Y-m-d'));
            }
        }
    }
}
