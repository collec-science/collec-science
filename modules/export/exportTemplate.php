<?php
include_once 'modules/classes/export/exportTemplate.class.php';
$dataClass = new ExportTemplate($bdd, $ObjetBDDParam);
$keyName = "export_template_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        /*
         * Display the list of all records of the table
         */
        $vue->set($dataClass->getListe(2), "data");
        $vue->set("export/exportTemplateList.tpl", "corps");
        break;
    case "display":
        /*
         * Display the detail of the record
         */
        $vue->set($dataClass->lire($id), "data");
        $vue->set("export/exportTemplateDisplay.tpl", "corps");
        break;
    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record 
         */
        dataRead($dataClass, $id, "export/exportTemplateChange.tpl");
        include_once "modules/classes/export/datasetTemplate.class.php";
        $dt = new DatasetTemplate($bdd, $ObjetBDDParam);
        $vue->set($dt->getListFromExportTemplate($id), "datasets");
        break;
    case "write":
        /*
         * write record in database
         */
        $id = dataWrite($dataClass, $_REQUEST);
        if ($id > 0) {
            $_REQUEST[$keyName] = $id;
        }
        break;
    case "delete":
        /*
         * delete record
         */
        dataDelete($dataClass, $id);
        break;
    case "import":
        require_once "modules/classes/export/export.class.php";
        require_once "modules/classes/export/datasetTemplate.class.php";
        require_once "modules/classes/export/datasetColumn.class.php";
        require_once "modules/classes/export/translator.class.php";
        $datasetTemplate = new DatasetTemplate($bdd, $ObjetBDDParam);
        $datasetColumn = new DatasetColumn($bdd, $ObjetBDDParam);
        $translator = new Translator($bdd, $ObjetBDDParam);
        $insertExportDataset = "insert into export_dataset (export_template_id, dataset_template_id) 
                                values (:export_template_id, :dataset_template_id)";
        $bdd->beginTransaction();
        try {
            if (file_exists($_FILES['upfile']['tmp_name'])) {
                $json = file_get_contents($_FILES["upfile"]["tmp_name"]);
                $data = json_decode($json, true);
                foreach ($data["export_template"] as $et) {
                    /**
                     * Search for existent template
                     */
                    $existent = $dataClass->getFromName($et["export_template_name"]);
                    if ($existent["export_template_id"] > 0) {
                        if ($existent["export_template_name"] == $et["export_template_name"]."_copy") {
                            throw new ExportException(_("Le modèle a déjà été importé. Supprimez-le avant de relancer l'importation"));
                        } else {
                            $et["export_template_name"] .= "_copy";
                        }
                    }
                    $et["export_template_id"] = 0;
                    if ($et["export_template_id"] > 0) {

                    }
                    $et["export_template_id"] = $dataClass->ecrire($et);
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
                        if ($existent["dataset_template_name"] == $dt["dataset_template_name"]."_copy") {
                            throw new ExportException(_("Le modèle de dataset a déjà été importé. Supprimez-le avant de relancer l'importation"));
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
                        $dataClass->executeAsPrepared($insertExportDataset, $dtnew, true);
                    }
                }
            } else {
                throw new ExportException(_("Le fichier contenant le modèle à importer n'a pas été téléchargé"));
            }

            $module_coderetour = 1;
            $bdd->commit();
            $message->set(_("Importation du modèle effectuée"));
        } catch (Exception $e) {
            $message->set($e->getMessage(), true);
            $module_coderetour = -1;
            $bdd->rollBack();
        }
}
