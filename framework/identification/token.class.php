<?php

/**
 * Class for generate a identification token or read id
 * 
 * Token is crypted with private key of server, and decrypted with public key
 * Token is encoded in JSON format. It contain 2 fields : login and expire (timestamp)
 * @author quinton
 *
 */
class TokenException extends Exception
{
}

class Token
{

    private $privateKey = "/etc/ssl/private/ssl-cert-snakeoil.key";

    private $pubKey = "/etc/ssl/certs/ssl-cert-snakeoil.pem";

    /**
     * validityDuration : default duration validity of the token
     * 
     * @var int
     */
    private $validityDuration = 86400;

    /**
     * Constructor
     *
     * @param string $privateKey
     *            : private key used for encoding
     * @param string $pubKey
     *            : public key used for decoding
     */
    function __construct($privateKey = "", $pubKey = "")
    {
        if (strlen($privateKey) > 0) {
            $this->privateKey = $privateKey;
        }
        if (strlen($pubKey) > 0) {
            $this->pubKey = $pubKey;
        }
        /*
         * Verification de l'existence des cles
         */
        foreach(array($this->privateKey,$this->pubKey) as $filename) {
            if (! file_exists($filename)) {
                throw new TokenException("File $filename not readable");
            }
        }
    }

    /**
     *
     * @param string $login
     *            : login to transmit
     * @param timestamp $tokenExpire
     *            : duration of validity of the token (seconds)
     * @return String : encrypted and encoded token
     */
    function createToken($login, $validityDuration = 0)
    {
        if (strlen($login) > 0) {
            if (is_numeric($validityDuration)) {
                $timestamp = time();
                $validityDuration > 0 ? $expire = $timestamp + $validityDuration : $expire = $timestamp + $this->validityDuration;
                $data = array(
                    "login" => $login,
                    "timestamp" => $timestamp,
                    "expire" => $expire
                );
                /*
                 * create json file
                 */
                $tokenJSON = json_encode($data);
                $key = $this->getKey("priv");
                if (openssl_private_encrypt($tokenJSON, $crypted, $key)) {
                    /*
                     * prepare file with base64 encoding
                     */
                    $dataToken = array(
                        "token" => base64_encode($crypted),
                        "expire" => $expire,
                        "timestamp" => $data["timestamp"]
                    );
                    $token = json_encode($dataToken);
                } else {
                    throw new TokenException("Encryption_token_not_realized");
                }
            } else {
                throw new TokenException("validity duration not numeric : " . $validityDuration);
            }
        } else {
            throw new TokenException("login_empty");
        }
        return $token;
    }

    /**
     * Decrypt a token, and extract the login
     *
     * @param json $token
     */
    function openToken($json)
    {
       $token = json_decode($json, true);
        /*
         * decrypt token
         */
        if (strlen($token["token"]) > 0) {
            $key = $this->getKey("pub");
            if (openssl_public_decrypt(base64_decode($token["token"]), $decrypted, $key)) {
                $data = json_decode($decrypted, true);
                /*
                 * Verification of token content
                 */
                if (strlen($data["login"]) > 0 && strlen($data["expire"]) > 0) {
                    $now = time();
                    /*
                     * test expire date
                     */
                    if ($data["expire"] > $now) {
                        $login = $data["login"];
                    } else {
                        throw new TokenException('token_expired');
                    }
                } else {
                    throw new TokenException("parameter_into_token_absent");
                }
            } else {
                throw new TokenException("token_cannot_be_decrypted");
            }
        } else {
            throw new TokenException("token_empty");
        }
        return $login;
    }

    /**
     * Read a token encapsuled into json file
     *
     * @param string $jsonData
     * @throws Exception
     * @return array
     */
    function openTokenFromJson($jsonData)
    {
        if (strlen($jsonData) > 0) {
            $token = json_decode($jsonData, true);
            return $this->openToken($token);
        }
        throw new TokenException("Json file empty");
    }

    /**
     * return the content of the specified key
     *
     * @param string $type
     * @throws Exception
     * @return string
     */
    private function getKey($type = "priv")
    {
        $contents = "";
        if ($type == "priv" || $type == "pub") {
            $type == "priv" ? $filename = $this->privateKey : $filename = $this->pubKey;
            if (file_exists($filename)) {
                $handle = fopen($filename, "r");
                if ($handle != false) {
                    $contents = fread($handle, filesize($filename));
                    if (! $contents) {
                        throw new TokenException("key " . $filename . " is empty");
                    }
                    fclose($handle);
                } else {
                    throw new TokenException($filename . " could not be open");
                }
            } else {
                throw new TokenException("key " . $filename . " not found");
            }
        } else {
            throw new TokenException("open key : type not specified");
        }
        return $contents;
    }
}