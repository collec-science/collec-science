<?php
require_once 'modules/classes/utils/translation.class.php';
$dataClass = new Translation($bdd, $ObjetBDDParam);
$keyName = "translation_id";
$id = $_REQUEST[$keyName];
$country = $_REQUEST["country"];
if (empty($country)) {
    $country = "en";
}
switch ($t_module["param"]) {
    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $vue->set("utils/translationChange.tpl", "corps");
        $vue->set($dataClass->getListeFromCountry($country), "data");
        $vue->set($country, "country");
        break;
    case "write":
        /*
         * write record in database
         */
        try {
            $dataClass->writeAll($_POST);
            $module_coderetour = 1;
            $message->set(_("Enregistrement effectué"));
        } catch (ObjetBDDException $o) {
            $message->set(_("Une erreur est survenue pendant l'enregistrement des traductions"), true);
            $message->setSyslog($o->getMessage());
            $module_coderetour = -1;
        }
        break;
    case "delete":
        /*
         * delete record
         */
        dataDelete($dataClass, $id);
        break;
}