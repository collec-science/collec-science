<?php
/**
 * Controleur de l'application (modele MVC)
 * Fichier modifie le 21 mars 2013 par Eric Quinton
 *
 */
/**
 * Lecture des parametres
 */
include_once ("framework/common.inc.php");
/**
 * Verification des donnees entrantes.
 * Codage UTF-8
 */
if (! check_encoding($_REQUEST)) {
    $message->set($LANG["message"][45]);
    $_REQUEST["module"] = "default";
    unset($_REQUEST["moduleBase"]);
    unset($_REQUEST["action"]);
}
/**
 * Verification de la version de la base de donnees
 */
if (! isset($_SESSION["dbversion"])) {
    require_once "framework/dbversion/dbversion.class.php";
    $dbversion = new DbVersion($bdd, $ObjetBDDParam);
    if ($dbversion->verifyVersion($APPLI_dbversion)) {
        $_SESSION["dbversion"] = $APPLI_dbversion;
    } else {
        if ($APPLI_modeDeveloppement) {
            unset($_SESSION["dbversion"]);
        }
        $message->set(str_replace("%", $APPLI_dbversion, $LANG["message"][46]) . $dbversion->getLastVersion()["dbversion_number"]);
        $_REQUEST["module"] = "default";
        unset($_REQUEST["moduleBase"]);
        unset($_REQUEST["action"]);
    }
}
/**
 * Decodage des variables html
 */
$_REQUEST = htmlDecode($_REQUEST);
/**
 * Lecture des donnees canoniques
 * La configuration de l'hote virtuel doit contenir ceci :
 * <Directory /var/www/html/collec>
 * RewriteEngine On
 * RewriteBase /
 * RewriteCond "/%{REQUEST_FILENAME}" !-f
 * RewriteCond "/%{REQUEST_FILENAME}" !-d
 * RewriteRule "(.*)" "/index.php?$1" [PT,QSA]
 * </Directory>
 *
 * par defaut, les liens canoniques doivent etre de la forme :
 * /famille/version/modulerecherche/id
 * La transformation est realisee ainsi :
 * familleversionmodulerecherche, puis :
 * si id n'est pas renseigne : List
 * si id est renseigne :
 * * la variable $requestId est affectee avec la valeur id
 * * si method=get : Display
 * * si method=post : Write
 * * si method=put : Replace
 * * si method=delete : Delete
 */
if (! isset($_REQUEST["module"])) {
    if (isset($_REQUEST["moduleBase"]) && isset($_REQUEST["action"])) {
        $_REQUEST["module"] = $_REQUEST["moduleBase"] . $_REQUEST["action"];
    } else {
        $request_uri = $_SERVER["REQUEST_URI"];
        if (substr($request_uri, 0, 2) == "//") {
            $request_uri = substr($request_uri, 1);
        }
        $uri = explode("/", $request_uri);
        if (count($uri) > 2 && $uri[1] != $display) {
            /*
             * Extraction le cas echeant des variables GET
             */
            $uri3 = explode("?", $uri[3]);
            if (count($uri3) == 2) {
                $uri[3] = $uri3[0];
            }
            $_REQUEST["module"] = $uri[1] . $uri[2] . $uri[3];
            /*
             * On recherche si le quatrieme element existe
             */
            if (strlen($uri[4]) == 0) {
                $_REQUEST["module"] .= "List";
            } else {
                $uri4 = explode("?", $uri[4]);
                $requestId = $uri4[0];
                /*
                 * Prepositionnement par defaut de la valeur uid (la plus frequente)
                 */
                if (! isset($_REQUEST["uid"])) {
                    $_REQUEST["uid"] = $uri[4];
                }
                switch ($_SERVER["REQUEST_METHOD"]) {
                    case "GET":
                        $_REQUEST["module"] .= "Display";
                        break;
                    case "POST":
                        $_REQUEST["module"] .= "Write";
                        break;
                    case "PUT":
                        $_REQUEST["module"] .= "Replace";
                        break;
                    case "DELETE":
                        $_REQUEST["module"] .= "Delete";
                        break;
                    default:
                        $_REQUEST["module"] = "default";
                        break;
                }
            }
        }
    }
}
/*
 * page par defaut
 */
if (strlen($_REQUEST["module"]) == 0) {
    $_REQUEST["module"] = "default";
}
/*
 * Stockage de l'UID appele, pour lien direct vers le detail d'un echantillon
 */
if ($_REQUEST["uid"] > 0) {
    $_SESSION["uid"] = $_REQUEST["uid"];
}
/**
 * Recuperation du module
 */
