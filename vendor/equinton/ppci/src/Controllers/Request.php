<?php
namespace Ppci\Controllers;

use Psr\Log\LoggerInterface;
use Ppci\Controllers\PpciController;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Ppci\Libraries\Request as RequestLib;

class Request extends PpciController
{
    protected RequestLib $lib; // Change to the real library

    public function initController(
        RequestInterface $request,
        ResponseInterface $response,
        LoggerInterface $logger
    ) {
        parent::initController($request, $response, $logger);
        $this->lib = new RequestLib(); //Change to the real library
    }

    function list() {
        return $this->lib->list();
    }
    function change() {
        return $this->lib->change();
    }
    function write() {
        return $this->lib->write();
    }
    function delete() {
        return $this->lib->delete();
    }
    function writeExec() {
        return $this->lib->writeExec();
    }
    function exec() {
        return $this->lib->exec();
    }
    function execList() {
        return $this->lib->execList();
    }
    function copy() {
        return $this->lib->copy();
    }
}