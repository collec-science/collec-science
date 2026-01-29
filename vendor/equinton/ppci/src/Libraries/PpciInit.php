<?php

namespace Ppci\Libraries;

use Config\App;
use \Ppci\Models\Log;
use \Ppci\Libraries\PpciException;


class PpciInit
{
    protected static $isInitialized = false;
    protected static $isDbversionOk = false;
    static function init()
    {
        if (!self::$isInitialized) {
            /**
             * Add generic functions
             */
            helper('ppci');
            /**
             * Add messages to user and syslog
             */
            $message = service('MessagePpci');
            if ($_ENV["CI_ENVIRONMENT"] == "development") {
                $message->displaySyslog();
            }
            /**
             * Add filter messages
             */
            if (isset($_SESSION["filterMessages"])) {
                foreach ($_SESSION["filterMessages"] as $mes) {
                    $message->set($mes, true);
                }
                unset($_SESSION["filterMessages"]);
            }

            /**
             * Get parameters stored in ini file
             * and populate App/Config/App class
             */
            /**
             * @var App
             */
            $appConfig = service("AppConfig");
            try {
                /**
                 * Set the locale
                 */
                if (!isset($_SESSION["locale"])) {
                    $locale = new Locale();
                    if (isset($_COOKIE["locale"])) {
                        $language = $_COOKIE["locale"];
                    } else {
                        /**
                         * Recuperation de la langue du navigateur
                         */
                        $language = explode(';', $_SERVER['HTTP_ACCEPT_LANGUAGE']);
                        $language = substr($language[0], 0, 2);
                    }
                    $locale->setLocale($language);
                } else {
                    set_translation_language($_SESSION["locale"]);
                }

                /**
                 * @var Database
                 */
                $paramDb = config("Database");
                /**
                 * set the connection
                 */
                $db = db_connect();
                $db->query("set search_path = " . $paramDb->default["searchpath"]);
                /**
                 * purge logs in database
                 */
                if (!isset($_SESSION["log_purged"]) || !$_SESSION["log_purged"]) {
                    /**
                     * @var Log
                     */
                    $log = service('Log');
                    $log->purge($appConfig->logDuration);
                    /**
                     * Delete old files in temp folder
                     */
                    $liveDuration = 3600 * 24; // delete all files longer than 24 hours
                    /**
                     * purge temp directory
                     */
                    self::folderPurge($appConfig->APP_temp, $liveDuration);
                    /**
                     * purge session directory
                     */
                    $sessionParam = config("session");
                    self::folderPurge($sessionParam->savePath, $liveDuration);
                    /**
                     * purge log files in writable/logs
                     */
                    $errorLogs = new ErrorLogs;
                    $errorLogs->purgeLogs($appConfig->logDuration);
                    $_SESSION["log_purged"] = true;
                }
            } catch (PpciException $e) {
                $message->set($e->getMessage());
            }

            self::$isInitialized = true;
        }
    }
    static function folderPurge($directory, $liveDuration)
    {
        $folder = opendir($directory);
        if ($folder) {
            while (false !== ($entry = readdir($folder))) {
                $path = $directory . "/" . $entry;
                $file = fopen($path, 'r');
                if ($file) {
                    $stat = fstat($file);
                    $atime = $stat["atime"];
                    fclose($file);
                    $infos = pathinfo($path);
                    if (!is_dir($path) && ($infos["basename"] != ".gitkeep") && ($infos["basename"] != "index.html")) {
                        $age = time() - $atime;
                        if ($age > $liveDuration) {
                            unlink($path);
                        }
                    }
                }
            }
        }
    }
}
