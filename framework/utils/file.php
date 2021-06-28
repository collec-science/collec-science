<?php
namespace framework;

class FileException extends \Exception
{
}
switch ($t_module["param"]) {
  case "documentationGetFile":
    try {
      $_REQUEST["disposition"] == "attachment" ? $disposition = "attachment" : $disposition = "inline";
      if (empty($_REQUEST["filename"])) {
        throw new FileException(_("Aucun nom de fichier n'a été fourni"));
      }
      $filename = str_replace("..", "", $_REQUEST["filename"]);

      $filename = $_SERVER["DOCUMENT_ROOT"] . "/documentation/" . $filename;
      if (!is_file($filename)) {
        throw new FileException(sprintf(_("Le fichier %s n'existe pas ou n'est pas lisible"), $_REQUEST["filename"]));
      }
      $a_filename = explode("/", $filename);
      $displayedFilename = $a_filename[count($a_filename) - 1];
      $vue->setParam(
        array(
          "filename" => $a_filename[count($a_filename) - 1],
          "tmp_name" => $filename,
          "content_type" => mime_content_type($filename),
          "disposition" => $disposition
        )
      );
    } catch (FileException $fe) {
      $module_coderetour = -1;
      $message->set($fe->getMessage(), true);
    }
    break;
}
