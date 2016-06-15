<?php
/**
 * Created : 13 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
$dt = new DateTime();
$date = $dt->format("D M d H:i:s.u Y");
$appli = "monAppli";
$pid = getmypid();
$code_error = "$appli message";
$level = "notice";
$message = "Message a generer";
openlog("[$date] [$appli:$level] [pid $pid] $code_error",LOG_PERROR , LOG_LOCAL7);
syslog(LOG_NOTICE, "$message");
?>