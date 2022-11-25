<?php

/**
 * Storage of the translations of the tables of parameters
 */
class Translation extends ObjetBDD
{

    public array $tableList = array(
        "object_status",
        "event_type",
        "container_type",
        "container_family",
        "sample_type",
        "movement_type",
        "multiple_type",
        "movement_reason",
        "storage_condition"
    );
/**
 * Constructor
 *
 * @param PDO $db
 * @param array $param
 */
    function __construct(PDO $db, array $param = array())
    {
        $this->table = "translation";
        $this->colonnes = array(
            "translation_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "country_code" => array(
                "type" => 0,
                "requis" => 1
            ),
            "initial_label" => array(
                "type" => 0,
                "requis" => 1
            ),
            "country_label" => array(
                "type" => 0
            )
        );
        parent::__construct($db, $param);
    }

/**
 * Get the list of labels to translate, with or without translations
 *
 * @param string $country
 * @return array
 */
    function getListeFromCountry(string $country):array
    {
        /**
         * Generate the request to get all labels to translate
         */
        $nbTables = count($this->tableList);
        $sql = "with req as (";
        for ($i = 0; $i < $nbTables; $i++) {
            if ($i > 0) {
                $sql .= " UNION ";
            }
            $sql .= "SELECT '" . $this->tableList[$i] . "' as tablename, " . $this->tableList[$i] . "_name as initial_label 
            FROM " . $this->tableList[$i];
        }
        $sql .= ")";
        $sql .= " SELECT tablename, req.initial_label, coalesce(translation_id, 0) as translation_id, country_label
                FROM req
                LEFT OUTER JOIN translation t on (req.initial_label = t.initial_label and country_code = :country_code)";
        return $this->getListeParamAsPrepared($sql, array("country_code" => $country));
    }
/**
 * Write all translations for a country code
 *
 * @param array $source
 * @return void
 */
    function writeAll(array $source)  {
        $country_code = $source["country"];
        if (empty($country_code)) {
            throw new ObjetBDDException(_("Le code du pays n'a pas été renseigné"));
        }
        $data = array();
        foreach ($source as $k => $v) {
            if (substr($k,0,2) == "id") {
                $ka = explode("-",$k);
                $row = array(
                    "country_code"=>$country_code,
                    "translation_id"=>$v,
                    "initial_label"=>$source["row-".$ka[1]."-initial_label"],
                    "country_label"=>$source["row-".$ka[1]."-country_label"]
                );
                $data[] = $row;
            }
        }
        foreach ($data as $row) {
            if ($row["translation_id"]>0 || !empty($row["country_label"])) {
                if (! $this->ecrire($row) > 0) {
                    throw new ObjetBDDException(_("Une erreur a été rencontrée lors de l'enregistrement en base de données"));
                }
            }
        }
    }
}
