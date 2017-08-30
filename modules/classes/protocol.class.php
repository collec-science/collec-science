<?php

/**
 * Created : 13 sept. 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class ProtocolException extends Exception
{
}

class Protocol extends ObjetBDD
{

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "protocol";
        $this->colonnes = array(
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
            "project_id" => array(
                "type" => 1
            )
        );
        parent::__construct($bdd, $param);
    }

    function ecrire_document($id, $file)
    {
        if ($file["error"] == 0 && $file["size"] > 0 && $id > 0 && is_numeric($id)) {
            
            $extension = substr($file["name"], strrpos($file["name"], ".") + 1);
            if (strtolower($extension) == "pdf") {
                /*
                 * Verification antivirale
                 */
                testScan($file["tmp_name"]);
                /*
                 * Ecriture du fichier
                 */
                $fp = fopen($file['tmp_name'], 'rb');
                $this->updateBinaire($id, "protocol_file", $fp);
            } else
                throw new FileException("Seuls les fichiers PDF peuvent être téléchargés");
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
            if ($this->verifyProject($this->lire($id))) {
                $ref = $this->getBlobReference($id, "protocol_file");
                if (! $ref) {
                    throw new ProtocolException("Pas de fichier à afficher");
                } else {
                    return $ref;
                }
            } else {
                throw new ProtocolException("Droits insuffisants pour lire le fichier");
            }
        }
    }

    /**
     * Surcharge de getliste pour recuperer la presence ou non d'un fichier de description
     *
     * {@inheritdoc}
     * @see ObjetBDD::getListe()
     */
    function getListe($order)
    {
        $sql = "select protocol_id, protocol_name, protocol_version, protocol_year,
				case when protocol_file is null then 0 else 1 end as has_file,
                project_name
				from protocol
                left outer join project using (project_id)";
        if (strlen($order) > 0) {
            $sql .= " order by " . $this->encodeData($order);
        }
        return $this->getListeParam($sql);
    }

    /**
     * Fonction permettant de verifier si le protocole fait partie des projets de
     * l'utilisateur
     *
     * @param array $data
     * @throws Exception
     * @return boolean
     */
    function verifyProject($data)
    {
        $retour = false;
        if ($_SESSION["droits"]["project"] == 1) {
            $retour = true;
        } else {
            foreach ($_SESSION["projects"] as $value) {
                if ($data["project_id"] == $value["project_id"]) {
                    $retour = true;
                    break;
                }
            }
        }
        return $retour;
    }
}
?>