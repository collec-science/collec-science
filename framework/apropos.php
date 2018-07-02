<?php
/**
* @author eric.quinton
*/
$vue->set( $APPLI_version, "version");
$vue->set(_($APPLI_versiondate) , "versiondate");
$filename = "apropos_".$LANG["date"]["locale"].".tpl";
if (!file_exists($SMARTY_params["templates"]."/".$filename)) {
    $filename = "apropos_fr.tpl";
}
$vue->set("apropos_".$LANG["date"]["locale"].".tpl" , "corps");
?>