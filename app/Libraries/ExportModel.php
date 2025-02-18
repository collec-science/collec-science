<?php

namespace App\Libraries;

use App\Models\ExportModel as ModelsExportModel;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class ExportModel extends PpciLibrary
{
    /**
     * @var ModelsExportModel
     */
    protected PpciModel $dataclass;

    

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsExportModel();
        $this->keyName = "export_model_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function list()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->getListe("export_model_name"), "data");
        $this->vue->set("exportmodel/exportModelList.tpl", "corps");
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        $data = $this->dataclass->lire($this->id);
        $this->vue->set($data, "data");
        $this->vue->set(json_decode($data["pattern"], true), "pattern");
        $this->vue->set("exportmodel/exportModelDisplay.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "exportmodel/exportModelChange.tpl");
        return $this->vue->send();
    }
    function duplicate()
    {
        $this->vue = service('Smarty');
        $data = $this->dataclass->lire($this->id);
        $data["export_model_id"] = 0;
        $data["export_model_name"] .= " - copy";
        $this->vue->set($data, "data");
        $this->vue->set("exportmodel/exportModelChange.tpl", "corps");
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
        try {
            $this->dataDelete($this->id);
            return true;
        } catch (PpciException) {
            return false;
        }
    }
    function exportExec() {
        try {
            $model = array();
            if ($_REQUEST["export_model_id"] > 0) {
                $model = $this->dataclass->lire($_REQUEST["export_model_id"]);
            } else if (!empty($_REQUEST["export_model_name"])) {
                $model = $this->dataclass->getModelFromName($_REQUEST["export_model_name"]);
            }
            if ($model["export_model_id"] > 0) {
                $this->dataclass->initModel(json_decode($model["pattern"], true));
                //$this->dataclass->modeDebug = true;
                /**
                 * Generate the structure of the database
                 */
                $this->dataclass->generateStructure();
                $data = array();
                foreach ($this->dataclass->getListPrimaryTables() as $key => $table) {
                    if ($key == 0 && !empty($_REQUEST["keys"])) {
                        $keys = $_REQUEST["keys"];
                        /**
                         * set the list of records for the first item
                         */
                        $data[$table] = $this->dataclass->getTableContent($table, $keys);
                    } else {
                        $data[$table] = $this->dataclass->getTableContent($table);
                    }
                }
                if ($this->dataclass->modeDebug) {
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
            $this->message->set($e->getMessage(), true);
            $this->message->setSyslog($e->getMessage(),true);
            return $this->display();
        }
    }
    function importExec()
    {
        /**
         * Verify the project, if it's specified
         */
        if (($_REQUEST["export_model_id"] > 0 || !empty($_REQUEST["export_model_name"])) && $_FILES["filename"]["size"] > 0 ) {
            if ($_REQUEST["export_model_id"]) {
                $model = $this->dataclass->lire($_REQUEST["export_model_id"]);
            } else {
                $model = $this->dataclass->getModelFromName($_REQUEST["export_model_name"]);
            }
            $this->dataclass->initModel(json_decode($model["pattern"], true));
            /**
             * Generate the structure of the database
             */
            $this->dataclass->generateStructure();
            //$this->dataclass->modeDebug = true;
            $filename = $_FILES["filename"]["tmp_name"];
            $realFilename = $_FILES["filename"]["name"];
            $filename = str_replace("../", "", $filename);
            $handle = fopen($filename, 'r');
            if (!$handle) {
                $this->message->set(sprintf(_("Fichier %s non trouvé ou non lisible"), $filename), true);
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
                            $this->dataclass->importDataTable($tableName, $values, 0, array($_REQUEST["parentKeyName"] => $key));
                            $firstTable = false;
                        } else {
                            $this->dataclass->importDataTable($tableName, $values);
                        }
                    }
                    $db->transCommit();
                    $this->message->set(sprintf(_("Importation effectuée, fichier %s traité."), $realFilename));
                } catch (PpciException $e) {
                    if ($db->transEnabled) {
                        $db->transRollback();
                    }
                    $this->message->set($e->getMessage(), true);
                }
            }
        } else {
            $this->message->set(_("Paramètres d'importation manquants ou droits insuffisants"), true);
        }
    }
}
