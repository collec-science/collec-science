<?php

namespace Config;

use Ppci\Libraries\HelpPpci as LibrariesHelpPpci;

class HelpPpci extends LibrariesHelpPpci
{
    function __construct()
    {
        $this->set("totp", _("identification/la-double-authentification.html"));
        $this->set("groups", _("droits/les-groupes-d'utilisateurs.html"));
        
    }
}
