<?php

namespace Ppci\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Ppci\Libraries\PpciInit;

class StartcallFilter implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        /**
         * @var PpciInit
         */
        $init = service("PpciInit");
        $init::init();
        $_SESSION['LAST_ACTIVITY'] = time(); // update last activity time stamp
        $conf = service("AppConfig");
        if (!isset($_SESSION["ABSOLUTE_START"])) {
            $_SESSION["ABSOLUTE_START"] = time();
        } elseif (time() - $_SESSION["ABSOLUTE_START"] > $conf->APPLI_absolute_session) {
            $_SESSION["filterMessages"][] = _("La session a expiré, vous devez vous reconnecter");
            $login = new \Ppci\Models\Login();
            $login->disconnect();
            defaultPage();
        }
        setLogRequest($request);
        /**
         * Uncode html vars
         */
        $_REQUEST = htmlDecode($_REQUEST);
        $_GET = htmlDecode($_GET);
        $_POST = htmlDecode($_POST);
    }
    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null) {}
}
