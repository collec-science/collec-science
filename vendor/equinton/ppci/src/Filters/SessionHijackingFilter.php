<?php

namespace Ppci\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Config\App;
use Ppci\Libraries\Dbparam;
use Ppci\Models\Dbparam as ModelsDbparam;
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
                    /**
                     * @var App
                     */
                    $app = service("AppConfig");
                    /**
                     * @var ModelsDbparam
                     */
                    $dbparam = service("Dbparam");
                    $log->sendMailToAdmin(
                        sprintf(
                            _("%1s - %2s : tentative d'usurpation de session"),
                            $app->applicationName,
                            $dbparam->getParam("APPLI_title")
                        ),
                        "ppci/mail/sessionhijacking.tpl",
                        [
                            "ip" => $log->getIPClientAddress(),
                            "login" => $_SESSION["login"],
                            "date" => date($_SESSION["date"]["maskdatelong"])
                        ],
                        "sessionHijacking",
                        $_SESSION["login"]
                    );
                    $session->destroy();
                    $_SESSION = [];
                    $_SESSION["hostOrigin"] = $_SERVER["HTTP_HOST"];
                    helper('cookie');
                    setcookie('tokenIdentity', "", time() - 36000);
                    /**
                     * @var Message
                     */
                    $message = service("MessagePpci");
                    $message->set(_("Pour des raisons de sécurité, la session de travail a été réinitialisée"), true);
                }
            }
        }
    }
    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null) {}
}
