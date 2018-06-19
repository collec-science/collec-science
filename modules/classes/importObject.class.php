<?php

/**
 * Created : 17 août 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
/**
 * Classes d'exception
 *
 * @author quinton
 *        
 */
class FichierException extends Exception
{
}

class HeaderException extends Exception
{
}

class ImportObjectException extends Exception
{
}

/**
 * Classe realisant l'import
 *
 * @author quinton
 *        
 */
class ImportObject
{

    private $separator = ",";

    private $utf8_encode = false;

    private $colonnes = array(
        "sample_identifier",
        "collection_id",
        "sample_type_id",
        "sample_status_id",
        "wgs84_x",
        "wgs84_y",
        "sampling_date",
        "expiration_date",
        "sample_multiple_value",
        "sample_metadata_json",
        "sample_parent_uid",
        "sampling_place_id",
        "container_identifier",
        "container_type_id",
        "container_status_id",
        "sample_location",
        "sample_column",
        "sample_line",
        "container_parent_uid",
        "container_location",
        "container_column",
        "container_line"
    );

    private $colnum = array(
        "sample_multiple_value",
        "sample_column",
        "sample_line",
        "container_column",
        "container_line",
        "container_parent_uid",
        "sample_parent_uid"
    );

    private $handle;

    private $fileColumn = array();

    public $nbTreated = 0;

    private $collection = array();

    private $sample_type = array();

    private $container_type = array();

    private $object_status = array();

    private $sampling_place = array();

    private $sample;

    private $container;

    private $movement;

    private $samplingPlace;

    private $identifierType;

    private $sampleType;

    private $objectIdentifier;

    private $initIdentifiers = false;

    private $identifiers = array();

    private $md_columns = array();

    public $minuid, $maxuid;

    /**
     * Initialise la lecture du fichier, et lit la ligne d'entete
     *
     * @param string $filename
     * @param string $separator
     * @param string $utf8_encode
     * @throws HeaderException
     * @throws FileException
     */
    function initFile($filename, $separator = ",", $utf8_encode = false)
    {
        if ($separator == "tab") {
            $separator = "\t";
        }
        $this->separator = $separator;
        $this->utf8_encode = $utf8_encode;
        /*
         * Ouverture du fichier
         */
        if ($this->handle = fopen($filename, 'r')) {
            $this->initIdentifiers();
            /*
             * Lecture de la premiere ligne et affectation des colonnes
             */
            $data = $this->readLine();
            $range = 0;
            for ($range = 0; $range < count($data); $range ++) {
                $value = $data[$range];
                /*
                 * identification of metadata columns
                 */
                if (substr($value, 0, 2) == "md_") {
                    $this->md_columns[] = $value;
                }
                /*
                 * Traitement du renommage de project_id en collection_id,
                 * de sample_date en sampling_date
                 * pour la compatibilité ascendante
                 */
                if ($value == "project_id") {
                    $value = "collection_id";
                }
                if ($value == "sample_date") {
                    $value = "sampling_date";
                }
                if (in_array($value, $this->colonnes) || substr($value, 0, 3) == "md_") {
                    $this->fileColumn[$range] = $value;
                } else {
                    throw new HeaderException("Header column $range is not recognized ($value)");
                }
            }
        } else {
            throw new FichierException("$filename not found or not readable");
        }
    }

    /**
     * Initialise les classes utilisees pour realiser les imports
     *
     * @param Sample $sample
     * @param Container $container
     * @param Movement $movement
     */
    function initClasses(Sample $sample, Container $container, Movement $movement, SamplingPlace $samplingPlace, IdentifierType $identifierType, Sampletype $sampleType)
    {
        $this->sample = $sample;
        $this->container = $container;
        $this->movement = $movement;
        $this->samplingPlace = $samplingPlace;
        $this->identifierType = $identifierType;
        $this->sampleType = $sampleType;
    }

    /**
     * Fonction d'initialisation d'une instance de classe
     * pour utilisation dans les scripts
     *
     * @param string $name
     *            : nom de l'instance
     * @param Object $instance
     *            : instance a stocker
     */
    function initClass($name, $instance)
    {
        $this->$name = $instance;
    }

