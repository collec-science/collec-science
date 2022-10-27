<?php

switch ($t_module["param"]) {
  case "SERVER":
    $vue->set($_SERVER, "data");
    $module_coderetour = 1;
    break;
  case "SESSION":
    $content = array();
    foreach ($_SESSION as $k => $v) {
      if (!is_object($v)) {
        if (is_array($v)) {
          $content[$k] = json_encode($v);
        } else {
        $content[$k] = $v;
      }
    }else {
      $content[$k] = "object";
    }
  }
    $vue->set($content, "data");
    $module_coderetour = 1;
    break;
  default:
    $module_coderetour = -1;
}
$vue->set("framework/utils/system.tpl", "corps");
