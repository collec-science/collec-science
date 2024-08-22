<?php

namespace App\Libraries;

use App\Models\Export;
use App\Models\Lot as ModelsLot;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Lot extends PpciLibrary
{
    /**
     * @var ModelsLot
     */
    protected PpciModel $dataclass;

    private $keyName;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsLot();
        $this->keyName = "lot_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function list()
    {
        $this->vue = service('Smarty');
        $_SESSION["moduleListe"] = "lotList";
        /**
         * Display the list of all records of the table
         */
        $collection_id = 0;
        if ($_GET["collection_id"] > 0) {
            $collection_id = $_GET["collection_id"];
        } elseif ($_COOKIE["collectionId"] > 0) {
            $collection_id = $_COOKIE["collectionId"];
        }
        if ($collection_id > 0) {
            $this->vue->set($this->dataclass->getLotsFromCollection($collection_id), "lots");
        }
        $this->vue->set($_SESSION["collections"], "collections");
        $this->vue->set("export/lotList.tpl", "corps");
        return $this->vue->send();
    }
    function create()
    {
        /**
         * Verify if each uid is authorized
         */
        $ok = false;
        $sample = new Sample();
        if (count($_POST["uids"]) > 0) {
            foreach ($_SESSION["collections"] as $value) {
                if ($_POST["collection_id"] == $value["collection_id"]) {
                    $ok = true;
                }
            }
            if ($ok) {
                try {
                    $db = $this->dataclass->db;
                    $db->transBegin();
                    $_REQUEST["lot_id"] = $this->dataclass->createLot($_POST["collection_id"], $_POST["uids"]);
                    $db->transCommit();
                    $this->message->set(_("Lot créé"));
                    return $this->display();
                } catch (PpciException $e) {
                    $this->message->set(_("Une erreur est survenue pendant la création du lot"), true);
                    $this->message->setSyslog($e->getMessage());
                    if ($db->transEnabled) {
                        $db->transRollback();
                    }
                    return $sample->list();
                }
            } else {
                $this->message->set(_("Vous ne disposez pas des droits suffisants pour créer le lot"), true);
                return $sample->list();
            }
        } else {
            $this->message->set(_("Aucun échantillon n'a été sélectionné"), true);
            return $sample->list();
        }
    }
    function display()
    {
        $this->vue = service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->vue->set("export/lotDisplay.tpl", "corps");
        $this->vue->set($this->dataclass->getDetail($this->id), "data");
        /**
         * Get the list of exports
         */
        $export = new Export();
        $this->vue->set($export->getListFromLot($this->id), "exports");
        /**
         * Get the list of samples
         */
        $this->vue->set($this->dataclass->getSamples($this->id), "samples");
    }
    function write()
    {
        $sample = new Sample();
        try {
            $this->id = $this->dataWrite($_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return $this->display();
            } else {
                return $sample->list();
            }
        } catch (PpciException) {
            return $sample->list();
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
            return $this->display();
        }
    }
    function deleteSamples()
    {
        try {
            $db = $this->dataclass->db;
            $db->transBegin();
            if (empty($_POST["samples"])) {
                throw new PpciException(_("Aucun échantillon n'a été sélectionné"));
            }
            $this->dataclass->deleteSamples($this->id, $_POST["samples"]);
            $db->transCommit();
            $this->message->set(_("Suppression des échantillons sélectionnés effectuée"));
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            if ($db->transEnabled) {
                $db->transRollback();
            }
        }
        return $this->display();
    }
}