    /**
     * Lit une ligne dans le fichier
     *
     * @return array|NULL
     */
    function readLine()
    {
        if ($this->handle) {
            $data = fgetcsv($this->handle, 1000, $this->separator);
            if ($data !== false) {
                if ($this->utf8_encode) {
                    foreach ($data as $key => $value) {
                        $data[$key] = utf8_encode($value);
                    }
                }
            }
            return $data;
        } else {
            return null;
        }
    }

    /**
     * Ferme le fichier
     */
    function fileClose()
    {
        if ($this->handle) {
            fclose($this->handle);
        }
    }

    /**
     * Lance l'import des lignes
     *
     * @param Sample $sample
     * @param Container $container
     * @param Movement $movement
     * @throws ImportObjectException
     */
    function importAll()
    {
        $date = date($_SESSION["MASKDATELONG"]);
        $num = 1;
        $maxuid = 0;
        $minuid = 99999999;
        $this->initIdentifiers();
        /*
         * Inhibition du traitement des dates par la classe
         */
        $this->sample->auto_date = 0;
        /*
         * Traitement du fichier
         */
        while (($data = $this->readLine()) !== false) {
            /*
             * Preparation du tableau
             */
            $values = $this->prepareLine($data);
            $num ++;
            /*
             * Controle de la ligne
             */
            $resControle = $this->controlLine($values);
            if (! $resControle["code"]) {
                throw new ImportObjectException("Line $num : " . $resControle["message"]);
            }
            /*
             * Mise a defaut des champs obligatoires non renseignes
             */
            foreach (array(
                "sample_line",
                "sample_column",
                "container_column",
                "container_line"
            ) as $field) {
                if (! strlen($values[$field]) > 0) {
                    $values[$field] = 1;
                }
            }
            /*
             * Traitement de l'echantillon
             */
            $sample_uid = 0;
            if (strlen($values["sample_identifier"]) > 0) {
                $dataSample = $values;
                $dataSample["sample_creation_date"] = $date;
                $dataSample["identifier"] = $values["sample_identifier"];
                $dataSample["object_status_id"] = $values["sample_status_id"];
                if (! $dataSample["object_status_id"] > 0) {
                    $dataSample["object_status_id"] = 1;
                }
                $dataSample["multiple_value"] = $values["sample_multiple_value"];
                $dataSample["sampling_place_id"] = $values["sampling_place_id"];
                $dataSample["parent_sample_id"] = $values["parent_sample_id"];
                /*
                 * Traitement des dates - mise au format de base de donnees avant importation
                 */
                $fieldDates = array(
                    "sampling_date",
                    "expiration_date"
                );
                foreach ($fieldDates as $fieldDate) {
                    if (strlen($values[$fieldDate]) > 0) {
                        $dataSample[$fieldDate] = $this->formatDate($values[$fieldDate]);
                    }
                }
                /*
                 * Preparation des metadonnees
                 */
                if (strlen($values["sample_metadata_json"]) > 0) {
                    $md_array = json_decode($values["sample_metadata_json"], true);
                } else {
                    $md_array = array();
                }
                foreach ($this->md_columns as $md_col) {
                    if (strlen($values[$md_col] > 0)) {
                        $colname = substr($md_col, 2);
                        $md_array[$colname] = $values[$md_col];
                    }
                }
                if (count($md_array) > 0) {
                    $dataSample["metadata"] = json_encode($md_array);
                }
                /*
                 * Debut d'ecriture en table
                 */
                try {
                    $sample_uid = $this->sample->ecrire($dataSample);
                    
                    /*
                     * Traitement des identifiants complementaires
                     */
                    foreach ($this->identifiers as $idcode => $typeid) {
                        if (strlen($values[$idcode]) > 0) {
                            $dataCode = array(
                                "object_identifier_id" => 0,
                                "uid" => $sample_uid,
                                "identifier_type_id" => $typeid,
                                "object_identifier_value" => $values[$idcode]
                            );
                            $this->objectIdentifier->ecrire($dataCode);
                        }
                    }
                    /*
                     * Mise a jour des bornes de l'uid
                     */
                    if ($sample_uid < $minuid) {
                        $minuid = $sample_uid;
                    }
                    if ($sample_uid > $maxuid) {
                        $maxuid = $sample_uid;
                    }
                } catch (PDOException $pe) {
                    throw new ImportObjectException("Line $num : error when import sample - " . $pe->getMessage());
                }
            }
            /*
             * Traitement du conteneur
             */
            $container_uid = 0;
            if (strlen($values["container_identifier"]) > 0) {
                $dataContainer = $values;
                $dataContainer["identifier"] = $values["container_identifier"];
                $dataContainer["object_status_id"] = $values["container_status_id"];
                if (! $dataContainer["object_status_id"] > 0) {
                    $dataContainer["object_status_id"] = 1;
                }
                try {
                    $container_uid = $this->container->ecrire($dataContainer);
                    /*
                     * Traitement des identifiants complementaires
                     */
                    foreach ($this->identifiers as $idcode => $typeid) {
                        if (strlen($values[$idcode]) > 0) {
                            $dataCode = array(
                                "object_identifier_id" => 0,
                                "uid" => $sample_uid,
                                "identifier_type_id" => $typeid
                            );
                            $this->objectIdentifier->ecrire($dataCode);
                        }
                    }
                    /*
                     * Mise a jour des bornes de l'uid
                     */
                    if ($container_uid < $minuid) {
                        $minuid = $container_uid;
                    }
                    if ($container_uid > $maxuid) {
                        $maxuid = $container_uid;
                    }
                } catch (PDOException $pe) {
                    throw new ImportObjectException("Line $num : error when import container - " . $pe->getMessage());
                }
                /*
                 * Traitement du rattachement du container
                 */
                if (strlen($values["container_parent_uid"]) > 0) {
                    try {
                        $this->movement->addMovement($container_uid, $date, 1, $values["container_parent_uid"], $_SESSION["login"], $values["container_location"], null, null, $values["container_column"], $values["container_line"]);
                    } catch (Exception $e) {
                        throw new ImportObjectException("Line $num : error when create input movement for container - " . $e->getMessage());
                    }
                }
            }
            /*
             * Traitement de l'entree de l'echantillon dans le container
             */
            if ($sample_uid > 0 && $container_uid > 0) {
                try {
                    $this->movement->addMovement($sample_uid, $date, 1, $container_uid, $_SESSION["login"], $values["sample_location"], null, null, $values["sample_column"], $values["sample_line"]);
                } catch (Exception $e) {
                    throw new ImportObjectException("Line $num : error when create input movement for sample (" . $e->getMessage() + ")");
                }
            }
            if ($values["container_parent_uid"] && $sample_uid > 0 && ! ($container_uid > 0)) {
                /*
                 * Creation du mouvement d'entree de l'echantillon dans le container
                 */
                try {
                    $this->movement->addMovement($sample_uid, $date, 1, $values["container_parent_uid"], $_SESSION["login"], $values["sample_location"], null, null, $values["sample_column"], $values["sample_line"]);
                } catch (Exception $e) {
                    throw new ImportObjectException("Line $num : error when create input movement for sample (" . $e->getMessage() + ")");
                }
            }
            $this->nbTreated ++;
        }
        $this->minuid = $minuid;
        $this->maxuid = $maxuid;
    }

