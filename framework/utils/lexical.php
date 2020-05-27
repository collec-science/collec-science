<?php

/**
 * Get the text corresponding to the lexical entry
 */
try {
  if (strlen($_REQUEST["lexical"]) > 0) {
    file_exists("param/lexical-" . $LANG["date"]["locale"] . ".ini") ? $filename = "param/lexical-" . $LANG["date"]["locale"] . ".ini" : $filename = "param/lexical-fr.ini";
    $lexical = parse_ini_file($filename);
    $vue->set( $lexical[$_REQUEST["lexical"]], "lexical");
  }
} catch (Exception $e) {
  $message->setSyslog("Error when parsing lexical");
  $message->setSyslog(($e->getMessage()));
}
