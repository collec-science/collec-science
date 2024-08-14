<?php

/**
 * Parse actions.xml to extract routes and rights
 * Must be run as:
 * php actionsParse.php filename.xml
 * 
 * Generate two files:
 * - rights.txt
 * - routes.txt
 * 
 * Each content can be included in Config/Rights.php and Config/Routes.php
 */
try {
    $filename = $argv[1];
    if (empty ($filename)) {
        throw new Exception("You must add the name of the xml file to execute this program, as: php actionsParse.php actions.xml");
    }
    if (!file_exists($filename)) {
        throw new Exception("The file $filename don't exists");
    }
    $rights = "";
    $routes = "";
    $dom = new DOMDocument();
    $dom->load($filename);
    if (!$dom) {
        throw new Exception("The file $filename is not readable");
    }
    $root = $dom->getElementsByTagName($dom->documentElement->tagName);
    $root = $root->item(0);
    $nodes = $root->childNodes;
    foreach ($nodes as $node) {
        if ($node->hasAttributes() && $node->tagName != "model") {
            /*foreach ($nodes->attributes as $attname => $noeud_attribute) {
                $g_module[$noeud->tagName][$attname] = $noeud->getAttribute($attname);
            }*/
            $right = $node->getAttribute("droits");
            if (!empty ($right)) {
                $rights .= '"' . $node->tagName . '"=>[';
                $aRight = explode(',', $right);
                $i = 0;
                foreach ($aRight as $r) {
                    if ($i > 0) {
                        $rights .= ",";
                    }
                    $i++;
                    if ($r == "gestion" ) {
                        $r = "manage";
                    }
                    $rights .= '"' . $r . '"';
                }
                $rights .= '],' . PHP_EOL;
            }
            /**
             * Treatment of routes
             */
            $action = $node->getAttribute("action");
            if (!empty ($action)) {
                $action = str_replace(".php", "", $action);
                $aAction = explode("/", $action);
                $param = $node->getAttribute("param");
                if (empty ($param)) {
                    $param = "index";
                }
                $verb = "add";
                if (in_array($param, ["write", "delete"])) {
                    $verb = "post";
                }
                $aAction[0] == "framework" ? $radical = "\Ppci\Controllers\\" : $radical = "";
                //$action = str_replace(["modules/","ppci/", ".php"], ["","",""], $action);

                $routes .= '$routes->'.$verb."('" . lcfirst($node->tagName) . "', '" . $radical;
                for ($i = 1; $i < count($aAction); $i++) {
                    if ($i > 1) {
                        $routes .= "\\";
                    }
                    $routes .= ucfirst($aAction[$i]);
                }
                $routes .= "::" . $param . "');" . PHP_EOL;
            }
        }
    }


    echo $rights;

    echo PHP_EOL;

    echo $routes;

} catch (Exception $e) {
    echo $e->getMessage() . PHP_EOL;
}

