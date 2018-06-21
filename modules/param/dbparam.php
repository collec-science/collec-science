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
            $message->set (_("Enregistrement effectué"));
            $module_coderetour = 1;
            $log->setLog ( $_SESSION ["login"], get_class ( $dataClass ) . "-writeGlobal" );
        }catch (Exception $e) {
            if ($OBJETBDD_debugmode > 0) {
                foreach ($dataClass->getErrorData(1) as $messageError) {
                    $message->set($messageError);
                }
            } else {
                $message->set (_("Problème lors de la mise en fichier..."));
            }
            $message->setSyslog ( $e->getMessage () );
            $module_coderetour = - 1;
        }
        break;
}
?>