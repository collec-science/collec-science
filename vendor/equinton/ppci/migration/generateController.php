<?php

/**
 * This program generate all controllers from a Route.php file
 * into the destination folder
 * 
 * The script must run as : 
 * php generateController.php Routes.php app/Controllers
 */

try {
    $filename = $argv[1];
    if (empty($filename)) {
        throw new Exception("You must add the name of the Route.php file to execute this program, as: php generateController.php Routes.php app/Controllers");
    }
    if (!file_exists($filename)) {
        throw new Exception("The file $filename don't exists");
    }
    $targetFolder = $argv[2];
    if (empty($targetFolder)) {
        throw new Exception("You must indicate in the second argument the path where the controllers will be created");
    }
    if (!is_dir($targetFolder)) {
        throw new Exception("The folder $targetFolder don't exists");
    }
    if (substr($targetFolder, -1) != '/') {
        $targetFolder .= "/";
    }
    $routes = [];
    /**
     * Open the file, and read each line
     */
    $handle = fopen($filename, 'r');
    while (($line = fgets($handle)) !== false) {
        if (str_contains($line, '$routes->')) {
            /**
             * Treatment of the line
             */
            $functionContent = explode(",", substr($line, strpos("(", $line), -2));
            $functionContent = str_replace (["'", '"', " ",")"], ["","","",""], $functionContent);
            $content = explode("::", $functionContent[1]);
            $routes[$content[0]][] = $content[1];
        }
    }
    fclose($handle);
    $i = 0;
    foreach ($routes as $route => $fonctions) {
        $librarieName = "Libraries" . $route;
        $corps = "<?php" . PHP_EOL
            . "namespace App\Controllers;" . PHP_EOL . PHP_EOL
            . "use \Ppci\Controllers\PpciController;" . PHP_EOL
            . "use App\Libraries\\" . $route . " as " . $librarieName .";". PHP_EOL . PHP_EOL
            . "class " . $route . " extends PpciController {" . PHP_EOL
            . 'protected $lib;' . PHP_EOL
            . "function __construct() {" . PHP_EOL
            . '$this->lib = new ' . $librarieName . "();" . PHP_EOL
            . "}" . PHP_EOL;
        foreach ($fonctions as $fonction) {
            $corps .= "function " . $fonction . "() {" . PHP_EOL
                . 'return $this->lib->' . $fonction . "();" . PHP_EOL
                . "}" . PHP_EOL;
        }
        $corps .= "}" . PHP_EOL;
        /**
         * Generate file
         */
        $target = $targetFolder . $route . ".php";
        if (($handle = fopen($target, "w")) === false) {
            throw new Exception(sprintf("unable to create the file %s", $target));
        }
        fwrite($handle, $corps);
        fclose($handle);
        $i++;
    }
    echo $i . " files generated" . PHP_EOL;
} catch (Exception $e) {
    echo $e->getMessage() . PHP_EOL;
}