unset($module);
/**
 * Generation du module a partir de moduleBase et action
 */
$module = $_REQUEST["module"];
$moduleRequested = $module;
/**
 * Gestion des modules
 */
$isHtml = false;
$isAjax = false;
if ($APPLI_modeDeveloppement) {
    unset($_SESSION["menu"]);
}
while (isset($module)) {
    /*
     * Recuperation du tableau contenant les attributs du module
     */
    $t_module = $navigation->getModule($module);
    if (count($t_module) == 0) {
        $message->set($LANG["message"][35] . " ($module)");
        $t_module = $navigation->getModule("default");
    }
    /*
     * Extraction des droits necessaires
     */
    $droits_array = explode(",", $t_module["droits"]);
    /*
     * Forcage de l'identification si identification en mode HEADER
     */
    if ($ident_type == "HEADER") {
        $t_module["loginrequis"] = 1;
    }
    /*
     * Preparation de la vue
     */
    if (! isset($vue) && isset($t_module["type"])) {
        switch ($t_module["type"]) {
            case "ajax":
            case "json":
            case "ws":
                $vue = new VueAjaxJson();
                $isAjax = true;
                break;
            case "csv":
                $vue = new VueCsv();
                $isAjax = true;
                break;
            case "pdf":
                $vue = new VuePdf();
                $isAjax = true;
                break;
            case "binaire":
                $vue = new VueBinaire();
                $isAjax = true;
                break;
            case "smarty":
            case "html":
            default:
                $isHtml = true;
                $vue = new VueSmarty($SMARTY_param, $SMARTY_variables);
        }
    }
    
    /*
     * Verification si le login est requis
     */
    if (strlen($t_module["droits"]) > 1 || $t_module["loginrequis"] == 1 || isset($_REQUEST["login"])) {
        $loginForm = false;
        /*
         * Cas du service web
         */
        if ($t_module["type"] == "ws") {
            require_once "framework/identification/identification.class.php";
            $lg = new LoginGestion($bdd_gacl, $ObjetBDDParam);
            $dataId = $lg->getLoginFromTokenWS($_REQUEST["login"], $_REQUEST["token"]);
            if (strlen($dataId["login"]) > 0) {
                $_SESSION["login"] = $dataId["login"];
                $log->setLog($_SESSION["login"], "connexion", "swtoken-ok");
                /*
                 * Traitement post identification, si necessaire
                 */
                if (file_exists("modules/postLoginWS.php")) {
                    include 'modules/postLoginWS.php';
                }
            } else {
                $log->setLog($_REQUEST["login"], "connexion", "swtoken-ko");
            }
        } else {
            /*
             * Affichage de l'ecran de saisie du login si necessaire
             */
            if (in_array($ident_type, array(
                "BDD",
                "LDAP",
                "LDAP-BDD"
            )) && ! isset($_REQUEST["login"]) && strlen($_SESSION["login"]) == 0 && ! isset($_COOKIE["tokenIdentity"])) {
                /*
                 * Gestion de la saisie du login
                 */
                $vue->set("ident/login.tpl", "corps");
                $vue->set($tokenIdentityValidity, "tokenIdentityValidity");
                $vue->set($APPLI_lostPassword, "lostPassword");
                $loginForm = true;
                if ($t_module["retourlogin"] == 1) {
                    $vue->set($_REQUEST["module"], "module");
                }
                $message->set($LANG["login"][2]);
            } else {
                
                /*
                 * Verification du login
                 */
                if (! isset($_SESSION["login"])) {
                    /*
                     * Purge des anciens enregistrements dans log
                     */
                    $log->purge($LOG_duree);
                    /*
                     * Traitement de l'identification par jeton
                     */
                    if (isset($_COOKIE["tokenIdentity"])) {
                        try {
                            require_once 'framework/identification/token.class.php';
                            $token = new Token($privateKey, $pubKey);
                            $login = $token->openToken($_COOKIE["tokenIdentity"]);
                        } catch (Exception $e) {
                            $message->set($LANG["message"][48]);
                            $message->setSyslog($e->getMessage());
                            $log->setLog("unknown", "connexion", "token-ko");
                        }
                        if (strlen($login) > 0) {
                            $log->setLog($login, "connexion", "token-ok");
                        } else {
                            $log->setLog("unknown", "connexion", "token-ko");
                        }
                    } else {
                        /*
                         * Verification du login
                         */
                        $login = $identification->verifyLogin($_REQUEST["login"], $_REQUEST["password"]);
                    }
                    if (strlen($login) > 0) {
                        /*
                         * Le login a ete valide
                         * Declenchement de toutes les operations d'initialisation necessaires
                         */
                        $_SESSION["login"] = $login;
                        unset($_SESSION["menu"]);
                        $message->set($LANG["message"][10]);
                        
                        /*
                         * Regeneration de l'identifiant de session
                         */
                        session_regenerate_id();
                        /*
                         * Recuperation de la derniere connexion et affichage a l'ecran
                         */
                        $lastConnect = $log->getLastConnexion();
                        if (isset($lastConnect["log_date"])) {
                            $texte = $LANG["login"][48];
                            $texte = str_replace(":datelog", $lastConnect["log_date"], $texte);
                            $texte = str_replace(":iplog", $lastConnect["ipaddress"], $texte);
                            $message->set($texte);
                        }
                        $message->setSyslog("connexion ok for " . $_SESSION["login"] . " from " . getIPClientAddress());
                        /*
                         * Reinitialisation du menu
                         */
                        unset($_SESSION["menu"]);
                        /*
                         * Recuperation des cookies le cas echeant
                         */
                        include 'modules/cookies.inc.php';
                        /*
                         * Calcul des droits
                         */
                        require_once 'framework/droits/droits.class.php';
                        $acllogin = new Acllogin($bdd_gacl, $ObjetBDDParam);
                        try {
                            $_SESSION["droits"] = $acllogin->getListDroits($_SESSION["login"], $GACL_aco, $LDAP);
                        } catch (Exception $e) {
                            if ($APPLI_modeDeveloppement) {
                                $message->set($e->getMessage());
                            } else {
                                $message->setSyslog($e->getMessage());
                            }
                        }
                        
                        /*
                         * Integration des commandes post login
                         */
                        include "modules/postLogin.php";
                        /*
                         * Gestion de l'identification par token
                         */
                        if ($_REQUEST["loginByTokenRequested"] == 1) {
                            require_once 'framework/identification/token.class.php';
                            $tokenClass = new Token($privateKey, $pubKey);
                            try {
                                $token = $tokenClass->createToken($_SESSION["login"], $tokenIdentityValidity);
                                /*
                                 * Ecriture du cookie
                                 */
                                $cookieParam = session_get_cookie_params();
                                $cookieParam["lifetime"] = $tokenIdentityValidity;
                                if (! $APPLI_modeDeveloppement) {
                                    $cookieParam["secure"] = true;
                                }
                                $cookieParam["httponly"] = true;
                                setcookie('tokenIdentity', $token, time() + $tokenIdentityValidity, $cookieParam["path"], $cookieParam["domain"], $cookieParam["secure"], $cookieParam["httponly"]);
                            } catch (Exception $e) {
                                $message->set($e->getMessage());
                            }
                        }
                    } else {
                        $message->set($LANG["message"][11]);
                        $message->setSyslog("connexion ko from " . getIPClientAddress());
                    }
                }
            }
        }
    }
    
    /*
     * Controles complementaires
     */
    $resident = 1;
    $motifErreur = "ok";
    if ($t_module["loginrequis"] == 1 && ! isset($_SESSION["login"])) {
        $resident = 0;
    }
    /*
     * Verification des droits
     */
    if (strlen($t_module["droits"]) > 1) {
        if (! isset($_SESSION["login"])) {
            $resident = 0;
            $motifErreur = "nologin";
        } else {
            
            $resident = 0;
            foreach ($droits_array as $key => $value) {
                if ($_SESSION["droits"][$value] == 1) {
                    $resident = 1;
                }
            }
            if ($resident == 0) {
                $motifErreur = "droitko";
            }
        }
    }
    /*
     * Verification que le module soit bien appele apres le module qui doit le preceder
     * La recherche peut contenir plusieurs noms de modules, separes par le caractere |
     */
    if (strlen($t_module["modulebefore"]) > 0) {
        $before = explode(",", $t_module["modulebefore"]);
        $beforeok = false;
        foreach ($before as $value) {
            if ($_SESSION["moduleBefore"] == $value) {
                $beforeok = true;
            }
        }
        if (! $beforeok) {
            $resident = 0;
            if ($APPLI_modeDeveloppement) {
                $message->set($LANG["message"][47] . $_SESSION["moduleBefore"]);
            }
            $motifErreur = "errorbefore";
        }
    }
    
    /*
     * Verification s'il s'agit d'un module d'administration
     */
    $moduleAdmin = false;
    if (in_array("admin", $droits_array)) {
        $moduleAdmin = true;
        /*
         * Verification si la duree de connexion en mode admin est depassee
         */
        if (isset($_SESSION["last_activity_admin"]) && (time() - $_SESSION["last_activity_admin"]) < $APPLI_admin_ttl) {
            /*
             * L'acces est dans le laps de temps autorise
             */
            $_SESSION["last_activity_admin"] = time();
        } else {
            if (in_array($ident_type, array(
                "BDD",
                "LDAP",
                "LDAP-BDD"
            )) && ! isset($_REQUEST["loginAdmin"]) && ! $loginForm) {
                /*
                 * saisie du login en mode admin
                 */
                $vue->set("ident/loginAdmin.tpl", "corps");
                $resident = 0;
                if ($t_module["retourlogin"] == 1) {
                    $vue->set($_REQUEST["module"], "module");
                }
                $message->set($LANG["login"][49]);
            } else {
                /*
                 * Recuperation de l'identification
                 */
                if (strlen($identification->verifyLogin($_REQUEST["loginAdmin"], $_REQUEST["password"], true)) > 0) {
                    $_SESSION["last_activity_admin"] = time();
                } else {
                    $resident = 0;
                    $motifErreur = "adminko";
                }
            }
        }
    }
    
    /*
     * fin d'analyse du module
     */
    /*
     * Enregistrement de l'acces au module
     */
    try {
        $log->setLog($_SESSION["login"], $module, $motifErreur);
    } catch (Exception $e) {
        if ($OBJETBDD_debugmode > 0) {
            $message->set($log->getErrorData(1));
        } else {
            $message->set($LANG["message"][38]);
        }
        $message->setSyslog($e->getMessage());
    }
    
    unset($module_coderetour);
    
    /*
     * Execution du module
     */
    if ($resident == 1) {
        /*
         * Mise a niveau de la variable stockant le module precedemment appele
         */
        if (! $isAjax && $module != "default") {
            $_SESSION["moduleBefore"] = $module;
        }
        include $t_module["action"];
        unset($module);
        /*
         * Recuperation du code de retour et affectation du nom du nouveau module
         */
        if (isset($module_coderetour)) {
            switch ($module_coderetour) {
                case - 1:
                    unset($vue);
                    $module = $t_module["retourko"];
                    break;
                case 0:
                case 1:
                case 2:
                case 3:
                default:
                    if (isset($t_module["retourok"])) {
                        $module = $t_module["retourok"];
                    }
                    break;
            }
        }
    } else {
        /*
         * Traitement des erreurs
         */
        switch ($motifErreur) {
            case "droitko":
                if (strlen($t_module["droitko"]) > 1) {
                    $module = $t_module["droitko"];
                } else {
                    $module = $APPLI_moduleDroitKO;
                }
                break;
            case "nologin":
                $module = $APPLI_moduleErrorLogin;
                break;
            case "errorbefore":
                $module = $APPLI_moduleErrorBefore;
                break;
            case "adminko":
                $module = $APPLI_moduleAdminLogin;
                break;
            default:
                unset($module);
        }
    }
}
/*
 * Traitement de l'affichage vers le navigateur
 */
