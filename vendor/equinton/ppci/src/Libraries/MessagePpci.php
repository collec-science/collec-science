<?php
namespace Ppci\Libraries;

class MessagePpci
{

    /**
     * Array with all messages
     *
     * @var array
     */
    private $_message = array();

    private $_syslog = array();

    private $_displaySyslog = false;

    public $is_error = false;

    function __construct($displaySyslog = false)
    {
        $this->_displaySyslog = $displaySyslog;
        if (isset($_SESSION["filterMessage"])) {
            foreach ($_SESSION["filterMessage"] as $message) {
                $this->set($message, true);
            }
            unset($_SESSION["filterMessage"]);
        }
    }

    /**
     * Add a new message
     *
     * @param string $value
     * @param boolean $is_error
     * @return void
     */
    function set(string $value, bool $is_error = false)
    {
        $this->_message[] = $value;
        if ($is_error) {
            $this->is_error = true;
        }
    }

    /**
     * Set a message to syslog
     *
     * @param string $message
     * @return void
     */
    function setSyslog($message, $is_error = false)
    {
        if ($is_error) {
            $this->is_error = true;
        }
        $dt = new \DateTime();
        $date = $dt->format("D M d H:i:s.u Y");
        $this->_syslog[] = $message;
        if ($this->is_error) {
            $priority = LOG_ERR;
            $level = "error";
        } else {
            $priority = LOG_INFO;
            $level = "info";
        }
        /**
         * Write log in system log
         */
        openlog("[$date] [" . $_SESSION["APPLI_code"] . ":$level]", LOG_PID | LOG_PERROR, LOG_LOCAL7);
        syslog($priority, $message);
        closelog();
    }

    /**
     * Get all messages
     * @return array
     */
    function get(): array
    {
        if ($this->_displaySyslog) {
            return array_merge($this->_message, $this->_syslog);
        } else {
            return $this->_message;
        }
    }

    /**
     * Get the number of messages recorded
     *
     * @return int
     */
    function getMessageNumber()
    {
        return (count($this->_message));
    }

    /**
     * Retourne le tableau formate avec saut de ligne entre
     * chaque message
     *
     * @return string
     */
    function getAsHtml()
    {
        if ($this->_displaySyslog) {
            $tableau = array_merge($this->_message, $this->_syslog);
        } else {
            $tableau = $this->_message;
        }
        return $this->gethtmlentities($tableau);
    }

    function gethtmlentities($tableau, $empty = true)
    {
        $data = "";
        foreach ($tableau as $value) {
            if (is_array($value)) {
                $data .= $this->gethtmlentities($value, $empty);
            } else {
                if (!$empty) {
                    $data .= "<br>";
                }
                $empty = false;
                $data .= htmlentities($value);
            }
        }
        return $data;
    }

    /**
     * Activate the display of syslog messages
     *
     * @param boolean $level
     * @return void
     */
    function displaySyslog(bool $level = true)
    {
        $this->_displaySyslog = $level;
    }
}
