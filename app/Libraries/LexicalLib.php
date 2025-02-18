<?php

namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;

class LexicalLib extends PpciLibrary
{
    private $content;

    function __construct()
    {
        if (empty($_SESSION["lexical"])) {
            $radical = ROOTPATH . "documentation/lexical-";
        file_exists($radical . $_SESSION["locale"] . ".ini") ? $filename = $radical .  $_SESSION["locale"] . ".ini" : $filename = $radical . "-fr.ini";
        $f = fopen($filename, "r");
        if ($f) {
            while ($line = fgets($f)) {
                $line = trim($line);
                if (!empty($line)) {
                    $d = explode("=", $line);
                    $this->content[$d[0]] = str_replace('"','',[$d[1]]);
                }   
            }
            $_SESSION["lexical"] = $this->content;
            ksort($this->content);
        }
        } else {
            $this->content = $_SESSION["lexical"];
        }
    }
    function index()
    {
        $this->vue = service("Smarty");
        try {
            if (!empty($_REQUEST["lexical"])) {
                $this->vue->set($this->content[$_REQUEST["lexical"]], "lexique");
            }
            $this->vue->set($this->content, "lexique");
        } catch (PpciException $e) {
            $this->message->setSyslog("Error when parsing lexical",true);
            $this->message->setSyslog($e->getMessage(),true);
        }
        $this->vue->set('documentation/lexique.tpl', 'corps');
        return $this->vue->send();
    }
    function getAjax() {
        $this->vue = service ("AjaxView");
        $this->vue->set($this->content[$_REQUEST["lexical"]]);
        return $this->vue->send();
    }
}
