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
            if (!empty($requiredRights)) {
                $ok = false;
                if (!isset($_SESSION["isLogged"])) {
                    if ($request->is("get")) {
                        $_SESSION["moduleRequired"] = $moduleName;
                    }
                    $login = new \Ppci\Libraries\Login();
                    $retour = $login->getLogin();
                    if (isset($retour)) {
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
                    $defaultPage = new \Ppci\Libraries\DefaultPage();
                    return ($defaultPage->display());
                } else {
                    if (isset($_SESSION["moduleRequired"])) {
                        $retour = $_SESSION["moduleRequired"];
                        unset ($_SESSION["moduleRequired"]);
                        return redirect($retour);
                    }
                }
            }
        }
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
    }
}
