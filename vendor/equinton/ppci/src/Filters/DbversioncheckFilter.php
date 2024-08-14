<?php

namespace Ppci\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Config\App;
use Config\Database;
use Ppci\Libraries\MessagePpci;
use \Ppci\Models\Dbversion;

/**
 * Test if the user has sufficient rights to execute the module
 */
class DbversioncheckFilter implements FilterInterface
{
    public bool $isDbversionOk = false;
    public function before(RequestInterface $request, $arguments = null)
    {
        /**
         * @var Message
         */
        $message = service('MessagePpci');
        try {
            if (!isset($_SESSION["dbversionCheck"])) {
                /**
                 * @var App
                 */
                $paramApp = config("App");

                /**
                 * Verify the database version
                 */

                $dbversion = new Dbversion();
                if ($dbversion->verifyVersion($paramApp->dbversion)) {
                    $this->isDbversionOk = true;
                } else {
                    $message->set(
                        sprintf(
                            _('La base de données n\'est pas dans la version attendue (%1$s). Version actuelle : %2$s'),
                            $paramApp->dbversion,
                            $dbversion->getLastVersion()["dbversion_number"]
                        ),
                        true
                    );
                }
                $_SESSION["dbversionCheck"] = true;
                $defaultPage = new \Ppci\Libraries\DefaultPage();
                return ($defaultPage->display());
            }
        } catch (\Exception $e) {
            $message->set($e->getMessage());
            $defaultPage = new \Ppci\Libraries\DefaultPage();
            return ($defaultPage->display());
        }
    }
    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
    }
}
