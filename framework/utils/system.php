<?php

switch ($t_module["param"]) {
  case "SERVER":
  $vue->set($_SERVER, "data");
  $module_coderetour = 1;
  break;
  case "SESSION":
  $vue->set($_SESSION, "data");
  $module_coderetour = 1;
  break;
  default:
  $module_coderetour = -1;
}
$vue->set("framework/utils/system.tpl", "corps");
