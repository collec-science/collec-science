<?php

namespace Ppci\Controllers;

use Psr\Log\LoggerInterface;
use Ppci\Controllers\PpciController;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Ppci\Libraries\Aclappli as Lib;

class Aclappli extends PpciController
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
    function display()
    {
        return $this->lib->display();
    }
    function change()
    {
        return $this->lib->change();
    }
    function write()
    {
        if ($this->lib->write()) {
            return $this->display();
        } else {
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->lib->delete()) {
            return $this->display();
        } else {
            return $this->change();
        }
    }
}
