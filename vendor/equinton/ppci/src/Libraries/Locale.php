<?php

namespace Ppci\Libraries;

use Config\App;
use Ppci\Config\Ppci;
use Ppci\Models\PpciException;

class Locale
{


    public array $LANG = array(
        "locale" => "fr",
        "date" => [
            "locale" => "fr",
            "formatdate" => "DD/MM/YYYY",
            "formatdatetime" => "DD/MM/YYYY HH:mm:ss",
            "formatdatecourt" => "dd/mm/yy",
            "maskdatelong" => "d/m/Y H:i:s",
            "maskdate" => "d/m/Y",
            "maskdateexport" => 'd-m-Y'
        ]
    );

    function setLocale(string $locale = "")
    {
        /**
         * @var App
         */
        $appConfig = service("AppConfig");
        if (empty($locale)) {
            if (isset($_COOKIE["locale"])) {
                $locale = $_COOKIE["locale"];
            } else {
                /**
                 * Get the locale of the browser
                 */
                $locale = explode(';', $_SERVER['HTTP_ACCEPT_LANGUAGE']);
                $locale = substr($locale[0], 0, 2);
            }
            if (empty($locale)) {
                $locale = array_key_first($appConfig->locales);
            }
        }
        if (!array_key_exists($locale, $appConfig->locales)) {
            $locale = array_key_first($appConfig->locales);
        }
        $_SESSION["date"] = $appConfig->locales[$locale];
        $_SESSION["locale"] = $locale;
        helper('cookie');
        set_cookie("locale", $locale, 31536000);

        /**
         * Parameters for gettext
         */
        set_translation_language($locale);
    }
}
