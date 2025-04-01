<?php
namespace Ppci\Models;

use Config\App;
use OTPHP\TOTP;
use chillerlan\QRCode\QRCode as QRCodeQRCode;

/**
 * Management of TOTP identification
 */
class Gacltotp
{
    private $otp;
    private $privateKey = "/etc/ssl/private/ssl-cert-snakeoil.key";
    private $pubKey = "/etc/ssl/certs/ssl-cert-snakeoil.pem";

    function __construct($privateKey = "", $pubKey = "")
    {
        if (!empty($privateKey)) {
            $this->privateKey = $privateKey;
        }
        if (!empty($pubKey)) {
            $this->pubKey = $pubKey;
        }
        /**
         * Verify if the keys are readable
         */
        foreach (array($this->privateKey, $this->pubKey) as $filename) {
            if (!file_exists($filename)) {
                throw new \Ppci\Libraries\PpciException("File $filename not readable");
            }
        }
    }
    /**
     * Create the secret for a new identification
     *
     * @return void
     */
    function createSecret(): string
    {
        if (!isset($this->otp)) {
            $this->otp = TOTP::create();
        }
        return $this->otp->getSecret();
    }

    /**
     * Generate the QRCODE to display on the screen
     *
     */
    function createQrCode($secret = null)
    {
        if (!empty($secret)) {
            $this->otp = TOTP::create($secret);
        }
        $this->otp->setLabel($_SESSION["login"]);
        $dbparam = service("Dbparam");
        $this->otp->setIssuer($dbparam->getParam("otp_issuer"));
        /**
         * @var App
         */
        $paramApp = config("App");
        $filename = $paramApp->APP_temp . "/" . $_SESSION["login"] . "_totp.png";
        $qrcode = new QRCodeQRCode();
        $qrcode->render($this->otp->getProvisioningUri(), $filename);
    }
    /**
     * Verify the otp code
     *
     * @param string $secret
     * @param string $otpcode
     * @return boolean
     */
    function verifyOtp(string $secret, string $otpcode): bool
    {
        $this->otp = TOTP::create($secret);
        return $this->otp->verify($otpcode);
    }

    /**
     * Encode the secret key
     *
     * @param string $key
     * @return string
     */
    function encodeTotpKey(string $key): string
    {
        if (openssl_public_encrypt($key, $crypted, $this->getKey("pub"), OPENSSL_PKCS1_OAEP_PADDING)) {
            $encodedKey = base64_encode($crypted);
        } else {
            throw new \Ppci\Libraries\PpciException(_("Une erreur est survenue pendant le chiffrement de la clé secrète"));
        }
        return $encodedKey;
    }
    /**
     * Decode the secret key
     *
     * @param string $key
     * @return string
     */
    function decodeTotpKey(string $key): string
    {
        if (openssl_private_decrypt(base64_decode($key), $decrypted, $this->getKey("priv"), OPENSSL_PKCS1_OAEP_PADDING)) {
            return $decrypted;
        } else {
            throw new \Ppci\Libraries\PpciException(_("Une erreur est survenue pendant le déchiffrement de la clé secrète"));
        }
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
                if ($handle) {
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
    /**
     * Encode a content with the public (pub) or private (priv) key
     *
     * @param [type] $content in json or other
     * @param [type] $keyType
     * @return string (base_64 encrypted)
     */
    public function encode($content, $keyType)
    {
        if ($keyType == "priv") {
            if (openssl_private_encrypt($content, $crypted, $this->getKey("priv"))) {
            } else {
                throw new \Ppci\Libraries\PpciException(_("Une erreur est survenue pendant le chiffrement"));
            }
        } else {
            if (openssl_public_encrypt($content, $crypted, $this->getKey("pub"))) {
            } else {
                throw new \Ppci\Libraries\PpciException(_("Une erreur est survenue pendant le chiffrement"));
            }
        }
        return base64_encode($crypted);
    }
    /**
     * Decrypt a content with public (pub) or private (priv) key
     *
     * @param [type] $crypted in format base64
     * @param [type] $keyType
     * @return string (json)
     */
    public function decode($crypted, $keyType)
    {
        $crypted = base64_decode($crypted);
        if ($keyType == "priv") {
            if (openssl_private_decrypt($crypted, $decrypted, $this->getKey("priv"))) {
            } else {
                throw new \Ppci\Libraries\PpciException(_("Une erreur est survenue pendant le déchiffrement"));
            }
        } else {
            if (openssl_public_decrypt($crypted, $decrypted, $this->getKey("pub"))) {
            } else {
                throw new \Ppci\Libraries\PpciException(_("Une erreur est survenue pendant le déchiffrement"));
            }
        }
        return $decrypted;
    }
}
