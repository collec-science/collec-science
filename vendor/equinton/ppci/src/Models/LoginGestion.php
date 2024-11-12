<?php
namespace Ppci\Models;

use Config\App;
use ZxcvbnPhp\Zxcvbn;
use Ppci\Config\SmartyParam;
use Ppci\Libraries\Mail;
use Ppci\Libraries\PpciException;

/**
 * Classe permettant de manipuler les logins stockés en base de données locale
 */
class LoginGestion extends PpciModel
{
    private $privateKey = "/etc/ssl/private/ssl-cert-snakeoil.key";
    private $publicKey = "/etc/ssl/certs/ssl-cert-snakeoil.pem";
    public $nbattempts = 2;
    public $attemptdelay = 6;
    /**
     * Instance Ppci Mail
     *
     * @var Mail
     */
    public $mail;
    /**
     * instance App parameters
     *
     * @var App
     */
    public $paramApp;


    public function __construct()
    {
        $this->table = "logingestion";
        $this->fields = array(
            "id" => array(
                "type" => 1,
                "key" => 1,
                "defaultValue" => 0
            ),
            "datemodif" => array(
                "type" => 3,
                "defaultValue" => date($this->datetimeFormat),
            ),
            "mail" => array(
                "pattern" => "#^.+@.+\.[a-zA-Z]{2,6}$#",
            ),
            "login" => array(
                'requis' => 1,
            ),
            "nom" => array(
                "type" => 0,
            ),
            "prenom" => array(
                "type" => 0,
            ),
            "actif" => array(
                'type' => 1,
                'defaultValue' => 1,
            ),
            "password" => array(
                'type' => 0,
                'longueur' => 256,
            ),
            "is_clientws" => array(
                "type" => 1,
                "defaultValue" => '0',
            ),
            "tokenws" => array(
                'type' => 0,
            ),
            "is_expired" => array(
                "type" => 1,
                "defaultValue" => "0"
            ),
            "nbattempts" => array("type" => 1),
            "lastattempt" => array("type" => 3)
        );
        /**
         * @var App
         */
        $this->paramApp = config("App");
        $this->privateKey = $this->paramApp->privateKey;
        $this->publicKey = $this->paramApp->pubKey;
        parent::__construct();
    }

    function setKeys(string $privateKey, string $publicKey): void
    {
        $this->privateKey = $privateKey;
        $this->publicKey = $publicKey;
    }

    /**
     * Vérification du login en mode base de données
     *
     * @param string $login
     * @param string $password
     * @return boolean
     */
    public function controlLogin($login, $password)
    {
        $log = service("Log");
        $passwordok = false;
        $tests = true;
        $login = strtolower($login);
        if (!empty($login) && !empty($password)) {
            $sql = "select id, login, password, nbattempts, lastattempt, is_expired from LoginGestion where login = :login: and actif = 1";
            $this->autoFormatDate = false;
            $data = $this->lireParamAsPrepared($sql, array("login" => $login));
            if (!$data["id"] > 0) {
                $tests = false;
            }
            /**
             * Verify if the number of attempts is reached
             */
            if ($tests && $data["nbattempts"] >= $this->nbattempts && !empty($data["lastattempt"])) {
                $lastdate = strtotime($data["lastattempt"]) + $this->attemptdelay;
                if ($lastdate > time()) {
                    $this->addAttempt($data["id"]);
                    $tests = false;
                }
            }
            if ($tests) {
                /**
                 * Test the password
                 */
                if ($this->_testPassword($login, $password, $data["password"])) {
                    $passwordok = true;
                    $this->resetAttempt($data["id"]);
                } else {
                    $this->addAttempt($data["id"]);
                }
            }
        }
        if (!$passwordok) {
            $log->setLog($login, "connection-db", "ko");
        }
        return $passwordok;
    }
    function addAttempt($id)
    {
        $sql = "update logingestion set nbattempts = nbattempts + 1,
                lastattempt = now()
                where id = :id:";
        $this->executeQuery($sql, array("id" => $id), true);
    }
    function resetAttempt($id)
    {
        $sql = "update logingestion set nbattempts = 0, lastattempt = null
        where id = :id:";
        $this->executeQuery($sql, array("id" => $id), true);
    }

