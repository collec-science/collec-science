<?php

/**
 * Created : 7 août 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
class PasswordException extends Exception
{
}

class Passwordlost extends ObjetBDD
{

    function __construct($bdd, $param = null)
    {
        $this->table = "passwordlost";
        $this->colonnes = array(
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
        parent::__construct($bdd, $param);
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
     * @throws Exception
     * @return array|string[]|NULL[]
     */
    function createTokenFromMail($mail, $duree_token = 7200)
    {
        $data = array();
        if (strlen($mail) > 0) {
            /*
             * Recherche de l'identifiant correspondant
             */
            require_once 'framework/identification/loginGestion.class.php';
            $lg = new LoginGestion($this->connection, $this->paramori);
            $dl = $lg->getFromMail($mail);
            if ($dl["id"] > 0) {
                global $log;
                if ($log->getLastConnexionType($dl["login"]) == "db") {
                    if ($dl["actif"] == 1) {
                        $this->auto_date = 0;
                        $data = array();
                        $data["id"] = $dl["id"];
                        $data["token"] = $this->generateToken();
                        $data["expiration"] = date(DATELONGMASK, time() + $duree_token);
                        $this->ecrire($data);
                    } else {
                        throw new PasswordException("Account not active");
                    }
                } else {
                    throw new PasswordException("Account not allowed to reset password");
                }
            } else {
                throw new PasswordException("Account not found from mail");
            }
        }
        return $data;
    }

    /**
     * Verification du token fourni, en gerant l'expiration ou l'utilisation
     *
     * @param string $token
     * @throws Exception
     * @return mixed
     */
    function verifyToken($token)
    {
        if (strlen($token) > 0) {
            $sql = "select passwordlost.*, login, actif ";
            $sql .= " from passwordlost ";
            $sql .= " join logingestion using (id)";
            $sql .= " where token = :token and expiration > :expiration";
            $sql .= " and usedate is null order by passwordlost_id desc limit 1";
            $data = $this->lireParamAsPrepared($sql, array(
                "token" => $token,
                "expiration" => date("Y-m-d H:i:s")
            ));
            
            if ($data["passwordlost_id"] > 0) {
                if ($data["actif"] == 0) {
                    throw new PasswordException("account desactivated");
                }
                return $data;
            } else {
                throw new PasswordException("token not found");
            }
        } else {
            throw new PasswordException("token empty");
        }
    }

    /**
     * Desactivation du token
     *
     * @param string $token
     */
    function disableToken($token)
    {
        $this->auto_date = 0;
        $data = $this->verifyToken($token);
        if ($data["passwordlost_id"] > 0) {
            $data["usedate"] = date("Y-m-d H:i:s", time());
            $this->ecrire($data);
        }
    }
}
?>