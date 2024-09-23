<?php

namespace Ppci\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Ppci\Libraries\LastRelease;

class VersionCheckFilter implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        if (empty($_SESSION["versionCheck"])) {
            $app = service('AppConfig');
            if ($app->checkRelease == 1) {
                $version = new LastRelease;
            $version->check();
            }
            $_SESSION["versionCheck"] = 1;
        }
    }
    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null) {}
}