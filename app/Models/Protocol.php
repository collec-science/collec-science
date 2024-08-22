<?php

namespace App\Models;

use Ppci\Libraries\PpciException;
use Ppci\Models\PpciModel;

/**
 * Created : 13 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */

class Protocol extends PpciModel
{

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct()
    {
        $this->table = "protocol";
        $this->fields = array(
            "protocol_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "protocol_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "protocol_version" => array(
                "type" => 0,
                "requis" => 1,
                "defaultValue" => "1.0"
            ),
            "protocol_year" => array(
                "type" => 1
            ),
            "collection_id" => array(
                "type" => 1
            ),
            "authorization_number" => array(
                "type" => 0
            ),
            "authorization_date" => array(
                "type" => 2
            )
        );
        parent::__construct();
    }

    /**
     * Ecriture d'un document joint dans la base
     */
    function write_document($id, $file)
    {
        if ($file["error"] == 0 && $file["size"] > 0 && $id > 0 && is_numeric($id)) {

            $extension = substr($file["name"], strrpos($file["name"], ".") + 1);
            if (strtolower($extension) == "pdf") {
                if (!is_uploaded_file($file["tmp_name"])) {
                    throw new PpciException(_("Erreur technique : le fichier n'a pas été téléchargé correctement dans le serveur"));
                }
                /*
                 * Ecriture du fichier
                 */
                $fp = fopen($file['tmp_name'], 'rb');
                if (!$fp > 0) {
                    throw new PpciException(_("Erreur technique : le fichier téléchargé n'est pas accessible par l'application"));
                }
                try {
                    $this->updateBinaire($id, "protocol_file", $fp);
                } catch (\Exception $e) {
                    throw new PpciException($e->getMessage());
                }
            } else {
                throw new PpciException(_("Seuls les fichiers PDF peuvent être téléchargés"));
            }
        }
    }

    /**
     * Retourne le fichier contenant la reference de la description du protocole
     *
     * @param int $id
     * @return reference|NULL
     */
    function getProtocolFile($id)
    {
        if ($id > 0 && is_numeric($id)) {
            /*
             * Verification si l'utilisateur peut charger le fichier
             */
            if ($this->verifyCollection($this->lire($id))) {
                $ref = $this->getBlobReference($id, "protocol_file");
                if (!$ref) {
                    throw new PpciException(_("Pas de fichier à afficher"));
                } else {
                    return $ref;
                }
            } else {
                throw new PpciException(_("Droits insuffisants pour lire le fichier"));
            }
        }
    }
    /**
     * Delete the document attached to a protocol
     *
     * @param int $id
     * @return void
     */
    function documentDelete($id)
    {
        if ($this->verifyCollection($this->lire($id))) {
            $sql = "update protocol set protocol_file = null where protocol_id = :id:";
            $this->executeAsPrepared($sql, array("id" => $id));
        }
    }

    /**
     * Surcharge de getliste pour recuperer la presence ou non d'un fichier de description
     *
     * {@inheritdoc}
     * @see ObjetBDD::getListe()
     */
    function getListe($order = ""): array
    {
        $sql = "select protocol_id, protocol_name, protocol_version, protocol_year,
                authorization_number, authorization_date,
				case when protocol_file is null then 0 else 1 end as has_file,
                collection_name
				from protocol
                left outer join collection using (collection_id)";
        if (!empty($order)) {
            $sql .= " order by " . $order;
        }
        return $this->getListeParam($sql);
    }

    /**
     * Fonction permettant de verifier si le protocole fait partie des collections de
     * l'utilisateur
     *
     * @param array $data
     * @throws Exception
     * @return boolean
     */
    function verifyCollection($data)
    {
        $retour = false;
        if ($_SESSION["userRights"]["collection"] == 1) {
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
