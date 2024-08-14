<?php
namespace Ppci\Libraries;

class News extends PpciLibrary
{
    static function getNews()
    {
        $filename = APPPATH . "Config/news" . $_SESSION["locale"] . ".txt";
        if (!file_exists($filename)) {
            $filename = APPPATH . "Config/news.txt";
        }
        $doc = "";
        $file = file($filename);
        foreach ($file as $value) {
            $doc .= htmlentities($value) . "<br>";
        }
        $vue = service("Smarty");
        $vue->set($doc, "texteNews");
        $vue->set("ppci/news.tpl", "corps");
        return $vue->send();
    }
}