    /**
     * verify the password
     *
     * @param string $login
     * @param string $password
     * @param string $hash
     * @return boolean
     */
    private function _testPassword($login, $password, $hash)
    {
        $login = strtolower($login);
        $ok = false;
        /**
         * Test the type of hash
         */
        $pinfo = password_get_info($hash);
        if ($pinfo["algo"] > 0) {
            $ok = password_verify("$password", $hash);
        } else {
            /**
             * old hash algorithm
             */
            $newHash = hash("sha256", $password . $login);
            if ($newHash == $hash) {
                $ok = true;
            }
        }
        if ($ok) {
            /**
             * Verify if the account is not expired
             */
            $log = service("Log");
            $this->autoFormatDate = false;
            $data = $this->getFromLogin($login);
            $this->autoFormatDate = true;
            $nb = $log->countNbExpiredConnectionsFromDate($login, $data["datemodif"]);
            if ($nb > 0) {
                $message = service("MessagePpci");
                if ($nb > 3) {
                    $message->set(_("Votre mot de passe a expiré. Veuillez contacter l'administrateur de l'application pour le renouveler"), true);
                    $ok = false;
                } else {
                    $message->set(_("Votre mot de passe va expirer. Veuillez le changer immédiatement"), true);
                }
            }
        }
        return $ok;
    }

    /**
     * Recupere le login a partir d'un jeton pour les services web
     *
     * @param string $token
     * @return bool
     */
    public function getLoginFromTokenWS($login, $token)
    {
        $retour = false;
        if (!empty($token) && !empty($login)) {
            $sql = "select tokenws from logingestion where is_clientws = '1' and actif = '1'
            and login = :login:";
            $data = $this->lireParamAsPrepared(
                $sql,
                array(
                    "login" => $login
                )
            );
            /**
             * decode the token
             */
            if (
                openssl_private_decrypt(
                    base64_decode($data["tokenws"]),
                    $decrypted,
                    $this->getKey("priv"),
                    OPENSSL_PKCS1_OAEP_PADDING
                ) && $decrypted == $token
            ) {
                $retour = true;
            }
        }
        return $retour;
    }

    /**
     * Retourne la liste des logins existants, triee par nom-prenom
     *
     * @return array
     */
    public function getListeTriee()
    {
        $sql = "select id,l.login,nom,prenom,mail,actif, is_clientws,
                nbattempts, lastattempt
                from logingestion l";
        return $this->getListeParam($sql);
    }

    /**
     * Preparation de la mise en table, avec verification du mot de passe
     * (non-PHPdoc)
     *
     * @see ObjetBDD::ecrire()
     */
    public function write(array $data): int
    {
        if ($data["id"] > 0) {
            $dataBefore = $this->lire($data["id"]);
        }
        if (!empty($data["pass1"]) && !empty($data["pass2"]) && $data["pass1"] == $data["pass2"]) {
            if ($this->controleComplexite($data["pass1"]) > 2 && strlen($data["pass1"]) > 9) {
                $data["password"] = $this->_encryptPassword($data["pass1"]);
                $data["is_expired"] = 1;
            } else {
                throw new \Ppci\Libraries\PpciException(_("Mot de passe insuffisamment complexe ou trop petit"));
            }
        }
        $data["datemodif"] = date($_SESSION["date"]["maskdatelong"]);
        $data["login"] = strtolower($data["login"]);
        /*
         * Traitement de la generation du token d'identification ws
         */
        if ($data["is_clientws"] == 1) {
            if (empty($data["tokenws"])) {
                $token = bin2hex(openssl_random_pseudo_bytes(32));
                if (openssl_public_encrypt($token, $crypted, $this->getKey("pub"), OPENSSL_PKCS1_OAEP_PADDING)) {
                    $data["tokenws"] = base64_encode($crypted);
                } else {
                    $this->message->set(_("Une erreur est survenue pendant le chiffrement du jeton d'identification, qui n'a pas pu être mis à jour"), true);
                    unset ($data["tokenws"]);
                }
            } else {
                /**
                 * unset the token, to avoid the storage
                 */
                unset($data["tokenws"]);
            }
        }
        if ($data["resetattempts"] == 1) {
            $data["nbattempts"] = 0;
            $data["lastattempt"] = "";
        }
        $id = parent::write($data);
        if ($data["id"] > 0 && $dataBefore["actif"] == 0 && $data["actif"] == 1 && !empty($data["mail"])) {
            /**
             * Send mail to prevent of the activation of the account
             */
            if ($this->paramApp->MAIL_enabled == 1) {
                /**
                 * Send a mail
                 */
                if (!isset($this->mail)) {
                    $this->mail = new Mail($this->paramApp->MAIL_param);
                }
                $APPLI_address = "https://" . $_SERVER["HTTP_HOST"];
                $subject = $_SESSION["dbparams"]["APPLI_title"] . " - " . _("Activation de votre compte");
                $this->mail->SendMailSmarty(
                    $data["mail"],
                    $subject,
                    "ppci/mail/accountActivate.tpl",
                    array(
                        "prenom" => $data["prenom"],
                        "nom" => $data["nom"],
                        "applicationName" => $_SESSION["dbparams"]["APPLI_title"],
                        "APPLI_address" => $APPLI_address
                    )
                );
                $this->message->set(_("Un message vient d'être envoyé à l'utilisateur pour l'informer de l'activation de son compte"));
            }
        }
        return $id;
    }

