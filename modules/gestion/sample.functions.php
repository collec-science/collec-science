<?php

/**
 * Created : 30 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
function sampleInitDatEntry()
{
    global $vue, $bdd, $ObjetBDDParam;
    /*
     * Recherche des projets
     */
    $vue->set($_SESSION["projects"], "projects");
    /*
     * Recherche des types d'échantillons
     */
    require_once 'modules/classes/sampleType.class.php';
    $sampleType = new SampleType($bdd, $ObjetBDDParam);
    $vue->set($sampleType->getListe(2), "sample_type");
    require_once 'modules/classes/objectStatus.class.php';
    $objectStatus = new ObjectStatus($bdd, $ObjetBDDParam);
    $vue->set($objectStatus->getListe(1), "objectStatus");
    require_once 'modules/classes/samplingPlace.class.php';
    $samplingPlace = new SamplingPlace($bdd, $ObjetBDDParam);
    $vue->set($samplingPlace->getListe(1), "samplingPlace");
}

/**
 * Fonction d'initialisation globale des tables de reference
 * utilisee pour les imports externes
 * return array
 */
class SampleInitClass
{

    public $classes = array(
        "sampling_place_name" => array(
            "filename" => "samplingPlace.class.php",
            "classname" => "SamplingPlace",
            "field" => "sampling_place_name",
            "id" => "sampling_place_id"
        ),
        "object_status_name" => array(
            "filename" => "objectStatus.class.php",
            "classname" => "ObjectStatus",
            "field" => "object_status_name",
            "id" => "object_status_id"
        ),
        "project_name" => array(
            "filename" => "project.class.php",
            "classname" => "Project",
            "field" => "project_name",
            "id" => "project_id"
        ),
        "sample_type_name" => array(
            "filename" => "sampleType.class.php",
            "classname" => "SampleType",
            "field" => "sample_type_name",
            "id" => "sample_type_id"
        ),
        "identifier_type_code" => array(
            "filename" => "identifierType.class.php",
            "classname" => "IdentifierType",
            "field" => "identifier_type_code",
            "id" => "identifier_type_id"
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
        global $bdd, $ObjetBDDParam;
        /*
         * Recuperation de tous les libelles connus dans la base de donnees
         */
        
        $dclasse = array();
        foreach ($this->classes as $classe) {
            require_once 'modules/classes/' . $classe["filename"];
            $instance = new $classe["classname"]($bdd, $ObjetBDDParam);
            switch ($classe["field"]) {
                case "identifier_type_code":
                    $data = $instance->getListeWithCode();
                    break;
                case "project_name":
                    $data = $_SESSION["projects"];
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
?>