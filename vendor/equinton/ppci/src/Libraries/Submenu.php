<?php
namespace Ppci\Libraries;
use \Ppci\Models\Menu;
class Submenu extends PpciLibrary {

    function index (string $name) {
        $vue = service ("Smarty");
        $menu = new Menu($this->appConfig->APP_menufile);
        $vue->set($menu->getSubmenu($name),"submenu");
        $vue->set("ppci/submenu.tpl", "corps");
        $vue->htmlVars[] = "submenu";
        return $vue->send();
    }
}