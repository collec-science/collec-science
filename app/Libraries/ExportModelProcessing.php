<?php

namespace App\Libraries;

use App\Libraries\ExportModel as LibrariesExportModel;
use App\Models\ExportModel;
use App\Models\ExportModelProcessing as ModelsExportModelProcessing;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;

class ExportModelProcessing extends PpciLibrary
{
    private $exportModel, $export;

    function __construct()
    {
        parent::__construct();
        $this->exportModel = new ExportModel();
        $this->export = new ModelsExportModelProcessing();
        $this->export->modeDebug = false;
    }

    function exec()
    {
        try {
            $model = array();
            if ($_REQUEST["export_model_id"] > 0) {
                $model = $this->exportModel->lire($_REQUEST["export_model_id"]);
            } else if (!empty($_REQUEST["export_model_name"])) {
                $model = $this->exportModel->getModelFromName($_REQUEST["export_model_name"]);
            }
            if ($model["export_model_id"] > 0) {
                $this->export->initModel(json_decode($model["pattern"], true));
                //$this->export->modeDebug = true;
                /**
                 * Generate the structure of the database
                 */
                $this->export->generateStructure();
                $data = array();
                foreach ($this->export->getListPrimaryTables() as $key => $table) {
                    if ($key == 0 && count($_REQUEST["keys"]) > 0) {
                        $keys = $_REQUEST["keys"];
                        /**
                         * set the list of records for the first item
                         */
                        $data[$table] = $this->export->getTableContent($table, $keys);
                    } else {
                        $data[$table] = $this->export->getTableContent($table);
                    }
                }
                if ($this->export->modeDebug) {
                    throw new PpciException("Debug mode: no file generated");
                }
                $this->vue = service("FileView");
                $this->vue->setParam(array("filename" => $_SESSION["dbparams"]["APPLI_code"] . '-' . date('YmdHis') . ".json"));
                $this->vue->set(json_encode($data));
                return $this->vue->send();
            } else {
                throw new PpciException(_("Le modèle d'export n'est pas défini ou n'a pas été trouvé"));
            }
        } catch (PpciException $e) {
            if (isset($_REQUEST["returnko"])) {
                $t_module["retourko"] = $_REQUEST["returnko"];
            }
            $this->message->set($e->getMessage(), true);
            $this->message->setSyslog($e->getMessage());
        }
        $em = new LibrariesExportModel;
        return $em->display();
    }

    function importExec()
    {
        /**
         * set the return values
         */
        if (isset($_REQUEST["returnok"])) {
            $t_module["retourok"] = $_REQUEST["returnok"];
        }
        if (isset($_REQUEST["returnko"])) {
            $t_module["retourko"] = $_REQUEST["returnok"];
        }
        /**
         * Verify the project, if it's specified
         */
        $testProject = true;
        if (($_REQUEST["export_model_id"] > 0 || !empty($_REQUEST["export_model_name"])) && $_FILES["filename"]["size"] > 0 && $testProject) {
            if ($_REQUEST["export_model_id"]) {
                $model = $this->exportModel->lire($_REQUEST["export_model_id"]);
            } else {
                $model = $this->exportModel->getModelFromName($_REQUEST["export_model_name"]);
            }
            $this->export->initModel(json_decode($model["pattern"], true));
            /**
             * Generate the structure of the database
             */
            $this->export->generateStructure();
            //$this->export->modeDebug = true;
            $filename = $_FILES["filename"]["tmp_name"];
            $realFilename = $_FILES["filename"]["name"];
            $filename = str_replace("../", "", $filename);
            $handle = fopen($filename, 'r');
            if (!$handle) {
                $this->message->set(sprintf(_("Fichier %s non trouvé ou non lisible"), $filename), true);
                return ZZZ;
            } else {
                $contents = fread($handle, filesize($filename));
                fclose($handle);
                $data = json_decode($contents, true);
                try {
                    $db = $this->dataclass->db;
                    $db->transBegin();
                    $firstTable = true;
                    foreach ($data as $tableName => $values) {
                        if ($firstTable && !empty($_REQUEST["parentKeyName"])) {
                            $key = $_REQUEST["parentKey"];
                            $this->export->importDataTable($tableName, $values, 0, array($_REQUEST["parentKeyName"] => $key));
                            $firstTable = false;
                        } else {
                            $this->export->importDataTable($tableName, $values);
                        }
                    }

                    $this->message->set(sprintf(_("Importation effectuée, fichier %s traité."), $realFilename));
                    return ZZZ;
                } catch (PpciException $e) {
                    if ($db->transEnabled) {
                        $db->transRollback();
                    }
                    $this->message->set($e->getMessage(), true);
                    return ZZZ;
                }
            }
        } else {
            $this->message->set(_("Paramètres d'importation manquants ou droits insuffisants"), true);
            return ZZZ;
        }
    }
}
