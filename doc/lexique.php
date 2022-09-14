<?php
/**
 * affichage du lexique en fonction de la langue choisie
 * Created : 10 oct. 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
file_exists("param/lexique-".$LANG["date"]["locale"].".txt" ) ? $filename = "param/lexique-".$LANG["date"]["locale"].".txt" : $filename = "param/lexique-fr.txt";
/*
 * lecture du fichier
 */
$f = fopen($filename, "r");
if ($f) {
$data = array();
while ($line = fgets($f)) {
    $line = trim($line);
    if (!empty($line)) {
        $d = explode(":", $line);
        $content = "";
        foreach ($d as $id=>$value) {
            if ($id == 0) {
                $key = $d[0];
            } else {
                if ($id > 1) {
                    $content .= ":";
                }
                $content .= $value;
            }
        }
        $data [] = array("item"=> $key, "content"=>$content);
    }
}
$vue->set($data, "lexique");
$vue->set("documentation/lexique.tpl", "corps");
} else {
    $message->set(_("Impossible de lire le fichier contenant le lexique"));
}
?>
