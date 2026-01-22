<?php
namespace Ppci\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Config\App;
use Ppci\Models\Log;

class SessionHijackingFilter implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        /**
         * @var App
         */
        if (!empty($_SERVER["HTTP_HOST"])) {
            /**
             * @var CodeIgniter\Session\Session session
             */
            $session = service("session");
            if (empty($_SESSION["hostOrigin"])) {
                $session->set("hostOrigin", $_SERVER["HTTP_HOST"]);
            } else {
                if ($session->get("hostOrigin") != $_SERVER["HTTP_HOST"]) {
                    /**
                     * @var Log
                     */
                    $log = service("Log");
                    $log->setLog(
                        $_SESSION["login"],
                        "sessionHijacking",
                        "server of origin:" . $_SESSION["hostOrigin"]
                    );
                    $session->destroy();
                    $_SESSION = [];
                    /**
                     * @var Message
                     */
                    $_SESSION["filterMessages"][] = _("Pour des raisons de sécurité, la session de travail a été réinitialisée");
                    defaultPage();
                }
            }
        }
    }
public function after(RequestInterface $request, ResponseInterface $response, $arguments = null) {}

}