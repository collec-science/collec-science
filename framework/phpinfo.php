<?php
if ($_SESSION["droits"]["admin"] == 1)
	ob_start();
	phpinfo();
	$phpinfo = ob_get_contents();
	ob_end_clean();
	$smarty->assign("phpinfo", $phpinfo);
	$smarty->assign("corps", "phpinfo.tpl");
?>