<?php
namespace Ppci\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Config\App;
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
        $conf = new App();
        if (!isset($_SESSION["ABSOLUTE_START"])) {
            $_SESSION["ABSOLUTE_START"] = time();
        } elseif (time() - $_SESSION["ABSOLUTE_START"] > $conf->APPLI_absolute_session) {
            $_SESSION["filterMessages"][] = _("La session a expiré, vous devez vous reconnecter");
            $login = new \Ppci\Models\Login();
            $login->disconnect();
            $defaultPage = new \Ppci\Libraries\DefaultPage();
            return ($defaultPage->display());
        }
        setLogRequest($request);
        /**
         * Uncode html vars
         */
        $_REQUEST = htmlDecode($_REQUEST);
    }
    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
    }
}
