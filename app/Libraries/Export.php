<?php

namespace App\Libraries;

use App\Libraries\Lot as LibrariesLot;
use App\Models\Export as ModelsExport;
use App\Models\ExportTemplate;
use App\Models\Lot;
use App\Models\MimeType;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Export extends PpciLibrary
{
    /**
     * @var ModelsExport
     */
    protected PpciModel $dataclass;

    private $keyName;

    function __construct()
    {
        parent::__construct();
        $this->dataClass = new ModelsExport();
        $this->keyName = "export_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function change()
    {
        $this->vue = service('Smarty');
        /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
        $this->dataRead($this->id, "export/exportChange.tpl", $_REQUEST["lot_id"]);
        $lot = new Lot();
        $this->vue->set($lot->getDetail($_REQUEST["lot_id"]), "lot");
        $template = new ExportTemplate();
        $this->vue->set($template->getListe("export_template_name"), "templates");
        return $this->vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                $lot = new LibrariesLot;
                return $lot->display();
            } else {
                return $this->change();
            }
        } catch (PpciException) {
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
            $lot = new LibrariesLot;
            return $lot->display();
        } catch (PpciException $e) {
            return $this->change();
        }
    }
    function exec()
    {
        /**
         * Get the record of the lot
         */
        $lot = new Lot();
        $llot = new LibrariesLot;
        $dlot = $lot->lire($_REQUEST["lot_id"]);
        if ($dlot["collection_id"] > 0) {
            if (collectionVerify($dlot["collection_id"])) {
                try {
                    $files = $this->dataclass->generate($this->id);
                    /* Warning: only one file must be generated */
                    if (file_exists($files[0]["filetmp"])) {
                        /**
                         * Get the contentType
                         */
                        $mimeType = new MimeType();
                        $type_mime_id = $mimeType->getTypeMime($files[0]["filetype"]);
                        if ($type_mime_id > 0) {
                            $dmime = $mimeType->lire($type_mime_id);
                            $param = array(
                                "filename" => $files[0]["filename"],
                                "tmp_name" => $files[0]["filetmp"],
                                "content_type" => $dmime["content_type"]
                            );
                            $this->vue = service("BinaryView");
                            $this->vue->setParam($param);
                            /**
                             * Update the export date
                             */
                            $this->dataclass->updateExportDate($this->id);
                        } else {
                            throw new PpciException(sprintf(_("Le type mime pour l'extension %s n'a pas été décrit dans la base de données"), $files[0]["filetype"]));
                        }
                    } else {
                        $this->message->set(_("Une erreur indéterminée s'est produite lors de la génération du fichier"), true);
                        return $llot->display();
                    }
                } catch (PpciException $e) {
                    $this->message->set($e->getMessage(), true);
                    return $llot->display();
                }
            } else {
                $this->message->set(_("Vous ne disposez pas des droits suffisants sur la collection pour exporter le lot"), true);
                return $llot->display();
            }
        } else {
            $this->message->set(_("Le lot indiqué n'existe pas"), true);
            return $llot->display();
        }
    }
}
