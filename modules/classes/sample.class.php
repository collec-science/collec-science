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
					s.collection_id, collection_name, s.sample_type_id, s.dbuid_origin,
					sample_type_name, s.sample_creation_date, s.sampling_date, s.metadata, s.expiration_date,
                    s.parent_sample_id,
					st.multiple_type_id, s.multiple_value, st.multiple_unit, mt.multiple_type_name,
					so.identifier, so.wgs84_x, so.wgs84_y, 
					so.object_status_id, object_status_name,
					pso.uid as parent_uid, pso.identifier as parent_identifier,
					container_type_name, clp_classification,
					operation_id, protocol_name, protocol_year, protocol_version, operation_name, operation_order,operation_version,
					metadata_schema,
					document_id, identifiers,
					movement_date, movement_type_name, movement_type_id,
					sp.sampling_place_id, sp.sampling_place_name,
                    lm.line_number, lm.column_number
					from sample s
					join sample_type st on (st.sample_type_id = s.sample_type_id)
					join collection p on (p.collection_id = s.collection_id)
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
            "collection_id" => array(
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
            "sampling_date" => array(
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
            ),
            "expiration_date" => array(
                "type" => 2
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
        $ok = $this->verifyCollection($data);
        $error = false;
        /*
         * Verification complementaire par rapport aux donnees deja stockees
         */
        if ($ok && $data["uid"] > 0) {
            $ok = $this->verifyCollection($this->lire($data["uid"]));
        }
        if ($ok) {
            $object = new Object($this->connection, $this->param);
            $uid = $object->ecrire($data);
            if ($uid > 0) {
                $data["uid"] = $uid;
                if (parent::ecrire($data) > 0) {
                    return $uid;
                } else {
                    $error = true;
                }
            } else {
                $error = true;
            }
        } else {
            $error = true;
        }
        if ($error) {
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
        if ($this->verifyCollection($data)) {
            
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
    function verifyCollection($data)
    {
        $retour = false;
        foreach ($_SESSION["collections"] as $value) {
            if ($data["collection_id"] == $value["collection_id"]) {
                $retour = true;
                break;
            }
        }
        return $retour;
    }

    /**
     * Retourne le nombre d'echantillons attaches a un projet
     *
     * @param int $collection_id
     */
    function getNbFromCollection($collection_id)
    {
        if ($collection_id > 0) {
            $sql = "select count(*)as nb from sample where collection_id = :collection_id";
            $var["collection_id"] = $collection_id;
            $data = $this->lireParamAsPrepared($sql, $var);
            if (count($data) > 0) {
                return $data["nb"];
            } else {
                return 0;
            }
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
        $order = " order by collection_name, sample_type_name, identifier, uid";
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
        if ($param["collection_id"] > 0) {
            $where .= $and . " s.collection_id = :collection_id";
            $and = " and ";
            $data["collection_id"] = $param["collection_id"];
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
        if (strlen($param["select_date"]) > 0) {
            switch ($param["select_date"]) {
                case "cd":
                    $field = "sample_creation_date";
                    break;
                case "sd":
                    $field = "sampling_date";
                    break;
                case "ed":
                    $field = "expiration_date";
                    break;
            }
            $where .= $and . "s.$field between :date_from and :date_to";
            $data["date_from"] = $this->formatDateLocaleVersDB($param["date_from"], 2);
            $data["date_to"] = $this->formatDateLocaleVersDB($param["date_to"], 2);
            $and = " and ";
        }
        /*
         * Recherche dans les metadonnees
         */
        if (strlen($param["metadata_field"][0]) > 0 && strlen($param["metadata_value"][0]) > 0) {
            $where .= $and . " ";
            /*
             * Traitement des divers champs de metadonnees (3 maxi)
             * ajout des parentheses si necessaire
             * si le meme field est utilise, operateur or, sinon operateur and
             */
            if ($param["metadata_field"][0] == $param["metadata_field"][1]) {
                $is_or = true;
            } else {
                $is_or = false;
            }
            if (strlen($param["metadata_field"][1]) > 0 && $param["metadata_field"][2] == $param["metadata_field"][1] && strlen($param["metadata_value"][2]) > 0) {
                $is_or1 = true;
            } else {
                $is_or1 = false;
            }
            if ($is_or) {
                $where .= "(";
            }
            $where .= "lower(s.metadata->>:metadata_field0) like lower (:metadata_value0)";
            $data["metadata_field0"] = $param["metadata_field"][0];
            $data["metadata_value0"] = "%" . $param["metadata_value"][0] . "%";
            if (strlen($param["metadata_field"][1]) > 0 && strlen($param["metadata_value"][1]) > 0) {
                if ($is_or) {
                    $where .= " or ";
                } else {
                    $where .= " and ";
                }
                $where .= " lower(s.metadata->>:metadata_field1) like lower (:metadata_value1)";
                $data["metadata_field1"] = $param["metadata_field"][1];
                $data["metadata_value1"] = "%" . $param["metadata_value"][1] . "%";
            }
            if ($is_or && ! $is_or1) {
                $where .= ")";
                $is_or = false;
            }
            if (! $is_or && $is_or1) {
                $where .= " (";
            }
            
            if (strlen($param["metadata_field"][2]) > 0 && strlen($param["metadata_value"][2]) > 0) {
                if ($is_or1) {
                    $where .= " or ";
                } else {
                    $where .= " and ";
                }
                $where .= " lower(s.metadata->>:metadata_field2) like lower (:metadata_value2)";
                $data["metadata_field2"] = $param["metadata_field"][2];
                $data["metadata_value2"] = "%" . $param["metadata_value"][2] . "%";
            }
            if ($is_or || $is_or1) {
                $where .= ")";
            }
            $and = " and ";
        }
        /*
         * Fin de traitement des criteres de recherche
         */
        if ($where == "where") {
            $where = "";
        }
        /*
         * Rajout de la date de dernier mouvement pour l'affichage
         */
        $this->colonnes["movement_date"] = array(
            "type" => 3
        );
        return $this->getListeParamAsPrepared($this->sql . $where, $data);
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
             c.collection_id, collection_name, sample_type_name, sample_creation_date, sampling_date, expiration_date,
             multiple_value, sampling_place_name, metadata::varchar, 
            identifiers, dbuid_origin, parent_sample_id, '' as dbuid_parent
            from sample 
            join object o using(uid) 
            join collection c using (collection_id)
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
                if ($this->verifyCollection($value)) {
                    if (strlen($value["dbuid_origin"]) == 0) {
                        $value["dbuid_origin"] = $_SESSION["APPLI_code"] . ":" . $value["uid"];
                    }
                    /*
                     * Generation du dbuid du parent dans le cas d'un echantillon derive
                     */
                    if ($value["parent_sample_id"] > 0) {
                        $dparent = $this->lireFromId($value["parent_sample_id"]);
                        $value["dbuid_parent"] = $_SESSION["APPLI_code"] . ":" . $dparent["uid"];
                    }
                    unset($value["parent_sample_id"]);
                    unset($value["collection_id"]);
                    unset ($value["uid"]);
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
            "collection_name",
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
            if (strlen($row["dbuid_origin"]) == 0) {
                /*
                 * $ori = explode(":", $row["dbuid_origin"]);
                 * if ($_SESSION["APPLI_code"] == $ori[0]) {
                 * throw new SampleException("Il n'est pas possible d'importer un échantillon issu de la base de données courante");
                 * }
                 * } else {
                 */
                throw new SampleException("L'identifiant de la base de données d'origine n'a pas été fourni");
            }
            /*
             * Verification de l'existence de la collection
             */
            if (strlen($row["collection_name"]) == 0) {
                throw new SampleException("Le nom de la collection n'a pas été renseigné");
            }
            /*
             * Verification de l'existence d'un type d'echantillon
             */
            if (strlen($row["sample_type_name"]) == 0) {
                throw new SampleException("Le type d'échantillon n'a pas été renseigné");
            }
            /*
             * Verification de la coherence des dates
             */
            $fieldDates = array(
                "sampling_date",
                "expiration_date",
                "sample_creation_date"
            );
            foreach ($fieldDates as $fieldDate) {
                if (strlen($row[$fieldDate]) > 0) {
                    /*
                     * Verification du format francais
                     */
                    $result = date_parse_from_format("d/m/Y", $row[$fieldDate]);
                    if ($result["warning_count"] > 0) {
                        /*
                         * Test du format general
                         */
                        $result = date_parse($row[$fieldDate]);
                        if ($result["warning_count"] > 0) {
                            throw new SampleException("Le format de date de $fieldDate n'est pas reconnu. ");
                        }
                    }
                    if ($result["warning_count"] == 0) {
                        /*
                         * Verification que la date contienne bien une annee, mois, jour
                         */
                        if (strlen($result["year"]) == 0 || strlen($result["month"]) == 0 || strlen($result["day"]) == 0) {
                            throw new SampleException("La date de $fieldDate est incomplète ou incohérente. ");
                        }
                    }
                }
            }
            /*
             * Verification de la colonne metadata
             */
            if (strlen($row["metadata"]) > 0) {
                $a_m = json_decode($row["metadata"], true);
                if (count($a_m) == 0) {
                    throw new SampleException("Les métadonnées ne sont pas correctement formatées (champ metadata)");
                }
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
        /*
         * Ajout des informations manquantes
         */
        if (strlen($data["object_status_id"]) == 0) {
            $data["object_status_id"] = 1;
        }
        if (strlen($data["sample_creation_date"]) == 0) {
            $data["sample_creation_date"] = date(DATE_ATOM);
        }
        /*
         * Recherche de l'uid existant a partir de dbuid_origin
         */
        if (strlen($data["dbuid_origin"]) > 0) {
            /*
             * Recherche si c'est une reintegration dans la base d'origine
             */
            $field = explode(":", $data["dbuid_origin"]);
            if ($field[0] == $_SESSION["APPLI_code"]) {
                $uid = $field[1];
                $data["dbuid_origin"] = "";
            } else {
                $uid = $this->getUidFromDbuidOrigin($data["dbuid_origin"]);
            }
            if ($uid > 0) {
                $data["uid"] = $uid;
            }
        }

        /*
         * Recuperation de l'echantillon parent, si existant
         */
        if (strlen($data["dbuid_parent"]) > 0) {
            $dbuidparent = explode(":", $data["dbuid_parent"]);
            if ($dbuidparent[0] == $_SESSION["APPLI_code"]) {
                $dataParent = $this->lire($dbuidparent[1]);
            } else {
                $dataParent = $this->lireParamAsPrepared("select sample_id from sample where dbuid_origin = :dbuidorigin", array(
                    "dbuidorigin" => $data["dbuid_parent"]
                ));
            }
            if ($dataParent["sample_id"] > 0) {
                $data["parent_sample_id"] = $dataParent["sample_id"];
            }
        }
        $uid = $object->ecrire($data);
        if ($uid > 0) {
            $data["uid"] = $uid;
            /*
             * Recherche de l'identifiant d'origine (sample_id)
             */
            $dataOrigine = $this->lire($uid);
            if ($dataOrigine["sample_id"] > 0) {
                $data["sample_id"] = $dataOrigine["sample_id"];
            }
            parent::ecrire($data);
            return $uid;
        } else {
            throw new SampleException("Impossible d'écrire dans la table Object");
        }
        return - 1;
    }

    /**
     * Recherche l'uid a partir du dbuid_origin
     *
     * @param string $dbuidorigin
     * @return number
     */
    function getUidFromDbuidOrigin($dbuidorigin)
    {
        $uid = 0;
        if (strlen($dbuidorigin) > 0) {
            /*
             * Recherche si l'echantillon provient de la base de donnees courante
             * cas de la reintegration d'un echantillon modifie a l'exterieur
             */
            
            $sql = "select uid from sample where dbuid_origin = :dbuid_origin";
            $data = $this->lireParamAsPrepared($sql, array(
                "dbuid_origin" => $dbuidorigin
            ));
            if ($data["uid"] > 0) {
                $uid = $data["uid"];
            }
        }
        return $uid;
    }
}

?>