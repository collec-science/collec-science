<?php

$filename = "doc/".$language."/".$t_module["param1"];
$filesize = filesize($filename);
$handle = fopen($filename, "r");
if ($handle) {
	$fichier = fread($handle, $filesize);
	fclose($handle);
	header("content-type: application/pdf");
	header('Content-Disposition: attachment; filename="'.$t_module["param1"].'"');
	header('Content-Transfer-Encoding: binary');
	header('Content-Length: '.$filesize);
	header('Pragma: no-cache');
	header('Cache-Control:must-revalidate, post-check=0, pre-check=0');
	header('Expires: 0');
	echo $fichier;
}
?>