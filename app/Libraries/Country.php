<?php

namespace App\Libraries;

use App\Models\Country as ModelsCountry;
use App\Models\Import;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Country extends PpciLibrary
{
    /**
     * @var ModelsCountry
     */
    protected PpciModel $dataclass;



    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsCountry();
        $this->keyName = "country_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function list()
    {
        $this->vue = service('Smarty');
        /*
         * Display the list of all records of the table
         */
        $this->vue->set($this->dataclass->getListe(2), "countries");
        $this->vue->set("param/countryList.tpl", "corps");
        return $this->vue->send();
    }
    function import()
    {
        if ($_POST["importOption"] == "fr" || $_POST["importOption"] == "en") {
            $filename = ROOTPATH . "documentation/countries-" . $_POST["importOption"] . ".csv";
        } else {
            $filename = $_FILES['upfile']['tmp_name'];
        }
        if (!file_exists($filename)) {
            $this->message->set(_("Le fichier n'existe pas ou n'a pas pu être téléchargé"), true);
        } else {
            $db = $this->dataclass->db;
            try {
                $import = new Import($filename, ",", false, ["id", "alpha2", "alpha3", "name"]);
                $rows = $import->getContentAsArray();
                $nb = 0;
                $db->transBegin();
                foreach ($rows as $row) {
                    $data = [
                        "country_name" => $row["name"],
                        "country_code2" => strtoupper($row["alpha2"]),
                        "country_code3" => strtoupper($row["alpha3"]),
                        "country_id" => $row["id"]
                    ];
                    $this->dataclass->ecrire($data);
                    $nb++;
                }
                $db->transCommit();
                $this->message->set(sprintf(_("%s pays importés"), $nb));
            } catch (PpciException $e) {
                if ($db->transEnabled) {
                    $db->transRollback();
                }
                $this->message->set(_("Impossible d'importer la liste des pays"), true);
                $this->message->set($e->getMessage());
            }
        }
    }
}
