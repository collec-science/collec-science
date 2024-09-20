<?php

namespace Ppci\Controllers;

use Ppci\Libraries\Locale as LibrariesLocale;

class Locale extends PpciController
{
    function Index($locale = "")
    {
        if (empty($locale) && isset($_REQUEST["locale"])) {
            $locale = $_REQUEST["locale"];
        }
        if (!empty($locale)) {
            $localeLib = new LibrariesLocale();
            $localeLib->setLocale($locale);
            if (isset($_SESSION["menu"])) {
                unset($_SESSION["menu"]);
            }
        }
        return defaultPage();
    }
}