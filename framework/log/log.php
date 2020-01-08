<?php
/**
 * queries to log table
 */
switch ($t_module["param"]) {
    case "getLastConnections":
    $vue->set($log->getLastConnections($APPLI_absolute_session), "connections");
    $vue->set("framework/lastConnections.tpl", "corps");
    break;
    case "list":
    $vue->set($log->getDistinctValuesFromField("login"), "logins");
    $vue->set($log->getDistinctValuesFromField("nom_module"), "modules");
    if (isset($_POST["date_from"])) {
        $df = $_POST["date_from"];
        $dt = $_POST["date_to"];
        $vue->set($_POST["loglogin"],"loglogin");
        $vue->set($_POST["logmodule"],"logmodule");
    } else {
        $ds = new DateTime();
        $ds->modify("-1 month");
        $df = $ds->format($_SESSION["MASKDATE"]);
        $dt = date($_SESSION["MASKDATE"]);
    }
    $vue->set($df, "date_from");
    $vue->set($dt, "date_to");
    /**
     * Search triggering
     */
    if ($_POST["isSearch"] == 1) {
        $vue->set($log->search($_POST), "logs");
    }
    $vue->set("framework/logList.tpl", "corps");
    break;
}