<?php
namespace Ppci\Libraries;

class Backup extends PpciLibrary
{
    static function display()
    {
        $vue = service("Smarty");
        $vue->set("ppci/backup.tpl", "corps");
        return $vue->send();
    }

    function exec()
    {
        $conf = config("Database");
        $dbname = "postgresql://" . $conf->default["username"] . ":" . $conf->default["password"] . "@" . $conf->default["hostname"] . "/" . $conf->default["database"];
        $tmpname = tempnam(WRITEPATH . "temp", "backup");
        $filename = $conf->default["database"] . "-" . date("YmdHis") . ".sql.gz";
        $command = "pg_dump --dbname=$dbname |gzip -c > $tmpname";
        /**
         * Create the backup file
         */
        exec($command);
        if (file_exists($tmpname) && filesize($tmpname) > 0) {
            /**
             * Send the file to the browser
             */
            $vuefile = service("BinaryView");
            $vuefile->setParam(
                [
                    "tmp_name" => $tmpname,
                    "disposition" => "attachment",
                    "filename" => $filename
                ]
            );
            $vuefile->send();
            $this->message->set(_("Fichier généré. Vérifiez son contenu !"));
            return "default";
        } else {
            $this->message->set(_("Le fichier de backup n'a pas été généré"), true);
            return "backupDisplay";
        }

    }

}