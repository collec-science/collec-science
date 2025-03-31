<?php
namespace Ppci\Controllers;

class Totp extends PpciController
{
    protected $lib;

    public function initController(
        $request,
        $response,
        $logger
    ) {
        parent::initController($request, $response, $logger);
        $this->lib = new \Ppci\Libraries\Totp();
    }
    function index()
    {
        return $this->lib->input();
    }
    function admin() {
        $smarty = service("Smarty");
        $smarty->set(1, "isAdmin");
        return $this->lib->input();
    }

    function create()
    {
        return $this->lib->create();
    }
    function createVerify()
    {
        return $this->lib->createVerify();
    }
    function getQrcode()
    {
        return $this->lib->getQrcode();
    }
    function verify()
    {
        return $this->lib->verify();
    }
    function showCode() {
        return $this->lib->showCode();
    }

}