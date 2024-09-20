<?php

namespace App\Libraries;

use App\Models\Barcode;
use App\Models\Label as ModelsLabel;
use App\Models\Metadata;
use App\Models\Printer;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Label extends PpciLibrary
{
    /**
     * @var ModelsLabel
     */
    protected PpciModel $dataclass;

    private $keyName;

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
        $this->vue->set($barcode->getListe(1), "barcodes");
        $this->vue->set($metadata->getListe(), "metadata");
        return $this->vue->send();
    }
    function write()
    {
        try {
            $_REQUEST["label_xsl"] = hex2bin($_REQUEST["label_xsl"]);
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return true;
            } else {
                return false;
            }
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
            return $this->change();
        } else {
            try {
                $this->dataDelete($this->id);
                return $this->list();
            } catch (PpciException) {
                return $this->change();
            }
        }
    }
    function copy()
    {
        /*
         * Duplication d'une etiquette
         */
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
}
