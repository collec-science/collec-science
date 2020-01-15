<?php
include_once "modules/exportmodel/exportmodel.class.php";
$exportModel = new ExportModel($bdd, $ObjetBDDParam);
$export = new ExportModelProcessing($bdd);
$export->modeDebug = false;
switch ($t_module["param"]) {
    case "exec":
        try {
            $model = array();
            if ($_REQUEST["export_model_id"] > 0) {
                $model = $exportModel->lire($_REQUEST["export_model_id"]);
            } else if (strlen($_REQUEST["export_model_name"]) > 0) {
                $model = $exportModel->getModelFromName($_REQUEST["export_model_name"]);
            }
            if ($model["export_model_id"] > 0) {
                $export->initModel($model["pattern"]);
                $data = array();
                foreach ($export->getListPrimaryTables() as $key => $table) {
                    if ($key == 0 && count($_REQUEST["keys"]) > 0) {
                            $keys = $_REQUEST["keys"];
                        /**
                         * set the list of records for the first item
                         */
                        $data[$table] = $export->getTableContent($table, $keys);
                    } else {
                        $data[$table] = $export->getTableContent($table);
                    }
                }
                if ($export->modeDebug) {
                    throw new ExportException("Debug mode: no file generated");
                }
                $vue->setParam(array("filename" => $_SESSION["APPLI_code"] . '-' . date('YmdHis') . ".json"));
                $vue->set(json_encode($data));
            } else {
                throw new ExportException(_("Le modèle d'export n'est pas défini ou n'a pas été trouvé"));
            }
        } catch (ExportException $e) {
            if (isset($_REQUEST["returnko"])) {
                $t_module["retourko"] = $_REQUEST["returnko"];
            }
            $module_coderetour = -1;
            $message->set($e->getMessage(), true);
            $message->setSyslog($e->getMessage());
        }
        break;

    case "importExec":
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
        if (isset($_REQUEST["project_id"])) {
            if (!verifyProject($_REQUEST["project_id"])) {
                $testProject = false;
            }
        }
        if (($_REQUEST["export_model_id"] > 0 || strlen($_REQUEST["export_model_name"]) > 0) && $_FILES["filename"]["size"] > 0 && $testProject) {
            if ($_REQUEST["export_model_id"]) {
                $model = $exportModel->lire($_REQUEST["export_model_id"]);
            } else {
                $model = $exportModel->getModelFromName($_REQUEST["export_model_name"]);
            }
            $export->initModel($model["pattern"]);
            $filename = $_FILES["filename"]["tmp_name"];
            $realFilename = $_FILES["filename"]["name"];
            $filename = str_replace("../", "", $filename);
            $handle = fopen($filename, 'r');
            if (!$handle) {
                $message->set(sprintf(_("Fichier %s non trouvé ou non lisible"), $filename), true);
                $module_coderetour = -1;
            } else {
                $contents = fread($handle, filesize($filename));
                fclose($handle);
                $data = json_decode($contents, true);
                try {
                    $bdd->beginTransaction();
                    $firstTable = true;
                    foreach ($data as $tableName => $values) {
                        if ($firstTable && strlen($_REQUEST["parentKeyName"]) > 0) {
                            $key = $_REQUEST["parentKey"];
                            $export->importDataTable($tableName, $values, 0, array($_REQUEST["parentKeyName"] => $key));
                            $firstTable = false;
                        } else {
                            $export->importDataTable($tableName, $values);
                        }
                    }
                    $bdd->commit();
                    $message->set(sprintf(_("Importation effectuée, fichier %s traité."), $realFilename));
                    $module_coderetour = 1;
                } catch (ExportException $e) {
                    $bdd->rollback();
                    $message->set($e->getMessage(), true);
                    $module_coderetour = -1;
                }
            }
        } else {
            $module_coderetour = -1;
            $message->set(_("Paramètres d'importation manquants ou droits insuffisants"), true);
        }
        break;
}
