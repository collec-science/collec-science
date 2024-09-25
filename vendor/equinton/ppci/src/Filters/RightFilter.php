<?php

namespace Ppci\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;

/**
 * Test if the user has sufficient rights to execute the module
 */
class RightFilter implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        $query = explode("/", uri_string());
        if (!empty($query)) {
            $moduleName = $query[0];
            if (!empty($query[1])) {
                $moduleName .= ucfirst($query[1]);
            }
            $appRights = new \App\Config\Rights();
            $requiredRights = $appRights->getRights($moduleName);
            if (empty($requiredRights)) {
                $ppciRights = new \Ppci\Config\Rights();
                $requiredRights = $ppciRights->getRights($moduleName);
            }
            if (!empty($requiredRights) || (isset($_REQUEST["login"]) && isset($_REQUEST["token"]))) {
                $hasRedirect = true;
                $ok = false;
                if (!isset($_SESSION["isLogged"])) {
                    if ($request->is("get")) {
                        $_SESSION["moduleRequired"] = $moduleName;
                        $_SESSION["get"] = $_GET;
                        $_SESSION["request"] = $_REQUEST;
                        $hasRedirect = false;
                    }
                    $login = new \Ppci\Libraries\Login();
                    $retour = $login->getLogin();
                    if (!empty($retour)) {
                        return redirect()->to(site_url($retour));
                    }
                }
                foreach ($requiredRights as $r) {
                    if ($_SESSION["userRights"][$r] == 1) {
                        $ok = true;
                        break;
                    }
                }
                if (!$ok) {
                    $message = service('MessagePpci');
                    $message->set(_("Vous ne disposez pas des droits nécessaires pour exécuter cette fonction"), true);
                    helper("ppci");
                    setLogRequest($request, "ko: insufficient rights");
                    return defaultPage();
                } else {
                    if (!empty($_SESSION["moduleRequired"]) && $hasRedirect) {
                        $retour = $_SESSION["moduleRequired"];
                        unset($_SESSION["moduleRequired"]);
                        $_GET = $_SESSION["get"];
                        $_REQUEST = $_SESSION["request"];
                        unset($_SESSION["get"]);
                        unset($_SESSION["request"]);
                        return redirect($retour);
                    }
                }
            }
        }
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null) {}
}
