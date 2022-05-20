<?php

/**
 * Classe permettant d'enregistrer toutes les operations effectuees dans la base
 *
 * @author quinton
 *
 */
class Log extends ObjetBDD
{

    /**
     * Constructeur
     *
     * @param pdo   $p_connection
     * @param array $param
     */
    public function __construct($bdd, $param = null)
    {
        $this->table = "log";
        $this->colonnes = array(
            "log_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0,
            ),
            "login" => array(
                "type" => 0,
                "requis" => 0,
            ),
            "nom_module" => array(
                "type" => 0,
            ),
            "log_date" => array(
                "type" => 3,
                "requis" => 1,
            ),
            "commentaire" => array(
                "type" => 0,
            ),
            "ipaddress" => array(
                "type" => 0,
            ),
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Fonction enregistrant un evenement dans la table
     *
     * @param string $login
     * @param string $module
     * @param string $comment
     *
     * @return integer
     */
    public function setLog($login, $module, $commentaire = null)
    {
        global $GACL_aco;
        $data = array(
            "log_id" => 0,
            "commentaire" => $commentaire,
        );
        if (empty($login)) {
            if (!empty($_SESSION["login"])) {
                $login = $_SESSION["login"];
            } else {
                $login = "unknown";
            }
        }
        $data["login"] = $login;
        if (is_null($module)) {
            $module = "unknown";
        }
        $data["nom_module"] = $GACL_aco . "-" . $module;
        $data["log_date"] = date($_SESSION["MASKDATELONG"]);
        $data["ipaddress"] = $this->getIPClientAddress();
        return $this->ecrire($data);
    }

    /**
     * Fonction de purge du fichier de traces
     *
     * @param int $nbJours : nombre de jours de conservation
     *
     * @return int
     */
    public function purge($nbJours)
    {
        if ($nbJours > 0) {
            $sql = "delete from " . $this->table . "
					where log_date < current_date - interval '" . $nbJours . " day'";
            return $this->executeSQL($sql);
        }
    }

    /**
     * Recupere l'adresse IP de l'agent
     *
     * @return IPAddress
     */
    public function getIPClientAddress()
    {
        /*
         * Recherche si le serveur est accessible derriere un reverse-proxy
         */
        if (isset($_SERVER["HTTP_X_FORWARDED_FOR"])) {
            return $_SERVER["HTTP_X_FORWARDED_FOR"];
        } else if (isset($_SERVER["REMOTE_ADDR"])) {
            /*
             * Cas classique
             */
            return $_SERVER["REMOTE_ADDR"];
        } else {
            return -1;
        }
    }

    /**
     * Renvoie les informations de derniere connexion
     *
     * @return array
     */
    public function getLastConnexion()
    {
        global $GACL_aco;
        if (isset($_SESSION["login"])) {
            $module = $GACL_aco."-connection%";
            $sql = "select log_date, ipaddress from log where login = :login
            and nom_module like :module and commentaire like 'ok%'
            order by log_id desc limit 2";
            $data = $this->getListeParamAsPrepared(
                $sql,
                array(
                    "login" => $_SESSION["login"],
                    "module"=>$module
                )
            );
            return $data[1];
        }
    }
    /**
     * Get the list of all connexions during max duration of session
     *
     * @param integer $duration
     * @return array
     */
    public function getLastConnections($duration = 36000)
    {
        global $GACL_aco;
        if (isset($_SESSION["login"])) {
            $module = $GACL_aco."-connection%";
            $token = $GACL_aco."-connection-token";
            $sql = "select log_date, ipaddress from log where login = :login
            and nom_module like :module and commentaire like 'ok%' and commentaire <> :token
            and log_date > :datefrom
            order by log_id desc";
            $date = new DateTime("now");
            $date->sub(new DateInterval("PT" . $duration . "S"));
            return $this->getListeParamAsPrepared(
                $sql,
                array(
                    "login" => $_SESSION["login"],
                    "datefrom" => $date->format(DATELONGMASK),
                    "module" => $module,
                    "token" => $token
                )
            );
        }
    }

    /**
     * Retourne le dernier type de connexion realisee pour un compte
     *
     * @param string $login
     *
     * @return string
     */
    public function getLastConnexionType($login)
    {
        if (strlen($login) > 0) {
            global $GACL_aco;
            $like = " like '".$GACL_aco."-connection%'";
            $sql = "select nom_module from log";
            $sql .= " where login = :login and nom_module $like and commentaire = 'ok' and nom_module <> 'connection-token'";
            $sql .= "order by log_id desc limit 1";
            $data = $this->lireParamAsPrepared(
                $sql,
                array(
                    "login" => $login,
                )
            );
            $connectionType = explode("-", $data["nom_module"]);
            return $connectionType[2];
        }
    }

    /**
     * Recherche si le compte a fait l'objet de trop de tentatives de connexion
     * Si c'est le cas, declenche le blocage du compte pour la duree indiquee
     * La duree de blocage est reinitialisee a chaque tentative pendant la periode
     * de contention
     *
     * @param string $login
     * @param number $maxtime
     * @param number $nbMax
     *
     * @return boolean
     */
    public function isAccountBlocked($login, $maxtime = 600, $nbMax = 10)
    {
        global $GACL_aco;
        $is_blocked = true;
        /*
         * Verification si le compte est bloque, et depuis quand
         */
        $accountBlocking = false;
        $date = new DateTime("now");
        $date->sub(new DateInterval("PT" . $maxtime . "S"));
        $nom_module = $GACL_aco."-connectionBlocking";
        $sql = "select log_id from log where lower(login) = lower(:login) and nom_module = '$nom_module' and log_date > :blockingdate order by log_id desc limit 1";
        $data = $this->lireParamAsPrepared(
            $sql,
            array(
                "login" => $login,
                "blockingdate" => $date->format(DATELONGMASK),
            )
        );
        if ($data["log_id"] > 0) {
            $accountBlocking = true;
        }
        if (!$accountBlocking) {
            $nom_module = $GACL_aco."-connection%";
            $sql = "select log_date, commentaire from log where lower(login) = lower(:login)
                    and nom_module like '$nom_module'
                    and log_date > :blockingdate
                order by log_id desc limit :nbmax";
            $data = $this->getListeParamAsPrepared(
                $sql,
                array(
                    "login" => $login,
                    "nbmax" => $nbMax,
                    "blockingdate" => $date->format(DATELONGMASK),
                )
            );
            $nb = 0;
            /*
             * Recherche si une connexion a reussi
             */
            foreach ($data as $value) {
                if ($value["commentaire"] == "ok") {
                    $is_blocked = false;
                    break;
                }
                $nb++;
            }
            if ($nb >= $nbMax) {
                /*
                 * Verrouillage du compte
                 */
                $this->blockingAccount($login);
            } else {
                $is_blocked = false;
            }
        }
        return $is_blocked;
    }

    /**
     * Fonction de blocage d'un compte
     * - cree un enregistrement dans la table log
     * - envoie un mail aux administrateurs
     *
     * @param string $login
     */
    public function blockingAccount($login)
    {
        global $message, $APPLI_address, $GACL_aco;
        $login = strtolower($login);
        $this->setLog($login, "connectionBlocking");
        $message->setSyslog("connectionBlocking for login $login");
        $date = date("Y-m-d H:i:s");
        $subject = "SECURITY REPORTING - " . $GACL_aco . " - account blocked";
        $contents = "<html><body>" . "The account <b>$login<b> was blocked at $date for too many connection attempts" . '<br>Software : <a href="' . $APPLI_address . '">' . $APPLI_address . "</a>" . '</body></html>';
        $this->sendMailToAdmin($subject, $contents, "sendMailAdminForBlocking", $login);
    }
    /**
     * Calculate the number of calls to a module
     * return false if the number is greater than $maxNumber
     *
     * @param [varchar] $moduleName
     * @param [int] $maxNumber
     * @param [int] $duration: in seconds
     * @return boolean
     */
    public function getCallsToModule($moduleName, $maxNumber, $duration)
    {
        global $APPLI_address, $GACL_aco, $message;
        $sql = "select count(*) as nombre from log
                where nom_module = :moduleName
                and lower(login) = lower(:login)
                and log_date > :dateref
                ";
        $dateRef = date('Y-m-d H:i:s', time() - $duration);
        $moduleNameComplete = $GACL_aco . "-" . $moduleName;
        $data = $this->lireParamAsPrepared($sql, array("moduleName" => $moduleNameComplete, "login" => $_SESSION["login"], "dateref" => $dateRef));
        if ($data["nombre"] > $maxNumber) {
            $messageLog = $moduleName . "-Duration:" . $duration . "-nbCalls:" . $data["nombre"] . "-nbMax:" . $maxNumber;
            $this->setLog($_SESSION["login"], "nbMaxCallReached", $messageLog);
            $message->setSyslog($GACL_aco . "-" . $APPLI_address . ":nbMaxCallReached-" . $messageLog);
            $message->set(_("Le nombre d'accès autorisés pour le module demandé a été atteint. Si vous considérez que la valeur est trop faible, veuillez contacter l'administrateur de l'application"), true);
            $subject = "SECURITY REPORTING - " . $GACL_aco . " - Maximum number of calls to a module reached";
            $contents = "<html><body>" . "The account <b>" . $_SESSION["login"] . "<b> as reached the maximum number of authorized calls for the module $moduleName" . "<br>" . $data["nombre"] . " calls made in $duration seconds." . '<br>Software : <a href="' . $APPLI_address . '">' . $APPLI_address . "</a>" . '</body></html>';
            $this->sendMailToAdmin($subject, $contents, "sendMailAdminForMaxCalls", $_SESSION["login"]);
            return false;
        } else {
            return true;
        }
    }
    /**
     * Send mails to administrors
     *
     * @param [string] $subject: subject of mail
     * @param [string] $contents: content of mail, in html format
     * @param [string] $moduleName: name of the module recorded in log table for this send
     * @param [type] $login: login of the user concerned by this message
     * @return void
     */
    public function sendMailToAdmin($subject, $contents, $moduleName, $login)
    {
        global $message, $MAIL_enabled, $APPLI_mail, $APPLI_mailToAdminPeriod, $GACL_aco;
        $moduleNameComplete = $GACL_aco . "-" . $moduleName;

        if ($MAIL_enabled == 1) {
            include_once 'framework/identification/mail.class.php';
            include_once 'framework/droits/droits.class.php';
            include_once 'framework/identification/loginGestion.class.php';
            $MAIL_param = array(
                "replyTo" => "$APPLI_mail",
                "subject" => $subject,
                "from" => "$APPLI_mail",
                "contents" => $contents,
            );
            /*
             * Recherche de la liste des administrateurs
             */
            $aclAco = new Aclaco($this->connection, $this->paramori);
            $logins = $aclAco->getLogins("admin");
            /*
             * Envoi des mails aux administrateurs
             */
            if (isset($APPLI_mailToAdminPeriod)) {
                $period = $APPLI_mailToAdminPeriod;
            } else {
                $period = 7200;
            }
            $lastDate = date('Y-m-d H:i:s', time() - $period);
            $mail = new Mail($MAIL_param);
            $loginGestion = new LoginGestion($this->connection, $this->paramori);
            foreach ($logins as $value) {
                $admin = $value["login"];
                $dataLogin = $loginGestion->lireByLogin($admin);
                if (strlen($dataLogin["mail"]) > 0) {
                    /**
                     * search if a mail has been send to this admin for the same event and the same user recently
                     */
                    $sql = 'select log_id, log_date from log' . " where nom_module = :moduleName" . ' and login = :login' . ' and commentaire = :admin' . ' and log_date > :lastdate' . ' order by log_id desc limit 1';
                    $dataSql =  array(
                        "admin" => $admin,
                        "login" => $login,
                        "lastdate" => $lastDate,
                        "moduleName" => $moduleNameComplete
                    );
                    $logval = $this->lireParamAsPrepared(
                        $sql,
                        $dataSql
                    );
                    if (!$logval["log_id"] > 0) {
                        if ($mail->sendMail($dataLogin["mail"], array())) {
                            $this->setLog($login, $moduleName, $value["login"]);
                        } else {
                            global $message;
                            $message->setSyslog("error_sendmail_to_admin:" . $dataLogin["mail"]);
                        }
                    }
                }
            }
        }
    }
    /**
     * Calculate the number of expired connections from db connections
     *
     * @param [string] $login
     * @param [string] $date
     * @return number
     */
    function countNbExpiredConnectionsFromDate($login, $date)
    {
        $login = strtolower($login);
        $sql = "select count(*) as nombre from log
                where login = :login
                and log_date::date > :date
                and commentaire = 'db-ok-expired'";
        $data = $this->lireParamAsPrepared($sql, array("login" => $login, "date" => $date));
        return $data["nombre"];
    }
    /**
     * Get the delay of the last call from a login
     *
     * @param string $login
     * @return number
     */
    function getTimestampFromLastCall($login)
    {
        $login = strtolower($login);
        $ip = getIPClientAddress();
        $sql = "select extract (epoch from now() - log_date) as ts from log
                where login = :login and ipaddress = :ip
                order by log_date desc limit 1";
        $data = $this->lireParamAsPrepared($sql, array("login" => $login, "ip" => $ip));
        if (strlen($data["ts"]) == 0) {
            $data["ts"] = 10000;
        }
        return ($data["ts"]);
    }
    /**
     * Get the differents values contents in the log table
     *
     * @param string $field
     * @return array
     */
    function getDistinctValuesFromField($field)
    {
        if (array_key_exists($field, $this->colonnes)) {
            $sql = "select distinct $field as val from log order by $field";
            return $this->getListeParam($sql);
        }
    }
    /**
     * Search records in the log table
     *
     * @param array $param
     * @return array
     */
    function search($param)
    {
        $sql = "select * from log where log_date::date between :date_from and :date_to";
        $sqlParam = array(
            "date_from" => $this->formatDateLocaleVersDB($param["date_from"]),
            "date_to" => $this->formatDateLocaleVersDB($param["date_to"])
        );
        if (strlen($param["loglogin"]) > 0) {
            $sql .= " and lower(login) = lower(:login)";
            $sqlParam["login"] = $param["loglogin"];
        }
        if (strlen($param["logmodule"]) > 0) {
            $sql .= " and nom_module = :module";
            $sqlParam["module"] = $param["logmodule"];
        }
        return $this->getListeParamAsPrepared($sql, $sqlParam);
    }
}
