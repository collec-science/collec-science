<?php
file_exists("param/news-" . $LANG["date"]["locale"] . ".txt") ? $filename = "param/news-" . $LANG["date"]["locale"] . ".txt" : $filename = "param/news-fr.txt";
/*
 * lecture (parsing) du fichier
 */
$f = fopen($filename, "r");
if ($f) {
    $data = array();
    while ($line = fgets($f)) {
        $line = trim($line);
        /* quand la ligne est de la forme : Heading 1 :
         * ===========
         * donc on avait :
         * News
         * ===========
         */
        if (substr($line, 0, 3) == "===") { // 3 caractères minimum
            // alors supprime le dernier élément
            array_pop($data);
        }
        /* quand la ligne est de la forme : Heading 2 : (attention pourrait aussi être Horizontal Rule)
         * --------------------------
         * donc on avait :
         * Version 1.0.8 du 02/06/2017
         * ---------------------------
         */
        elseif (substr($line, 0, 3) == "---") { // 3 caractères minimum
            // alors considére le dernier élément comme un titre (une version)
            // NB pour prendre en compte Horizontal Rule il faudrait vérifier le type du dernier élément (vide ou non)
            $count =count($data);
            if ($count > 0 ) {
                $data[$count-1]["type"]='version';
            }
        }
        /* quand la ligne est de la forme :
         * Améliorations :
         */
        elseif (substr($line, - 1, 1) == ":") {
            $data[] = array("type"=>'category', "content"=>$line);
        }
        /* quand la ligne est de la forme :
         * - import de masse
         */
        elseif (substr($line, 0, 2) == "- ") {
            // ajoute le sous élément en prenant les caractères après "- "
            $data[] = array("type"=>'subitem', "content"=>substr($line, 2));
        }
        /* quand la ligne est de la forme : vide :
         *
         */
        elseif (empty($line) ) {
            // ajoute un élément vide qui pourrait servir si on veut distinguer Heading 2 de Horizontal Rule ---
            $data[] = array("type"=>'empty', "content"=>'');
        }
        /* quand la ligne est de la forme :
         * Première version de production
         */
        else {
            // ajoute l'élément
            // Attention : peut être modifié par la suite si la ligne d'après le déclare comme un titre (une version)
            $data[] = array("type"=>'item', "content"=>$line);
        }
    }
    $vue->set($data, "news");
    $vue->set("documentation/quoideneuf.tpl", "corps");
} else {
    $message->set(_("Impossible de lire le fichier contenant les news"));
}

?>
