<?php
namespace Ppci\Libraries;
class DefaultPage extends PpciLibrary {
    function display() {
        $vue = service('Smarty');
        return $vue->send();
    }
}