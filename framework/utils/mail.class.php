<?php

/**
 * @author Eric Quinton
 * @copyright Copyright (c) 2015, IRSTEA / Eric Quinton
 * @license http://www.cecill.info/licences/Licence_CeCILL-C_V1-fr.html LICENCE DE LOGICIEL LIBRE CeCILL-C
 *  Creation 30 sept. 2015
 */
class MailException extends Exception{}
class Mail
{

    private $param = array(
        "replyTo" => "",
        "subject" => "subjet",
        "contents" => "text message",
        "mailTemplate" => "framework/mail/mail.tpl"
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
        if (!isset($this->param["from"])){
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
     * Fonction d'envoi des mails
     *
     * @param string $dest
     *            : adresse de destination
     * @param array $data
     *            : parametres d'envoi du message
     * @return boolean
     */
    function sendMail($dest, array $data)
    {
        if (!empty($dest)) {
        $message = str_replace(array_keys($data), array_values($data), $this->param["contents"]);
        $subject = str_replace(array_keys($data), array_values($data), $this->param["subject"]);

        $message = wordwrap($message, 70, PHP_EOL);
        return mail($dest, $subject, $message, $this->getHeaders());
        } else {
            throw  new MailException("Mail->sendMail : no recipient address");
        }
    }

    /**
     * Send mail with smarty template
     *
     * @param array $smartyParam
     * @param string $dest
     * @param string $subject
     * @param string $template_name
     * @param array $data
     * @return bool
     */
    function SendMailSmarty(array $smartyParam, string $dest, string $subject, string $template_name, array $data, bool $debug = false) {
        if (!isset($this->smarty)) {
        $this->smarty = new Smarty();
        $this->smarty->template_dir = $smartyParam["templates"];
        $this->smarty->compile_dir = $smartyParam["templates_c"];
        $this->smarty->cache_dir = $smartyParam["cache_dir"];
        $this->smarty->caching = $smartyParam["cache"];
        }

        foreach ($data as $variable=>$value) {
        $this->smarty->assign($variable, $value);
        }
        $this->smarty->assign("mailContent", $template_name);
        if (!$debug) {
        return mail($dest, $subject, $this->smarty->fetch($this->param["mailTemplate"]),$this->getHeaders());
        } else {
            printA($this->param);
            printA($data);
            $this->smarty->display($this->param["mailTemplate"]);
        }
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
        return 'Content-type: text/html; charset=UTF-8;' ;
    }
}
