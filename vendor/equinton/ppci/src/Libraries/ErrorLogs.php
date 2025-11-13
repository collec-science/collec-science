<?php

namespace Ppci\Libraries;

use Config\Paths;

class ErrorLogs extends PpciLibrary
{

    private string $path;
    private array $files = [];

    function __construct()
    {
        if (isset($_SERVER["envPath"])) {
            $this->path = $_SERVER["envPath"] . "/writable/logs";
        } else {
            $ciPaths = new Paths;
            $this->path = $ciPaths->writableDirectory . "/logs";
        }
    }

    function getErrorFiles()
    {
        $this->files = [];
        $files = scandir($this->path, SCANDIR_SORT_DESCENDING);
        if (! $files) {
            throw new PpciException(_("Le dossier contenant les fichiers d'erreur n'est pas accessible"), true);
        }
        /**
         * Purge the content of the list to conserve only log files
         */
        foreach ($files as $file) {
            if (substr($file, 0, 3) == "log") {
                $this->files[] = $file;
            }
        }
        if (empty($files)) {
            throw new PpciException(_("Aucun fichier de log n'a été trouvé"), true);
        }
    }

    function getContentFile(string $filename)
    {
        $this->getErrorFiles();
        if (in_array($filename, $this->files)) {
            $vue = service("Smarty");
            $vue->set($filename, "filename");
            $vue->set(file($this->path . "/$filename"), "logs");
            $vue->set("ppci/utils/logerrordisplay.tpl", "corps");
            return $vue->send();
        } else {
            throw new PpciException(_("Le fichier demandé n'existe pas"), true);
        }
    }

    function getErrorLogFiles()
    {
        $vue = service("Smarty");
        $this->getErrorFiles();
        /**
         * add the size of each file
         */
        $files = [];
        foreach ($this->files as $file) {
            $size = filesize($this->path . "/" . $file);
            if ($size > 1024 && $size < 1048576) {
                $size = intval($size / 1024) . " kb";
            } else if ($size >= 1048576) {
                $size = intval($size / 1048576) . "mb";
            } else {
                $size .= " b";
            }
            $files[$file] = $size;
        }
        $vue->set($files, "logfiles");
        $vue->set("ppci/utils/logerrorlist.tpl", "corps");
        return $vue->send();
    }
}
