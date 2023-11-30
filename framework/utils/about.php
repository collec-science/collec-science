<?php
/**
 * @author eric.quinton
 */
$vue->set($APPLI_version, "version");
$vue->set(_($APPLI_versiondate), "versiondate");
$locale = $_SESSION["FORMATDATE"];
$search = "display/templates/about_".$locale.".tpl";
if (file_exists($search)) {
    $filename = "about_".$locale.".tpl";
} else {
    $filename = "about_en.tpl";
}
$vue->set($filename, "corps");
