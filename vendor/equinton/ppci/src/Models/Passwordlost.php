<?php
namespace Ppci\Models;

/**
 * Created : 7 août 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */


class Passwordlost extends PpciModel
{

    function __construct()
    {
        $this->table = "passwordlost";
        $this->fields = array(
            "passwordlost_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "id" => array(
                "type" => 1,
                "requis" => 1,
                "parentAttrib" => 1
            ),
            "token" => array(
                "requis" => 1
            ),
            "expiration" => array(
                "type" => 3,
                "requis" => 1
            ),
            "usedate" => array(
                "type" => 3
            )
        );
        parent::__construct();
    }

    function generateToken(int $size = 64)
    {
        return bin2hex(openssl_random_pseudo_bytes($size));
    }

    /**
     * Cree un token de renouvellement du mot de passe
     *
     * @param string $mail
     * @param number $duree_token
     * @throws PpciException
     * @return array|string[]|NULL[]
     */
    function createTokenFromMail($mail, $duree_token = 7200)
    {
        $data = array();
        if (!empty($mail) ) {
            /*
             * Recherche de l'identifiant correspondant
             */
            $lg = new LoginGestion();
            $dl = $lg->getFromMail($mail);
            if ($dl["id"] > 0) {
                $log = service ("Log");
                if ($log->getLastConnexionType($dl["login"]) == "db") {
                    if ($dl["actif"] == 1) {
                        $this->autoFormatDate = 0;
                        $data = array();
                        $data["id"] = $dl["id"];
                        $data["token"] = $this->generateToken();
                        printA($_SESSION["date"]["datemasklong"]);
                        printA(time() + $duree_token);
                        $data["expiration"] = date("Y-m-d H:i:s", time() + $duree_token);
                        $this->ecrire($data);
                    } else {
                        throw new \Ppci\Libraries\PpciException(_("Le compte n'est pas actif"));
                    }
                } else {
                    throw new \Ppci\Libraries\PpciException(_("Le compte n'est pas autorisé à réinitialiser son mot de passe, la dernière connexion réussie n'ayant pas été réalisée dans un mode compatible"));
                }
            } else {
                throw new \Ppci\Libraries\PpciException(_("Aucun compte n'a été trouvé pour le mail considéré"));
            }
        }else {
            throw new \Ppci\Libraries\PpciException(_("Le mail n'a pas été renseigné"));
        }
        return $data;
    }

    /**
     * Verification du token fourni, en gerant l'expiration ou l'utilisation
     *
     * @param string $token
     * @throws PpciException
     * @return mixed
     */
    function verifyToken($token)
    {
        if (!empty($token)) {
            $sql = "select passwordlost.*, login, actif 
             from passwordlost 
             join logingestion using (id)
             where token = :token: and expiration > :expiration:
              and usedate is null order by passwordlost_id desc limit 1";
            $data = $this->lireParamAsPrepared($sql, array(
                "token" => $token,
                "expiration" => date("Y-m-d H:i:s")
            ));

            if ($data["passwordlost_id"] > 0) {
                if ($data["actif"] == 0) {
                    throw new \Ppci\Libraries\PpciException("account desactivated");
                }
                return $data;
            } else {
                throw new \Ppci\Libraries\PpciException("token not found");
            }
        } else {
            throw new \Ppci\Libraries\PpciException("token empty");
        }
    }

    /**
     * Desactivation du token
     *
     * @param string $token
     */
    function disableToken($token)
    {
        $this->autoFormatDate = 0;
        $data = $this->verifyToken($token);
        if ($data["passwordlost_id"] > 0) {
            $data["usedate"] = date("Y-m-d H:i:s", time());
            $this->ecrire($data);
        }
    }
}
