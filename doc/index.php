<?php
/*
 * Module d'affichage de la documentation
 * Permet d'afficher dans le menu l'ensemble de la documentation,
 * a partir d'une seule page.
 * 
 * Gere l'internationalisation
 * Utilise egalement l'attribut param1 de actions.xml
 */ 
$handle = @fopen("doc/".$language."/".$t_module["param1"], "r");
$doc = "";
if ($handle) {
    while (!feof($handle)) {
        $buffer = fgets($handle, 4096);
        $doc .= $buffer;
    }
    fclose($handle);
}
/*
    header("content-type: text/html");
   header('Content-Disposition: inline; filename="'.$t_module["param1"].'"');
    header('Pragma: no-cache');
    header('Cache-Control:must-revalidate, post-check=0, pre-check=0');
    header('Expires: 0');
    echo $doc;
    */

    $smarty->assign("doc",$doc);
    $smarty->assign("corps","documentation/index.tpl");
    


?>