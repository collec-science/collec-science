<?php

namespace App\Libraries;

use App\Models\ObjectClass;
use App\Models\Printer;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class ObjectLib extends PpciLibrary
{
    /**
     * @var ObjectClass
     */
    protected PpciModel $dataclass;

    private $keyName;
    private $uids;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ObjectClass();
        $this->keyName = "uid";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
        if (isset($_REQUEST["uids"])) {
            is_array($_REQUEST["uids"]) ? $this->uids = $_REQUEST["uids"] : $this->uids = array($_REQUEST["uids"]);
        }
    }
    function getDetailAjax()
    {
        /**
         * Retourne le detail d'un objet a partir de son uid
         * (independamment du type : sample ou container)
         */
        $is_partial = false;
        if (isset($_REQUEST["is_partial"])) {
            $is_partial = $_REQUEST["is_partial"];
        }
        $this->vue = service("AjaxView");
        $this->vue->set($this->dataclass->getDetail($this->id, $_REQUEST["is_container"], $is_partial));
        return $this->vue->send();
    }
    function printLabelDirect()
    {
        if ($_REQUEST["printer_id"]) {
            try {
                $pdffile = $this->dataclass->generatePdf($this->uids);

                $printer = new Printer();
                $dp = $printer->lire($_REQUEST["printer_id"]);
                if (!empty($dp["printer_queue"])) {
                    $options = " -o fit-to-page";
                    define("SPACE", " ");
                    $commande = $this->appConfig->print_direct_command;
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
                    if (!empty($dp["printer_user"])) {
                        $user = $cmdopt["user"] . $dp["printer_user"];
                    } else {
                        $user = "";
                    }
                    $commande .= SPACE . $destination . SPACE . $server . SPACE . $user . SPACE . $options . SPACE . $pdffile;
                    exec($commande, $retour, $retour);
                    $this->dataclass->eraseQrcode($this->appConfig->APP_temp);
                    $this->dataclass->eraseXslfile();
                    if ($retour == 0) {
                        $this->message->set(_("Impression lancée"));
                        return true;
                    } else {
                        $this->message->set(_("L'impression a échoué pour un problème technique"), true);
                        $this->message->setSyslog("print command error : $commande");
                        return false;
                    }
                } else {
                    $this->message->set(_("Imprimante non connue"), true);
                    return false;
                }
            } catch (PpciException $e) {
                $this->message->set($e->getMessage(), true);
                return false;
            }
        } else {
            $this->message->set(_("Imprimante non définie"), true);
            return false;
        }
    }
    function printLabel()
    {
        $this->vue = service("PdfView");
        try {
            if (! $this->uids[0] > 0) {
                throw new PpciException(_("Aucune ligne n'a été sélectionnée, l'impression des étiquettes est impossible"), true);
            }
            $this->vue->setFilename($this->dataclass->generatePdf($this->uids));
            $this->vue->setDisposition("inline");
            $this->dataclass->eraseQrcode($this->appConfig->APP_temp);
            $this->dataclass->eraseXslfile();
            $this->vue->send();
            return true;
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            return false;
        }
    }
    function exportCSV()
    {
        if ($this->uids) {
            $data = $this->dataclass->getForPrint($this->uids);
            if (count($data) > 0) {
                $this->vue = service("CsvView");
                $this->vue->set($data);
                $this->vue->regenerateHeader();
                $this->vue->setFilename("printlabel.csv");
                $this->vue->send();
                return true;
            } else {
                $this->message->set(_("Pas d'objets à exporter"), true);
                return false;
            }
        } else {
            $this->message->set(_("Pas d'objet sélectionné pour la génération du fichier"), true);
            return false;
        }
    }
    function setTrashed()
    {
        $trashed = $_POST["settrashed"];
        if (count($_POST["uids"]) > 0 && ($trashed == 0 || $trashed == 1)) {
            is_array($_POST["uids"]) ? $uids = $_POST["uids"] : $uids = array($_POST["uids"]);
            $db = $this->dataclass->db;
            $db->transBegin();
            try {
                foreach ($uids as $uid) {
                    $this->dataclass->setTrashed($uid, $trashed);
                }
                $db->transCommit();
                if ($_POST["trashed"] == 1) {
                    $this->message->set(_("Mise à la corbeille effectuée"));
                } else {
                    $this->message->set(_("Sortie de la corbeille effectuée"));
                }
                return true;
            } catch (PpciException $e) {
                $this->message->set(_("L'opération sur la corbeille a échoué"), true);
                $this->message->set($e->getMessage());
                if ($db->transEnabled) {
                    $db->transRollback();
                }
                return false;
            }
        } else {
            $this->message->set(_("Opération sur la corbeille impossible à exécuter"), true);
            return false;
        }
    }
}
