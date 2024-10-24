<?php

namespace App\Libraries;

use App\Models\DatasetColumn;
use App\Models\DatasetTemplate;
use App\Models\ExportTemplate as ModelsExportTemplate;
use App\Models\Translator;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class ExportTemplate extends PpciLibrary
{
    /**
     * @var ModelsExportTemplate
     */
    protected PpciModel $dataclass;

    

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsExportTemplate();
        $this->keyName = "export_template_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function list()
    {
        $this->vue = service('Smarty');
        /*
         * Display the list of all records of the table
         */
        $this->vue->set($this->dataclass->getListe(2), "data");
        $this->vue->set("export/exportTemplateList.tpl", "corps");
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        /*
         * Display the detail of the record
         */
        $this->vue->set($this->dataclass->lire($this->id), "data");
        $this->vue->set("export/exportTemplateDisplay.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record 
         */
        $this->dataRead($this->id, "export/exportTemplateChange.tpl");
        $dt = new DatasetTemplate();
        $this->vue->set($dt->getListFromExportTemplate($this->id), "datasets");
        return $this->vue->send();
    }
    function write()
    {
        try {
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
        try {
            $this->dataDelete($this->id);
            return true;
        } catch (PpciException $e) {
            return false;
        }
    }
    function import()
    {
        $datasetTemplate = new DatasetTemplate();
        $datasetColumn = new DatasetColumn();
        $translator = new Translator();
        $insertExportDataset = "insert into export_dataset (export_template_id, dataset_template_id) 
                                values (:export_template_id:, :dataset_template_id:)";
        $db = $this->dataclass->db;
        $db->transBegin();
        try {
            if (file_exists($_FILES['upfile']['tmp_name'])) {
                $json = file_get_contents($_FILES["upfile"]["tmp_name"]);
                $data = json_decode($json, true);
                foreach ($data["export_template"] as $et) {
                    /**
                     * Search for existent template
                     */
                    $existent = $this->dataclass->getFromName($et["export_template_name"]);
                    if ($existent["export_template_id"] > 0) {
                        if ($existent["export_template_name"] == $et["export_template_name"] . "_copy") {
                            throw new PpciException(_("Le modèle a déjà été importé. Supprimez-le avant de relancer l'importation"));
                        } else {
                            $et["export_template_name"] .= "_copy";
                        }
                    }
                    $et["export_template_id"] = 0;
                    if ($et["export_template_id"] > 0) {
                    }
                    $et["export_template_id"] = $this->dataclass->ecrire($et);
                    /**
                     * Treatment of datasets
                     */
                    foreach ($et["children"]["export_dataset"] as $ed) {
                        /**
                         * Treatment of the dataset template
                         */
                        $dt = $ed["parents"]["dataset_template"];
                        /**
                         * Search for existent dataset_template
                         */
                        $existent = $datasetTemplate->getFromName($dt["dataset_template_name"]);
                        if ($existent["dataset_template_id"] > 0) {
                            if ($existent["dataset_template_name"] == $dt["dataset_template_name"] . "_copy") {
                                throw new PpciException(_("Le modèle de dataset a déjà été importé. Supprimez-le avant de relancer l'importation"));
                            } else {
                                $dt["dataset_template_name"] .= "_copy";
                            }
                        }
                        $dt["dataset_template_id"] = 0;
                        $dt["dataset_template_id"] = $datasetTemplate->ecrire($dt);
                        /**
                         * Treatment of each column
                         */
                        foreach ($dt["children"]["dataset_column"] as $dc) {
                            /**
                             * Treatment of translator
                             */
                            $dc["dataset_column_id"] = 0;
                            $dc["dataset_template_id"] = $dt["dataset_template_id"];
                            $t = $dc["parents"]["translator"][0];
                            if (!empty($t)) {
                                $t["translator_id"] = 0;
                                $dc["translator_id"] = $translator->ecrire($t);
                            }
                            $datasetColumn->ecrire($dc);
                        }
                        /**
                         * write relation between export_template and dataset_template
                         */
                        $dtnew = array(
                            "export_template_id" => $et["export_template_id"],
                            "dataset_template_id" => $dt["dataset_template_id"]
                        );
                        $this->dataclass->executeSQL($insertExportDataset, $dtnew, true);
                    }
                }
            } else {
                throw new PpciException(_("Le fichier contenant le modèle à importer n'a pas été téléchargé"));
            }
            $db->transCommit();
            $this->message->set(_("Importation du modèle effectuée"));
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            if ($db->transEnabled) {
                $db->transRollback();
            }
        }
    }
}
