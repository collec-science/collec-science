<?php

include_once "framework/utils/mail.class.php";

$mail = new Mail($MAIL_param);
$_REQUEST["test"]=1 ? $test = true: $test = false;
$mail->SendMailSmarty(
  $SMARTY_param,
  $_SESSION["mail"],
  "test",
  "framework/mail/accountActivate.tpl",
  array(
    "login" => $_SESSION["login"],
    "module" => $module,
    "date" => date('d/m/Y'),
    "APPLI_address" => "https://".$_SERVER["HTTP_HOST"],
  ),
  "fr",
  $test
);

