<?php

/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class SampleException extends Exception
{
}

class Sample extends ObjetBDD
{

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    private $sql = "select s.sample_id, s.uid,
					s.project_id, project_name, s.sample_type_id, s.dbuid_origin,
					sample_type_name, s.sample_creation_date, s.sample_date, s.metadata, 
                    s.parent_sample_id,
					st.multiple_type_id, s.multiple_value, st.multiple_unit, mt.multiple_type_name,
					so.identifier, so.wgs84_x, so.wgs84_y, 
					so.object_status_id, object_status_name,
					pso.uid as parent_uid, pso.identifier as parent_identifier,
					container_type_name, clp_classification,
					operation_id, protocol_name, protocol_year, protocol_version, operation_name, operation_order,operation_version,
					metadata_schema,
					document_id, identifiers,
					storage_date, movement_type_name, movement_type_id,
					sp.sampling_place_id, sp.sampling_place_name,
                    lm.line_number, lm.column_number
					from sample s
					join sample_type st on (st.sample_type_id = s.sample_type_id)
					join project p on (p.project_id = s.project_id)
					join object so on (s.uid = so.uid)
					left outer join sampling_place sp on (sp.sampling_place_id = s.sampling_place_id)
					left outer join object_status os on (so.object_status_id = os.object_status_id)
					left outer join sample ps on (s.parent_sample_id = ps.sample_id)
					left outer join object pso on (ps.uid = pso.uid)	
					left outer join container_type ct using (container_type_id)
					left outer join operation using (operation_id)
					left outer join protocol using (protocol_id)
					left outer join multiple_type mt on (st.multiple_type_id = mt.multiple_type_id)
					left outer join last_photo on (so.uid = last_photo.uid)
					left outer join v_object_identifier voi on  (s.uid = voi.uid)
					left outer join last_movement lm on (s.uid = lm.uid)
					left outer join movement_type using (movement_type_id)
                    left outer join metadata using (metadata_id)
					";

