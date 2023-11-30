<?php

/****
 * Created : 30 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/collection.class.php';
$dataClass = new Collection($bdd, $ObjetBDDParam);
$keyName = "collection_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        /***
         * Display the list of all records of the table
         */
        try {
            $vue->set($dataClass->getListe(2), "data");
            $vue->set("param/collectionList.tpl", "corps");
        } catch (Exception $e) {
            $message->set($e->getMessage(), true);
        }
        break;
    case "change":
        /***
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        dataRead($dataClass, $id, "param/collectionChangeTab.tpl");
        /**
         * Recuperation des groupes
         */
        $vue->set($dataClass->getAllGroupsFromCollection($id), "groupes");
        /**
         * Get the list of all samples types
         */
        $vue->set($dataClass->getAllsampletypesFromCollection($id), "sampletypes");
        $vue->set($dataClass->getAlleventtypesFromCollection($id), "eventtypes");
        /**
         * Recuperation des referents
         */
        require_once 'modules/classes/referent.class.php';
        $referent = new Referent($bdd, $ObjetBDDParam);
        $vue->set($referent->getListe(2), "referents");
        require_once 'modules/classes/license.class.php';
        $license = new License($bdd, $ObjetBDDParam);
        $vue->set($license->getListe(2), "licenses");
        break;
    case "write":
        /**
         * write record in database
         */
        $id = dataWrite($dataClass, $_REQUEST);
        if ($id > 0) {
            $_REQUEST[$keyName] = $id;
            /**
             * Rechargement eventuel des collections autorises pour l'utilisateur courant
             */
            try {
                $dataClass->initCollections();
            } catch (Exception $e) {
                if ($APPLI_modeDeveloppement) {
                    $message->set($e->getMessage(), true);
                }
            }
        }
        break;
    case "delete":
        /**
         * delete record
         */
        dataDelete($dataClass, $id);
        break;
    case "getAjax":
        $vue->set($dataClass->lire($_REQUEST["collection_id"]));
        break;
    case "generateMails":
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
                    $lastDate = date_create($_SESSION["notificationDate"]);
                    $interval = date_diff($lastDate, $currentDate)->format("%a");
                    if ($interval >= $_SESSION["notificationDelay"]) {
                        $notification = true;
                    }
                }
            }
            if ($notification) {
                require_once "modules/classes/sample.class.php";
                $sample = new Sample($bdd, $ObjetBDDParam);
                require_once "modules/classes/event.class.php";
                $event = new Event($bdd, $ObjetBDDParam);
                require_once "framework/utils/mail.class.php";
                $mail = new Mail();
                $collections = $dataClass->getNotificationDetails();
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
                    $dbparam = new DbParam($bdd, $ObjetBDDParam);
                }
                $dbparam->setParameter("notificationLastDate", date('Y-m-d'));
            }
        }
        break;
}