    /**
     * Fonction reformatant la date en testant le format francais, puis standard
     *
     * @param string $date
     * @return string
     */
    function formatDate($date)
    {
        $val = "";
        /*
         * Verification du format de date
         */
        $result = date_parse_from_format($_SESSION["MASKDATE"], $date);
        if ($result["warning_count"] > 0) {
            /*
             * Test du format general
             */
            $result = date_parse($date);
        }
        if ($result["warning_count"] == 0) {
            $val = $result["year"] . "-" . str_pad($result["month"], 2, "0", STR_PAD_LEFT) . "-" . str_pad($result["day"], 2, "0", STR_PAD_LEFT);
            if (strlen($result["hour"]) > 0 && strlen($result["minute"]) > 0) {
                $val .= " " . str_pad($result["hour"], 2, "0", STR_PAD_LEFT) . ":" . str_pad($result["minute"], 2, "0", STR_PAD_LEFT);
                if (strlen($result["second"]) == 0) {
                    $result["second"] = 0;
                }
                $val .= ":" . str_pad($result["second"], 2, "0", STR_PAD_LEFT);
            }
        }
        return $val;
    }

    /**
     * Reecrit une ligne, en placant les bonnes valeurs en fonction de l'entete
     *
     * @param array $data
     * @return array[]
     */
    function prepareLine($data)
    {
        $nb = count($data);
        $values = array();
        for ($i = 0; $i < $nb; $i ++) {
            $values[$this->fileColumn[$i]] = $data[$i];
        }
        /*
         * Recherche de la valeur de l'id du sample_parent
         */
        if ($values["sample_parent_uid"] > 0) {
            $dp = $this->sample->lire($values["sample_parent_uid"]);
            $values["parent_sample_id"] = $dp["sample_id"];
        }
        return $values;
    }

