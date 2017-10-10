<?php
/**
 * Created : 10 oct. 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
$fichier = file("param/lexique.txt");
$doc = "";
foreach ($fichier as $value) {
    $value = trim($value);
    if (strlen($value) > 0) {
        $data = explode(":",$value);
        $doc .= "<b>".htmlentities($data[0])."</b> : ".htmlentities($data[1])."<br>";
    }
}

$vue->set($doc, "doc");
$vue->set("documentation/lexique.tpl", "corps");
?>