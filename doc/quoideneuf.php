<?php
$fichier = file("install/readme.txt");
$doc = "";
foreach($fichier as $key=>$value) {
	if (substr($value,1,1)=="*" or substr($value,0,1)=="*"){
		$doc .= "&nbsp;&nbsp;&nbsp;";
	}
	if ($APPLI_utf8==true) utf8_encode($value);
	$doc .= htmlentities($value)."<br>";
}

$smarty->assign("texteNews",$doc);
$smarty->assign("corps","documentation/quoideneuf.tpl");
?>