    /**
     * Initialise les tableaux pour traiter les controles
     *
     * @param array $collection
     * @param array $sample_type
     * @param array $container_type
     * @param array $container_status
     */
    function initControl($collection, $sample_type, $container_type, $object_status, $sampling_place)
    {
        $this->collection = $collection;
        $this->sample_type = $sample_type;
        $this->container_type = $container_type;
        $this->object_status = $object_status;
        $this->sampling_place = $sampling_place;
    }

    /**
     * Declenche le controle pour toutes les lignes
     *
     * @return array[]["line"=>int, "message"=>string]
     */
    function controlAll()
    {
        $num = 1;
        $retour = array();
        $this->initIdentifiers();
        while (($data = $this->readLine()) !== false) {
            $values = $this->prepareLine($data);
            $num ++;
            $controle = $this->controlLine($values);
            if ($controle["code"] == false) {
                $retour[] = array(
                    "line" => $num,
                    "message" => $controle["message"]
                );
            }
        }
        return $retour;
    }

    /**
     * Controle une ligne
     *
     * @param array $data
     * @return array ["code"=>boolean,"message"=>string]
     */
    function controlLine($data)
    {
        $retour = array(
            "code" => true,
            "message" => ""
        );
        $emptyLine = true;
        /*
         * Traitement de l'echantillon
         */
        if (strlen($data["sample_identifier"]) > 0) {
            $emptyLine = false;
            /*
             * Verification de la collection
             */
            $ok = false;
            foreach ($this->collection as $value) {
                if ($data["collection_id"] == $value["collection_id"]) {
                    $ok = true;
                    break;
                }
            }
            if ($ok == false) {
                $retour["code"] = false;
                $retour["message"] .= _("Le numéro de la collection indiqué n'est pas reconnu ou autorisé.");
            }
            /*
             * Verification du type d'echantillon
             */
            $ok = false;
            foreach ($this->sample_type as $value) {
                if ($data["sample_type_id"] == $value["sample_type_id"]) {
                    $ok = true;
                    break;
                }
            }
            if ($ok == false) {
                $retour["code"] = false;
                $retour["message"] .= _("Le type d'échantillon n'est pas connu.");
            }
            
            /*
             * Verification du statut
             */
            $ok = false;
            if ($data["sample_status_id"] > 0) {
                foreach ($this->object_status as $value) {
                    if ($data["sample_status_id"] == $value["object_status_id"]) {
                        $ok = true;
                        break;
                    }
                }
                if ($ok == false) {
                    $retour["code"] = false;
                    $retour["message"] .= _("Le statut de l'échantillon n'est pas connu.");
                }
            }
            /*
             * Verification du lieu de collecte
             */
            $ok = false;
            if ($data["sampling_place_id"] > 0) {
                foreach ($this->sampling_place as $value) {
                    if ($data["sampling_place_id"] == $value["sampling_place_id"]) {
                        $ok = true;
                        break;
                    }
                }
                if ($ok == false) {
                    $retour["code"] = false;
                    $retour["message"] .= _("L'emplacement de collecte de l'échantillon n'est pas connu.");
                }
            }
            /*
             * Verification des dates
             */
            $fieldDates = array(
                "sampling_date",
                "expiration_date"
            );
            foreach ($fieldDates as $fieldDate) {
                if (strlen($data[$fieldDate]) > 0) {
                    /*
                     * Verification du format de date
                     */
                    $result = date_parse_from_format($_SESSION["MASKDATE"], $data[$fieldDate]);
                    if ($result["warning_count"] > 0) {
                        /*
                         * Test du format general
                         */
                        $result1 = date_parse($data[$fieldDate]);
                        if ($result1["warning_count"] > 0) {
                            $retour["code"] = false;
                            $retour["message"] .= sprintf(_("Le format de date de %s n'est pas reconnu."), $fieldDate);
                        }
                    }
                }
            }
            
            /*
             * Verification des metadonnees
             * Elles doivent correspondre a celles definies dans l'operation
             */
            if (strlen($data["sample_metadata_json"]) > 0) {
                $metadataSchema = json_decode($this->sampleType->getMetadataForm($data["sample_type_id"]), true);
                
                $metadataSchemaNames = array();
                $valuesMetadataJson = json_decode($data["sample_metadata_json"], true);
                /*
                 * Verification de la colonne metadata
                 */
                if (count($valuesMetadataJson) == 0) {
                    $retour["code"] = false;
                    $retour["message"] .= _("Les métadonnées ne sont pas correctement formatées (champ sample_metadata_json)");
                }
                $valuesMetadataJsonNames = array();
                foreach ($metadataSchema as $field) {
                    $metadataSchemaNames[] = $field["name"];
                }
                foreach ($valuesMetadataJson as $key => $field) {
                    if (! in_array($key, $metadataSchemaNames)) {
                        $retour["code"] = false;
                        $retour["message"] .= sprintf(_("Les métadonnées ne correspondent pas au type d'échantillon (%s inconnu). "), $key);
                    }
                }
            }
            /*
             * Verification de l'echantillon parent
             */
            if ($data["sample_parent_uid"] > 0) {
                if (! $data["parent_sample_id"] > 0) {
                    $retour["code"] = false;
                    $retour["message"] .= sprintf(_("L'échantillon parent défini n'existe pas (%s)"), $data["sample_parent_uid"]);
                }
            }
        }
        /*
         * Traitement du container
         */
        if (strlen($data["container_identifier"]) > 0) {
            $emptyLine = false;
            /*
             * Verification du type de container
             */
            $ok = false;
            foreach ($this->container_type as $value) {
                if ($data["container_type_id"] == $value["container_type_id"]) {
                    $ok = true;
                    break;
                }
            }
            if ($ok == false) {
                $retour["code"] = false;
                $retour["message"] .= _("Le type de contenant n'est pas connu.");
            }
            /*
             * Verification du statut du container
             */
            if (strlen($data["container_status_id"]) > 0) {
                $ok = false;
                foreach ($this->object_status as $value) {
                    if ($data["container_status_id"] == $value["object_status_id"]) {
                        $ok = true;
                        break;
                    }
                }
                if ($ok == false) {
                    $retour["code"] = false;
                    $retour["message"] .= _("Le statut du contenant n'est pas connu.");
                }
            }
        }
        /*
         * Verification de l'uid du container parent
         */
        if (strlen($data["container_parent_uid"]) > 0) {
            $container_id = $this->container->getIdFromUid($data["container_parent_uid"]);
            if (! $container_id > 0) {
                $retour["code"] = false;
                $retour["message"] .= sprintf(_("L'UID du contenant parent (%s) n'existe pas. "), $data["container_parent_uid"]);
            }
        }
        
        /*
         * Verification des champs numeriques
         */
        foreach ($this->colnum as $key) {
            if (strlen($data[$key]) > 0) {
                if (! is_numeric($data[$key])) {
                    $retour["code"] = false;
                    $retour["message"] .= sprintf(_("Le champ %s n'est pas numérique."), $key);
                }
            }
        }
        /*
         * Traitement de la ligne vierge
         */
        if ($emptyLine) {
            $retour["code"] = false;
            $retour["message"] .= _("Aucun échantillon ou contenant n'est décrit (pas d'identifiant pour l'un ou pour l'autre).");
        }
        return $retour;
    }

