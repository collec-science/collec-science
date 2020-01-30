<?php

/**
 * Created : 16 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/object.class.php';
$dataClass = new ObjectClass($bdd, $ObjetBDDParam);
$keyName = "uid";
$id = $_REQUEST[$keyName];
if (isset($_REQUEST["uids"])) {
    is_array($_REQUEST["uids"]) ? $uids = $_REQUEST["uids"] : $uids = array($_REQUEST["uids"]);
}
switch ($t_module["param"]) {
    case "getDetailAjax":
        /**
         * Retourne le detail d'un objet a partir de son uid
         * (independamment du type : sample ou container)
         */
        $is_partial = false;
        if (isset($_REQUEST["is_partial"])) {
            $is_partial = $_REQUEST["is_partial"];
        }
        $vue->set($dataClass->getDetail($id, $_REQUEST["is_container"], $is_partial));
        break;
    case "printLabelDirect":
        if ($_REQUEST["printer_id"]) {
            try {
                $pdffile = $dataClass->generatePdf($uids);
                require_once 'modules/classes/printer.class.php';
                $printer = new Printer($bdd, $ObjetBDDParam);
                $dp = $printer->lire($_REQUEST["printer_id"]);
                if (strlen($dp["printer_queue"]) > 0) {
                    $options = " -o fit-to-page";
                    define("SPACE", " ");
                    $commande = $APPLI_print_direct_command;
                    if ($commande == "lpr") {
                        $cmdopt = array(
                            "destination" => "-P ",
                            "server" => "-H ",
                            "user" => "-U "
                        );
                    } else {
                        $cmdopt = array(
                            "destination" => "-d ",
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
                        $message->set(_("Impression lancée"));
                    } else {
                        $message->set(_("L'impression a échoué pour un problème technique"), true);
                        $message->setSyslog("print command error : $commande");
                    }
                } else {
                    $message->set(_("Imprimante non connue"), true);
                    $module_coderetour = -1;
                }
                $t_module["retourko"] = $_REQUEST["lastModule"];
                $t_module["retourok"] = $_REQUEST["lastModule"];
                $module_coderetour = 1;
            } catch (Exception $e) {
                $message->set($e->getMessage(), true);
                $module_coderetour = -1;
                $t_module["retourko"] = $_REQUEST["lastModule"];
            }
        } else {
            $message->set(_("Imprimante non définie"), true);
            $module_coderetour = -1;
            $t_module["retourko"] = $_REQUEST["lastModule"];
        }
        break;
    case "printLabel":
        $t_module["retourko"] = $_REQUEST["lastModule"];
        $t_module["retourok"] = $_REQUEST["lastModule"];
        try {
            $vue->setFilename($dataClass->generatePdf($uids));
            $vue->setDisposition("inline");
            $dataClass->eraseQrcode($APPLI_temp);
            $dataClass->eraseXslfile();
            $module_coderetour = 1;
        } catch (Exception $e) {
            $message->set($e->getMessage(), true);
            $module_coderetour = -1;
        }

        if ($module_coderetour == -1) {
            /*
             * Reinitialisation de la vue
             */
            unset($vue);
        }
        break;
    case "exportCSV":
        $data = $dataClass->getForPrint($uids);
        if (count($data) > 0) {
            $vue->set($data);
            $vue->regenerateHeader();
            $vue->setFilename("printlabel.csv");
        } else {
            unset($vue);
            $module_coderetour = -1;
        }
        break;
    case "setTrashed":
        $trashed = $_POST["trashed"];
        if (count($_POST["uids"]) > 0 && ($trashed == 0 || $trashed == 1)) {
            is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
            $bdd->beginTransaction();
            try {
                foreach ($uids as $uid) {
                    $dataClass->setTrashed($uid, $_POST["trashed"]);
                }
                $bdd->commit();
                $module_coderetour = 1;
                if ($_POST["trashed"] == 1) {
                    $message->set(_("Mise à la corbeille effectuée"));
                } else {
                    $message->set(_("Sortie de la corbeille effectuée"));
                }
            } catch (Exception $e) {
                $message->set(_("L'opération sur la corbeille a échoué"), true);
                $message->set($e->getMessage());
                $bdd->rollback();
                $module_coderetour = -1;
            }
        } else {
            $message->set(_("Opération sur la corbeille impossible à exécuter"), true);
        }
        break;
}
