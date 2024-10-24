<?php

namespace Ppci\Controllers;

use Psr\Log\LoggerInterface;
use Ppci\Controllers\PpciController;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Ppci\Libraries\Acllogin as Lib;

class Acllogin extends PpciController
{
    protected Lib $lib;

    public function initController(
        RequestInterface $request,
        ResponseInterface $response,
        LoggerInterface $logger
    ) {
        parent::initController($request, $response, $logger);
        $this->lib = new Lib;
    }

    function list()
    {
        return $this->lib->list();
    }
    function change()
    {
        return $this->lib->change();
    }
    function write()
    {
        if ($this->lib->write()) {
            return $this->list();
        } else {
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->lib->delete()) {
            return $this->list();
        } else {
            return $this->change();
        }
    }
}