    /**
     * Initialise la liste des identifiants secondaires possibles
     */
    function initIdentifiers()
    {
        if (! $this->initIdentifiers) {
            
            $dit = $this->identifierType->getListe();
            /*
             * Rajout des codes dans les colonnes autorisees
             */
            foreach ($dit as $value) {
                $this->colonnes[] = $value["identifier_type_code"];
                $this->identifiers[$value["identifier_type_code"]] = $value["identifier_type_id"];
            }
            $this->initIdentifiers = true;
        }
    }

    /**
     * Execution de l'importation d'echantillons provenant d'une base externe
     *
     * @param array $data
     *            : tableau contenant les donnees a importer
     * @param SampleInitClass $sic
     *            : liste des valeurs des tables de reference
     * @param array $post
     *            : tableau des valeurs fournies par le formulaire
     */
    function importExterneExec($data, SampleInitClass $sic, $post)
    {
        $simpleFields = array(
            "identifier",
            "wgs84_x",
            "wgs84_y",
            "multiple_value",
            "dbuid_origin",
            "metadata",
            "dbuid_parent"
        );
        $refFields = array(
            "sampling_place_name",
            "collection_name",
            "object_status_name",
            "sample_type_name"
        );
        $this->sample->auto_date = 0;
        $dclass = $sic->init(true);
        $this->maxuid = 0;
        $this->minuid = 99999999;
        foreach ($data as $row) {
            /*
             * Preparation de l'echantillon a importer dans la base
             */
            $dataSample = array();
            /*
             * Champs simples, sans transcodage
             */
            foreach ($simpleFields as $field) {
                if (strlen($row[$field]) > 0) {
                    if ($field == "metadata") {
                        /*
                         * Ajout d'un decodage/encodage pour les champs json, pour
                         * eviter les problemes potentiels et verifier la structure
                         */
                        $dataSample[$field] = json_encode(json_decode($row[$field]));
                    } else {
                        $dataSample[$field] = $row[$field];
                    }
                }
            }
            $fieldDates = array(
                "sampling_date",
                "expiration_date",
                "sample_creation_date"
            );
            foreach ($fieldDates as $fieldDate) {
                if (strlen($row[$fieldDate]) > 0) {
                    $dataSample[$fieldDate] = $this->formatDate($row[$fieldDate]);
                }
            }
            /*
             * Champs transcodes
             */
            foreach ($refFields as $field) {
                if (strlen($row[$field]) > 0) {
                    /*
                     * Recheche de la valeur a appliquer dans les donnees post
                     */
                    $value = $row[$field];
                    /*
                     * Transformation des espaces en underscore,
                     * pour tenir compte du transcodage opere par le navigateur
                     */
                    $fieldHtml = str_replace(" ", "_", $value);
                    $newval = $post[$field . "-" . $fieldHtml];
                    /*
                     * Recherche de la cle correspondante
                     */
                    $id = $dclass[$field][$newval];
                    if ($id > 0) {
                        $key = $sic->classes[$field]["id"];
                        $dataSample[$key] = $id;
                    }
                }
            }
            /*
             * Recherche des metadonnees
             */
            if (strlen($row["metadata"]) > 0) {
                $metadata = json_decode($row["metadata"], true);
            } else {
                $metadata = array();
            }
            foreach ($row as $fieldname => $fieldvalue) {
                if (substr($fieldname, 0, 3) == "md_") {
                    if (strlen($fieldvalue) > 0) {
                        $metadata[substr($fieldname, 3)] = $fieldvalue;
                    }
                }
            }
            if (count($metadata) > 0) {
                $dataSample["metadata"] = json_encode($metadata);
            }
            
            /*
             * Declenchement de l'ecriture en base
             */
            try {
                $uid = $this->sample->ecrireImport($dataSample);
                if ($uid > 0) {
                    if ($uid < $this->minuid) {
                        $this->minuid = $uid;
                    }
                    $this->maxuid = $uid;
                    $this->nbTreated ++;
                    /*
                     * Traitement des identifiants complementaires
                     */
                    if (strlen($row["identifiers"]) > 0) {
                        $idents = explode(",", $row["identifiers"]);
                        foreach ($idents as $ident) {
                            $idvalue = explode(":", $ident);
                            $dataIdent = array();
                            $dataIdent["uid"] = $uid;
                            /*
                             * Recherche de la valeur a appliquer dans les donnees post
                             */
                            $value = $row[$field];
                            $newval = $_POST["identifier_type_code-" . $idvalue[0]];
                            $dataIdent["identifier_type_id"] = $dclass["identifier_type_code"][$newval];
                            $dataIdent["object_identifier_value"] = $idvalue[1];
                            $this->objectIdentifier->writeOrReplace($dataIdent);
                        }
                    }
                } else {
                    throw new ImportObjectException("Problem when importing - line " . $this->nbTreated + 1);
                }
            } catch (Exception $e) {
                throw new ImportObjectException($e->getMessage());
            }
        }
    }
}
?>