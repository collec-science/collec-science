<?php

namespace App\Libraries;

use App\Models\Collection;
use App\Models\Protocol as ModelsProtocol;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Protocol extends PpciLibrary
{
    /**
     * @var ModelsProtocol
     */
    protected PpciModel $dataclass;

    private $keyName;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsProtocol();
        $this->keyName = "protocol_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function list()
    {
        $this->vue = service('Smarty');

        $this->vue->set($this->dataclass->getListe(), "data");
        $this->vue->set("param/protocolList.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "param/protocolChange.tpl");
        $collection = new Collection();
        $this->vue->set($collection->getListe(2), "collections");
        helper('appfunctions');
        $this->vue->set(getMaximumFileUploadSize(), "maxFileSize");
        return $this->vue->send();
    }
    function write()
    {
        /*
         * write record in database
         */
        try {
            $db = $this->dataclass->db;
            $db->transBegin();
            $this->id = $this->dataWrite($_POST, true);
            if ($this->id > 0) {
                if ($_FILES["protocol_file"]["error"] == 1) {
                    throw new PpciException(_("Problème rencontré pendant le téléchargement du fichier joint"), true);
                }
                /*
                 * Traitement du fichier eventuellement joint
                 */
                if ($_FILES["protocol_file"]["size"] > 0) {
                    try {
                        $this->dataclass->ecrire_document($this->id, $_FILES["protocol_file"]);
                    } catch (PpciException $fe) {
                        throw new PpciException($fe->getMessage());
                    } catch (PpciException $e) {
                        $this->message->setSyslog($e->getMessage());
                        throw new PpciException(_("impossible d'enregistrer la pièce jointe"));
                    }
                }
                if ($_POST["documentDelete"] == 1) {
                    $this->dataclass->documentDelete($this->id);
                }
                $_REQUEST[$this->keyName] = $this->id;
                $db->transCommit();
                $this->message->set(_("Enregistrement effectué"));
                return $this->list();
            }
        } catch (PpciException $e) {
            if ($db->transEnabled) {
                $db->transRollback();
            }
            $this->message->set($e->getMessage(), true);
            return $this->change();
        }
    }
    function delete()
    {
        /*
         * delete record
         */
        try {
            $this->dataDelete($this->id);
            return $this->list();
        } catch (PpciException $e) {
            return $this->change();
        }
    }
    function file()
    {
        try {
            $ref = $this->dataclass->getProtocolFile($this->id);
            //$this->vue->setDisposition("inline");
            $this->vue = service("PdfView");
            $this->vue->setFileReference($ref);
            return $this->vue->send();
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            return $this->list();
        }
    }
}
