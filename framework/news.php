<?php

/**
 * @author eric.quinton
 */
$filename = "param/news_" . $LANG["date"]["locale"] . ".txt";
if (!file_exists($filename)) {
    $filename = "param/news.txt";
}
$doc = "";
$file = file($filename);
foreach ($file as $value) {
    if (substr($value, 1, 1) == "*" || substr($value, 0, 1) == "*") {
        $doc .= "&nbsp;&nbsp;&nbsp;";
    }
    utf8_encode($value);
    $doc .= htmlentities($value) . "<br>";
}

$vue->set($doc, "texteNews");
$vue->set("framework/news.tpl", "corps");
?>
