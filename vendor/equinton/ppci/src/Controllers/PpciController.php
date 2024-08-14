<?php
namespace Ppci\Controllers;

use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Config\App;
use Psr\Log\LoggerInterface;

/**
 * Generic controller for prototypephp
 */
class PpciController extends \App\Controllers\BaseController
{
    protected $message;
    protected $config;
    /**
     * 
     * Systematic code used
     *
     * @param RequestInterface $request
     * @param ResponseInterface $response
     * @param LoggerInterface $logger
     * @return void
     */
    public function initController(
        RequestInterface $request,
        ResponseInterface $response,
        LoggerInterface $logger
    ) {
        parent::initController($request, $response, $logger);
        $this->message = service('MessagePpci');
        /**
         * @var App
         */
        $this->config = config("App");
        $session = session();
        if ($session->getFlashdata("POST")){
            $_POST = $session->getFlashdata("POST");
        }
        if ($session->getFlashdata("GET")){
            $_GET = $session->getFlashdata("GET");
        }
        if ($session->getFlashdata("REQUEST")){
            $_REQUEST = $session->getFlashdata("REQUEST");
        }
        if (!empty($_SESSION["lastGet"])) {
            foreach ($_SESSION["lastGet"] as $k => $v) {
                if (!isset($_REQUEST[$k])) {
                    $_REQUEST[$k] = $v;
                }
            }
        }
    }

}