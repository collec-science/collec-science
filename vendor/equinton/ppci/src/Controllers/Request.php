<?php
namespace Ppci\Controllers;

use Psr\Log\LoggerInterface;
use Ppci\Controllers\PpciController;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Ppci\Libraries\Request as RequestLib;
use Ppci\Libraries\PpciException;

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
    function write()
    {
        $this->lib->write();
        return $this->change();
    }
    function writeExec() {
        if ($this->lib->write()) {
            return $this->lib->exec();
        } else {
            return $this->lib->change();
        }
    }
    function delete()
    {
        if ($this->lib->delete()) {
            return $this->lib->list();
        } else {
            return $this->lib->change();
        }
    }
    function exec() {
        return $this->lib->exec();
    }
    function execCsv(){
        try {
            return $this->lib->execCsv();
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            return $this->lib->change();
        } 
    }
    function execList() {
        return $this->lib->execList();
    }
    function copy() {
        return $this->lib->copy();
    }
}