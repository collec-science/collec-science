<?php

namespace Ppci\Libraries;

/**
 * HelpPpci
 * 
 * Used to generate help address for native modules of Ppci
 * 
 * must be herited in app/Config/HelpPpci.php
 * It's used by SmartyPpci and declared in app/config/Services.php
 * 
 * Example of implementation:
 * 
 * <?php
 * namespace Config;
 * use Ppci\Libraries\HelpPpci as LibrariesHelpPpci;
 * class HelpPpci extends LibrariesHelpPpci
 * {
 *    function __construct()
 *   {
 *        $this->set("totp", _("identification/la-double-authentification.html"));
 *   }
 * }
 * 
 */
abstract class HelpPpci
{

    protected $helps = [];

    function get(string $key)
    {
        if (array_key_exists($key, $this->helps)) {
            return ($this->helps[$key]);
        } else {
            return false;
        }
    }
    function set(string $key, string $address)
    {
        $this->helps[$key] = $address;
    }
}
