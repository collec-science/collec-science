<?php
namespace Ppci\Models;
/**
 * Class for generate a identification token or read id
 *
 * Token is crypted with private key of server, and decrypted with public key
 * Token is encoded in JSON format. It contain 2 fields : login and expire (timestamp)
 * @author quinton
 *
 */

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
        if (!empty($privateKey)) {
            $this->privateKey = $privateKey;
        }
        if (!empty($pubKey) ) {
            $this->pubKey = $pubKey;
        }
        /*
         * Verification de l'existence des cles
         */
        foreach (array($this->privateKey, $this->pubKey) as $filename) {
            if (!file_exists($filename)) {
                throw new \Ppci\Libraries\PpciException("File $filename not readable");
            }
        }
    }

    /**
     *
     * @param string $login
     *            : login to transmit
     * @param $tokenExpire
     *            : duration of validity of the token (seconds)
     * @return string : encrypted and encoded token
     */
    function createToken($login, $validityDuration = 0)
    {
        if (!empty($login)) {
            if (is_numeric($validityDuration)) {
                $timestamp = time();
                $validityDuration > 0 ? $expire = $timestamp + $validityDuration : $expire = $timestamp + $this->validityDuration;
                $data = array(
                    "login" => $login,
                    "timestamp" => $timestamp,
                    "expire" => $expire,
                    "ip" => getIPClientAddress()
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
                        "timestamp" => $data["timestamp"],
                        "ip" => $data["ip"]
                    );
                    $token = json_encode($dataToken);
                } else {
                    throw new \Ppci\Libraries\PpciException("Encryption_token_not_realized");
                }
            } else {
                throw new \Ppci\Libraries\PpciException("validity duration not numeric : " . $validityDuration);
            }
        } else {
            throw new \Ppci\Libraries\PpciException("login_empty");
        }
        return $token;
    }

    /**
     * Decrypt a token, and extract the login
     *
     * @param string $token (json content)
     */
    function openToken($json)
    {
        $login = "";
        $token = json_decode($json, true);
        /*
         * decrypt token
         */
        if (!empty($token["token"])) {
            $key = $this->getKey("pub");
            try {
                if (openssl_public_decrypt(base64_decode($token["token"]), $decrypted, $key)) {
                    $data = json_decode($decrypted, true);

                    /**
                     * Verification of token content
                     */
                    if (!empty($data["login"]) > 0 && !empty($data["expire"]) && !empty($data["ip"])) {
                        /**
                         * Test IP address
                         */
                        if ($data["ip"] == getIPClientAddress()) {
                            $now = time();
                            /**
                             * test expire date
                             */
                            if ($data["expire"] > $now) {
                                $login = $data["login"];
                            } else {
                                throw new \Ppci\Libraries\PpciException('token_expired');
                            }
                        } else {
                            throw new \Ppci\Libraries\PpciException('IP_address_non_equivalent');
                        }
                    } else {
                        throw new \Ppci\Libraries\PpciException("parameter_into_token_absent");
                    }
                } else {
                    throw new \Ppci\Libraries\PpciException("token_cannot_be_decrypted");
                }
            } catch (\Exception $e) {
                throw new \Ppci\Libraries\PpciException("token_cannot_be_decrypted");
            }
        } else {
            throw new \Ppci\Libraries\PpciException("token_empty");
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
        if (!empty($jsonData)) {
            $token = json_decode($jsonData, true);
            return $this->openToken($token);
        }
        throw new \Ppci\Libraries\PpciException("Json file empty");
    }

    /**
     * return the content of the specified key
     *
     * @param string $type
     * @throws PpciException
     * @return string
     */
    private function getKey($type = "priv")
    {
        $contents = "";
        if ($type == "priv" || $type == "pub") {
            $type == "priv" ? $filename = $this->privateKey : $filename = $this->pubKey;
            if (file_exists($filename)) {
                $handle = fopen($filename, "r");
                if ($handle ) {
                    $contents = fread($handle, filesize($filename));
                    if (!$contents) {
                        throw new \Ppci\Libraries\PpciException("key " . $filename . " is empty");
                    }
                    fclose($handle);
                } else {
                    throw new \Ppci\Libraries\PpciException($filename . " could not be open");
                }
            } else {
                throw new \Ppci\Libraries\PpciException("key " . $filename . " not found");
            }
        } else {
            throw new \Ppci\Libraries\PpciException("open key : type not specified");
        }
        return $contents;
    }
}
