<?php
/** Fichier cree le 10 mai 07 par quinton
*
*UTF-8
*/

if ($identification->disconnect($APPLI_address)==1) {
	$message=$LANG["message"][7];	
}else{
	$message=$LANG["message"][8];
}

?>