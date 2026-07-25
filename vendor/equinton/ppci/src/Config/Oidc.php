<?php

namespace Ppci\Config;

use CodeIgniter\Config\BaseConfig;

class Oidc extends BaseConfig
{
    /**
     * List of Oidc servers, separated by comma
     * used only when identification mode is MIXED
     */
    public string $servers = "";

     public array $default = [
        "name" => "display name",
        "provider" => 'https://id.provider.com',
        "clientId" => 'ClientIDHere',
        "clientSecret" => 'ClientSecretHere',
        "name" => "name",
        "email" => "email",
        "groups" => "supannEntiteAffectationPrincipale",
        "firstname" => "given_name",
        "lastname" => "family_name",
        "scopeGroup" => "affectation",
        "getGroups" => 1,
        "logo" => "public/favicon.png",
        "isPublic" => 0
    ];

    public array $orcid = [
        "name" => "ORCID",
        "provider" => 'https://sandbox.orcid.org',
        "clientId" => 'ClientIDHere',
        "clientSecret" => 'ClientSecretHere',
        "name" => "name",
        "email" => "email",
        "groups" => "supannEntiteAffectationPrincipale",
        "firstname" => "given_name",
        "lastname" => "family_name",
        "scopeGroup" => "affectation",
        "getGroups" => 0,
        "logo" => "public/display/images/orcid.png",
        "isPublic" => 1
    ];
}
