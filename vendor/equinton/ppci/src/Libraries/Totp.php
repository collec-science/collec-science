<?php

namespace Ppci\Libraries;

use \Ppci\Models\Gacltotp;
use \Ppci\Models\Acllogin;
use CodeIgniter\Cookie\Cookie;

class Totp extends PpciLibrary
{
    protected Gacltotp $gacltotp;
    protected Acllogin $acllogin;
    protected Login $login;
    protected $datalogin;
    protected $defaultPage;

    function __construct()
    {
        parent::__construct();
        $this->gacltotp = new Gacltotp($this->appConfig->privateKey, $this->appConfig->pubKey);
        $this->acllogin = new Acllogin();
        $this->datalogin = $this->acllogin->getFromLogin($_SESSION["login"]);
        if (empty($datalogin["acllogin_id"])) {
            $datalogin["acllogin_id"] = $this->acllogin->addLoginByLoginAndName($_SESSION["login"]);
        }
        $this->defaultPage = new \Ppci\Libraries\DefaultPage();
        $this->login = new Login();
    }
    function input()
    {
        $vue = service("Smarty");
        $vue->set('ppci/ident/totp.tpl', 'corps');
        return $vue->send();
    }
    function create()
    {
        if ($this->acllogin->isTotp()) {
            $_SESSION["filterMessages"][] = "Vous avez déjà activé l'identification à double facteur : contactez un administrateur de l'application pour réinitialiser cette fonction";
            return redirect("default");
        }
        unset($_SESSION["totpSecret"]);
        $_SESSION["totpSecret"] = $this->gacltotp->createSecret();
        $this->gacltotp->createQrCode();
        $vue = service("Smarty");
        $vue->set("ppci/droits/otpCreate.tpl", "corps");
        return $vue->Send();
    }

    function createVerify()
    {
        if (empty($_POST["otpcode"])) {
            $this->message->set(_("Les informations fournies sont insuffisantes pour valider la création de la double identification"));
        } else {
            if ($this->gacltotp->verifyOtp($_SESSION["totpSecret"], $_POST["otpcode"])) {
                /**
                 * Write the secret into the database
                 */
                $datalogin = $this->acllogin->getFromLogin($_SESSION["login"]);
                $datalogin["totp_key"] = $this->gacltotp->encodeTotpKey($_SESSION["totpSecret"]);
                $this->acllogin->ecrire($datalogin);
                unset($_SESSION["totpSecret"]);
                $this->message->set(_("La double authentification est maintenant activée."));
                /**
                 * Delete the qrcode
                 */
                $filename = WRITEPATH . "temp/" . $_SESSION["login"] . "_totp.png";
                if (file_exists($filename)) {
                    unlink($filename);
                }
            } else {
                $this->message->set(_("Le code fourni n'a pu être vérifié"), true);
            }
        }
        return $this->defaultPage->display();
    }

    function getQrcode()
    {
        /**
         * must be a vuebinaire instance
         */
        $vue = service("BinaryView");
        $vue->setParam(
            array(
                "disposition" => "inline",
                "tmp_name" => WRITEPATH . "temp/" . $_SESSION["login"] . "_totp.png"
            )
        );
        return $vue->send();
    }

    function verify()
    {
        try {
            if (
                $this->gacltotp->verifyOtp(
                    $this->gacltotp->decodeTotpKey($this->acllogin->getTotpKey($_SESSION["login"])),
                    $_POST["otpcode"]
                )
            ) {
                $_SESSION["isLogged"] = true;
                $this->log->setlog($_SESSION["login"], "totpVerifyExec", "ok");
                $this->message->set(_("Vous êtes maintenant connecté"));
                $this->login->postLogin("totp");
                $_SESSION["adminSessionTime"] = time();
                unset($_SESSION["menu"]);
                /**
                 * Generate the cookie to inhibit the totp control
                 */
                if (isset($_POST["otptrusted"])) {
                    helper('cookie');
                    $maxAge = 2592000;
                    $content = json_encode([
                        "uid" => $_SESSION["login"],
                        "exp" => time() + $maxAge
                    ]);
                    $encoded = $this->gacltotp->encode($content, "priv");
                    $cookie = new Cookie(
                        'totpTrustBrowser',
                        $encoded,
                        [
                            'max-age' => $maxAge
                        ]
                    );
                    set_cookie($cookie);
                }
            } else {
                $this->log->setlog($_SESSION["login"], "totpVerifyExec", "ko");
                $this->message->set(_("Le code TOTP rentré n'a pas été reconnu"), true);
            }
        } catch (PpciException $pe) {
            $this->message->setSyslog($pe->getMessage());
            $this->message->set($pe->getMessage(), true);
        }
        if (!empty($_SESSION["moduleRequired"])) {
            $retour = $_SESSION["moduleRequired"];
            unset($_SESSION["moduleRequired"]);
            return redirect()->to($retour);
        }
        return $this->defaultPage->display();
    }
}
