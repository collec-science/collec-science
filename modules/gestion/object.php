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
                    $commande = "lpr";
                    $destination = "-P " . $dp["printer_queue"];
                    $server = "";
                    if (strlen($dp["printer_server"]) > 0) {
                        $server = "-H " . $dp["printer_server"];
                    } else {
                        $server = "";
                    }
                    if (strlen($dp["printer_user"]) > 0) {
                        $user = "-U " . $dp["printer_user"];
                    } else {
                        $user = "";
                    }
                    $commande .= SPACE . $destination . SPACE . $server . SPACE . $user . SPACE . $options . SPACE . $pdffile;
                    exec($commande);
                    $message->set("Impression lancée");
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
            $vue->setFilename($dataClass->generatePdf($dataClass, $id));
            $vue->setDisposition("inline");
            $dataClass->eraseQrcode($APPLI_temp);
            $dataClass->eraseXslfile();
            $module_coderetour = 1;
        } catch (Exception $e) {
            $message->set($e->getMessage());
            $module_coderetour = - 1;
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