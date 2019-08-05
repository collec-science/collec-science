<?php
/**
 * queries to log table
 */
switch ($t_module["param"]) {
    case "getLastConnections":
    $vue->set($log->getLastConnections($APPLI_absolute_session), "connections");
    $vue->set("framework/lastConnections.tpl", "corps");
    break;
}