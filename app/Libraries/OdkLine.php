<?php

namespace App\Libraries;

use App\Models\OdkLine as ModelOdkLine;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class OdkLine extends PpciLibrary
{

    /**
     * @var ModelOdkLine
     */
    protected PpciModel $dataclass;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelOdkLine;
        $this->keyName = "odk_line_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function writeLines()
    {
        $db = $this->dataclass->db;
        try {
            $odkId = $_POST["odk_id"];
            if (!is_numeric($odkId) || $odkId == 0) {
                throw new PpciException(_("L'identifiant du formulaire ODK n'est pas dans le format attendu"));
            }
            $db->transBegin();
            /**
             * Generate the list of lines
             */
            $lines = [];
            foreach ($_POST as $k => $v) {
                if (substr($k, 0, 5) == "line_") {
                    $var = explode("-", $k);
                    $lines[$var[1]][$var[0]] = $v;
                }
            }
            /**
             * write all lines
             */
            foreach ($lines as $lineId => $line) {
                $line["odk_line_id"] = $lineId;
                $line["odk_id"] = $odkId;
                $this->dataclass->write($line);
            }
            $db->transCommit();
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            $db->transRollback();
        }
    }
}
