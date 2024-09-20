<?php
namespace Ppci\Controllers;

class Gacl extends PpciController {

    function appliindex() {
        $lib = new \Ppci\Libraries\Aclappli();
        return $lib->list();
    }
    function applidisplay() {
        $lib = new \Ppci\Libraries\Aclappli();
        return $lib->display();
    }
    function applichange () {
        $lib = new \Ppci\Libraries\Aclappli();
        return $lib->change();
    }
    function appliwrite() {
        $lib = new \Ppci\Libraries\Aclappli();
        return $lib->write();
    }
    function applidelete() {
        $lib = new \Ppci\Libraries\Aclappli();
        return $lib->delete();
    }
    function loginindex() {
        $lib = new \Ppci\Libraries\Acllogin();
        return $lib->list();
    }
    function loginchange() {
        $lib = new \Ppci\Libraries\Acllogin();
        return $lib->change();
    }
    function loginwrite() {
        $lib = new \Ppci\Libraries\Acllogin();
        return $lib->write();
    }
    function logindelete() {
        $lib = new \Ppci\Libraries\Acllogin();
        return $lib->delete();
    }
    function groupindex() {
        $lib = new \Ppci\Libraries\Aclgroup();
        return $lib->list();
    }
    function groupchange() {
        $lib = new \Ppci\Libraries\Aclgroup();
        return $lib->change();
    }
    function groupwrite() {
        $lib = new \Ppci\Libraries\Aclgroup();
        return $lib->write();
    }
    function groupdelete() {
        $lib = new \Ppci\Libraries\Aclgroup();
        return $lib->delete();
    }
    function acodisplay() {
        $lib = new \Ppci\Libraries\Aclaco();
        return $lib->display();
    }
    function acochange() {
        $lib = new \Ppci\Libraries\Aclaco();
        return $lib->change();
    }
    function acowrite() {
        $lib = new \Ppci\Libraries\Aclaco();
        return $lib->write();
    }
    function acodelete () {
        $lib = new \Ppci\Libraries\Aclaco();
        return $lib->delete();
    }
}