<?php
/**
 * Display the content of a markdown file
 */
if (empty ($t_module["param"])) {
  $module_coderetour = -1;
}
if (!file_exists($t_module["param"])) {
  $message->set(sprintf(_("Le fichier %s n'existe pas"), $t_module["param"]), true);
  $module_coderetour = -1;
}
$handle = fopen($t_module["param"], "r");
$content = fread($handle, filesize($t_module["param"]));
if (strlen($content) == 0) {
  $message->set(sprintf(_("Le fichier %s est vide ou ne peut être lu"), $t_module["param"], true));
}
$vue->set($content, "markdownContent");
fclose($handle);
$vue->set ("framework/utils/markdownDisplay.tpl", "corps");
