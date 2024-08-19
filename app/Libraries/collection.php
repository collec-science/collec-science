<?php 
namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Xx extends PpciLibrary { 
    /**
     * @var xx
     */
    protected PpciModel $dataclass;

    private $keyName;

function __construct()
    {
        parent::__construct();
        $this->dataClass = new XXX();
        $this->keyName = "xxx_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

/****
 * Created : 30 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/collection.class.php';
$this->dataclass = new Collection();
$this->keyName = "collection_id";
$this->id = $_REQUEST[$this->keyName];


    function list(){
$this->vue=service('Smarty');
        /***
         * Display the list of all records of the table
         */
        try {
            $this->vue->set($this->dataclass->getListe(2), "data");
            $this->vue->set("param/collectionList.tpl", "corps");
        } catch (Exception $e) {
            $this->message->set($e->getMessage(), true);
        }
        }
    function change(){
$this->vue=service('Smarty');
        /***
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->dataRead( $this->id, "param/collectionChangeTab.tpl");
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
        require_once 'modules/classes/referent.class.php';
        $referent = new Referent();
        $this->vue->set($referent->getListe(2), "referents");
        require_once 'modules/classes/license.class.php';
        $license = new License();
        $this->vue->set($license->getListe(2), "licenses");
        }
        function write() {
    try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return $this->display();
            } else {
                return $this->change();
            }
        } catch (PpciException) {
            return $this->change();
        }
    }
        /**
         * write record in database
         */
        $this->id = $this->dataWrite( $_REQUEST);
        if ($this->id > 0) {
            $_REQUEST[$this->keyName] = $this->id;
            /**
             * Rechargement eventuel des collections autorises pour l'utilisateur courant
             */
            try {
                $this->dataclass->initCollections();
            } catch (Exception $e) {
                if ($APPLI_modeDeveloppement) {
                    $this->message->set($e->getMessage(), true);
                }
            }
        }
        }
    function delete(){
        /**
         * delete record
         */
         try {
            $this->dataDelete($this->id);
            return $this->list();
        } catch (PpciException $e) {
            return $this->change();
        }
        }
    function getAjax() {
        $this->vue->set($this->dataclass->lire($_REQUEST["collection_id"]));
        }
    function generateMails() {
        /**
         * Search if it's necessary to generate notifications
         */
        if ($MAIL_enabled == 1) {
            $notification = false;
            $currentDate = date_create();
            if ($_SESSION["notificationDelay"] > 0) {
                if (empty($_SESSION["notificationLastDate"])) {
                    $notification = true;
                } else {
                    $lastDate = date_create($_SESSION["notificationLastDate"]);
                    $interval = date_diff($lastDate, $currentDate)->format("%a");
                    if ($interval >= $_SESSION["notificationDelay"]) {
                        $notification = true;
                    }
                }
            }
            if ($notification) {
                require_once "modules/classes/sample.class.php";
                $sample = new Sample();
                require_once "modules/classes/event.class.php";
                $event = new Event();
                require_once "framework/utils/mail.class.php";
                $mail = new Mail();
                $collections = $this->dataclass->getNotificationDetails();
                foreach ($collections as $col) {
                    $data = array();
                    /**
                     * Search expired_samples
                     */
                    if ($col["expiration_delay"] > 0) {
                        $dateTo = new $currentDate;
                        $dateTo->add(new DateInterval("P" . $col["expiration_delay"] . "D"));
                        $data["samples"] = $sample->getExpirationSamples($col["collection_id"], $currentDate->format("Y-m-d"), $dateTo->format("Y-m-d"));
                    }
                    /**
                     * Search for due events
                     */
                    if ($col["event_due_delay"] > 0) {
                        $dateTo = new $currentDate;
                        $dateTo->add(new DateInterval("P" . $col["event_due_delay"] . "D"));
                        $data["events"] = $event->getEventsDueDate($col["collection_id"], $currentDate->format("Y-m-d"), $dateTo->format("Y-m-d"));
                    }

                    if (!empty($data["samples"]) || !empty($data["events"])) {
                        $data["collection_name"] = $col["collection_name"];
                        isset($_SESSION["FORMATDATE"])? $locale =  $_SESSION["FORMATDATE"] : $locale = $MAIL_param["defaultLocale"];
                        $mail->SendMailSmarty(
                            $SMARTY_param,
                            $col["notification_mails"],
                            $_SESSION["APPLI_title"] . " - " . _(sprintf("Notifications concernant la collection %s", $col["collection_name"])),
                            "param/collectionMail.tpl",
                            $data,
                           $locale,
                            false
                        );

                    }
                }
                /**
                 * Update the date of the last mail send
                 */
                if (!isset($dbparam)) {
                    include_once 'framework/dbparam/dbparam.class.php';
                    $dbparam = new DbParam();
                }
                $dbparam->setParameter("notificationLastDate", date('Y-m-d'));
            }
        }
        }
}
