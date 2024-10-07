<?php
namespace Ppci\Libraries\Views;

use Config\App;
use \Smarty\Smarty;
use \Ppci\Config\SmartyParam;
use \Ppci\Models\Menu;
use \App\Libraries\BeforeDisplay;


class SmartyPpci
{
    /**
     * Generic variables used when display templates
     *
     * @var array
     */
    protected $SMARTY_variables = array(
        "header" => "ppci/header.tpl",
        "footer" => "ppci/footer.tpl",
        "corps" => "main.tpl",
        "display" => "/display",
        "favicon" => "/favicon.png",
        "APPLI_title" => "Ppci",
        "APPLI_titre" => "Ppci",
        "LANG" => array(
            "date" => array(
                "locale" => "fr",
                "formatdate" => "DD/MM/YYYY",
                "formatdatetime" => "DD/MM/YYYY HH:mm:ss",
                "formatdatecourt" => "dd/mm/yy"
            )
        ),
        "menu" => "",
        "isConnected" => 0,
        "APP_help_address" => "",
        "developpementMode" => 1,
        "messageError" => 0,
        "copyright" => "Copyright © 2024"
    );
    /**
     * Variables that must not encoded before send
     *
     * @var array
     */
    public $htmlVars = array(
        "menu",
        "LANG",
        "message",
        "texteNews",
        "doc",
        "phpinfo",
        "markdownContent"
    );
    public $templateMain;
    protected \Smarty $smarty;
    protected $isSent = false;
    public function __construct()
    {
        if (!isset($this->smarty)) {
            $this->smarty = new \Smarty();
        }
        $smp = new SmartyParam();
        $this->smarty->caching = false;
        $this->smarty->setTemplateDir($smp->params["templateDir"]);
        $this->smarty->setCompileDir(ROOTPATH . $smp->params["compileDir"]);
        $this->templateMain = $smp->params["template_main"];
        $this->smarty->setCacheDir('cache');
        /**
         * Assign default variables to Smarty class
         */
        foreach ($this->SMARTY_variables as $k => $v) {
            $this->smarty->assign($k, $v);
        }
        /**
         * Assign variables from app/Config/App
         */
        /**
         * @var App
         */
        $appConfig = config("App");
        $this->set($appConfig->copyright, "copyright");
        $this->set($appConfig->APP_help_address, "APP_help_address");
        /**
         * Assign variables from dbparam table
         */
        $dbparam = service("Dbparam");
        $this->set($dbparam->getParam("APPLI_title"), "APPLI_title");
        /**
         * Development mode
         */
        if ($_ENV["CI_ENVIRONMENT"] == "development") {
            $content = sprintf(
                _("Mode développement - base de données : pgsql:host=%1s;dbname=%2s - schema : %3s"),
                $_ENV["database.default.hostname"],
                $_ENV["database.default.database"],
                $_ENV["database.default.searchpath"]
            );
            $this->set($content, "developmentMode");
        }
        /** Add the menu */
        if (!isset($_SESSION["menu"]) || $_ENV["CI_ENVIRONMENT"] == "development") {
            $menu = new Menu($appConfig->APP_menufile);
            $_SESSION["menu"] = $menu->generateMenu();
        }
        $this->set($_SESSION["menu"], "menu");
        $this->set($_SESSION["isLogged"], "isLogged");
        $this->set($_SESSION["login"], "login");
    }
    /**
     * Add variable to Smarty
     *
     * @param [type] $value
     * @param string $variableName
     * @return void
     */
    function set($value, string $variableName)
    {
        $this->smarty->assign($variableName, $value);
    }
    /**
     * Trigger display
     *
     * @return void
     */
    function send()
    {
        if (!$this->isSent) {
            $message = service('MessagePpci');
            if ($message->is_error) {
                $this->set(1, "messageError");
            }
            $this->set($_SESSION["userRights"], "rights");
            /**
             * Add specific variables
             */
            BeforeDisplay::setGeneric($this);
            /**
             * Encode data before send
             */
            foreach ($this->smarty->getTemplateVars() as $key => $value) {
                if (!in_array($key, $this->htmlVars)) {
                    $this->smarty->assign($key, esc($value));
                }
            }
            /**
             * Generate the CSRF Field
             */
            $this->smarty->assign("csrf", csrf_field());

            /**
             * Get messages
             */
            $this->smarty->assign("message", $message->getAsHtml());
            /**
             * Trigger the display
             */
            try {
                $this->smarty->display($this->templateMain);
            } catch (\Exception $e) {
                echo $e->getMessage();
            }
            $this->isSent = true;
        }
    }


    /**
     * Return the content of a variable
     *
     * @param string $variable
     * @return string|array
     */
    function get($variable = "")
    {
        return $this->smarty->getTemplateVars($variable);
    }
    /**
     * Legacy function
     * encode data to html display
     *
     * @param [type] $data
     * @return 
     */
    function encodehtml($data)
    {
        return esc($data);
    }
    function fetch(string $template)
    {
        return $this->smarty->fetch($template);
    }
}