    function read(int $id, bool $getDefault = true, $parentValue = 0): array
    {
        $data = parent::read($id, $getDefault, $parentValue);
        if (!empty($data["tokenws"])) {
            /**
             * decode the token
             */
            if (openssl_private_decrypt(base64_decode($data["tokenws"]), $decrypted, $this->getKey("priv"), OPENSSL_PKCS1_OAEP_PADDING)) {
                $data["tokenws"] = $decrypted;
            } else {
                $this->message->set(_("Une erreur est survenue pendant le déchiffrement du jeton d'identification"),true);
                $data["tokenws"] = "";
            }
        }
        return $data;
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
            $type == "priv" ? $filename = $this->privateKey : $filename = $this->publicKey;
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

    function getDbconnectProvisionalNb($login)
    {
        $login = strtolower($login);
        $sql = "select count(*) as dbconnect_provisional_nb
        from logingestion l
        join log on (l.login = log.login and log_date > datemodif
                       and commentaire = 'db-ok-expired')
        where l.login = :login:";
        $result = $this->lireParamAsPrepared($sql, array("login" => $login));
        $result["dbconnect_provisional_db"] > 0 ? $val = $result["dbconnect_provisional_db"] : $val = 0;
        return $val;
    }

    /**
     * Surcharge de la fonction supprimer pour effacer les traces des anciens mots de passe
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::supprimer()
     */
    public function supprimer($id)
    {
        $data = $this->lire($id);
        if (parent::supprimer($id) > 0) {
            /*
             * Recherche si un enregistrement existe dans la gestion des droits
             */
            $acllogin = new Acllogin();
            $datalogin = $acllogin->getFromLogin($data["login"]);
            if ($datalogin["acllogin_id"] > 0) {
                $acllogin->supprimer($datalogin["acllogin_id"]);
            }
        }
    }

    public function getFromLogin($login)
    {
        $login = strtolower($login);
        if (!empty($login)) {
            $sql = "select * from logingestion where login = :login:";
            return $this->lireParamAsPrepared($sql, array("login" => $login));
        } else {
            return [];
        }
    }

    /**
     * Fonction de validation de changement du mot de passe
     *
     * @param string $oldpassword
     * @param string $pass1
     * @param string $pass2
     * @return boolean
     */
    public function changePassword($oldpassword, $pass1, $pass2)
    {
        if (isset($_SESSION["login"])) {
            $oldData = $this->lireByLogin($_SESSION["login"]);
            $log = new Log();
            if ($log->getLastConnexionType($_SESSION["login"]) == "db") {
                if ($this->_testPassword($_SESSION["login"], $oldpassword, $oldData["password"])) {
                    /*
                     * Verifications de validite du mot de passe
                     */
                    if ($this->_passwordVerify($pass1, $pass2)) {
                        $this->writeNewPassword($_SESSION["login"], $pass1);
                    } else {
                        throw new PpciException(_("La modification du mot de passe a échoué"));
                    }
                } else {
                    throw new PpciException(_("L'ancien mot de passe est incorrect"));
                }
            } else {
                throw new PpciException(_("Le mode d'identification utilisé pour votre compte n'autorise pas la modification du mot de passe depuis cette application"));
            }
        }
    }

    /**
     * Declenche le changement de mot de passe apres perte
     *
     * @param string $login
     * @param string $pass1
     * @param string $pass2
     * @return boolean
     */
    public function changePasswordAfterLost($login, $pass1, $pass2)
    {
        if (!empty($login) && $this->_passwordVerify($pass1, $pass2)) {
            $this->writeNewPassword($login, $pass1);
        } else {
            throw new PpciException(_("Le mot de passe que vous avez indiqué n'est pas assez complexe, ou un problème est survenu lors de l'enregistrement"));
        }
    }

    /**
     * Ecrit le nouveau mot de passe en base de donnees
     *
     * @param string $login
     * @param string $pass
     * @return boolean
     */
    private function writeNewPassword($login, $pass)
    {

        $log = service("Log");
        $message = service("MessagePpci");
        $APPLI_address = "https://" . $_SERVER["HTTP_HOST"];
        $login = strtolower($login);
        $retour = false;
        $oldData = $this->lireByLogin($login);
        if ($log->getLastConnexionType($login) == "db") {
            $data = $oldData;
            $data["password"] = $this->_encryptPassword($pass);
            $this->autoFormatDate = false;
            $data["datemodif"] = date("Y-m-d");
            $data["is_expired"] = 0;
            if ($this->ecrire($data) > 0) {
                $this->autoFormatDate = true;
                $retour = true;
                $log->setLog($login, "password_change", "ip:" . $_SESSION["remoteIP"]);
                $message->set(_("Le mot de passe a été modifié"));
            } else {
                $message->set(_("Echec de la modification du mot de passe pour une raison inconnue. Si le problème persiste, contactez l'assistance"), true);
            }
        } else {
            $message->set(_("Le mode d'identification utilisé pour votre compte n'autorise pas la modification du mot de passe depuis cette application"), true);
        }
        return $retour;
    }

    /**
     * Generate hash for password
     *
     * @param [string] $pass
     * @return string
     */
    private function _encryptPassword($pass)
    {
        return password_hash($pass, PASSWORD_BCRYPT, array("cost" => 13));
    }

    /**
     * Fonction verifiant la validite du mot de passe fourni,
     * avant changement
     *
     * @param string $login
     * @param string $pass1
     * @param string $pass2
     * @return boolean
     */
    private function _passwordVerify($pass1, $pass2)
    {
        $message = service("MessagePpci");
        $ok = false;
        /*
         * Verification que le mot de passe soit identique
         */
        if ($pass1 == $pass2) {
            /*
             * Verification de la longueur - minimum : 10 caracteres
             */
            if (strlen($pass1) >= $this->paramApp->APP_passwordMinLength) {
                /*
                 * Verification de la complexite du mot de passe
                 */
                if ($this->controleComplexite($pass1) >= 3) {
                    /**
                     * Verify strength of password
                     */
                    $zxcvbn = new Zxcvbn();
                    $strength = $zxcvbn->passwordStrength($pass1, array());
                    if ($strength["score"] > 1) {
                        $ok = true;
                    } else {
                        $message->set(_("Le mot de passe n'est pas assez fort"), true);
                    }
                } else {
                    $message->set(_("Le mot de passe n'est pas assez complexe"), true);
                }
            } else {
                $message->set(_("Le mot de passe est trop court"), true);
            }
        } else {
            $message->set(_("Le mot de passe n'est pas identique dans les deux zones"), true);
        }
        return $ok;
    }

    /**
     * Fonction verifiant la complexite d'un mot de passe
     * Retourne le nombre de jeux de caracteres differents utilises
     *
     * @param string $password
     * @return number
     */
    public function controleComplexite($password)
    {
        $long = strlen($password);
        $type = array(
            "min" => 0,
            "maj" => 0,
            "chiffre" => 0,
            "other" => 0,
        );
        for ($i = 0; $i < $long; $i++) {
            $car = substr($password, $i, 1);
            if ($type["min"] == 0) {
                $type["min"] = preg_match("/[a-z]/", $car);
            }
            if ($type["maj"] == 0) {
                $type["maj"] = preg_match("/[A-Z]/", $car);
            }
            if ($type["chiffre"] == 0) {
                $type["chiffre"] = preg_match("/[0-9]/", $car);
            }
            if ($type["other"] == 0) {
                $type["other"] = preg_match("/[^0-9a-zA-Z]/", $car);
            }
        }
        return $type["min"] + $type["maj"] + $type["chiffre"] + $type["other"];
    }

    /**
     * Retourne un enregistrement a partir du login
     *
     * @param string $login
     * @return array
     */
    public function lireByLogin($login)
    {
        $sql = "select * from logingestion
				where lower(login) = lower(:login:)";
        return $this->lireParam($sql, ["login"=>$login]);
    }

    /**
     * Retourne un enregistrement a partir du mail
     *
     * @param string $mail
     *
     * @return array
     */
    public function getFromMail($mail)
    {
        if (!empty($mail)) {
            $sql = "select id, nom, prenom, login, mail, actif 
             from logingestion
             where lower(mail) = lower(:mail:)
             order by id desc limit 1";
            return $this->lireParamAsPrepared(
                $sql,
                array(
                    "mail" => $mail,
                )
            );
        } else {
            return array();
        }
    }
}
