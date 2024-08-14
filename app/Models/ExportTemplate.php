<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class ExportTemplate extends PpciModel
{
    /**
     * Constructor
     *
     * @param PDO $bdd: connection to the database
     * @param array $param: specific parameters
     */
    function __construct()
    {
        $this->table = "export_template";
        $this->fields = array(
            "export_template_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "export_template_name" => array("type" => 0, "requis" => 1),
            "export_template_description" => array("type" => 0),
            "export_template_version" => array("type" => 0),
            "is_zipped" => array("type" => 0),
            "filename" => array("type" => 0, "requis" => 1, "defaultValue" => "cs-export.csv")
        );
        parent::__construct();
    }

    /**
     * Overload of getListe to add the list of embedded datasets
     *
     * @param string $order
     * @return array
     */
    function getListe($order = ""): array
    {
        $data = parent::getListe($order);
        /**
         * Get the list of datasets
         */
        foreach ($data as $key => $row) {
            $datasets = $this->getListDatasets($row["export_template_id"]);
            $ds = "";
            $comma = "";
            $is_comma = false;
            foreach ($datasets as $dataset) {
                $ds .= $comma . $dataset["dataset_template_name"];
                if (!$is_comma) {
                    $comma = ", ";
                    $is_comma = true;
                }
            }
            $data[$key]["datasets"] = $ds;
        }
        return $data;
    }
    /**
     * Get the list of datasets attached to a template export
     *
     * @param [type] $id
     * @return array
     */
    function getListDatasets(int $id)
    {
        $sql = "select dataset_template_id, dataset_template_name
            from export_dataset
            join dataset_template using (dataset_template_id)
            where export_template_id = :id:
            order by dataset_template_name";
        return $this->getListeParamAsPrepared($sql, array("id" => $id));
    }

    /**
     * Overload of ecrire to write the datasets attached to the template
     *
     * @param array $data
     * @return int
     */
    function write($data): int
    {
        $id = parent::write($data);
        if ($id > 0) {
            $this->ecrireTableNN("export_dataset", "export_template_id", "dataset_template_id", $id, $data["dataset"]);
        }
        return $id;
    }
    /**
     * Get the key of a export_template from its name
     *
     * @param string $name
     * @return array
     */
    function getFromName(string $name): array
    {
        $sql = "select * from export_template
            where export_template_name = :name:";
        return $this->lireParamAsPrepared($sql, array("name" => $name));
    }
}
