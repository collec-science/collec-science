<?php

namespace Config;

use CodeIgniter\Config\BaseConfig;

class App extends BaseConfig
{
    /**
     * --------------------------------------------------------------------------
     * Base Site URL
     * --------------------------------------------------------------------------
     *
     * URL to your CodeIgniter root. Typically, this will be your base URL,
     * WITH a trailing slash:
     *
     *    http://example.com/
     */
    public string $baseURL = 'http://localhost:8080/';

    /**
     * Allowed Hostnames in the Site URL other than the hostname in the baseURL.
     * If you want to accept multiple Hostnames, set this.
     *
     * E.g. When your site URL ($baseURL) is 'http://example.com/', and your site
     *      also accepts 'http://media.example.com/' and
     *      'http://accounts.example.com/':
     *          ['media.example.com', 'accounts.example.com']
     *
     * @var list<string>
     */
    public array $allowedHostnames = [];

    /**
     * --------------------------------------------------------------------------
     * Index File
     * --------------------------------------------------------------------------
     *
     * Typically this will be your index.php file, unless you've renamed it to
     * something else. If you are using mod_rewrite to remove the page set this
     * variable so that it is blank.
     */
    public string $indexPage = '';

    /**
     * --------------------------------------------------------------------------
     * URI PROTOCOL
     * --------------------------------------------------------------------------
     *
     * This item determines which server global should be used to retrieve the
     * URI string.  The default setting of 'REQUEST_URI' works for most servers.
     * If your links do not seem to work, try one of the other delicious flavors:
     *
     * 'REQUEST_URI'    Uses $_SERVER['REQUEST_URI']
     * 'QUERY_STRING'   Uses $_SERVER['QUERY_STRING']
     * 'PATH_INFO'      Uses $_SERVER['PATH_INFO']
     *
     * WARNING: If you set this to 'PATH_INFO', URIs will always be URL-decoded!
     */
    public string $uriProtocol = 'REQUEST_URI';

    /**
     * --------------------------------------------------------------------------
     * Default Locale
     * --------------------------------------------------------------------------
     *
     * The Locale roughly represents the language and location that your visitor
     * is viewing the site from. It affects the language strings and other
     * strings (like currency markers, numbers, etc), that your program
     * should run under for this request.
     */
    public string $defaultLocale = 'fr';

    /**
     * --------------------------------------------------------------------------
     * Negotiate Locale
     * --------------------------------------------------------------------------
     *
     * If true, the current Request object will automatically determine the
     * language to use based on the value of the Accept-Language header.
     *
     * If false, no automatic detection will be performed.
     */
    public bool $negotiateLocale = true;

    /**
     * --------------------------------------------------------------------------
     * Supported Locales
     * --------------------------------------------------------------------------
     *
     * If $negotiateLocale is true, this array lists the locales supported
     * by the application in descending order of priority. If no match is
     * found, the first locale will be used.
     *
     * IncomingRequest::setLocale() also uses this list.
     *
     * @var string[]
     */
    public array $supportedLocales = ['fr', 'en'];

    /**
     * --------------------------------------------------------------------------
     * Application Timezone
     * --------------------------------------------------------------------------
     *
     * The default timezone that will be used in your application to display
     * dates with the date helper, and can be retrieved through app_timezone()
     *
     * @see https://www.php.net/manual/en/timezones.php for list of timezones supported by PHP.
     */
    public string $appTimezone = 'UTC';

    /**
     * --------------------------------------------------------------------------
     * Default Character Set
     * --------------------------------------------------------------------------
     *
     * This determines which character set is used by default in various methods
     * that require a character set to be provided.
     *
     * @see http://php.net/htmlspecialchars for a list of supported charsets.
     */
    public string $charset = 'UTF-8';

    /**
     * --------------------------------------------------------------------------
     * Force Global Secure Requests
     * --------------------------------------------------------------------------
     *
     * If true, this will force every request made to this application to be
     * made via a secure connection (HTTPS). If the incoming request is not
     * secure, the user will be redirected to a secure version of the page
     * and the HTTP Strict Transport Security header will be set.
     */
    public bool $forceGlobalSecureRequests = true;

    /**
     * --------------------------------------------------------------------------
     * Reverse Proxy IPs
     * --------------------------------------------------------------------------
     *
     * If your server is behind a reverse proxy, you must whitelist the proxy
     * IP addresses from which CodeIgniter should trust headers such as
     * X-Forwarded-For or Client-IP in order to properly identify
     * the visitor's IP address.
     *
     * You need to set a proxy IP address or IP address with subnets and
     * the HTTP header for the client IP address.
     *
     * Here are some examples:
     *     [
     *         '10.0.1.200'     => 'X-Forwarded-For',
     *         '192.168.5.0/24' => 'X-Real-IP',
     *     ]
     *
     * @var array<string, string>
     */
    public array $proxyIPs = [];

