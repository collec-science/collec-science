<?php

/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
//require_once 'modules/classes/object.class.php';

class Container extends ObjetBDD
{

    private $sql = "select c.container_id, o.uid, o.identifier, o.wgs84_x, o.wgs84_y, 
					container_type_id, container_type_name,
					container_family_id, container_family_name, os.object_status_id, object_status_name,
					storage_product, clp_classification, storage_condition_name,
					document_id, identifiers,
					movement_date, movement_type_name, movement_type_id,
                    lines, columns, first_line,
                    column_number, line_number, container_uid, oc.identifier as container_identifier,
                    o.referent_id, referent_name
					from container c
					join object o using (uid)
					join container_type using (container_type_id)
					join container_family using (container_family_id)
					left outer join object_status os on (o.object_status_id = os.object_status_id)
					left outer join storage_condition using (storage_condition_id)
					left outer join last_photo using (uid)
					left outer join v_object_identifier using (uid)
					left outer join last_movement using (uid)
                    left outer join object oc on (container_uid = oc.uid)
                    left outer join movement_type using (movement_type_id)
                    left outer join referent r on (o.referent_id = r.referent_id)
            ";
    private $uidMin = 999999999, $uidMax = 0, $numberUid = 0;

    /**
     *
     * @param PDO   : $bdd
     * @param array : $param
     */
    function __construct($bdd, $param = null)
    {
        $this->table = "container";
        $this->colonnes = array(
            "container_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "uid" => array(
                "type" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "container_type_id" => array(
                "type" => 1,
                "requis" => 1
            )
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Surcharge de lire pour ramener les informations
     * generales (table object, notamment)
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::lire()
     */
    function lire($uid, $getDefault = false, $parentValue = "")
    {
        $sql = $this->sql . " where o.uid = :uid";
        $data["uid"] = $uid;
        if (is_numeric($uid) && $uid > 0) {
            $retour = parent::lireParamAsPrepared($sql, $data);
        } else {
            $retour = parent::getDefaultValue($parentValue);
        }
        return $retour;
    }

    /**
     * Surcharge de la fonction ecrire pour
     * enregistrer les informations dans object
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::ecrire()
     */
    function ecrire($data)
    {
        $object = new ObjectClass($this->connection, $this->param);
        $uid = $object->ecrire($data);
        if ($uid > 0) {
            $data["uid"] = $uid;
            parent::ecrire($data);
            return $uid;
        }
    }

    /**
     * Surcharge de supprimer pour effacer les donnees liees
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::supprimer()
     */
    function supprimer($uid)
    {
        $data = $this->lire($uid);
        /*
         * suppression de l'echantillon
         */
        parent::supprimer($data["container_id"]);
        /*
         * Suppression de l'objet
         */
        $object = new ObjectClass($this->connection, $this->paramori);
        $object->supprimer($uid);
    }

    /**
     * Retourne tous les échantillons contenus
     * dans le contenant
     *
     * @param int : $uid
     * @return array
     */
    function getContentSample($uid)
    {
        if ($uid > 0 && is_numeric($uid)) {
            $sql = "select o.uid, o.identifier, sa.*,
					movement_date, movement_type_id, identifiers,
					collection_name, sample_type_name, object_status_name,
					sampling_place_name,
					pso.uid as parent_uid, pso.identifier as parent_identifier,
                    column_number, line_number,
                    case when ro.referent_name is not null then ro.referent_name else cr.referent_name end as referent_name
					from object o
					join sample sa on (sa.uid = o.uid)
					join last_movement lm on (lm.uid = o.uid and lm.container_uid = :uid)
					join collection c using (collection_id)
					join sample_type using (sample_type_id)
					left outer join v_object_identifier voi on (o.uid = voi.uid) 
					left outer join object_status using (object_status_id)
					left outer join sampling_place using (sampling_place_id)
					left outer join sample ps on (sa.parent_sample_id = ps.sample_id)
					left outer join object pso on (ps.uid = pso.uid)
                    left outer join referent ro on (o.referent_id = ro.referent_id)
                    left outer join referent cr on (c.referent_id = cr.referent_id)
					where lm.movement_type_id = 1
					order by o.identifier, o.uid
					";
            $data["uid"] = $uid;
            $this->colonnes["sample_creation_date"] = array(
                "type" => 2
            );
            $this->colonnes["sampling_date"] = array(
                "type" => 2
            );
            $this->colonnes["movement_date"] = array(
                "type" => 3
            );
            return $this->getListeParamAsPrepared($sql, $data);
        }
    }

    /**
     * Retourne tous les contenants contenus
     *
     * @param int $uid
     * @return array
     */
    function getContentContainer($uid)
    {
        if ($uid > 0 && is_numeric($uid)) {
            $sql = "select o.uid, o.identifier, container_type_id, container_type_name,
					container_family_id, container_family_name, o.object_status_id,
					storage_product, storage_condition_name, 
					object_status_name, clp_classification,
					movement_date, movement_type_id, column_number, line_number,
                    document_id
					from object o
					join container co on (co.uid = o.uid)
					join container_type using (container_type_id)
					join container_family using (container_family_id)
					join last_movement lm on (lm.uid = o.uid and lm.container_uid = :uid)
					left outer join object_status os on (o.object_status_id = os.object_status_id)
					left outer join storage_condition using (storage_condition_id)
                    left outer join  last_photo on (o.uid = last_photo.uid)
					where lm.movement_type_id = 1
					order by o.identifier, o.uid
					";
            $data["uid"] = $uid;
            /*
             * Rajout de la date de dernier mouvement pour l'affichage
             */
            $this->colonnes["movement_date"] = array(
                "type" => 3
            );
            return $this->getListeParamAsPrepared($sql, $data);
        }
    }

    /**
     * Retourne le contenant parent
     *
     * @param int $uid
     * @return array
     */
    function getParent($uid)
    {
        if ($uid > 0 && is_numeric($uid)) {
            $sql = "select co.container_id, o.uid, o.identifier, container_type_id, container_type_name
					from object o
					join container co on (co.uid = o.uid)
					join container_type using (container_type_id)
					join last_movement lm on (lm.uid = :uid and lm.container_uid = o.uid) 
					where lm.movement_type_id = 1
					order by o.identifier, o.uid
					";
            $data["uid"] = $uid;
            return $this->lireParamAsPrepared($sql, $data);
        }
    }

    /**
     * Retourne tous les contenants parents d'un objet
     *
     * @param int $uid
     * @return array
     */
    function getAllParents($uid)
    {
        $data = array();
        if ($uid > 0 && is_numeric($uid)) {
            $continue = true;
            while ($continue) {
                $parent = $this->getParent($uid);
                if ($parent["uid"] > 0) {
                    $data[] = $parent;
                    $uid = $parent["uid"];
                } else {
                    $continue = false;
                }
            }
        }
        return $data;
    }

    /**
     * Retourne le numero d'un contenant a partir de son uid
     *
     * @param int $uid
     * @return int;
     */
    function getIdFromUid($uid)
    {
        if (is_numeric($uid) && $uid > 0) {
            $sql = "select container_id from container where uid = :uid";
            $data["uid"] = $uid;
            $row = $this->lireParamAsPrepared($sql, $data);
            return $row["container_id"];
        } else {
            return -1;
        }
    }

    /**
     * Recherche les contenants a partir du tableau de parametres fourni
     *
     * @param array $param
     */
    function containerSearch($param)
    {
        $data = array();
        $where = "where";
        $and = "";
        if ($param["container_type_id"] > 0) {
            $where .= " container_type_id = :container_type_id";
            $data["container_type_id"] = $param["container_type_id"];
            $and = " and ";
        } elseif ($param["container_family_id"] > 0) {
            $where .= " container_family_id = :container_family_id";
            $data["container_family_id"] = $param["container_family_id"];
            $and = " and ";
        }
        if (strlen($param["name"]) > 0) {
            $where .= $and . "( ";
            $or = "";
            if (is_numeric($param["name"])) {
                $where .= " o.uid = :uid";
                $data["uid"] = $param["name"];
                $or = " or ";
            }
            $identifier = "%" . strtoupper($this->encodeData($param["name"])) . "%";
            $where .= "$or upper(o.identifier) like :identifier ";
            $and = " and ";
            $data["identifier"] = $identifier;
            /*
             * Recherche sur les identifiants externes
             * possibilite de recherche sur cab:valeur, p. e.
             */
            $where .= " or upper(identifiers) like :identifier ";
            $where .= ")";
        }
        if ($param["object_status_id"] > 0) {
            $where .= $and . " os.object_status_id = :object_status_id";
            $and = " and ";
            $data["object_status_id"] = $param["object_status_id"];
        }

        if ($param["uid_max"] > 0 && $param["uid_max"] >= $param["uid_min"]) {
            $where .= $and . " o.uid between :uid_min and :uid_max";
            $and = " and ";
            $data["uid_min"] = $param["uid_min"];
            $data["uid_max"] = $param["uid_max"];
        }
        if ($and == "") {
            $where = "";
        }

        /*
         * Rajout de la date de dernier mouvement pour l'affichage
         */
        $this->colonnes["movement_date"] = array(
            "type" => 3
        );
        return $this->getListeParamAsPrepared($this->sql . $where /*. $order*/, $data);
    }

    /**
     * Retourne la liste des contenants correspondant au type
     *
     * @param int $container_type_id
     * @return array
     */
    function getFromType($container_type_id)
    {
        if (is_numeric($container_type_id) && $container_type_id > 0) {
            $data["container_type_id"] = $container_type_id;
            $where = " where container_type_id = :container_type_id";
            $order = " order by uid desc";
            return $this->getListeParamAsPrepared($this->sql . $where . $order, $data);
        }
    }

    /**
     * Genere un tableau permettant d'afficher les objets contenus dans un container
     * a leur emplacement, dans le cas ou le nb de cellules est > 1
     * @param array $dcontainer
     * @param array $dsample
     * @param number $columns
     * @param number $lines
     * @param string $first_line
     * @return array|string|string[]|array[]
     */
    function generateOccupationArray($dcontainer, $dsample, $columns = 1, $lines = 1, $first_line = "T")
    {
        $data = array();
        /*
         * Generation d'un tableau vide
         */
        for ($line = 0; $line < $lines; $line++) {
            for ($column = 0; $column < $columns; $column++) {
                $data[$line][$column] = "";
            }
        }
        /*
         * Traitement de chaque tableau pour integrer les informations
         */
        foreach ($dcontainer as $value) {
            if ($value["line_number"] > 0 && $value["column_number"] > 0) {
                $data[$value["line_number"] - 1][$value["column_number"] - 1] = array("type" => "C", "uid" => $value["uid"], "identifier" => $value["identifier"]);
            }
        }
        foreach ($dsample as $value) {
            if ($value["line_number"] > 0 && $value["column_number"] > 0) {
                $data[$value["line_number"] - 1][$value["column_number"] - 1] = array("type" => "S", "uid" => $value["uid"], "identifier" => $value["identifier"]);
            }
        }
        /*
         * Tri du tableau
         */
        if ($lines > 1 && $first_line == "B") {
            krsort($data);
        }
        return $data;
    }
    /**
     * Generate an array with all contents of all containers included
     *
     * @param array $uids
     * @return array
     */
    function generateExportGlobal($uids)
    {
        global $APPLI_version;
        $data = array();
        /** 
         * Inhibit the date encoding
         */
        $this->auto_date = 0;
        /**
         * Add reference of the export
         */
        $data["collec-science_version"] = $APPLI_version;
        $data["export_version"] = 1.0;
        if (!is_array($uids)) {
            $uids = array($uids);
        }
        foreach ($uids as $uid) {
            $data[] = $this->getContainerWithObjects($uid);
        }
        return $data;
    }
    /**
     * Get a container with all objects included
     *
     * @param int $uid
     * @return array
     */
    function getContainerWithObjects($uid)
    {
        $row = $this->lire($uid);
        /**
         * Get all samples in the container
         */
        $dataSamples = $this->getContentSample($uid);
        if (count($dataSamples) > 0) {
            $row["samples"] = array();
            /**
             * generate the dbuid_origin
             */
            foreach ($dataSamples as $dataSample) {
                if (strlen($dataSample["dbuid_origin"]) == 0) {
                    $dataSample["dbuid_origin"] = $_SESSION["APPLI_code"] . ":" . $dataSample["uid"];
                }
                $row["samples"][] = $dataSample;
            }
        }
        /**
         * Get containers
         */
        $containers = $this->getContentContainer($uid);
        foreach ($containers as $container) {
            $row["containers"][] = $this->getContainerWithObjects($container["uid"]);
        }
        return $row;
    }

    /**
     * Recupere tous les libelles des tables de reference utilises dans le fichier a importer
     * import de donnees externes
     *
     * @param array $data
     * @return mixed[][]
     */
    public function getAllNamesFromReference($data)
    {
        $names = array();
        $fields = array(
            "sampling_place_name",
            "object_status_name",
            "collection_name",
            "sample_type_name",
            "referent_name",
            "container_type_name"
        );
        foreach ($data as $key => $df) {
            $names = $this->extractUniqueReference($names, $fields, $df);
        }
        return $names;
    }
    /**
     * Recursive treatment of the data for extract unique references
     *
     * @param array $names
     * @param array $fields
     * @param array $data
     * @return array
     */
    private function extractUniqueReference($names, $fields, $data)
    {
        foreach ($data as $key => $df) {
            if (is_array($df)) {
                foreach ($df as $objet) {
                    $names = $this->extractUniqueReference($names, $fields, $objet);
                }
            } else {
                if (strlen($df) > 0 && in_array($key, $fields)) {
                    if (!in_array($df, $names[$key])) {
                        $names[$key][] = $df;
                    }
                }
                /**
                 * Traitement des identifiants secondaires
                 */
                if ($key == "identifiers" && strlen($df) > 0) {
                    $idents = explode(",", $df);
                    foreach ($idents as $ident) {
                        $idvalue = explode(":", $ident);
                        if (!in_array($idvalue[0], $names["identifier_type_code"])) {
                            $names["identifier_type_code"][] = $idvalue[0];
                        }
                    }
                }
            }
        }
        return $names;
    }

    /**
     * import containers and embedded objects from 
     * a JSON file transformed in array
     *
     * @param array $data
     * @param SampleInitClass $sic
     * @param array $post
     * @return void
     */
    function importExternal($data, SampleInitClass $sic, $post)
    {
        $this->auto_date = 0;
        $object = new ObjectClass($this->connection, $this->param);
        require_once 'modules/classes/movement.class.php';
        $movement = new Movement($this->connection, $this->paramori);
        require_once 'modules/classes/sample.class.php';
        $sample = new Sample($this->connection, $this->paramori);
        $sample->auto_date = 0;
        $dclass = $sic->init(true);
        $this->uidMin = 999999999;
        $this->uidMax = 0;
        $this->numberUid = 0;
        foreach ($data as $key => $row) {
            $this->importContainer($row, $dclass, $sic, $post, $object, $movement, $sample, 0);
        }
    }

    /**
     * Import a container with embedded objects
     *
     * @param array $data
     * @param array $dclass
     * @param SampleInitClass $sic
     * @param array $post
     * @param ObjectClass $object
     * @param Movement $movement
     * @param Sample $sampleClass
     * @param integer $uid_parent
     * @return int
     */
    function importContainer($data, $dclass, $sic, $post, $object, $movement, $sampleClass, $uid_parent = 0)
    {
        if (is_array($data)) {
            $staticFields = array(
                "identifier",
                "wgs84_x",
                "wgs84_y",
                "identifiers"
            );
            $dynamicFields = array(
                "object_status_name",
                "referent_name",
                "container_type_name"
            );
            $dcontainer = array();
            foreach ($staticFields as $field) {
                $dcontainer[$field] = $data[$field];
            }
            foreach ($dynamicFields as $field) {
                if (strlen($data[$field]) > 0) {
                    /*
                 * Search the value from post data
                 */
                    $value = $data[$field];
                    /*
                 * Transformation of spaces in underscore,
                 * to take into encoding realized by the browser 
                 */
                    $fieldHtml = str_replace(" ", "_", $value);
                    $newval = $post[$field . "-" . $fieldHtml];
                    /*
                 * Recherche de la cle correspondante
                 */
                    $id = $dclass[$field][$newval];
                    if ($id > 0) {
                        $key = $sic->classes[$field]["id"];
                        $dcontainer[$key] = $id;
                    }
                }
            }
            /**
             * Writing the container
             */
            $data["uid"] = 0;
            $uid = $object->ecrire($data);
            if ($uid > 0) {
                $dcontainer["uid"] = $uid;
                parent::ecrire($dcontainer);
            }
            /**
             * Generate the movement if necessary
             */
            if ($uid_parent > 0) {
                $movement->addMovement($uid, null, 1, $uid_parent, null, null, null, null, $data["column_number"], $data["line_number"]);
            }
            /**
             * Create embedded samples
             */
            foreach ($data["samples"] as $sample) {
                $this->importSample($sample, $dclass, $sic, $post, $object, $movement, $sampleClass, $uid);
            }
            /**
             * create embedded containers
             */
            foreach ($data["containers"] as $container) {
                $this->importContainer($container, $dclass, $sic, $post, $object, $movement, $sampleClass, $uid);
            }
            $this->calculateUidMinMax($uid);
        }
    }

    /**
     * Import a sample and create the movement
     *
     * @param array $data
     * @param array $dclass
     * @param SampleInitClass $sic
     * @param array $post
     * @param ObjectClass $object
     * @param Movement $movement
     * @param Sample $sampleClass
     * @param integer $uid_parent
     * @return void
     */
    function importSample($data, $dclass, $sic, $post, $object, $movement, $sampleClass, $uid_parent = 0)
    {
        $staticFields = array(
            "identifier",
            "wgs84_x",
            "wgs84_y",
            "multiple_value",
            "dbuid_origin",
            "metadata",
            "dbuid_parent",
            "sample_creation_date",
            "sampling_date",
            "expiration_date"
        );
        $dynamicFields = array(
            "sampling_place_name",
            "collection_name",
            "object_status_name",
            "sample_type_name",
            "referent_name"
        );
        $dsample = array();
        foreach ($staticFields as $field) {
            if (strlen($data[$field]) > 0) {
                if ($field == "metadata") {
                    /*
                     * Ajout d'un decodage/encodage pour les champs json, pour
                     * eviter les problemes potentiels et verifier la structure
                     */
                    $dsample[$field] = json_encode(json_decode($data[$field]));
                } else {
                    $dsample[$field] = $data[$field];
                }
            }
        }
        foreach ($dynamicFields as $field) {
            if (strlen($data[$field]) > 0) {
                /*
             * Search the value from post data
             */
                $value = $data[$field];
                /*
             * Transformation of spaces in underscore,
             * to take into encoding realized by the browser 
             */
                $fieldHtml = str_replace(" ", "_", $value);
                $newval = $post[$field . "-" . $fieldHtml];
                /*
             * Recherche de la cle correspondante
             */
                $id = $dclass[$field][$newval];
                if ($id > 0) {
                    $key = $sic->classes[$field]["id"];
                    $dsample[$key] = $id;
                }
            }
        }
        /**
         * Writing the sample
         */
        $uid = $sampleClass->ecrire($dsample);
        /**
         * Generate the movement
         */
        if ($uid_parent > 0) {
            $movement->addMovement($uid, null, 1, $uid_parent, null, null, null, null, $data["column_number"], $data["line_number"]);
        }
        $this->calculateUidMinMax($uid);
    }

    /**
     * Calculate the uid min and max generated, and the total number of uid generated
     *
     * @param int $uid
     * @return void
     */
    function calculateUidMinMax($uid)
    {
        if ($uid > $this->uidMax) {
            $this->uidMax = $uid;
        }
        if ($uid < $this->uidMin) {
            $this->uidMin = $uid;
        }
        $this->numberUid++;
    }

    /**
     * Get the limits of uid generated
     *
     * @return array
     */
    function getUidMinMax()
    {
        return (array(
            "min" => $this->uidMin,
            "max" => $this->uidMax,
            "number" => $this->numberUid
        ));
    }
}
