<?php

if ($_REQUEST["moduleFrom"] == "containerDisplay" && $_REQUEST["containerUid"] > 0) {
  $t_module["retourok"] = "containerDisplay";
  $_REQUEST["uid"] = $_REQUEST["containerUid"];
} else {
  $t_module["retourok"] = "sampleList";
}
$module_coderetour = 1;
