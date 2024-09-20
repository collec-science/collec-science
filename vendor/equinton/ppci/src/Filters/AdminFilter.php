<?php
namespace Ppci\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Config\App;
use Ppci\Libraries\Totp;
use Ppci\Models\Acllogin;

class AdminFilter implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        $conf = service("IdentificationConfig");
        if (!$conf->disableTotpToAdmin) {
            $query = explode("/", uri_string());
            if (!empty($query)) {
                $moduleName = $query[0];
                if (!empty($query[1])) {
                    $moduleName .= ucfirst($query[1]);
                }
                $ppciRights = new \Ppci\Config\Rights();
                if ($ppciRights->isAdminRequired($moduleName)) {
                    if ($_SESSION["userRights"]["admin"] == 1) {
                        if (
                            isset($_SESSION["adminSessionTime"])
                            && ($_SESSION["adminSessionTime"] + $conf->adminSessionDuration) > time()
                        ) {
                            $_SESSION["adminSessionTime"] = time();
                        } else {
                            /**
                             * Store the module called
                             */
                            if ($request->is("get")) {
                                $_SESSION["moduleRequired"] = $moduleName;
                            }
                            $aclLogin = new Acllogin();
                            $vue = service("Smarty");
                            if ($aclLogin->isTotp()) {
                                $vue->set(1, "isAdmin");
                                $_SESSION["filterMessages"][] = _("Vous devez vous ré-identifier avec votre code TOTP pour accéder aux modules d'administration");
                                return redirect("totpAdmin");
                            } else {
                                $_SESSION["filterMessages"][] = _("Vous devez activer la double identification TOTP pour accéder aux modules d'administration");
                                return redirect("totpCreate");
                            }
                        }
                    }
                }
            }
        }
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
    }
}