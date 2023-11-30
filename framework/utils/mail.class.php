<?php

/**
 * @author Eric Quinton
 * @copyright Copyright (c) 2015, IRSTEA / Eric Quinton
 * @license http://www.cecill.info/licences/Licence_CeCILL-C_V1-fr.html LICENCE DE LOGICIEL LIBRE CeCILL-C
 *  Creation 30 sept. 2015
 */
class MailException extends Exception
{
}
class Mail
{

    private $param = array(
        "replyTo" => "",
        "subject" => "subject",
        "contents" => "text message",
        "mailTemplate" => "framework/mail/mail.tpl" /* name of the main Smarty template used to send mails */
    );

    private Smarty $smarty;

    /**
     * Constructeur de la classe, avec passage des parametres
     *
     * @param array $param
     */
    function __construct(array $param = array())
    {
        $this->setParam($param);
        if (!isset($this->param["from"])) {
            global $APPLI_mail;
            $this->param["from"] = $APPLI_mail;
        }
    }

    /**
     * Assigne les parametres fournies en variable de classe
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
     * @param array $smartyParam Parameters to initialize Smarty
     * @param string $dest Mail of the recipient
     * @param string $subject subject of the mail
     * @param string $template_name name of the smarty template
     * @param array $data list of variables to transfert to the smarty instance
     * @param string $locale language used by the recipient
     * @param boolean $debug if true, display the content of the mail and the variables nor send message
     * @return bool
     */
    function SendMailSmarty(array $smartyParam, string $dest, string $subject, string $template_name, array $data, string $locale = "fr", bool $debug = false)
    {
        if (!isset($this->smarty)) {
            $this->smarty = new Smarty();
            $this->smarty->template_dir = $smartyParam["templates"];
            $this->smarty->compile_dir = $smartyParam["templates_c"];
            $this->smarty->cache_dir = $smartyParam["cache_dir"];
            $this->smarty->caching = $smartyParam["cache"];
        }
        $currentLocale = $_SESSION['LANG']["locale"];
        if ($locale != $currentLocale) {
            initGettext($locale);
        }
        foreach ($data as $variable => $value) {
            $this->smarty->assign($variable, $value);
        }
        $this->smarty->assign("mailContent", $template_name);
        /**
         * Add the logo to the main template
         */
        $this->smarty->assign("logo", "data:image/png;base64," . chunk_split(base64_encode(file_get_contents("favicon.png"))));
        if (!$debug) {
            $status = mail($dest, $subject, $this->smarty->fetch($this->param["mailTemplate"]), $this->getHeaders());
        } else {
            printA($this->param);
            printA($data);
            $this->smarty->display($this->param["mailTemplate"]);
            $status = true;
        }
        if ($locale != $currentLocale) {
            initGettext($currentLocale);
        }
        /**
         * Generate logs
         */
        global $log;
        empty($_SESSION["login"]) ? $login = "system" : $login = $_SESSION["login"];
        $log->setLog($login, "sendMail", "$dest / $subject");
        return $status;
    }

    /**
     * Retourne les entetes du message
     *
     * @return string
     */
    function getHeaders()
    {
        /*
         * Preparation de l'entete
         */
        return 'Content-type: text/html; charset=UTF-8;';
    }
}