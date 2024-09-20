<?php
namespace Ppci\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;

/**
 * Redirect to route from legacy variables "module" (direct links - not forms)
 */
class LegacyRouteFilter implements FilterInterface
{

    public function before(RequestInterface $request, $arguments = null)
    {
        /**
         * Legacy routes
         */
        $session = session();
        $newroute = "";
        if (!empty($_GET["module"])) {
            $newroute = $_GET["module"];
            unset($_REQUEST["module"]);
            unset($_GET["module"]);
            if (!empty($_GET)) {
                $session->setFlashData("GET", $_GET);
                /**
                 * Add the parameters to retrieve it to another request (page refresh, for example)
                 */
                $_SESSION["lastGet"] = $_GET;
            }
            if (!empty($_REQUEST)) {
                $session->setFlashData("REQUEST", $_REQUEST);
            }
            return redirect()->route($newroute)->withHeaders()->withInput()->withCookies();
        }
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
    }
}