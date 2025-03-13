<?php

namespace CodeIgniter;

use CodeIgniter\Boot;
use Config\Paths;
use CodeIgniter\Config\DotEnv;

class BootApp extends Boot {

    protected static function loadDotEnv(Paths $paths): void
    {
        require_once $paths->systemDirectory . '/Config/DotEnv.php';
        if (isset($_SERVER["envPath"]) && is_file($file = $_SERVER["envPath"] . DIRECTORY_SEPARATOR . ".env") && is_readable($file)) {
            (new DotEnv($_SERVER["envPath"],".env"))->load();
        } else {
            (new DotEnv($paths->appDirectory . '/../'))->load();
        }
    }
}