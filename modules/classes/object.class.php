<?php

/**
 * Created : 2016-06-02
 * Creator : Eric Quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class ObjectException extends Exception
{
}
;

class Object extends ObjetBDD
{

    public $dataPrint, $xslFile;

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = null)
    {
        $this->table = "object";
        $this->colonnes = array(
            "uid" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "identifier" => array(
                "type" => 0
            ),
            "wgs84_x" => array(
                "type" => 1
            ),
            "wgs84_y" => array(
                "type" => 1
            ),
            "object_status_id" => array(
                "type" => 1,
                "defaultValue" => 1
            )
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Surcharge de la fonction supprimer pour effacer les mouvements et les evenements
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::supprimer()
     */
    function supprimer($uid)
    {
        if ($uid > 0 && is_numeric($uid)) {
            /*
             * Supprime les mouvements associes
             */
            require_once 'modules/classes/storage.class.php';
            $storage = new Storage($this->connection, $this->paramori);
            $storage->supprimerChamp($uid, "uid");
            /*
             * Supprime les evenements associes
             */
            require_once 'modules/classes/event.class.php';
            $event = new Event($this->connection, $this->paramori);
            $event->supprimerChamp($uid, "uid");
            /*
             * Supprime l'objet
             */
            parent::supprimer($uid);
        }
    }

    /**
     * Fonction retournant une liste d'objets en fonction d'un identifiant (uid, identifier,
     * object_idenfier selectionne pour etre utilise dans les recherches
     * 
     * @param int|string $uid
     * @param number $is_container
     * @param boolean $is_partial
     *            : lance la recherche sur le debut de la chaine
     * @return array
     */
    function getDetail($uid, $is_container = 0, $is_partial = false)
    {
        if (strlen($uid) > 0) {
            if (is_numeric($uid) && $uid > 0) {
                
                $data["uid"] = $uid;
                $where = " where uid = :uid";
            } else {
                /*
                 * Recherche par identifiant ou par uid parent
                 */
                $operator = '=';
                if ($is_partial) {
                    $uid .= '%';
                    $operator = 'like';
                }
                $data["identifier"] = $uid;
                $where = " where upper(identifier) $operator upper(:identifier) 
                        or (upper(object_identifier_value) $operator upper (:identifier)
                        and used_for_search = 't')";
            }
            
            $sql = "select uid, identifier, wgs84_x, wgs84_y,
					container_type_name as type_name
					from object 
					join container using (uid)
					join container_type using (container_type_id)
                    left outer join object_identifier oi using (uid)
                    left outer join identifier_type it using (identifier_type_id) 
                    " . $where;
            if ($is_container != 1) {
                if (! is_numeric($uid)) {
                    $where .= " or upper(dbuid_origin) = upper(:identifier)";
                }
                $sql .= " UNION
					select uid, identifier, wgs84_x, wgs84_y,
					sample_type_name as type_name
					from object 
					join sample using (uid)
					join sample_type using (sample_type_id)
                    left outer join object_identifier oi using (uid)
                    left outer join identifier_type it using (identifier_type_id) 
                    " . $where;
            }
            return $this->getListeParamAsPrepared($sql, $data);
        }
    }

    /**
     * Prepare la liste des objets pour impression des etiquettes
     *
     * @param array $list
     * @return array
     */
    function getForPrint(array $list)
    {
        /*
         * Verification que la liste ne soit pas vide
         */
        if (count($list) > 0) {
            $data = $this->getForList($list, "uid");
            /**
             * Rajout des identifiants complementaires
             */
            /*
             * Recherche des types d'etiquettes
             */
            require_once 'modules/classes/identifierType.class.php';
            $it = new IdentifierType($this->connection, $this->param);
            $dit = $it->getListe("identifier_type_code");
            require_once 'modules/classes/objectIdentifier.class.php';
            $oi = new ObjectIdentifier($this->connection, $this->param);
            
            /*
             * Traitement de la liste
             */
            foreach ($data as $key => $value) {
                /*
                 * Traitement des metadonnees associees, integration dans le tableau
                 */
                $metadata = json_decode($value["metadata"], true);
                foreach ($metadata as $kmd => $md) {
                    $data[$key][$kmd] = $md;
                }
                /*
                 * Recuperation de la liste des identifiants externes
                 */
                $doi = $oi->getListFromUid($value["uid"]);
                /*
                 * Transformation en tableau direct
                 */
                $codes = array();
                foreach ($doi as $vdoi)
                    $codes[$vdoi["identifier_type_code"]] = $vdoi["object_identifier_value"];
                /*
                 * Rajout des codes
                 */
                foreach ($dit as $vdit)
                    $data[$key][$vdit["identifier_type_code"]] = $codes[$vdit["identifier_type_code"]];
            }
            return $data;
        }
    }

    /**
     * Recupere la liste des objets
     *
     * @param array $list
     * @return tableau
     */
    function getForList(array $list, $order = "")
    {
        /*
         * Verification que les uid sont numeriques
         * preparation de la clause where
         */
        $comma = false;
        $uids = "";
        foreach ($list as $value) {
            if (is_numeric($value) && $value > 0) {
                $comma == true ? $uids .= "," : $comma = true;
                $uids .= $value;
            }
        }
        $sql = "select uid, identifier, container_type_name as type_name, 
		clp_classification as clp,
		label_id, 'container' as object_type,
		storage_date, movement_type_name, movement_type_id,
		wgs84_x as x, wgs84_y as y,
		'' as prj, storage_product as prod, 
        null as metadata
		from object
		join container using (uid)
		join container_type using (container_type_id)
		left outer join last_movement using (uid)
		left outer join movement_type using (movement_type_id)
		where uid in ($uids)
		UNION
		select uid, identifier, sample_type_name as type_name, clp_classification as clp,
		label_id, 'sample' as object_type,
		storage_date, movement_type_name, movement_type_id,
		wgs84_x as x, wgs84_y as y,
		project_name as prj, storage_product as prod,
        metadata::varchar
		from object
		join sample using (uid)
		join project using (project_id)
		join sample_type using (sample_type_id)
        left outer join sampling_place using (sampling_place_id)
		left outer join container_type using (container_type_id)
		left outer join last_movement using (uid)
		left outer join movement_type using (movement_type_id)
		where uid in ($uids)
		";
        if (strlen($order) > 0) {
            $sql = "select * from (" . $sql . ") as a";
            $order = " order by $order";
        }
        return $this->getListeParam($sql . $order);
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
     * Fonction recherchant le premier label_id a partir de la liste
     * des uid fournis
     *
     * @param array $liste
     * @return number
     */
    function getFirstLabelIdFromArrayUid($liste)
    {
        $uids = $this->generateArrayUidToString($liste);
        $sql = "select label_id from container
					join container_type using (container_type_id)
					where uid in ($uids)
					UNION
					select label_id from sample
					join sample_type using (sample_type_id)
					join container_type using (container_type_id)
					where uid in ($uids)
					";
        $data = $this->getListeParam($sql);
        $label_id = 0;
        foreach ($data as $value) {
            if ($value["label_id"] > 0) {
                $label_id = $value["label_id"];
                break;
            }
        }
        return $label_id;
    }

    /**
     * Genere le QRCODE
     *
     * @param array $list
     * @return array[][]
     */
    function generateQrcode($list, $labelId = 0, $order = "uid")
    {
        if ($labelId > 0) {
            $uids = $this->generateArrayUidToString($list);
            require_once 'plugins/phpqrcode/qrlib.php';
            global $APPLI_temp;
            require_once 'modules/classes/objectIdentifier.class.php';
            $oi = new ObjectIdentifier($this->connection, $this->param);
            require_once 'modules/classes/label.class.php';
            $label = new Label($this->connection, $this->param);
            /*
             * Recuperation des donnees de l'etiquette
             */
            $fields = array();
            
            $dlabel = $label->lire($labelId);
            $fields = explode(",", $dlabel["label_fields"]);
            $APPLI_code = $_SESSION["APPLI_code"];
            /*
             * Recuperation des informations generales
             */
            
$sql = "select uid, identifier as id, clp_classification as clp, '' as pn,
                                        '$APPLI_code' as db,
                                        '' as prj, storage_product as prod,
                                         wgs84_x as x, wgs84_y as y, storage_date as cd,
					null as metadata, null as loc, object_status_name as status
                                        from object
                                        join container using (uid)
                                        join container_type using (container_type_id)
					join object_status using (object_status_id)
					left outer join last_movement using (uid)
                                        where uid in ($uids)
                    UNION
        select uid, identifier as id, clp_classification as clp, protocol_name as pn,
                                        '$APPLI_code' as db,
                                        project_name as prj, storage_product as prod,
                                         wgs84_x as x, wgs84_y as y, sample_date as cd,
					metadata::varchar, sampling_place_name as loc, object_status_name as status
                                        from object
                                        join sample using (uid)
                                        join sample_type using (sample_type_id)
                                        join project using (project_id)
					join object_status using (object_status_id)
					left outer join sampling_place using (sampling_place_id)
                                        left outer join container_type using (container_type_id)
                                        left outer join operation using (operation_id)
                                        left outer join protocol using (protocol_id)
                                        where uid in ($uids)
                        ";
            if (strlen($order) == 0)
                $order = "uid";
            $sql = "select * from (" . $sql . ") as a";
            $order = " order by $order";
            $data = $this->getListeParam($sql . $order);
            
            /*
             * Preparation du tableau de sortie
             * transcodage des noms de champ
             */
            /*
             * Recuperation de la liste des champs a inserer dans l'etiquette
             */
            $dataConvert = array();
            
            /**
             * Traitement de chaque ligne, et generation
             * du qrcode
             */
            
            foreach ($data as $row) {
                /*
                 * Recuperation des identifiants complementaires
                 */
                $doi = $oi->getListFromUid($row["uid"]);
                $rowq = array();
                foreach ($row as $key => $value) {
                    
                    if (strlen($value) > 0 && in_array($key, $fields))
                        $rowq[$key] = $value;
                }
                foreach ($doi as $value) {
                    $row[$value["identifier_type_code"]] = $value["object_identifier_value"];
                    if (in_array($value["identifier_type_code"], $fields))
                        $rowq[$value["identifier_type_code"]] = $value["object_identifier_value"];
                }
                /*
                 * Recuperation des metadonnees associees
                 */
                $metadata = json_decode($row["metadata"], true);
                foreach ($metadata as $key => $value) {
                    // on remplace les espaces qui ne sont pas gérés par le xml
                    $newKey = str_replace(" ", "_", $key);
                    $row[$newKey] = $value;
                    if (strlen($value) > 0 && in_array($newKey, $fields)) {
                        $rowq[$newKey] = $value;
                    }
                }
                /*
                 * Generation du qrcode
                 */
                $filename = $APPLI_temp . '/' . $row["uid"] . ".png";
                if ($dlabel["identifier_only"]) {
                    QRcode::png($rowq[$dlabel["label_fields"]], $filename);
                } else {
                    QRcode::png(json_encode($rowq), $filename);
                }
                /*
                 * Stockage des donnees pour la suite du traitement
                 */
                $dataConvert[] = $row;
            }
            return $dataConvert;
        }
    }

    /**
     * Lit les objets a partir des saisies batch
     *
     * @param unknown $batchdata
     * @return tableau
     */
    function batchRead($batchdata)
    {
        if (strlen($batchdata) > 0) {
            $batchdata = $this->encodeData($batchdata);
            /*
             * Preparation du tableau de travail
             */
            $data = explode("\n", $batchdata);
            /*
             * Requete de recherche des uid a partir de l'identifiant metier
             */
            $sql = "select uid 
                    from object 
                    left outer join object_identifier oi using (uid)
                    left outer join identifier_type it using (identifier_type_id) 
                    where upper(identifier) =  upper(:id)
                    or (upper(object_identifier_value) = upper (:id1)
                        and used_for_search = 't')";
            /*
             * Extraction des UID de chaque ligne scanee
             */
            $uids = array();
            $order = "";
            $i = 1;
            foreach ($data as $value) {
                $uid = 0;
                /*
                 * Suppression des espaces
                 */
                $value = trim($value, " \t\n\r");
                $datajson = json_decode($value, true);
                if (is_array($datajson)) {
                    if ($datajson["uid"] > 0 && $datajson["db"] == $_SESSION["APPLI_code"])
                        $uid = $datajson["uid"];
                } else {
                    /*
                     * Recuperation de l'uid associe a l'identifier fourni
                     * (resultat d'un scan base sur l'identifiant metier)
                     */
                    $val = "";
                    if (strlen($value) > 0) {
                        /*
                         * Recherche si la chaine commence par http
                         */
                        if (substr($value, 0, 4) == "http" || substr($value, 0, 3) == "htp") {
                            /*
                             * Extraction de la derniere valeur (apres le dernier /)
                             */
                            $aval = explode('/', $value);
                            $nbElements = count($aval);
                            if ($nbElements > 0)
                                $val = $aval[($nbElements - 1)];
                        } else
                            /*
                             * la chaine fournie est conservee telle quelle
                             */
                            $val = $value;
                        $val = trim($val);
                        if (strlen($val) > 0) {
                            $valobject = $this->lireParamAsPrepared($sql, array(
                                "id" => $val,
                                "id1" => $val
                            ));
                            if ($valobject["uid"] > 0)
                                $uid = $valobject["uid"];
                        }
                    }
                }
                if ($uid > 0) {
                    $uids[] = $uid;
                    $order .= " when " . $uid . " then $i";
                    $i ++;
                }
            }
            if (count($uids) > 0) {
                $order = " case uid " . $order . " end";
                return $this->getForList($uids, "$order");
            }
        }
    }

    function generatePdf($id)
    {
        global $message, $APPLI_temp, $APPLI_fop;
        $pdffile = "";
        /*
         * Recuperation du numero d'etiquettes
         */
        /*
         * Recuperation du modele d'etiquettes selectionne dans le formulaire
         */
        if ($_REQUEST["label_id"] > 0 && is_numeric($_REQUEST["label_id"])) {
            $label_id = $_REQUEST["label_id"];
        } else {
            /*
             * Recherche de la premiere etiquette par defaut
             */
            $label_id = $this->getFirstLabelIdFromArrayUid($id);
        }
        if ($label_id > 0) {
            /*
             * Generation des qrcodes
             */
            $data = $this->generateQrcode($id, $label_id);
            /*
             * Generation du fichier xml
             */
            if (count($data) > 0) {
                $this->dataPrint = $data;
                try {
                    $xml_id = bin2hex(openssl_random_pseudo_bytes(6));
                    /*
                     * Preparation du fichier xml
                     */
                    $doc = new DOMDocument('1.0', 'utf-8');
                    $objects = $doc->createElement("objects");
                    foreach ($data as $object) {
                        $item = $doc->createElement("object");
                        foreach ($object as $key => $value) {
                            if (strlen($key) > 0 && (strlen($value) > 0 || ($value === false))) {
                                // cas des booléens
                                if ($value === true) {
                                    $elem = $doc->createElement($key, "true");
                                } elseif ($value === false) {
                                    $elem = $doc->createElement($key, "false");
                                } else {
                                    $elem = $doc->createElement($key, $value);
                                }
                                
                                $item->appendChild($elem);
                            }
                        }
                        $objects->appendChild($item);
                    }
                    $doc->appendChild($objects);
                    
                    if ($label_id > 0) {
                        $xmlfile = $APPLI_temp . '/' . $xml_id . ".xml";
                        if (! $doc->save($xmlfile)) {
                            throw new ObjectException("Impossible de générer le fichier XML");
                        }
                        if (! file_exists($xmlfile)) {
                            throw new ObjectException("Impossible de générer le fichier XML");
                        }
                        /*
                         * Recuperation du fichier xsl
                         */
                        $xslfile = $APPLI_temp . '/' . $label_id . ".xsl";
                        if (! file_exists($xslfile)) {
                            try {
                                require_once 'modules/classes/label.class.php';
                                $label = new Label($this->connection, $this->paramori);
                                $dataLabel = $label->lire($label_id);
                                $handle = fopen($xslfile, 'w');
                                fwrite($handle, $dataLabel["label_xsl"]);
                                fclose($handle);
                            } catch (Exception $e) {
                                throw new ObjectException($e->getMessage());
                            }
                        }
                        if (! file_exists($xslfile)) {
                            throw new ObjectException("Impossible de générer le fichier xsl");
                        }
                        $this->xslFile = $xslfile;
                        /*
                         * Generation de la commande de creation du fichier pdf
                         */
                        $pdffile = $APPLI_temp . '/' . $xml_id . ".pdf";
                        $command = $APPLI_fop . " -xsl $xslfile -xml $xmlfile -pdf $pdffile";
                        exec($command);
                        if (! file_exists($pdffile)) {
                            throw new ObjectException("Fichier PDF non généré");
                        }
                    } else {
                        $message->set("Pas de modèle d'étiquettes disponible");
                    }
                } catch (Exception $e) {
                    $message->set("Erreur lors de la génération du fichier xml");
                    $message->setSyslog($e->getMessage());
                }
            } else {
                $message->set("Pas d'étiquettes à imprimer");
            }
            if (strlen($pdffile) == 0) {
                throw new ObjectException("Fichier PDF non généré");
            }
            return $pdffile;
        } else {
            throw new ObjectException("Pas d'étiquette sélectionnée");
        }
    }

    /**
     * Supprime les fichiers png apres generation
     * 
     * @param unknown $path
     */
    function eraseQrcode($path)
    {
        foreach ($this->dataPrint as $value) {
            unlink($path . "/" . $value["uid"] . ".png");
        }
    }

    /**
     * Supprime le fichier xsl, pour regeneration a la prochaine impression
     */
    function eraseXslfile()
    {
        unlink($this->xslFile);
    }
}
