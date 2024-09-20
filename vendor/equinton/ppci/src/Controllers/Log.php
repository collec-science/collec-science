<?php
namespace Ppci\Controllers;

class Log extends PpciController
{
    function getLastConnections()
    {
        $log = service("Log");
        $log->setMessageLastConnections();
        $lib = new \Ppci\Libraries\DefaultPage();
        return ($lib->display());
    }
    function index() {
        $vue = service ("Smarty");
        $log = service("Log");
        if (!empty($_POST["date_from"])) {
            $df = $_POST["date_from"];
            $dt = $_POST["date_to"];
            $vue->set($_POST["loglogin"],"loglogin");
            $vue->set($_POST["logmodule"],"logmodule");
        } else {
            $ds = new \DateTime();
            $ds->modify("-1 month");
            $df = $ds->format($_SESSION["date"]["maskdate"]);
            $dt = date($_SESSION["date"]["maskdate"]);
        }
        $vue->set($log->getDistinctValuesFromField("login",$df, $dt), "logins");
        $vue->set($log->getDistinctValuesFromField("nom_module", $df, $dt), "modules");
        $vue->set($df, "date_from");
        $vue->set($dt, "date_to");
        /**
         * Search triggering
         */
        if ($_POST["isSearch"] == 1) {
            $vue->set($log->search($_POST), "logs");
        }
        $vue->set("ppci/logList.tpl", "corps");
        return $vue->send();
    }
}