if ($isHtml) {
    /*
     * Affichage du menu
     */
    if (! isset($_SESSION["menu"])) {
        include_once 'framework/navigation/menu.class.php';
        $menu = new Menu($APPLI_menufile, $LANG);
        $_SESSION["menu"] = $menu->generateMenu();
    }
    
    $vue->set($_SESSION["menu"], "menu");
    if (isset($_SESSION["login"])) {
        $vue->set(1, "isConnected");
        $vue->set($_SESSION["login"], "login");
    }
    /*
     * Gestion de l'internationalisation
     */
    $vue->set($_SESSION["FORMATDATE"], "language");
    /*
     * Affichage de la page
     */
    /*
     * Alerte Mode developpement
     */
    if ($APPLI_modeDeveloppement) {
        $texteDeveloppement = $LANG["message"][32] . " : " . $BDD_dsn . ' - schema : ' . $BDD_schema;
        $vue->set($texteDeveloppement, "developpementMode");
    }
    $vue->set($_SESSION["moduleListe"], "moduleListe");
    /*
     * execution du code generique avant affichage
     */
    include 'modules/beforeDisplay.php';
    
    /*
     * Envoi des droits
     */
    $vue->set($_SESSION["droits"], "droits");
}
/**
 * Declenchement de l'envoi vers le navigateur
 */
if (isset($vue)) {
    try {
        $vue->send($paramSend);
    } catch (Exception $e) {
        $message->setSyslog($e->getMessage());
    }
}
/**
 * Generation des messages d'erreur pour Syslog
 */
$message->sendSyslog();
/**
 * Fin de traitement
 */

?>
