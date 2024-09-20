<?php
namespace Ppci\Controllers;


use \Ppci\Controllers\PpciController;
use \Ppci\Libraries\LoginGestionLib;

class LoginGestion extends PpciController {

    protected $lib;
    function __construct() {
        $this->lib = new LoginGestionLib();
    }
    function index() {
        return $this->lib->index();
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
    function changePassword() {
        return $this->lib->changePassword();
    }
    function changePasswordExec() {
        return $this->lib->changePasswordExec();
    }
}