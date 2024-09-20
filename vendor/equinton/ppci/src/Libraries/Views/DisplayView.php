<?php

namespace Ppci\Libraries\Views;

/**
 * Display an arbitrary content into the browser
 */
class DisplayView extends DefaultView
{
    private $fp;
    function __construct()
    {
        $this->open();
    }
    function open()
    {
        $this->fp = fopen('php://output', 'w');
    }
    function set($content, $variable = "")
    {
        if (!$this->fp) {
            $this->open();
        }
        fwrite($this->fp, $content);
    }
    function send($param = null)
    {
        if ($this->fp) {
            fclose($this->fp);
            ob_flush();
            exit();
        }
    }
}
