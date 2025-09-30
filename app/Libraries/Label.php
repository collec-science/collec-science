<?php

namespace App\Libraries;

use App\Models\Barcode;
use App\Models\Label as ModelsLabel;
use App\Models\LabelOptical;
use App\Models\Metadata;
use App\Models\Printer;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Libraries\Views\BinaryView;
use Ppci\Libraries\Views\DisplayView;
use Ppci\Models\PpciModel;

class Label extends PpciLibrary
{
    /**
     * @var ModelsLabel
     */
    protected PpciModel $dataclass;



    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsLabel();
        $this->keyName = "label_id";
        if (isset($_REQUEST[$this->keyName]) && strlen($_REQUEST[$this->keyName]) > 0) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    /**
     * Created : 8 sept. 2016
     * Creator : quinton
     * Encoding : UTF-8
     * Copyright 2016 - All rights reserved
     */



    function list()
    {
        $this->vue = service('Smarty');
        # TODO : modifier l'affichage de la liste, en rajoutant le nombre de codes optiques
        /*
         * Display the list of all records of the table
         */
        $this->vue->set($this->dataclass->getListe(2), "data");
        $this->vue->set("param/labelList.tpl", "corps");
        $this->setRelatedTablesToView($this->vue);
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "param/labelChange.tpl");
        $metadata = new Metadata();
        $barcode = new Barcode();
        $optical = new LabelOptical;
        $this->vue->set($barcode->getListe(1), "barcodes");
        $this->vue->set($metadata->getListe(), "metadata");
        $this->vue->set($optical->getListToChange($this->id), "opticals");
        return $this->vue->send();
    }
    function write()
    {
        try {
            $_REQUEST["label_xsl"] = hex2bin($_REQUEST["label_xsl"]);
            $this->id = $this->dataWrite($_REQUEST);
            $_REQUEST[$this->keyName] = $this->id;
            $optical = new LabelOptical;
            $optical->write($_REQUEST);
            /**
             * Second label
             */
            if ($_POST["optical2enabled"] == 1) {
                $content = [
                    "label_optical_id" => $_POST["label_optical_id2"],
                    "label_id" => $this->id,
                    "barcode_id" => $_POST["barcode_id2"],
                    "content_type" => $_POST["content_type2"],
                    "radical" => $_POST["radical2"],
                    "optical_content" => $_POST["optical_content2"]
                ];
                $optical->write($content);
            } elseif ($_POST["label_optical_id2"] > 0) {
                /**
                 * delete the second optical
                 */
                $optical->supprimer($_POST["label_optical_id2"]);
            }
            /**
             * Treatment of the logo
             */
            if ($_FILES["logo"]["error"]== 0) {
                $this->dataclass->writeLogo($this->id, $_FILES["logo"]);
            }
            return true;
        } catch (PpciException) {
            return false;
        }
    }
    function delete()
    {
        /*
         * delete record
         */
        /**
         * Search if the label is referenced into a model of container
         */
        $containers = $this->dataclass->getReferencedContainers($this->id);
        if (!empty($containers)) {
            foreach ($containers as $row) {
                $this->message->set(
                    sprintf(
                        _("La suppression du modèle d'étiquette n'est pas possible, il est référencé par le type de contenant %s"),
                        $row["container_type_name"]
                    ),
                    true
                );
            }
            return false;
        } else {
            try {
                $optical = new LabelOptical;
                $optical->deleteFromField($this->id, "label_id");
                $this->dataDelete($this->id);
                return true;
            } catch (PpciException) {
                return false;
            }
        }
    }
    function copy()
    {
        # TODO : intégrer label_optical
        /*
         * Duplication d'une etiquette
         */
        $this->vue = service('Smarty');
        $data = $this->dataclass->lire($this->id);
        $data["label_id"] = 0;
        $data["label_name"] = "";
        $this->vue->set($data, "data");
        $this->vue->set("param/labelChange.tpl", "corps");
        $metadata = new Metadata();
        $this->vue->set($metadata->getListe(), "metadata");
        $barcode = new Barcode();
        $this->vue->set($barcode->getListe(1), "barcodes");
        return $this->vue->send();
    }

    function setRelatedTablesToView($vue)
    {
        if (isset($_REQUEST["label_id"])) {
            $vue->set($_REQUEST["label_id"], "label_id");
        }
        $vue->set($this->dataclass->getListe(2), "labels");
        $printer = new Printer();
        $vue->set($printer->getListe(2), "printers");
        if (isset($_REQUEST["printer_id"])) {
            $vue->set($_REQUEST["printer_id"], "printer_id");
        }
    }

    function getLogo() {
        $data = $this->dataclass->getLogo($this->id);
        if ($data) {
            $vue = new DisplayView();
            $vue->set($data);
            $vue->send();
        }
    }
}
