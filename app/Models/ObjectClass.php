<?php

namespace App\Models;

use chillerlan\QRCode\{QRCode, QROptions};
use chillerlan\QRCode\Output\QROutputInterface;
use Picqer\Barcode\BarcodeGeneratorPNG;
use Picqer\Barcode\Exceptions\BarcodeException;
use Ppci\Libraries\PpciException;
use Ppci\Models\PpciModel;


/**
 * Created : 2016-06-02
 * Creator : Eric Quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */



class ObjectClass extends PpciModel
{

    public $dataPrint, $xslFile, $subsample;
    public Movement $movement;
    public Event $event;
    public Document $document;
    public Booking $booking;
    public ObjectIdentifier $oi;
    private $temp = "writable/temp";
    public $appConfig;
    private $logoFile;


    private $barcode;


    private $sql = "select uid, identifier, wgs84_x, wgs84_y, object_status_id, referent_id, change_date, uuid, trashed,
                  location_accuracy, st_astext(geom) as geom, object_comment,
                  sample_type_id,
                  case when s.collection_id is null then c.collection_id else s.collection_id end as collection_id,
                  container_type_id,
                  last_movement_id
                  from object
                  left outer join sample s using (uid)
                  left outer join container c using (uid)";

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct()
    {
        $this->table = "object";
        $this->fields = array(
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
            ),
            "referent_id" => array("type" => 1),
            "change_date" => array("type" => 3),
            "uuid" => array("type" => 0),
            "trashed" => array("type" => 1, "default" => 0),
            "location_accuracy" => array("type" => 1),
            "geom" => array("type" => 4),
            "object_comment" => array("type" => 0),
            "last_movement_id" => array("type" => 1),
            "object_login" => array("type" => 0)
        );
        $this->srid = 4326;
        $this->appConfig = service("AppConfig");
        $this->temp = $this->appConfig->APP_temp;
        parent::__construct();
    }

    /**
     * Surround of lire function to add some attributes
     *
     * @param int $id
     * @param boolean $getDefault
     * @param integer $parentValue
     * @return array
     */
    function read($id, $getDefault = true, $parentValue = 0): array
    {
        if ($id == 0 && $getDefault) {
            $data = $this->getDefaultValues($parentValue);
        } else {
            $data = $this->lireParamAsPrepared($this->sql . " where uid =:uid:", array("uid" => $id));
        }
        return $data;
    }

    /**
     * Overload of the function write
     * to update the date of change
     *
     * @param array $data
     * @return int
     */
    function write($data): int
    {
        $data["change_date"] = date($_SESSION["date"]["maskdatelong"]);
        /**
         * Operations on status change
         */
        if ($data["uid"] > 0) {
            $oldData = $this->lire($data["uid"]);
            if ($oldData["object_status_id"] != 3 && $data["object_status_id"] == 3) {
                /**
                 * object destroy, search if it's in a container
                 */
                $sql = "select uid from last_movement where uid = :uid: and movement_type_id = 1";
                $lastMovement = $this->lireParamAsPrepared($sql, array("uid" => $data["uid"]));
                if ($lastMovement["uid"] == $data["uid"]) {
                    /**
                     * Create an exit movement
                     */
                    if (!isset($this->movement)) {
                        $this->movement = new Movement;
                    }
                    $this->movement->addMovement($data["uid"], date($_SESSION["date"]["maskdatelong"]), 2);
                }
            }
        } else {
            /**
             * add login for creation
             */
            $data["object_login"] = $_SESSION["login"];
        }
        /**
         * Generate the geom object
         */
        if (!empty($data["wgs84_x"]) && !empty($data["wgs84_y"])) {
            $data["geom"] = "POINT(" . $data["wgs84_x"] . " " . $data["wgs84_y"] . ")";
        } else {
            $data["geom"] = "";
        }
        /**
         * rewrite trashed
         */
        if (empty($data["trashed"])) {
            $data["trashed"] = 0;
        }
        return parent::write($data);
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
            try {
                if (!isset($this->movement)) {
                    $this->movement = new Movement;
                }
                if (!isset($this->event)) {
                    $this->event = new Event;
                }
                if (!isset($this->document)) {
                    $this->document = new Document;
                }
                if (!isset($this->booking)) {
                    $this->booking = new Booking;
                }
                if (!isset($this->oi)) {
                    $this->oi = new ObjectIdentifier;
                }
                /*
                 * Supprime les mouvements associes
                 */
                $data = $this->lire($uid);
                if (!empty($data["last_movement_id"])) {
                    $movement_id = $data["last_movement_id"];
                    $data["last_movement_id"] = "";
                    parent::write($data);
                    $this->movement->supprimer($movement_id);
                }
                $this->movement->supprimerChamp($uid, "uid");
                /*
                 * Supprime les evenements associes
                 */
                $this->event->supprimerChamp($uid, "uid");
                /**
                 * Supprime les documents associés
                 */
                $this->document->supprimerChamp($uid, "uid");
                /**
                 * Supprime les réservations
                 */
                $this->booking->supprimerChamp($uid, "uid");
                /**
                 * Supprime les identifiants secondaires
                 */
                $this->oi->supprimerChamp($uid, "uid");

                /*
                 * Supprime l'objet
                 */
                parent::supprimer($uid);
            } catch (\Exception $e) {
                throw new PpciException($e->getMessage());
            }
        }
    }

    /**
     * Fonction retournant une liste d'objets en fonction d'un identifiant (uid, identifier,
     * object_idenfier selectionne pour etre utilise dans les recherches
     *
     * @param int|string $uid
     * @param int $is_container: 0: tout objet, 1: container, 2:sample
     * @param boolean $is_partial
     *            : lance la recherche sur le debut de la chaine
     * @return array
     */
    function getDetail($uid, $is_container = 0, $is_partial = false, $trashed = 0)
    {
        if (!empty($uid)) {
            $operator = '=';
            /*
             * Generation de la chaine pour dbuid_origin
             */
            $auid = explode(":", $uid);
            if (count($auid) == 2) {
                if ($auid[0] == $_SESSION["dbparams"]["APPLI_code"]) {
                    $uid = $auid[1];
                }
            }
            $searchUUID = false;
            if (is_numeric($uid) && $uid > 0) {

                $data["uid"] = $uid;
                $where = " where uid = :uid:";
            } else {
                if (strlen($uid) == 36) {
                    /**
                     * Search by UUID
                     */
                    $where = "where uuid = :uuid:";
                    $data["uuid"] = $uid;
                    $searchUUID = true;
                } else {
                    /**
                     * Search by identifier or parent uid
                     */
                    if ($is_partial) {
                        $uid .= '%';
                        $operator = 'like';
                    }
                    $data["identifier"] = $uid;
                    $trashed == 0 ? $data["trashed"] = 'f' : $data["trashed"] = 't';
                    $where = " where (upper(identifier) $operator upper(:identifier:)
                        or (upper(object_identifier_value) $operator upper (:identifier:)
                        and used_for_search = 't')) and trashed = :trashed:";
                }
            }
            if ($is_container < 2) {
                $sql = "select uid, identifier, wgs84_x, wgs84_y,
                    container_type_name as type_name, movement_type_id as last_movement_type,
                    uuid, location_accuracy, object_comment
					from object
					join container using (uid)
					join container_type using (container_type_id)
                    left outer join object_identifier oi using (uid)
                    left outer join identifier_type it using (identifier_type_id)
                    left outer join last_movement using (uid)
                    " . $where;
            } else {
                $sql = "";
            }
            if ($is_container == 0) {
                $sql .= " UNION ";
            }
            if ($is_container != 1) {
                if (!$searchUUID) {
                    $where .= " or upper(dbuid_origin) $operator upper(:dbuid_origin:)";
                    $data["dbuid_origin"] = $uid;
                }
                $sql .= "select uid, identifier, wgs84_x, wgs84_y,
                    sample_type_name as type_name, movement_type_id as last_movement_type,
                    uuid, location_accuracy, object_comment
					from object
					join sample using (uid)
					join sample_type using (sample_type_id)
                    left outer join object_identifier oi using (uid)
                    left outer join identifier_type it using (identifier_type_id)
                    left outer join last_movement using (uid)
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
            $it = new IdentifierType();
            $dit = $it->getListe("identifier_type_code");
            $oi = new ObjectIdentifier();

            /*
             * Traitement de la liste
             */
            foreach ($data as $key => $value) {
                /*
                 * Traitement des metadonnees associees, integration dans le tableau
                 */
                $metadata = json_decode($value["metadata"], true);
                foreach ($metadata as $kmd => $md) {
                    if (is_array($md)) {
                        $val = "";
                        $comma = "";
                        foreach ($md as $v) {
                            $val .= $comma . $v;
                            $comma = ", ";
                        }
                    } else {
                        $val = $md;
                    }
                    $data[$key][$kmd] = $val;
                }
                unset($data[$key]["metadata"]);
                /*
                 * Recuperation de la liste des identifiants externes
                 */
                $doi = $oi->getListFromUid($value["uid"]);
                /*
                 * Transformation en tableau direct
                 */
                $codes = array();
                foreach ($doi as $vdoi) {
                    $codes[$vdoi["identifier_type_code"]] = $vdoi["object_identifier_value"];
                }
                /*
                 * Rajout des codes
                 */
                foreach ($dit as $vdit) {
                    $data[$key][$vdit["identifier_type_code"]] = $codes[$vdit["identifier_type_code"]];
                }
            }
            return $data;
        }
    }

    /**
     * Recupere la liste des objets
     *
     * @param array $list
     * @return array
     */
    function getForList(array $list, $order = "", $trashed = 0)
    {
        /*
         * Verification que les uid sont numeriques
         * preparation de la clause where
         */
        $comma = false;
        $uids = "";
        foreach ($list as $value) {
            if (is_numeric($value) && $value > 0) {
                $comma ? $uids .= "," : $comma = true;
                $uids .= $value;
            }
        }
        if ($trashed != 0 && $trashed != 1) {
            $trashed = 0;
        }
        $trashed == 0 ? $trashed = " is not true" : $trashed = " is true";
        $sql = "select o.uid, o.identifier, container_type_name as type_name,
		clp_classification as clp,
		label_id, 'container' as object_type,
		movement_date, movement_type_name, movement_type_id,
		o.wgs84_x as x, o.wgs84_y as y,
		'' as prj, '' as col,storage_product as prod,
        null as metadata,
        oc.identifier as container_identifier, container_uid, line_number, column_number,
        o.uuid, o.location_accuracy, o.object_comment
        ,null as country_code, null as country_name
        ,null as sampling_date, null as expiration_date
        ,trim (referent_name || ' ' || coalesce(referent_firstname, ' ')) as referent
		from object o
		join container using (uid)
		join container_type using (container_type_id)
		left outer join last_movement using (uid)
		left outer join movement_type using (movement_type_id)
        left outer join object oc on (container_uid = oc.uid)
        left outer join referent r on (o.referent_id = r.referent_id)
		where o.uid in ($uids) and o.trashed$trashed
		UNION
		select o.uid, o.identifier, sample_type_name as type_name, clp_classification as clp,
		label_id, 'sample' as object_type,
		movement_date, movement_type_name, movement_type_id,
		o.wgs84_x as x, o.wgs84_y as y,
		collection_name as prj, collection_name as col, storage_product as prod,
        metadata::varchar,
        oc.identifier as container_identifier, container_uid, line_number, column_number,
        o.uuid, o.location_accuracy, o.object_comment
        ,ctry.country_code2 as country_code, ctry.country_name
        ,sampling_date, expiration_date
        ,case when o.referent_id is not null then
        trim (sr.referent_name || ' ' || coalesce(sr.referent_firstname, ' '))
        else
        trim (cr.referent_firstname || ' ' || coalesce(cr.referent_firstname, ' '))
        end as referent
		from object o
		join sample using (uid)
		join collection c using (collection_id)
		join sample_type using (sample_type_id)
    left outer join sampling_place using (sampling_place_id)
		left outer join container_type using (container_type_id)
		left outer join last_movement using (uid)
		left outer join movement_type using (movement_type_id)
    left outer join object oc on (container_uid = oc.uid)
    left outer join country ctry on (sample.country_id = ctry.country_id)
    left outer join referent sr on (o.referent_id = sr.referent_id)
    left outer join referent cr on (c.referent_id = cr.referent_id)
		where o.uid in ($uids) and o.trashed$trashed
		";
        if (!empty($order)) {
            $sql = "select * from (" . $sql . ") as a";
            $order = " order by $order";
        }
        $this->dateFields[] = "sampling_date";
        $this->datefields[] = "expiration_date";
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
                    $comma ? $val .= "," : $comma = true;
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
            $oi = new ObjectIdentifier();
            $label = new Label();
            /**
             * Recuperation des donnees de l'etiquette
             */
            $fields = array();

            $dlabel = $label->readRaw($labelId);
            /**
             * Generate the logo
             */
            $this->logoFile = $this->temp . '/' . $dlabel["label_id"] . "-logo.png";
            if (!empty($dlabel["logo"])) {
                $flogo = fopen($this->logoFile, 'w');
                fwrite($flogo, pg_unescape_bytea($dlabel["logo"]));
                fclose($flogo);
            }
            /**
             * Instanciate code generators
             * QRcode
             */
            $qrcode = new QRCode;
            $qrcode2 = new QRCode;
            $options = new QROptions;
            /*$options->version             = 7;
            $options->outputInterface = \chillerlan\QRCode\Output\QRGdImagePNG::class;
            $options->outputBase64        = false;*/
            $this->barcode = new BarcodeGeneratorPNG;
            /**
             * Get the list of opticals
             */
            $optical = new LabelOptical;
            $opticals = $optical->getListForPrint($labelId);

            $APPLI_code = $_SESSION["dbparams"]["APPLI_code"];
            /**
             * Recuperation des informations generales
             */
            $sql = "select o.uid, identifier as id, clp_classification as clp, '' as pn,
                            '$APPLI_code' as db,
                            '' as col, '' as prj, storage_product as prod,
                            wgs84_x as x, wgs84_y as y, movement_date as cd,
                            null as sd, null as ed,
					        null as metadata, null as loc,
                            object_status_name as status, null as dbuid_origin,
                            null as pid,
                            uuid, null as ctry,
                            trim (referent_name || ' ' || coalesce(referent_firstname, ' ')) as ref,
                            lm.container_identifier as stor, lm.line_number as lnum, lm.column_number as cnum
                        from object o
                            join container using (uid)
                            join container_type using (container_type_id)
                            join object_status using (object_status_id)
                            left outer join last_movement lm on (o.last_movement_id = lm.movement_id)
                            left outer join referent using (referent_id)
                        where o.uid in ($uids)
                    UNION
                        select o.uid, o.identifier as id, clp_classification as clp, protocol_name as pn,
                            '$APPLI_code' as db,
                            collection_name as col, collection_name as prj, storage_product as prod,
                            o.wgs84_x as x, o.wgs84_y as y, s.sample_creation_date as cd,
                            s.sampling_date as sd,
                            s.expiration_date as ed,
					        s.metadata::varchar, sampling_place_name as loc,
                            os.object_status_name as status, s.dbuid_origin,
                            pso.identifier as pid,
                            o.uuid, ctry.country_code2 as ctry,
                            case when o.referent_id is not null then
                            trim (sr.referent_name || ' ' || coalesce(sr.referent_firstname, ' '))
                            else
                            trim (cr.referent_firstname || ' ' || coalesce(cr.referent_firstname, ' '))
                            end as ref,
                            container_identifier as stor, line_number as lnum, column_number as cnum
                        from object o
                                join sample s on (o.uid = s.uid)
                                join sample_type st on (s.sample_type_id = st.sample_type_id)
                                join collection c on (s.collection_id = c.collection_id)
					            join object_status os on (os.object_status_id = o.object_status_id)
					            left outer join sampling_place sp on (s.sampling_place_id = sp.sampling_place_id)
                                left outer join container_type using (container_type_id)
                                left outer join operation using (operation_id)
                                left outer join protocol using (protocol_id)
                                left outer join sample ps on (s.parent_sample_id = ps.sample_id)
                                left outer join object pso on (ps.uid = pso.uid)
                                left outer join country ctry on (s.country_id = ctry.country_id)
                                left outer join referent sr on (o.referent_id = sr.referent_id)
                                left outer join referent cr on (c.referent_id = cr.referent_id)
                                left outer join last_movement lm on (o.uid = lm.uid)
                        where o.uid in ($uids)
                        ";

            if (empty($order)) {
                $order = "uid";
            }
            $sql = "select * from (" . $sql . ") as a";
            $order = " order by $order";
            $data = $this->getListeParam($sql . $order);

            /**
             * Preparation du tableau de sortie
             * transcodage des noms de champ
             */
            /**
             * Recuperation de la liste des champs a inserer dans l'etiquette
             */
            $dataConvert = array();

            /**
             * Traitement de chaque ligne, et generation
             * du qrcode
             */
            foreach ($data as $row) {
                /**
                 * add the number of the label
                 */
                $row["label_id"] = $dlabel["label_id"];
                /**
                 * Generation du dbuid_origin si non existant
                 */
                if (empty($row["dbuid_origin"])) {
                    $row["dbuid_origin"] = $APPLI_code . ":" . $row["uid"];
                }
                /**
                 * Recuperation des identifiants complementaires
                 */
                $doi = $oi->getListFromUid($row["uid"]);
                foreach ($doi as $value) {
                    $row[$value["identifier_type_code"]] = $value["object_identifier_value"];
                }
                /**
                 * Recuperation des metadonnees associees
                 */
                $metadata = json_decode($row["metadata"], true);
                foreach ($metadata as $key => $value) {
                    // on remplace les espaces qui ne sont pas gérés par le xml
                    $newKey = str_replace(" ", "_", $key);
                    $row[$newKey] = $value;
                }
                /**
                 * Generation du qrcode
                 */
                $second = false;
                foreach ($opticals as $opt) {
                    $fields = explode(",", $opt["optical_content"]);
                    /**
                     * generate the content of the optical
                     */
                    $rowq = [];
                    foreach ($row as $k => $v) {
                        if (!empty($v) && in_array($k, $fields)) {
                            $rowq[$k] = $v;
                        }
                    }
                    $filename = $this->temp . '/' . $row["uid"];
                    if ($second) {
                        $filename .= "-2";
                    }
                    $filename .= ".png";
                    if ($opt["barcode_id"] == 1) {
                        //QRCODE
                        if (!$second) {
                            if ($opt["content_type"] == 2) {
                                $qrcode->render($opt["radical"] . $rowq[$opt["optical_content"]], $filename);
                            } else {
                                $qrcode->render(json_encode($rowq), $filename);
                            }
                        } else {
                            if ($opt["content_type"] == 2) {

                                $qrcode2->render($opt["radical"] . $rowq[$opt["optical_content"]], $filename);
                            } else {
                                $qrcode2->render(json_encode($rowq), $filename);
                            }
                        }

                        /*$imagick = new \Imagick;
                        $imagick->readImageBlob($qrcode);
                        $imagick->setformat("png");
                        file_put_contents($filename, $imagick->getImageBlob());*/
                    } else {
                        //EAN 128
                        try {
                            file_put_contents(
                                $filename,
                                $this->barcode->getBarcode($rowq[$opt["optical_content"]], $opt["barcode_code"])
                            );
                        } catch (BarcodeException $e) {
                            throw new PpciException($e->getMessage());
                        }
                    }
                    $second = true;
                }


                /**
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
     * @param string $batchdata
     * @return array
     */
    function batchRead($batchdata)
    {
        if (!empty($batchdata)) {
            //$batchdata = $this->encodeData($batchdata);
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
                    left outer join sample using (uid)";

            $whereIdent = " where upper(identifier) =  upper(:id:)
                    or upper(dbuid_origin) = upper (:id2:)
                    or (upper(object_identifier_value) = upper (:id1:)
                         and used_for_search = 't') ";
            $whereExterne = " where upper(dbuid_origin) = upper(:id:)";
            // $order = "";
            /*
             * Extraction des UID de chaque ligne scanee
             */
            $uids = array();
            $i = 1;
            foreach ($data as $value) {
                $uid = 0;
                /*
                 * Suppression des espaces
                 */
                $value = trim($value, " \t\n\r");
                $datajson = json_decode($value, true);
                if (is_array($datajson)) {
                    if ($datajson["uid"] > 0 && $datajson["db"] == $_SESSION["dbparams"]["APPLI_code"]) {
                        $uid = $datajson["uid"];
                    } else if ($datajson["uid"] > 0 && !empty($datajson["db"])) {
                        $valobject = $this->lireParamAsPrepared(
                            $sql . $whereExterne,
                            array(
                                "id" => $datajson["db"] . ":" . $datajson["uid"]
                            )
                        );
                        if ($valobject["uid"] > 0) {
                            $uid = $valobject["uid"];
                        }
                    }
                } else {
                    /*
                     * Recuperation de l'uid associe a l'identifier fourni
                     * (resultat d'un scan base sur l'identifiant metier)
                     */
                    $val = "";
                    if (!empty($value)) {
                        /*
                         * Recherche si la chaine commence par http
                         */
                        if (substr($value, 0, 4) == "http" || substr($value, 0, 3) == "htp") {
                            /*
                             * Extraction de la derniere valeur (apres le dernier /)
                             */
                            $aval = explode('/', $value);
                            $nbElements = count($aval);
                            if ($nbElements > 0) {
                                $val = $aval[($nbElements - 1)];
                            }
                        } else {
                            /*
                             * la chaine fournie est conservee telle quelle
                             */
                            $val = $value;
                            /*
                             * Recherche s'il s'agit d'un champ de type dbuid
                             * provenant de l'instance courante
                             */
                            $aval = explode(":", $value);
                            if (count($aval) == 2) {
                                if ($aval[0] == $_SESSION["dbparams"]["APPLI_code"]) {
                                    $uid = $aval[1];
                                }
                            }
                        }
                        $val = trim($val);
                        if (is_numeric($val)) {
                            $uid = $val;
                        }
                        if (!empty($val) && $uid == 0) {
                            $valobject = $this->lireParamAsPrepared(
                                $sql . $whereIdent,
                                array(
                                    "id" => $val,
                                    "id1" => $val,
                                    "id2" => $val
                                )
                            );
                            if ($valobject["uid"] > 0) {
                                $uid = $valobject["uid"];
                            }
                        }
                    }
                }
                if ($uid > 0) {
                    $uids[] = $uid;
                    // $order .= " when " . $uid . " then $i";
                    $i++;
                }
            }
            if (count($uids) > 0) {
                $data = array();
                foreach ($uids as $uid) {
                    $line = $this->getForList(
                        array(
                            $uid
                        )
                    );
                    $data[] = $line[0];
                }
                return $data;
            }
        }
    }

    function generatePdf($id)
    {
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
                    $doc = new \DOMDocument('1.0', 'utf-8');
                    $objects = $doc->createElement("objects");
                    foreach ($data as $object) {
                        $item = $doc->createElement("object");
                        foreach ($object as $key => $value) {
                            if (!empty($key) && (!empty($value) || ($value === false))) {
                                // cas des booléens
                                if ($value === true) {
                                    $elem = $doc->createElement($key, "true");
                                } elseif ($value === false) {
                                    $elem = $doc->createElement($key, "false");
                                } elseif (!is_array($value)) {
                                    $elem = $doc->createElement($key, $value);
                                } else {
                                    // Array : checkbox in metadata
                                    $elem = $doc->createElement($key, $value["value"]);
                                }

                                $item->appendChild($elem);
                            }
                        }
                        $objects->appendChild($item);
                    }
                    $doc->appendChild($objects);

                    if ($label_id > 0) {
                        $xmlfile = $this->temp . '/' . $xml_id . ".xml";
                        if (!$doc->save($xmlfile)) {
                            throw new PpciException("Impossible de générer le fichier XML");
                        }
                        if (!file_exists($xmlfile)) {
                            throw new PpciException("Impossible de générer le fichier XML");
                        }
                        /*
                         * Recuperation du fichier xsl
                         */
                        $xslfile = $this->temp . '/' . $label_id . ".xsl";
                        if (!file_exists($xslfile)) {
                            try {
                                $label = new Label;
                                $dataLabel = $label->lire($label_id);
                                $handle = fopen($xslfile, 'w');
                                fwrite($handle, $dataLabel["label_xsl"]);
                                fclose($handle);
                            } catch (\Exception $e) {
                                throw new PpciException($e->getMessage());
                            }
                        }
                        if (!file_exists($xslfile)) {
                            throw new PpciException("Impossible de générer le fichier xsl");
                        }
                        $this->xslFile = $xslfile;
                        /*
                         * Generation de la commande de creation du fichier pdf
                         */
                        $pdffile = $this->temp . '/' . $xml_id . ".pdf";
                        $command = $this->appConfig->fop . " -xsl $xslfile -xml $xmlfile -pdf $pdffile";
                        exec($command);
                        if (!file_exists($pdffile)) {
                            throw new PpciException("Fichier PDF non généré");
                        }
                    } else {
                        $this->message->set(_("Pas de modèle d'étiquettes disponible"));
                    }
                } catch (\Exception $e) {
                    $this->message->set("Erreur lors de la génération du fichier xml");
                    $this->message->setSyslog($e->getMessage());
                }
            } else {
                $this->message->set(_("Pas d'étiquettes à imprimer"));
            }
            if (empty($pdffile)) {
                throw new PpciException("Fichier PDF non généré");
            }
            return $pdffile;
        } else {
            throw new PpciException("Pas d'étiquette sélectionnée");
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
            unlink($path . "/" . $value["uid"] . "-2.png");
        }
    }

    /**
     * Supprime le fichier xsl, pour regeneration a la prochaine impression
     */
    function eraseXslfile()
    {
        unlink($this->xslFile);
        unlink($this->logoFile);
    }

    /**
     * Change the referent in an object
     *
     * @param int $uid
     * @param int $referent_id
     *
     * @return mixed
     */
    function setReferent($uid, $referent_id)
    {
        if ($uid > 0) {
            $data = array("uid" => $uid, "referent_id" => $referent_id);
            $this->ecrire($data);
        }
    }
    /**
     * Set the status for an object
     *
     * @param integer $uid
     * @param integer $status_id
     * @return void
     */
    function setStatus($uids, $status_id)
    {
        if (!is_array($uids)) {
            $uids = array($uids);
        }
        if (empty($status_id)) {
            throw new PpciException(_("Le statut n'a pas été fourni"));
        }
        foreach ($uids as $uid) {
            if (empty($uid)) {
                throw new PpciException(_("L'identifiant de l'objet n'a pas été fourni"));
            }
            $data = array("uid" => $uid, "object_status_id" => $status_id);
            $this->ecrire($data);
        }
    }
    /**
     * get the content of an object with its type (type_name)
     *
     * @param [type] $uid
     * @return void
     */
    function readWithType($id, $field = "uid")
    {
        if (in_array($field, ["uid", "uuid", "identifier"])) {
            $sql = "select uid, identifier, wgs84_x, wgs84_y, object_status_id, referent_id,
                case when sample_id > 0 then 'sample' else 'container' end as type_name,
                sample_id, container_id, uuid, location_accuracy, object_comment
                ,case when sample_id is not null then sample.collection_id else container.collection_id end as collection_id
                from object
                left outer join sample using (uid)
                left outer join container using (uid)
                where $field = :id:";
            return $this->lireParamAsPrepared($sql, array("id" => $id));
        } else {
            return [];
        }
    }
    /**
     * Set the trashed status for an object
     *
     * @param int $uid
     * @param integer $trashed
     * @return void
     */
    function setTrashed($uid, $trashed = 0)
    {
        $sql = "update object set trashed = :trashed: where uid = :uid:";
        $this->executeSQL($sql, array("uid" => $uid, "trashed" => $trashed), true);
    }

    /**
     * Search an object from uid, identifier or uuid
     *
     * @param [type] $uid
     * @param [type] $identifier
     * @param [type] $uuid
     * @return array
     */
    function search($uid = null, $identifier = null, $uuid = null): array
    {
        if (!$uid > 0 && empty($identifier) && empty($uuid)) {
            throw new PpciException(_("Aucun identifiant n'a été fourni pour rechercher l'objet"), 400);
        }
        $sql = "select uid, identifier, uuid, container_id, sample_id
            from object
            left outer join container using (uid)
            left outer join sample using (uid)
            where ";
        if ($uid > 0) {
            $sql .= " uid = :uid:";
            $param["uid"] = $uid;
        } else if (!empty($identifier)) {
            $sql .= " identifier = :identifier:";
            $param["identifier"] = $identifier;
        } else {
            $sql .= " uuid = :uuid:";
            $param["uuid"] = $uuid;
        }
        return $this->lireParamAsPrepared($sql, $param);
    }

    function setLastMovement(int $uid, int $movement_id)
    {
        $data = array(
            "uid" => $uid,
            "last_movement_id" => $movement_id
        );
        $this->ecrire($data);
    }

    public function verifyCollection($data)
    {
        $retour = false;
        if (empty($data["collection_id"])) {
            $retour = true;
        } else {
            foreach ($_SESSION["collections"] as $value) {
                if ($data["collection_id"] == $value["collection_id"]) {
                    $retour = true;
                    break;
                }
            }
        }
        return $retour;
    }
}
