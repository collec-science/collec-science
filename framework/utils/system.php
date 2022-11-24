<?php

function systemPrepareData(array $data):array {
  $content = array();
  foreach ($data as $k => $v) {
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
return $content;
}

switch ($t_module["param"]) {
  case "SERVER":
    $vue->set(systemPrepareData($_SERVER), "data");
    $module_coderetour = 1;
    break;
  case "SESSION":
    $vue->set(systemPrepareData($_SESSION), "data");
    $module_coderetour = 1;
    break;
  default:
    $module_coderetour = -1;
}
$vue->set("framework/utils/system.tpl", "corps");