    function __construct($bdd, $param = array())
    {
        $this->table = "sample";
        $this->colonnes = array(
            "sample_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "uid" => array(
                "type" => 1,
                "parentAttrib" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "project_id" => array(
                "type" => 1,
                "requis" => 1
            ),
            "sample_type_id" => array(
                "type" => 1,
                "requis" => 1
            ),
            "sample_creation_date" => array(
                "type" => 3,
                "requis" => 1,
                "defaultValue" => "getDateHeure"
            ),
            "parent_sample_id" => array(
                "type" => 1
            ),
            "sample_date" => array(
                "type" => 3,
                "defaultValue" => "getDateHeure"
            ),
            "multiple_value" => array(
                "type" => 1
            ),
            "sampling_place_id" => array(
                "type" => 1
            ),
            "dbuid_origin" => array(
                "type" => 0
            ),
            "metadata" => array(
                "type" => 0
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
    function lire($uid, $getDefault, $parentValue)
    {
        $sql = $this->sql . " where s.uid = :uid";
        $data["uid"] = $uid;
        if (is_numeric($uid) && $uid > 0) {
            $retour = parent::lireParamAsPrepared($sql, $data);
        } else {
            $retour = parent::getDefaultValue($parentValue);
        }
        return $retour;
    }

    function lireFromId($sample_id)
    {
        $sql = $this->sql . " where s.sample_id = :sample_id";
        $data["sample_id"] = $sample_id;
        return parent::lireParamAsPrepared($sql, $data);
    }

    /**
     * Surcharge de la fonction ecrire pour verifier si l'echantillon est modifiable
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::ecrire()
     */
    function ecrire($data)
    {
        $ok = $this->verifyProject($data);
        /*
         * Verification complementaire par rapport aux donnees deja stockees
         */
        if ($ok && $data["uid"] > 0)
            $ok = $this->verifyProject($this->lire($data["uid"]));
        if ($ok) {
            /*
             * Mise en forme des metadonnees
             */
            if ($data["sample_type_id"] > 0) {
                require_once 'modules/classes/sampleType.class.php';
                $st = new SampleType($this->connection, $this->paramori);
                $dst = $st->getMetadataForm($data["sample_type_id"]);
                if (strlen($dst) > 2) {
                    $schema = json_decode($dst, true);
                    $metadata = array();
                    foreach ($schema as $value) {
                        if (strlen($data[$value["name"]]) > 0) {
                            $metadata[$value["name"]] = $data[$value["name"]];
                        }
                    }
                    $data["metadata"] = json_encode($metadata);
                }
            }
            $object = new Object($this->connection, $this->param);
            $uid = $object->ecrire($data);
            if ($uid > 0) {
                $data["uid"] = $uid;
                parent::ecrire($data);
                return $uid;
            }
        } else {
            throw new SampleException($LANG["appli"][4]);
        }
        return - 1;
    }

    /**
     * Surcharge de la fonction supprimer pour verifier si l'utilisateur peut supprimer l'echantillon
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::supprimer()
     */
    function supprimer($uid)
    {
        $data = $this->lire($uid);
        if ($this->verifyProject($data)) {
            
            /*
             * suppression de l'echantillon
             */
            parent::supprimer($data["sample_id"]);
            /*
             * Suppression de l'objet
             */
            require_once 'modules/classes/object.class.php';
            $object = new Object($this->connection, $this->paramori);
            $object->supprimer($uid);
        }
    }

    /**
     * Fonction permettant de verifier si l'echantillon peut etre modifie ou non
     * par l'utilisateur
     *
     * @param array $data
     * @throws Exception
     * @return boolean
     */
    function verifyProject($data)
    {
        $retour = false;
        foreach ($_SESSION["projects"] as $value) {
            if ($data["project_id"] == $value["project_id"]) {
                $retour = true;
                break;
            }
        }
        return $retour;
    }

    /**
     * Retourne le nombre d'echantillons attaches a un projet
     *
     * @param int $project_id
     */
    function getNbFromProject($project_id)
    {
        if ($project_id > 0) {
            $sql = "select count(*)as nb from sample where project_id = :project_id";
            $var["project_id"] = $project_id;
            $data = $this->lireParamAsPrepared($sql, $var);
            if (count($data) > 0) {
                return $data["nb"];
            } else
                return 0;
        }
    }

    /**
     * Fonction de recherche des échantillons
     *
     * @param array $param
     */
    function sampleSearch($param)
    {
        $data = array();
        $isFirst = true;
        $order = " order by project_name, sample_type_name, identifier, uid";
        $where = "where";
        $and = "";
        if ($param["sample_type_id"] > 0) {
            $where .= " s.sample_type_id = :sample_type_id";
            $data["sample_type_id"] = $param["sample_type_id"];
            $and = " and ";
        }
        if (strlen($param["name"]) > 0) {
            $where .= $and . "( ";
            $or = "";
            if (is_numeric($param["name"])) {
                $where .= " s.uid = :uid";
                $data["uid"] = $param["name"];
                $or = " or ";
            }
            $name = $this->encodeData($param["name"]);
            $identifier = "%" . strtoupper($name) . "%";
            $where .= "$or upper(so.identifier) like :identifier or upper(s.dbuid_origin) = upper(:dbuid_origin)";
            $and = " and ";
            $data["identifier"] = $identifier;
            $data["dbuid_origin"] = $name;
            /*
             * Recherche sur les identifiants externes
             * possibilite de recherche sur cab:valeur, p. e.
             */
            $where .= " or upper(identifiers) like :identifier ";
            $where .= ")";
        }
        if ($param["project_id"] > 0) {
            $where .= $and . " s.project_id = :project_id";
            $and = " and ";
            $data["project_id"] = $param["project_id"];
        }
        if ($param["object_status_id"] > 0) {
            $where .= $and . " so.object_status_id = :object_status_id";
            $and = " and ";
            $data["object_status_id"] = $param["object_status_id"];
        }
        if ($param["sampling_place_id"] > 0) {
            $where .= $and . " s.sampling_place_id = :sampling_place_id";
            $and = " and ";
            $data["sampling_place_id"] = $param["sampling_place_id"];
        }
        
        if ($param["uid_max"] > 0 && $param["uid_max"] >= $param["uid_min"]) {
            $where .= $and . " s.uid between :uid_min and :uid_max";
            $and = " and ";
            $data["uid_min"] = $param["uid_min"];
            $data["uid_max"] = $param["uid_max"];
        }
        /*
         * Recherche dans les metadonnees
         */
        if (strlen($param["metadata_field"]) > 0 && strlen($param["metadata_value"]) > 0) {
            $where .= $and . "upper(s.metadata->>:metadata_field) like upper (:metadata_value)";
            $data["metadata_field"] = $param["metadata_field"];
            $data["metadata_value"] = $param["metadata_value"] . "%";
            $and = " and ";
        }
        
        /*
         * if ($param ["limit"] > 0) {
         * $order .= " limit :limite";
         * $data ["limite"] = $param ["limit"];
         * }
         */
        if ($where == "where")
            $where = "";
        /*
         * Rajout de la date de dernier mouvement pour l'affichage
         */
        $this->colonnes["storage_date"] = array(
            "type" => 3
        );
        return $this->getListeParamAsPrepared($this->sql . $where /*. $order*/, $data);
    }

    /**
     * Retourne les echantillons associes a un parent
     *
     * @param int $uid
     *            : uid du parent
     */
    function getSampleassociated($uid)
    {
        if ($uid > 0 && is_numeric($uid)) {
            $data["uid"] = $uid;
            $where = " where pso.uid = :uid";
            $order = " order by s.uid";
            return $this->getListeParamAsPrepared($this->sql . $where . $order, $data);
        }
    }

    /**
     * Retourne la liste des informations pour des echantillons
     * script d'export pour import
     *
     * @param string $uids
     * @return array
     */
    function getForExport($uids)
    {
        if (strlen($uids) == 0) {
            throw new SampleException("Pas d'échantillons sélectionnés");
        } else {
            $this->auto_date = 0;
            $sql = "select o.uid, identifier, object_status_name, wgs84_x, wgs84_y, 
             project_id, project_name, sample_type_name, sample_creation_date, sample_date, 
             multiple_value, sampling_place_name,metadata::varchar, 
            identifiers 
            from sample 
            join object o using(uid) 
            join project using (project_id)
            left outer join v_object_identifier voi on (o.uid = voi.uid) 
            left outer join sampling_place using (sampling_place_id)
            left outer join sample_type using (sample_type_id)
            left outer join object_status using (object_status_id)
             where o.uid in (" . $uids . ")";
            $d = $this->getListeParam($sql);
            $this->auto_date = 1;
            /*
             * genere le dbuid pour import dans base externe
             */
            $data = array();
            foreach ($d as $value) {
                if ($this->verifyProject($value)) {
                    $value["dbuid_origin"] = $_SESSION["APPLI_code"] . ":" . $value["uid"];
                    unset($value["project_id"]);
                    $data[] = $value;
                }
            }
            if (count($data) > 0) {
                return $data;
            } else {
                throw new SampleException("Droits insuffisants pour exporter les échantillons");
            }
        }
    }

    /**
     * Genere une liste des uids separes par une virgule, a partir d'un
     * tableau contenant la liste des uid
     * (retour de formulaire a choix multiple)
     *
     * @param array $uids
     */
    function generateArrayUidToString($uids)
    {
        if (count($uids) > 0) {
            /*
             * Verification que les uid sont numeriques
             * preparation de la clause where
             */
            $comma = false;
            $val = "";
            foreach ($uids as $value) {
                if (is_numeric($value) && $value > 0) {
                    $comma == true ? $val .= "," : $comma = true;
                    $val .= $value;
                }
            }
            return $val;
        }
    }

    /**
     * Recupere tous les libelles des tables de reference utilises dans le fichier a importer
     * import de donnees externes
     *
     * @param array $data
     * @return mixed[][]
     */
    function getAllNamesFromReference($data)
    {
        $names = array();
        $fields = array(
            "sampling_place_name",
            "object_status_name",
            "project_name",
            "sample_type_name"
        );
        foreach ($data as $line) {
            foreach ($fields as $field) {
                if (strlen($line[$field]) > 0) {
                    if (! in_array($line[$field], $names[$field])) {
                        $names[$field][] = $line[$field];
                    }
                }
            }
            /*
             * Traitement des identifiants secondaires
             */
            if (strlen($line["identifiers"]) > 0) {
                $idents = explode(",", $line["identifiers"]);
                foreach ($idents as $ident) {
                    $idvalue = explode(":", $ident);
                    if (! in_array($idvalue[0], $names["identifier_type_code"])) {
                        $names["identifier_type_code"][] = $idvalue[0];
                    }
                }
            }
        }
        return $names;
    }

    /**
     * Verifie que l'echantillon peut etre importe
     *
     * @param array $row
     * @throws SampleException
     * @return boolean
     */
    function verifyBeforeImport($row)
    {
        if (count($row) > 0) {
            if (strlen($row["dbuid_origin"]) > 0) {
                $ori = explode(":", $row["dbuid_origin"]);
                if ($_SESSION["APPLI_code"] == $ori[0]) {
		    //CPP : commented to enable the UPDATE of previous samples (@see modules/gestion/sample.php)
                    //throw new SampleException("Il n'est pas possible d'importer un échantillon issu de la base de données courante");
                }
            } else {
                throw new SampleException("L'identifiant de la base de données d'origine n'a pas été fourni");
            }
            /*
             * Verification de l'existence du projet
             */
            if (strlen($row["project_name"]) == 0) {
                throw new SampleException("Le nom du projet (ou de la sous-collection) n'a pas été renseigné");
            }
            /*
             * Verification de l'existence d'un type d'echantillon
             */
            if (strlen($row["sample_type_name"]) == 0) {
                throw new SampleException("Le type d'échantillon n'a pas été renseigné");
            }
        }
        return true;
    }

    /**
     * Fonction d'ecriture dans le cadre d'un import externe
     * 
     * @param array $data
     * @throws SampleException
     * @return number
     */
    function ecrireImport($data)
    {
        $object = new Object($this->connection, $this->param);
        $uid = $object->ecrire($data);
        if ($uid > 0) {
            $data["uid"] = $uid;
            parent::ecrire($data);
            return $uid;
        } else {
            throw new SampleException("Impossible d'écrire dans la table Object");
        }
        return - 1;
    }
}

?>