    /**
     * --------------------------------------------------------------------------
     * Content Security Policy
     * --------------------------------------------------------------------------
     *
     * Enables the Response's Content Secure Policy to restrict the sources that
     * can be used for images, scripts, CSS files, audio, video, etc. If enabled,
     * the Response object will populate default values for the policy from the
     * `ContentSecurityPolicy.php` file. Controllers can always add to those
     * restrictions at run time.
     *
     * For a better understanding of CSP, see these documents:
     *
     * @see http://www.html5rocks.com/en/tutorials/security/content-security-policy/
     * @see http://www.w3.org/TR/CSP/
     */
    public bool $CSPEnabled = false;

    /**
     * --------------------------------------------------------------------------
     * PPCI parameters
     * --------------------------------------------------------------------------
     *
     * @var string
     */
    public string $version = "v24.0.0";
    /**
     * versionDate - don't change here, but in function setParameters() below
     *
     * @var string
     */
    public string $versionDate = "30/06/2024";
    /**
     * Number of the database version
     *
     * @var string
     */
    public string $dbversion = "24.0";
    /**
     * Location of the database schema
     *
     * @var string
     */
    public string $databaseSchemaFile = ROOTPATH . "documentation/schema.png";
    /**
     * Duration of conservation of logs in table log
     *
     * @var integer
     */
    public int $logDuration = 365;

    /**
     * Keys used to encrypt data in database or generate tokens
     *
     * @var string
     */
    public $privateKey = ROOTPATH . "id_app";
    public $pubKey = ROOTPATH . "id_app.pub";
    /**
     * List of locales date formats
     *
     * @var array
     */
    public $locales = [
        "fr" => [
            "formatdate" => "DD/MM/YYYY",
            "formatdatetime" => "DD/MM/YYYY HH:mm:ss",
            "formatdatecourt" => "dd/mm/yy",
            "maskdatelong" => "d/m/Y H:i:s",
            "maskdate" => "d/m/Y",
            "maskdateexport" => 'd-m-Y'
        ], "en" => [
            "formatdate" => "DD/MM/YYYY",
            "formatdatetime" => "DD/MM/YYYY HH:mm:ss",
            "formatdatecourt" => "dd/mm/yy",
            "maskdatelong" => "d/m/Y H:i:s",
            "maskdate" => "d/m/Y",
            "maskdateexport" => 'd-m-Y'
        ]
    ];
    /**
     * List of locales used in the app. The second parameter must be declared in 
     * /etc/locale.gen (locale-gen en-GB.UTF-8 to generate it)
     *
     * @var array
     */
    public $localesGettext = [
        "en" => "en_GB.UTF-8",
        "fr" => "C.UTF-8"
    ];
    /**
     * Domain of defined rights
     *
     * @var string
     */
    public $GACL_aco = "app";
    /**
     * Generic mail used to send messages to the administrators
     *
     * @var string
     */
    public $APP_mail = "mail@society.com";
    /**
     * Set true if send mails is enabled
     *
     * @var boolean
     */
    public $MAIL_enabled = true;

    /**
     * Parameters to send mails
     *
     * @var array
     */
    public $MAIL_param = array(
        "mailTemplate" => "ppci/mail/mail.tpl",
        "from" => "account@society.com",
        "defaultLocale" => "fr",
        "mailDebug" => 0
    );
    /**
     * Duration before resend a mail to administrators for the same event
     *
     * @var integer
     */
    public $APP_mailToAdminPeriod = 7200;
    /**
     * Minimal length of a password
     *
     * @var integer
     */
    public $APP_passwordMinLength = 12;
    /**
     * Folder to store temporary files
     *
     * @var [type]
     */
    public $APP_temp = WRITEPATH . "temp";

    /**
     * Ini file to add new parameters
     */
    public $APP_menufile = APPPATH . "Config/menu.xml";
    /**
     * Address to give help or to declare bug
     *
     * @var string
     */
    /**
     * URL of assistance
     *
     * @var string
     */
    public $APP_help_address = "https://github.com/equinton/ppci/issues/new";
    /**
     *
     * @var string
     */
    public $copyright = "Copyright © 2024 - All rights reserved. Author : Éric Quinton - Software distributed under AGPL license";

    /**
     * Max duration of a session
     *
     * @var integer
     */
    public $APPLI_absolute_session = 36000; // 10 hours

    /**
     * Disable the possibility to create or modifiy a right into the application
     *
     * @var integer
     */
    public $GACL_disable_new_right = 1;

    /**
     * Get last release informations
     * Ask Github or Gitlab to obtains informations on the last published release
     */
    public $checkRelease = 1;
    /**
     * Github server
     */
    public $APPLI_release = [
        "provider" => "github",
        "url" => "https://api.github.com/repos/equinton/ppci/releases/latest",
        "tag" => "tag_name",
        "date" => "published_at",
        "user_agent" => 'equinton/ppci',
        "description" => "body",
    ];
    /**
     * Gitlab server
     */
    /*
    public $APPLI_release = [
        "provider" => "gitlab",
        "url" => "https://gitlab.example.com/api/v4/projects/:id/releases/permalink/latest", // :id must be replaced by project_id
        "tag" => "tag_name",
        "date" => "released_at",
        "description" => "description",
    ];
    */
}
