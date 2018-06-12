<?php
file_exists("param/news-" . $LANG["date"]["locale"] . ".txt") ? $filename = "param/news-" . $LANG["date"]["locale"] . ".txt" : $filename = "param/news-fr.txt";
/*
 * lecture du fichier
 */
$f = fopen($filename, "r");
if ($f) {
    $doc = "";
    $linebefore = "";
    while ($line = fgets($f)) {
        $line = trim($line);
        if ($line == "News") {
            $line = "";
        }
        
        $firstchar = substr($line, 0, 1);
        if ($firstchar == "=" || substr($line, 0, 2) == "--") {
            if ($firstchar == "-") {
                $linebefore = "<h3>" . $linebefore . "</h3>";
            }
        } else {
            if (strlen($linebefore) > 0) {
                $doc .= $linebefore . "<br>";
            }
            if (substr($line, - 1, 1) == ":") {
                $linebefore = "<h4>" . htmlentities($line) . "</h4>";
            } else {
                $linebefore = htmlentities($line);
            }
        }
    }
    $vue->set($doc, "texteNews");
    $vue->set("documentation/quoideneuf.tpl", "corps");
} else {
    $message->set(_("Impossible de lire le fichier contenant les news"));
}

?>