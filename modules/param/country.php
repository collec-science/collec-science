<?php
require_once 'modules/classes/country.class.php';
$dataClass = new Country($bdd, $ObjetBDDParam);
$keyName = "country_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        /*
         * Display the list of all records of the table
         */
        $vue->set($dataClass->getListe(2), "countries");
        $vue->set("param/countryList.tpl", "corps");
        break;
}
