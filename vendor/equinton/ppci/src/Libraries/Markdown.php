<?php

namespace Ppci\Libraries;


class Markdown extends PpciLibrary
{
    function index($params)
    {
        $file = "";
        foreach ($params as $param) {
            $file .= "/" . $param;
        }
        $realfilepath = ROOTPATH . substr($file, 1);
        if (!file_exists($realfilepath)) {
            $this->message->set(sprintf(_("Le fichier %s n'existe pas"), $file), true);
            $default = new DefaultPage();
            return  $default->display();
        } else {
            $handle = fopen($realfilepath, "r");
            $content = fread($handle, filesize($realfilepath));
            if (empty($content)) {
                $this->message->set(sprintf(_("Le fichier %s est vide ou ne peut être lu"), $file, true));
            }
            $vue = service("Smarty");
            $vue->set($content, "markdownContent");
            fclose($handle);
            $vue->set("ppci/utils/markdownDisplay.tpl", "corps");
            return $vue->send();
        }
    }
}
