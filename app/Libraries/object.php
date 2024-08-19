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

/**
 * Created : 16 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
include_once 'modules/classes/object.class.php';
$this->dataclass = new ObjectClass();
$this->keyName = "uid";
$this->id = $_REQUEST[$this->keyName];
if (isset($_REQUEST["uids"])) {
    is_array($_REQUEST["uids"]) ? $uids = $_REQUEST["uids"] : $uids = array($_REQUEST["uids"]);
}

    function getDetailAjax() {
        /**
         * Retourne le detail d'un objet a partir de son uid
         * (independamment du type : sample ou container)
         */
        $is_partial = false;
        if (isset($_REQUEST["is_partial"])) {
            $is_partial = $_REQUEST["is_partial"];
        }
        $this->vue->set($this->dataclass->getDetail($this->id, $_REQUEST["is_container"], $is_partial));
        }
    function printLabelDirect() {
        if ($_REQUEST["printer_id"]) {
            try {
                $pdffile = $this->dataclass->generatePdf($uids);
                require_once 'modules/classes/printer.class.php';
                $printer = new Printer();
                $dp = $printer->lire($_REQUEST["printer_id"]);
                if (!empty($dp["printer_queue"]) ) {
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
                    if (!empty($dp["printer_server"])) {
                        $server = $cmdopt["server"] . $dp["printer_server"];
                    } else {
                        $server = "";
                    }
                    if (!empty($dp["printer_user"]) ) {
                        $user = $cmdopt["user"] . $dp["printer_user"];
                    } else {
                        $user = "";
                    }
                    $commande .= SPACE . $destination . SPACE . $server . SPACE . $user . SPACE . $options . SPACE . $pdffile;
                    exec($commande, $retour, $retour);
                    $this->dataclass->eraseQrcode( $this->appConfig->APP_temp);
                    $this->dataclass->eraseXslfile();
                    if ($retour == 0) {
                        $this->message->set(_("Impression lancée"));
                    } else {
                        $this->message->set(_("L'impression a échoué pour un problème technique"), true);
                        $this->message->setSyslog("print command error : $commande");
                    }
                } else {
                    $this->message->set(_("Imprimante non connue"), true);
                    $module_coderetour = -1;
                }
                $t_module["retourko"] = $_REQUEST["lastModule"];
                $t_module["retourok"] = $_REQUEST["lastModule"];
                $module_coderetour = 1;
            } catch (Exception $e) {
                $this->message->set($e->getMessage(), true);
                $module_coderetour = -1;
                $t_module["retourko"] = $_REQUEST["lastModule"];
            }
        } else {
            $this->message->set(_("Imprimante non définie"), true);
            $module_coderetour = -1;
            $t_module["retourko"] = $_REQUEST["lastModule"];
        }
        }
    function printLabel() {
        $t_module["retourko"] = $_REQUEST["lastModule"];
        $t_module["retourok"] = $_REQUEST["lastModule"];
        try {
            if (! $uids[0] > 0) {
                throw new Exception (_("Aucune ligne n'a été sélectionnée, l'impression des étiquettes est impossible"), true);
            }
            $this->vue->setFilename($this->dataclass->generatePdf($uids));
            $this->vue->setDisposition("inline");
            $this->dataclass->eraseQrcode( $this->appConfig->APP_temp);
            $this->dataclass->eraseXslfile();
            $module_coderetour = 1;
        } catch (Exception $e) {
            $this->message->set($e->getMessage(), true);
            $module_coderetour = -1;
        }

        if ($module_coderetour == -1) {
            /*
             * Reinitialisation de la vue
             */
            unset($this->vue);
        }
        }
    function exportCSV() {
        if ($uids) {
            $data = $this->dataclass->getForPrint($uids);
            if (count($data) > 0) {
                $this->vue->set($data);
                $this->vue->regenerateHeader();
                $this->vue->setFilename("printlabel.csv");
            } else {
                $this->message->set(_("Pas d'objets à exporter"), true);
                unset($this->vue);
                $module_coderetour = -1;
            }
        } else {
            unset($this->vue);
            $module_coderetour = -1;
            $this->message->set(_("Pas d'objet sélectionné pour la génération du fichier"), true);
        }
        }
    function setTrashed() {
        $trashed = $_POST["settrashed"];
        if (count($_POST["uids"]) > 0 && ($trashed == 0 || $trashed == 1)) {
            is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
            $db = $this->dataClass->db;
$db->transBegin();
            try {
                foreach ($uids as $uid) {
                    $this->dataclass->setTrashed($uid, $trashed);
                }
                
                $module_coderetour = 1;
                if ($_POST["trashed"] == 1) {
                    $this->message->set(_("Mise à la corbeille effectuée"));
                } else {
                    $this->message->set(_("Sortie de la corbeille effectuée"));
                }
            } catch (Exception $e) {
                $this->message->set(_("L'opération sur la corbeille a échoué"), true);
                $this->message->set($e->getMessage());
                if ($db->transEnabled) {
    $db->transRollback();
}
                $module_coderetour = -1;
            }
        } else {
            $this->message->set(_("Opération sur la corbeille impossible à exécuter"), true);
        }
        }
}
