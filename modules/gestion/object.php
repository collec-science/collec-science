<?php
/**
 * Created : 16 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/object.class.php';
$dataClass = new Object($bdd, $ObjetBDDParam);
$keyName = "uid";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "getDetailAjax":
        /**
         * Retourne le detail d'un objet a partir de son uid
         * (independamment du type : sample ou container)
         */
        $vue->set($dataClass->getDetail($id, $_REQUEST["is_container"]));
        break;
    case "printLabelDirect":
        if ($_REQUEST["printer_id"]) {
            try {
                $pdffile = $dataClass->generatePdf($id);
                require_once 'modules/classes/printer.class.php';
                $printer = new Printer($bdd, $ObjetBDDParam);
                $dp = $printer->lire($_REQUEST["printer_id"]);
                if (strlen($dp["printer_queue"]) > 0) {
                    $options = " -o fit-to-page";
                    define("SPACE", " ");
                    $commande = $APPLI_print_direct_command;
                    if ($commande == "lpr") {
                        $cmdopt = array("destination"=>"-P ",
                          "server" => "-H ",
                            "user" => "-U "
                        );
                    } else {
                        $cmdopt = array("destination"=>"-d ",
                            "server" => "-h ",
                            "user" => "-U "
                        );
                    }
                    /*
                     * Destination
                     */
                    $destination = $cmdopt["destination"] . $dp["printer_queue"];
                    $server = "";
                    if (strlen($dp["printer_server"]) > 0) {
                        $server = $cmdopt["server"] . $dp["printer_server"];
                    } else {
                        $server = "";
                    }
                    if (strlen($dp["printer_user"]) > 0) {
                        $user = $cmdopt["user"] . $dp["printer_user"];
                    } else {
                        $user = "";
                    }
                    $commande .= SPACE . $destination . SPACE . $server . SPACE . $user . SPACE . $options . SPACE . $pdffile;
                   exec($commande, $retour, $retour);
                   $dataClass->eraseQrcode($APPLI_temp);
                    $dataClass->eraseXslfile();
                    if ($retour == 0) {
                    $message->set("Impression lancée");
                    } else {
                        $message->set("L'impression a échoué pour un problème technique");
                        $message->setSyslog("print command error : $commande");
                    }
                } else {
                    $message->set("Imprimante non connue");
                    $module_coderetour = - 1;
                }
                $module_coderetour = 1;
            } catch (Exception $e) {
                $message->set($e->getMessage());
                $module_coderetour = - 1;
            }
        } else {
            $message->set("Imprimante non définie");
            $module_coderetour = - 1;
        }
        break;
    case "printLabel":
        try {
            $vue->setFilename($dataClass->generatePdf($id));
            $vue->setDisposition("inline");
            $dataClass->eraseQrcode($APPLI_temp);
            $dataClass->eraseXslfile();
            $module_coderetour = 1;
        } catch (Exception $e) {
            $message->set($e->getMessage());
            $module_coderetour = - 1;
        }
        
        if ($module_coderetour == -1) {
            /*
             * Reinitialisation de la vue
             */
            unset($vue);
        }
        break;
    case "exportCSV":
        $data = $dataClass->getForPrint($_REQUEST["uid"]);
        if (count($data) > 0) {
            $vue->set($data);
            $vue->setFilename("printlabel.csv");
        } else {
            unset($vue);
            $module_coderetour = - 1;
        }
        break;
}
?>