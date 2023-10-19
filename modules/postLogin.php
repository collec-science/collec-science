<?php
/**
 * @author Eric Quinton
 * @copyright Copyright (c) 2014, IRSTEA / Eric Quinton
 * @license http://www.cecill.info/licences/Licence_CeCILL-C_V1-fr.html LICENCE DE LOGICIEL LIBRE CeCILL-C
 *  Creation 7 avr. 2014
 *  Programme execute si necessaire apres identification
 */

/*
 * Suppression des documents de plus de 24 heures dans le dossier temporaire
 */
if (!empty($APPLI_temp)) {
    $dureeVie = 3600 * 24; // Suppression de tous les fichiers de plus de 24 heures
    // $dureeVie = 30;
    /*
     * Ouverture du dossier
     */
    $dossier = opendir($APPLI_temp);
    while (false !== ($entry = readdir($dossier))) {
        $path = $APPLI_temp . "/" . $entry;
        $file = fopen($path, 'r');
        $stat = fstat($file);
        $atime = $stat["atime"];
        fclose($file);
        $infos = pathinfo($path);
        if (!is_dir($path) && ($infos["basename"] != ".htaccess")) {
            $age = time() - $atime;
            if ($age > $dureeVie) {
                unlink($path);
            }
        }
    }
    closedir($dossier);
}
require_once 'modules/classes/collection.class.php';
$collection = new Collection($bdd, $ObjetBDDParam);
/*
 * Recuperation des collections attaches directement au login
 */
try {
    $collection->initCollections();
} catch (Exception $e) {
    if ($APPLI_modeDeveloppement) {
        $message->set($e->getMessage());
    }
}
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
        $collections = $collection->getNotificationDetails();
        foreach ($collections as $col) {
            $data = array();
            /**
             * Search expired_samples
             */
            if ($col["expiration_delay"] > 0) {
                $dateTo = $currentDate->add(new DateInterval("P" . $col["expiration_delay"] . "D"));
                $data["samples"] = $sample->getExpirationSamples($col["collection_id"], $currentDate->format("Y-m-d"), $dateTo->format("Y-m-d"));
            }
            /**
             * Search for due events
             */
            if ($col["event_due_delay"] > 0) {
                $dateTo = $currentDate->add(new DateInterval("P" . $col["event_due_delay"] . "D"));
                $data["events"] = $event->getEventsDueDate($col["collection_id"], $currentDate->format("Y-m-d"), $dateTo->format("Y-m-d"));
            }
            if (!empty($data["samples"]) || !empty($data["events"])) {
                $data["collection_name"] = $col["collection_name"];
                $dests = explode(";", $col["notification_mails"]);
                foreach ($dests as $dest) {
                    $mail->SendMailSmarty(
                        $SMARTY_param,
                        $dest,
                        $_SESSION["APPLI_title"] . " - " . _(sprintf("Notifications concernant la collection %s", $col["collection_name"])),
                        "param/collectionMail.tpl",
                        $data,
                        $_SESSION["FORMATDATE"],
                        true
                    );
                }
            }
        }
        /**
         * Update the date of the last mail send
         */
        $dbparam->setParameter("notificationLastDate", $currentDate->format('Y-m-d'));
    }
}