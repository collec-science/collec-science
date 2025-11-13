<?php

namespace Ppci\Controllers;

use Ppci\Libraries\ErrorLogs as Lib;
use Ppci\Libraries\PpciException;

class ErrorLogs extends PpciController
{
    protected Lib $lib;
    function __construct()
    {
        $this->lib = new Lib;
    }

    function getListFiles()
    {
        try {
            $this->lib->getErrorLogFiles();
        } catch (PpciException) {
            return defaultPage();
        }
    }
    function getLogContent() {
        try {
            $this->lib->getContentFile($_REQUEST["logfile"]);
        } catch (PpciException) {
            return $this->getListFiles();
        }
    }
}
