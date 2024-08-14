<?php
namespace Ppci\Libraries;
use \Ppci\Config\SmartyParam;
use Ppci\Libraries\Views\DisplayView;

/**
 * @author Eric Quinton
 * @copyright Copyright (c) 2015, IRSTEA / Eric Quinton
 * @license http://www.cecill.info/licences/Licence_CeCILL-C_V1-fr.html LICENCE DE LOGICIEL LIBRE CeCILL-C
 *  Creation 30 sept. 2015
 */

class Mail
{
    private $param = array(
        "replyTo" => "",
        "subject" => "subject",
        "contents" => "text message",
        "mailTemplate" => "ppci/mail/mail.tpl" /* name of the main Smarty template used to send mails */
    );

    private \Smarty $smarty;
    /**
     * @var App
     */
    private $paramApp;
    public $templateMain;
    /**
     * Constructeur de la classe, avec passage des parametres
     *
     * @param array $param
     */
    function __construct()
    {
        $this->smarty = new \Smarty();
        $smp = new SmartyParam();
        $this->smarty->caching = false;
        $this->smarty->setTemplateDir($smp->params["templateDir"]);
        $this->smarty->setCompileDir(ROOTPATH . $smp->params["compileDir"]);
        $this->templateMain = $smp->params["template_main"];
        $this->smarty->setCacheDir(WRITEPATH.'cache');
        $this->paramApp = service ("AppConfig");
    }

    /**
     * Assign the parameters
     *
     * @param array $param
     */
    function setParam(array $param)
    {
        foreach ($param as $key => $value) {
            if (isset($this->param[$key])) {
                $this->param[$key] = $value;
            }
        }
    }

    /**
     * Send mail with smarty template
     *
     * @param string $dest Mail of the recipient
     * @param string $subject subject of the mail
     * @param string $template_name name of the smarty template
     * @param array $data list of variables to transfert to the smarty instance
     * @param string $locale language used by the recipient
     * @param boolean $debug if true, display the content of the mail and the variables nor send message
     * @return bool
     */
    function SendMailSmarty( string $dest, string $subject, string $template_name, array $data, string $locale = "fr")
    {
        $currentLocale = $_SESSION["locale"];
        if ($locale != $currentLocale) {
            /**
             * @var Locale
             */
            $localeClass = new Locale();
            $localeClass->setLocale($locale);
        }
        foreach (["dest","subject","template_name"] as $var) {
            if (!empty ($$var)) {
                $this->param[$var] = $$var;
            }
        }
        foreach ($data as $variable => $value) {
            $this->smarty->assign($variable, $value);
        }
        $this->smarty->assign("mailContent", $template_name);
        /**
         * Add the logo to the main template
         */
        $this->smarty->assign("logo", "data:image/png;base64," . chunk_split(base64_encode(file_get_contents(FCPATH."favicon.png"))));
        $content = $this->smarty->fetch($this->param["mailTemplate"]);
        if ($this->paramApp->MAIL_param["mailDebug"] == 0) {
            $status = mail($this->param["dest"], $this->param["subject"], $content, $this->getHeaders());
        } else {
            /**
             * @var DisplayView
             */
            $view = service( "DisplayView");
            $view->set(print(_("Fac-similé de l'envoi d'un mail - mode debug").getLineFeed()));
            $view->set(print(_("Paramètres du mail :").getLineFeed()));
            $view->set(printA($this->param));
            $view->set(print(_("Données transmises :").getLineFeed()));
            $view->set(printA($data));
            $view->set($content);
            $view->send();
            $status = true;
        }
        if ($locale != $currentLocale) {
            $localeClass->setLocale($currentLocale);
        }
        /**
         * Generate logs
         */
        $log = service("Log");
        empty($_SESSION["login"]) ? $login = "system" : $login = $_SESSION["login"];
        $log->setLog($login, "sendMail", "$dest / $subject");
        if (!$status) {
            throw new PpciException(_("Un problème a été rencontré lors de l'envoi du mail"));
        }
        return $status;
    }

    /**
     * Get the headers
     *
     * @return string
     */
    function getHeaders()
    {
        return 'Content-type: text/html; charset=UTF-8;';
    }
}