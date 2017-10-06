<?php
/**
 * Created : 6 oct. 2017
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2017 - All rights reserved
 */
require_once 'modules/classes/dbparam.class.php';
$dataClass = new DbParam($bdd,$ObjetBDDParam);
switch ($t_module["param"]) {
    case "list":
        $vue->set($dataClass->getListe(2) ,"data" );
        $vue->set("param/dbparamListChange.tpl" , "corps");
        break;
    case "writeGlobal":
        try {
            $dataClass->ecrireGlobal($_REQUEST);
            $message->set ( $LANG ["message"] [5] );
            $module_coderetour = 1;
            $log->setLog ( $_SESSION ["login"], get_class ( $dataClass ) . "-writeGlobal" );
        }catch (Exception $e) {
            if ($OBJETBDD_debugmode > 0) {
                $message->set ( $dataClass->getErrorData ( 1 ) );
            } else {
                $message->set ( $LANG ["message"] [12] );
            }
            $message->setSyslog ( $e->getMessage () );
            $module_coderetour = - 1;
        }
        break;
}
?>