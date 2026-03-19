<?php

namespace App\Libraries;

use Ppci\Libraries\PpciLibrary;

class ImportTemplate extends PpciLibrary
{
    function change()
    {
        $this->vue = service('Smarty');
        $this->vue->set("gestion/importTemplate.tpl", "corps");
        return $this->vue->send();
    }

    function generate() {}
}
