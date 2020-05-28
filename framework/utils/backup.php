<?php

/**
 * Generate a backup of the database, and send it to the browser
 */

switch ($t_module["param"]) {
  case "display":
    $vue->set("framework/backup.tpl", "corps");
    break;
  case "exec":
    /**
     * Extract the database name and the server name
     */

    $dsn = explode(";", $BDD_dsn);
    $dsn_server = explode("=", $dsn[0]);
    $dsn_db = explode("=", $dsn[1]);
    $dbname = "postgresql://" . $BDD_login . ":" . $BDD_passwd . "@" . $dsn_server[1] . "/" . $dsn_db[1];
    $tmpname = tempnam($APPLI_temp, "backup");
    $filename = $dsn_db[1] . "-" . date("YmdHis") . ".sql.gz";
    $command = "pg_dump --dbname=$dbname |gzip -c > $tmpname";
    /**
     * Create the backup file
     */
    exec($command);
    if (file_exists($tmpname) && filesize($tmpname)>0) {
      /**
       * Send the file to the browser
       */
      $module_coderetour = 1;
    } else {
      $message->set(_("Le fichier de backup n'a pas été généré"));
      $module_coderetour = -1;
    }
    break;
  case "send":
    /**
     * send the file to the browser
     */
    if (file_exists($tmpname)) {
      $param = array(
        "tmp_name" => $tmpname,
        "disposition" => "attachment",
        "filename" => $filename
      );
      $vue->setParam($param);
    } else {
      $message->set(_("Le fichier de backup à charger n'a pas été trouvé"));
      $module_coderetour = -1;
      unset($vue);
    }
    break;
}
