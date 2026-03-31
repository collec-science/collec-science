<?php

namespace App\Models;

use Ppci\Libraries\PpciException;
use Ppci\Models\PpciModel;

/**
 * Created : 28 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class ObjectIdentifier extends PpciModel
{

    private $sql = "select object_identifier_id, uid, object_identifier_value, identifier_type_id,
					identifier_type_name, identifier_type_code, used_for_search
					from object_identifier
					join identifier_type using (identifier_type_id)";
    public Samplehisto $samplehisto;

    function __construct()
    {
        $this->table = "object_identifier";
        $this->fields = array(
            "object_identifier_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "uid" => array(
                "type" => 1,
                "requis" => 1,
                "parentAttrib" => 1
            ),
            "identifier_type_id" => array(
                "type" => 1,
                "requis" => 1
            ),
            "object_identifier_value" => array(
                "type" => 0,
                "requis" => 1
            )
        );
        parent::__construct();
    }
    function write(array $data): int
    {
        if (!isset($this->samplehisto)) {
            $this->samplehisto = new Samplehisto;
        }
        $this->samplehisto->initOldValues($data["uid"]);
        $id = parent::write($data);
        $this->samplehisto->generateHisto($data);
        return $id;
    }
    function writeOrReplace($data)
    {
        /*
         * Recherche si l'identifiant existe deja pour l'uid considere
         */
        if (empty($data["identifier_type_id"])) {
            if (empty($data["identifier_type_code"])) {
                throw new PpciException(sprintf(_("Il manque le code de l'identifiant secondaire pour pouvoir l'ajouter à l'échantillon %s"), $data["uid"]));
            }
            $identifierType = new IdentifierType;
            $data["identifier_type_id"] = $identifierType->getIdFromCode($data["identifier_type_code"]);
        }
        if (empty($data["identifier_type_id"])) {
            throw new PpciException(_("Le code de l'identifiant secondaire n'a pas été fourni, ou est inconnu dans la base de données"));
        }
        if (!isset($this->samplehisto)) {
            $this->samplehisto = new Samplehisto;
        }
        $this->samplehisto->initOldValues($data["uid"]);
        $sql = "select object_identifier_id from object_identifier where uid =:uid:
             and identifier_type_id = :typeid:";
        $dorigin = $this->lireParamAsPrepared($sql, array(
            "uid" => $data["uid"],
            "typeid" => $data["identifier_type_id"]
        ));
        if ($dorigin["object_identifier_id"] > 0) {
            $data["object_identifier_id"] = $dorigin["object_identifier_id"];
        }
        $ret = $this->ecrire($data);
        $this->samplehisto->generateHisto($data);
        return $ret;
    }

    function delete($id = null, bool $purge = false)
    {
        if (!isset($this->samplehisto)) {
            $this->samplehisto = new Samplehisto;
        }
        /**
         * get uid
         */
        $sql = "select uid from object_identifier where object_identifier_id = :id:";
        $res = $this->readParam($sql, ["id" => $id]);
        $this->samplehisto->initOldValues($res["uid"]);
        parent::delete($id);
        $this->samplehisto->generateHisto($res);
    }

    /**
     * Retourne la liste des identifiants secondaires associes a un UID
     *
     * @param int $uid
     */
    function getListFromUid(int $uid)
    {
        if ($uid > 0) {
            $data["uid"] = $uid;
            $where = " where uid = :uid:";
            return $this->getListeParamAsPrepared($this->sql . $where, $data);
        }
    }

    function getIdentifiers(int $uid): string
    {
        $sql = "SELECT array_to_string (array_agg(identifier_type_code || ':'|| object_identifier_value order by identifier_type_code, object_identifier_value), ',') as identifiers
                from object_identifier
                join identifier_type using (identifier_type_id)
                where uid = :uid:
                group by uid";
        $row = $this->readParam($sql, ["uid" => $uid]);
        $ids = $row["identifiers"];
        if (is_null($ids)) {
            $ids = "";
        }
        return $ids;
    }
}
