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
        "subject" => "sujet",
        "from" => "from@adresse.com",
        "contents" => "texte message"
    );

    /**
     * Constructeur de la classe, avec passage des parametres
     *
     * @param array $param
     * @param array $variables
     *            : variables utilisees dans le message
     */
    function __construct(array $param = array())
    {
        $this->setParam($param);
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
        if (strlen($dest) > 0) {
        $message = str_replace(array_keys($data), array_values($data), $this->param["contents"]);
        $subject = str_replace(array_keys($data), array_values($data), $this->param["subject"]);

        $message = wordwrap($message, 70, PHP_EOL);
        return mail($dest, $subject, $message, $this->getHeaders());
        } else {
            throw  new MailException("Mail->sendMail : no recipient address");
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
        return 'Content-type: text/html; charset=UTF-8' . PHP_EOL . 'From: ' . $this->param["from"] ;
    }
}
?>
