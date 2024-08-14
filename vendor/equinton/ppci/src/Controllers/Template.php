<?php
namespace Ppci\Controllers;

use Psr\Log\LoggerInterface;
use Ppci\Controllers\PpciController;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Ppci\Libraries\Template as TemplateLib;

class Template extends PpciController
{
    protected TemplateLib $lib; // Change to the real library

    public function initController(
        RequestInterface $request,
        ResponseInterface $response,
        LoggerInterface $logger
    ) {
        parent::initController($request, $response, $logger);
        $this->lib = new TemplateLib(); //Change to the real library
    }

    function list() {
        return $this->lib->list();
    }
    function display() {
        return $this->lib->display();
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
}