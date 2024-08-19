<?php

namespace App\Libraries;

use App\Models\Country as ModelsCountry;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Country extends PpciLibrary
{
    /**
     * @var ModelsCountry
     */
    protected PpciModel $dataclass;

    private $keyName;

    function __construct()
    {
        parent::__construct();
        $this->dataClass = new ModelsCountry();
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
}
