<?php
namespace Ppci\Controllers;
use App\Controllers\BaseController;

class Defaultpage extends BaseController
{

    
    public function index()
    {
        $lib = new \Ppci\Libraries\DefaultPage();
        return ($lib->display());
    }
}