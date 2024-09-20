<?php

use Ppci\Models\Log;
use Config\App;

function test($content = "")
{
    global $testOccurrence;
    $nl = getLineFeed();
    if (!isset($testOccurrence)) {
        $testOccurrence == 1;
    }
    $retour = "test $testOccurrence : $content  <br>";
    $testOccurrence++;
    echo $retour . $nl;
}
/**
 * Display the content of a variable
 * with a structured format
 *
 * @param $arr
 * @param integer $level
 * @return string
 */
/**
 * Display the content of a variable
 * with a structured format
 *
 * @param $arr
 * @param integer $level
 * @return void
 */
function printA($arr, $level = 0, $exclude = array())
{
    $childLevel = $level + 1;
    $nl = getLineFeed();

    if (is_array($arr)) {
        foreach ($arr as $key => $var) {
            if (!in_array($key, $exclude)) {
                if (is_object($var)) {
                    $var = (array) $var;
                    $key .= " (object)";
                }
                for ($i = 0; $i < $level * 4; $i++) {
                    echo "&nbsp;";
                }
                echo $key . ": ";
                if (is_array($var)) {
                    echo $nl;
                    printA($var, $childLevel, $exclude);
                } else {
                    print_r($var);
                    echo $nl;
                }
            }
        }
    } else {
        echo "$arr" . $nl;
    }
}

function getLineFeed()
{
    if (is_cli()) {
        return PHP_EOL;
    } else {
        return "<br>";
    }
}

function setLogRequest($request, $comment = null)
{
    /**
     * @var Log
     */
    $log = service("Log");
    if (isset($_SESSION["login"])) {
        $login = $_SESSION["login"];
    } else if (isset($_REQUEST["login"])) {
        $login = $_REQUEST["login"];
    } else {
        $login = "Unknown";
    }
    $module = $request->getUri()->getRoutePath();
    $db = db_connect();
    $db->query("set search_path = " . $_ENV["database.default.searchpath"]);
    $log->setLog($login, $module, $comment);
}

/**
 * decode html vars
 *
 * @param [type] $data
 * @return 
 */
function htmlDecode($data)
{
    if (is_array($data)) {
        foreach ($data as $key => $value) {
            $data[$key] = htmlDecode($value);
        }
    } else {
        $data = htmlspecialchars_decode($data, ENT_QUOTES);
    }
    return $data;
}
if (!function_exists('defaultPage')) {
    /**
     * Go to the default page
     *
     * @return void
     */
    function defaultPage()
    {
        $default = new \Ppci\Libraries\DefaultPage();
        $default->display();
    }
}


/**
 * Set locale
 */
function set_translation_language($language)
{
    $lang_path = APPPATH . 'Language/locales';
    /**
     * @var App
     */
    $app = service("AppConfig");
    bindtextdomain('lang', $lang_path);
    textdomain('lang');
    setlocale(LC_ALL, $app->localesGettext[$language]);
}
