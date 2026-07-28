<?php

namespace Ppci\Config;

use CodeIgniter\Config\BaseConfig;

class Cas extends BaseConfig
{
    /**
     * List of CAS servers, separated by comma
     * used only when identification mode is MIXED
     */
    public string $servers = "";

    public array $default = [
        "address" => "localhost",
        "uri" => "/cas",
        "port" => 443,
        "debug" => false,
        "CApath" => "",
        "getGroups" => 1,
        "groups" => "supannEntiteAffectation",
        "email" => "mail",
        "firstname" => "givenName",
        "lastname" => "sn",
        "name" => "cn",
        "logo" => "public/favicon.png"
    ];
}
