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
  $testOccurrence++;
}
/**
 * Display the content of a variable
 * with a structured format
 *
 * @param any $arr
 * @param integer $level
 * @return void
 */
function printA($arr, $level = 0)
{
  $childLevel = $level + 1;
  $nl = getLineFeed();
  if (is_array($arr)) {
    foreach ($arr as $key => $var) {
      if (!in_array($key, array("g_module", "navigation"))) {
        if (is_object($var)) {
          $var = (array) $var;
          $key .= " (object)";
        }
        for ($i = 0; $i < $level * 3; $i++) {
          echo " ";
        }
        echo $key . ": ";
        if (is_array($var)) {
          echo $nl;
          printA($var, $childLevel);
        } else {
          print_r($var);
          echo $nl;
        }
      }
    }
  } else {
    echo "$arr".$nl;
  }
}


