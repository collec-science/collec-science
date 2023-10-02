<?php
    include_once 'framework/navigation/menu.class.php';
  $menu = new Menu($APPLI_menufile);

  $vue->set($menu->getSubmenu($_REQUEST["module"]),"submenu");
  $vue->set("framework/submenu.tpl", "corps");
  $vue->htmlVars[] = "submenu";
  