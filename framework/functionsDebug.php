<?php

/**
 * Affiche le nom et le contenu d'une variable
 * @param array $tableau
 */
function printr($tableau, $mode_dump = 0, $force = false)
{
    global $APPLI_modeDeveloppement;
    if ($APPLI_modeDeveloppement || $force) {
        if ($mode_dump == 1) {
            var_dump($tableau);
        } else {
            if (is_array($tableau)) {
                print_r($tableau);
            } else {
                echo $tableau;
            }
        }
        echo "<br>";
    }
}

function test($content = "")
{
    global $testOccurrence;
    echo "test $testOccurrence : $content  <br>";
    $testOccurrence ++;
}
?>