<?php

namespace App\Models;

class SampleInitClass
{

    public $classes = array(
        "sampling_place_name" => array(
            "classname" => "App\Models\SamplingPlace",
            "field" => "sampling_place_name",
            "id" => "sampling_place_id"
        ),
        "object_status_name" => array(
            "classname" => "App\Models\ObjectStatus",
            "field" => "object_status_name",
            "id" => "object_status_id"
        ),
        "collection_name" => array(
            "classname" => "App\Models\Collection",
            "field" => "collection_name",
            "id" => "collection_id"
        ),
        "sample_type_name" => array(
            "classname" => "App\Models\SampleType",
            "field" => "sample_type_name",
            "id" => "sample_type_id"
        ),
        "identifier_type_code" => array(
            "classname" => "App\Models\IdentifierType",
            "field" => "identifier_type_code",
            "id" => "identifier_type_id"
        ),
        "referent_name" => array(
            "classname" => "App\Models\Referent",
            "field" => "referent_name",
            "id" => "referent_id"
        ),
        "container_type_name" => array(
            "classname" => "App\Models\ContainerType",
            "field" => "container_type_name",
            "id" => "container_type_id"
        ),
        "campaign_name" => array(
            "classname" => "App\Models\Campaign",
            "field" => "campaign_name",
            "id" => "campaign_id"
        ),
        "country_code" => array(
            "classname" => "App\Models\Country",
            "field" => "country_code2",
            "id" => "country_id"
        )
    );

    /**
     * Si $reverse vaut true, retourne, pour chaque classe, un tableau dont la cle
     * est le libelle et la valeur l'identifiant associe
     *
     * @param boolean $reverse
     * @return array[]
     */
    function init($reverse = false)
    {
        /*
         * Recuperation de tous les libelles connus dans la base de donnees
         */
        $dclasse = array();
        foreach ($this->classes as $classe) {
            $instance = new $classe["classname"];
            switch ($classe["field"]) {
                case  "identifier_type_code":
                    $data = $instance->getListeWithCode();
                    break;
                case "collection_name":
                    $data = $_SESSION["collections"];
                    break;
                case "referent_name":
                    $data = $instance->getListName();
                    break;
                default:
                    $data = $instance->getListe(2);
            }

            if ($reverse) {
                $donnees = array();
                foreach ($data as $value) {
                    $donnees[$value[$classe["field"]]] = $value[$classe["id"]];
                }
            } else {
                $donnees = $data;
            }
            $dclasse[$classe["field"]] = $donnees;
            unset($instance);
        }
        return $dclasse;
    }
}
