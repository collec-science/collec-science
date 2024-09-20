<?php

namespace Ppci\Config;

use CodeIgniter\Config\BaseConfig;

class IdentificationConfig extends BaseConfig
{
    /**
     * Identification mode
     * BDD : logins in database
     * LDAP : login in LDAP xxx
     * CAS : use a CAS server
     * HEADER : use the login transmitted by the web server (identification SAML with Mellon)
     * LDAP-BDD : test first LDAP, then BDD
     * CAS-BDD : a button to use CAS identification
     * OIDC : use an OIDC server
     * OIDC-BDD : add choice to use OIDC identification in addition to BDD
     *
     * @var string
     */
    public $identificationMode = "BDD";
    public $disableTotpToAdmin = 0;
    /**
     * List of parameters to use SAML identification with apache2-mellon
     *
     * @var array
     */
    public $HEADER = array(
        "login" => "MELLON_MAIL",
        "email" => "MELLON_MAIL",
        "name" => "MELLON_cn",
        "firstname" => "MELLON_givenname",
        "lastname" => "MELLON_sn",
        "organization" => "MELLON_supannentiteaffectationprincipale",
        "organizationGranted" => array(),
        "createUser" => true,
        "groups" => "MELLON_supannentiteaffectation",
        "groupsGranted" => array(),
        "getGroups" => 1,
    );
    /**
     * Organizations granted for Header connection
     * each organization must be separated by a comma
     *
     * @var string
     */
    public $organizationsGranted = "";
    
    /**
     * Address to disconnect from header connection
     *
     * @var string
     */
    public $ident_header_logout_address = "";
    /**
     * Parameters for LDAP identification
     *
     * @var array
     */
    public array $LDAP = array(
        "address" => "localhost",
        "port" => 389,
        "rdn" => "cn=manager,dc=example,dc=com",
        "basedn" => "ou=people,ou=example,o=societe,c=fr",
        "user_attrib" => "uid",
        "v3" => true,
        "tls" => false,
        "upn_suffix" => "", //pour Active Directory
        "groupSupport" => false,
        "groupAttrib" => "supannentiteaffectation",
        "commonNameAttrib" => "displayname",
        "mailAttrib" => "mail",
        'attributgroupname' => "cn",
        'attributloginname' => "memberuid",
        'basedngroup' => 'ou=example,o=societe,c=fr',
        "timeout" => 2,
        "ldapnoanonymous" => false,
        "ldaplogin" => "",
        "ldappassword" => ""
    );
    /**
     * Parameters for CAS identification
     *
     * @var array
     */
    public array $CAS = array(
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
    );

    public $identificationLogo = FCPATH."favicon.png";

    public array $OIDC = [
        "name" => "INRAE",
        "provider" => 'https://id.provider.com',
        "clientId" => 'ClientIDHere',
        "clientSecret" => 'ClientSecretHere',
        "name" => "name",
        "email" => "email",
        "groups" => "supannEntiteAffectationPrincipale",
        "firstname" => "given_name",
        "lastname" => "family_name",
        "scopeGroup" => "affectation",
        "getGroups" => 1
    ];
    /**
     * Number of tentatives of connection before block
     *
     * @var integer
     */
    public $CONNECTION_max_attempts = 5;
    /**
     * Blocking duration, in seconds. Reinitialized at each tentative
     *
     * @var integer
     */
    public $CONNECTION_blocking_duration = 600;



    public $APP_passwordMinLength = 12;
    /**
     * If set to 1, authorises recovery of a new password in the event of loss. The send of emails must be activated too
     *
     * @var integer
     */
    public $APPLI_lostPassword = 1;

    /**
     * Duration of validity of the token used to reidentify the user
     */
    public $tokenIdentityValidity = 36000; // 10 hours

    /***********************
     * ADMIN parameters
     ***********************/
    /**
     * Duration of identification to access to the admin modules
     *
     * @var integer
     */
    public $adminSessionDuration = 600;
    /**
     * If false, disable the secondary identification with TOTP
     *
     * @var boolean
     */
    public $adminMustUseTotp = true;
    /**
     * Time to resend an email to the administrator if an account is blocked
     *
     * @var integer
     */
    public $APPLI_mailToAdminPeriod = 7200;

    /**
     * Miscellaneous
     */
    /**
     * Set 1 to disable the creation of new rights in table aclaco
     *
     * @var integer
     */
    public $GACL_disable_new_right = 1;
}
