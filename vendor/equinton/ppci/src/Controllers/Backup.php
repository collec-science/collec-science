<?php 
namespace Ppci\Controllers;

class Backup extends PpciController {


    function index(){
        return \Ppci\Libraries\Backup::display();
        
    }
    function exec() {
        $backlib = new \Ppci\Libraries\Backup();
        return $backlib->exec();
    }
}