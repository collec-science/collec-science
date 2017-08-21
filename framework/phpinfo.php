<?php
if ($_SESSION["droits"]["admin"] == 1) {
    ob_start();
    phpinfo();
    $phpinfo = ob_get_contents();
    ob_end_clean();
    $vue->set($phpinfo, "phpinfo");
    $vue->set("phpinfo.tpl", "corps");
}
?>