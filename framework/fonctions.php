<?php

/**
 * Ensemble de fonctions utilisees pour la gestion des fiches
 */

/**
 * Lit un enregistrement dans la base de donnees, affecte le tableau a Smarty,
 * et declenche l'affichage de la page associee
 *
 * @param ObjetBDD $dataClass
 * @param int $id
 * @param string $smartyPage
 * @param int $idParent
 * @return array
 */
function dataRead($dataClass, $id, $smartyPage, $idParent = null)
{
    global $vue, $OBJETBDD_debugmode, $message;
    if (isset($vue)) {
        if (is_numeric($id)) {

            try {
                $data = $dataClass->lire($id, true, $idParent);
            } catch (Exception $e) {
                if ($OBJETBDD_debugmode > 0) {
                    foreach ($dataClass->getErrorData(1) as $messageError) {
                        $message->set($messageError);
                    }
                } else {
                    $message->set(_("Erreur de lecture des informations dans la base de données"));
                }
                $message->setSyslog($e->getMessage());
            }
        }
        /*
         * Affectation des donnees a smarty
         */
        $vue->set($data, "data");
        $vue->set($smartyPage, "corps");
        return $data;
    } else {
        global $module;
        // traduction: conserver inchangée la chaîne %s
        $message->set(sprintf(_('Erreur: type d\'affichage non défini pour le module demandé : %s'), $module));
    }
}

/**
 * Ecrit un enregistrement en base de donnees
 *
 * @param ObjetBDD $dataClass
 * @param array $data
 * @return int
 */
function dataWrite($dataClass, $data)
{
    global $message, $module_coderetour, $log, $OBJETBDD_debugmode;
    try {
        $id = $dataClass->ecrire($data);
        $message->set(_("Enregistrement effectué"));
        $module_coderetour = 1;
        $log->setLog($_SESSION["login"], get_class($dataClass) . "-write", $id);
    } catch (Exception $e) {
        if ($OBJETBDD_debugmode > 0) {
            foreach ($dataClass->getErrorData(1) as $messageError) {
                $message->set($messageError);
            }
        } else {
            $message->set(_("Problème lors de l'enregistrement..."));
        }
        $message->setSyslog($e->getMessage());
        $module_coderetour = - 1;
    }
    return ($id);
}

/**
 * Supprime un enregistrement en base de donnees
 *
 * @param ObjetBDD $dataClass
 * @param int $id
 * @return int
 */
function dataDelete($dataClass, $id)
{
    global $message, $module_coderetour, $log, $OBJETBDD_debugmode;
    $module_coderetour = - 1;
    $ok = true;
    if (is_array($id)) {
        foreach ($id as $value) {
            if (! (is_numeric($value) && $value > 0)) {
                $ok = false;
            }
        }
    } else {
        if (! (is_numeric($id) && $id > 0)) {
            $ok = false;
        }
    }
    if ($ok) {
        try {
            $ret = $dataClass->supprimer($id);
            $message->set(_("Suppression effectuée"));
            $module_coderetour = 1;
            $log->setLog($_SESSION["login"], get_class($dataClass) . "-delete", $id);
        } catch (Exception $e) {
            if ($OBJETBDD_debugmode > 0) {
                foreach ($dataClass->getErrorData(1) as $messageError) {
                    $message->set($messageError);
                }
            } else {
                $message->set(_("Problème lors de la suppression"));
            }
            $message->setSyslog($e->getMessage());
            $ret = - 1;
        }
    } else {
        $ret = - 1;
    }
    return ($ret);
}

/**
 * Modifie la langue utilisee dans l'application
 *
 * @param string $langue
 */
function setlanguage($langue)
{
    global $language, $LANG, $APPLI_cookie_ttl, $APPLI_menufile, $menu, $ObjetBDDParam;

    /*
     * Initialisation des parametres pour gettext
     */
    initGettext($langue);

    /*
     * Chargement de la langue par defaut
     */
    include ('locales/' . $language . ".php");
    /*
     * On gere le cas ou la langue selectionnee n'est pas la langue par defaut
     */
    if ($language != $langue) {
        $LANGORI = $LANG;
        /*
         * Test de l'existence du fichier locales selectionne
         */
        if (file_exists('locales/' . $langue . '.php')) {
            include 'locales/' . $langue . '.php';
            $LANGDIFF = $LANG;
            /*
             * Fusion des deux tableaux
             */
            $LANG = array();
            $LANG = array_replace_recursive($LANGORI, $LANGDIFF);
        }
    }
    $ObjetBDDParam["formatDate"] = $_SESSION["FORMATDATE"];
    $_SESSION["ObjetBDDParam"] = $ObjetBDDParam;
    /*
     * Mise en session de la langue
     */
    $_SESSION['LANG'] = $LANG;
    /*
     * Regeneration du menu
     */
    include_once 'framework/navigation/menu.class.php';
    $menu = new Menu($APPLI_menufile);
    $_SESSION["menu"] = $menu->generateMenu();
    /*
     * Appel des fonctions specifiques de l'application
     */
    include "modules/afterChangeLanguage.php";
    /*
     * Ecriture du cookie
     */
    $cookieParam = session_get_cookie_params();
    $cookieParam["lifetime"] = $APPLI_cookie_ttl;
    if (! $APPLI_modeDeveloppement) {
        $cookieParam["secure"] = true;
    }
    $cookieParam["httponly"] = true;

    setcookie('langue', $langue, time() + $APPLI_cookie_ttl, $cookieParam["path"], $cookieParam["domain"], $cookieParam["secure"], $cookieParam["httponly"]);
}

function initGettext($langue)
{
    /*
     * Pour smarty-gettext (gettext)
     */

    /*
     * Attention :
     * gettext fonctionne avec setlocale. Le problème est que setlocale dépend des locales installées sur le serveur.
     * Par exemple, si en_GB n'est pas installé alors setlocale(LC_ALL, "en_GB") ne va rien faire.
     * L'astuce utilisée ici est de ne pas compter sur setlocale (forcé à C, la localisation portable par défaut)
     * mais de détourner l'usage du domaine pour préciser la langue !
     * Va donc chercher par exemple dans locales/C/LC_MESSAGES/en.mo et non locales/en/LC_MESSAGES/mydomain.mo
     * Permet non seulement d'éviter des problèmes liés à l'environnement
     * mais en plus rend l'arborescence plus simple en mettant toutes les langues dans le même répertoire
     * sans avoir à gérer le domaine, souvent superflu et source possible d'erreur.
     * (il sera toujours possible de rétablir le domaine si besoin, avec un domaine de la forme $domaine_$langue
     */
    /*
     * Attention au cache :
     * le cache de gettext est coriace et peut amener à l'apparition d'ancienne traduction
     * lors d'une modification d'un fichier de traduction .mo il est recommander de relancer le serveur :
     * sudo service apache2 reload
     */
    // var_dump($langue); // aide à la traduction lors du développement
    setlocale(LC_ALL, "C.UTF-8", "C"); // setlocale pour linux // C = localisation portable par défaut
                                       // Attention : La valeur retournée par setlocale() dépend du système sur lequel PHP est installé. setlocale() retourne exactement ce que la fonction système setlocale retourne.
                                       // TODO aide au diagnostic : vérifier que setlocale a réussi ou que le fichier de langue existe bien
                                       // $path = realpath("./locales") . "/C/LC_MESSAGES/$langue.mo";
                                       // var_dump( $path, file_exists( $path ) );
    putenv("LANG=C.UTF-8"); // putenv pour windows // non testé
    bindtextdomain($langue, realpath("./locales"));
    bind_textdomain_codeset($langue, "UTF-8");
    textdomain($langue);
}

/**
 * Fonction testant si la donnee fournie est de type UTF-8 ou non
 *
 * @param array|string $data
 * @return boolean
 */
function check_encoding($data)
{
    $result = true;
    if (is_array($data)) {
        foreach ($data as $value) {
            if (! check_encoding($value)) {
                $result = false;
            }
        }
    } else {
        if (strlen($data) > 0) {
            if (! mb_check_encoding($data, "UTF-8")) {
                $result = false;
            }
        }
    }
    return $result;
}

/**
 * Retourne l'adresse IP du client, en tenant compte le cas echeant du reverse-proxy
 *
 * @return string
 */
function getIPClientAddress()
{
    /*
     * Recherche si le serveur est accessible derriere un reverse-proxy
     */
    if (isset($_SERVER["HTTP_X_FORWARDED_FOR"])) {
        return $_SERVER["HTTP_X_FORWARDED_FOR"];
        /*
         * Cas classique
         */
    } else if (isset($_SERVER["REMOTE_ADDR"])) {
        return $_SERVER["REMOTE_ADDR"];
    } else {
        return - 1;
    }
}

/**
 * Fonction recursive decodant le html en retour de navigateur
 *
 * @param array|string $data
 * @return array|string
 */
function htmlDecode($data)
{
    if (is_array($data)) {
        foreach ($data as $key => $value) {
            $data[$key] = htmlDecode($value);
        }
    } else {
        $data = htmlspecialchars_decode($data, ENT_QUOTES);
    }
    return $data;
}

/**
 * Fonction d'analyse des virus avec clamav
 *
 * @author quinton
 *        
 *         Exemple d'usage :
 *        
 *         $nomfiletest = "/tmp/eicar.com.txt";
 *         try {
 *         echo "analyse antivirale de $nomfiletest";
 *         testScan ( $nomfiletest );
 *         echo "Fichier sans virus reconnu par Clamav<br>";
 *         } catch ( FileException $f ) {
 *         echo $f->getMessage () . "<br>";
 *         } catch ( VirusException $v ) {
 *         echo $v->getMessage () . "<br>";
 *         } finally {
 *         echo "Fin du test";
 *         }
 */
class VirusException extends Exception
{
}

class FileException extends Exception
{
}

function testScan($file)
{
    if (file_exists($file)) {
        if (extension_loaded('clamav')) {
            $retcode = cl_scanfile($file["tmp_name"], $virusname);
            if ($retcode == CL_VIRUS) {
                $message = $file["name"] . " : " . cl_pretcode($retcode) . ". Virus found name : " . $virusname;
                throw new VirusException($message);
            }
        } else {
            /*
             * Test avec clamscan
             */
            $clamscan = "/usr/bin/clamscan";
            $clamscan_options = "-i --no-summary";
            if (file_exists($clamscan)) {
                exec("$clamscan $clamscan_options $file", $output);
                if (count($output) > 0) {
                    $message = $file["name"] . " : ";
                    foreach ($output as $value) {
                        $message .= $value . " ";
                    }
                    throw new VirusException($message);
                }
            } else {
                throw new FileException("clamscan not found");
            }
        }
    } else {
        throw new FileException("$file not found");
    }
}

function getHeaders()
{
    $header = array();
    foreach ($_SERVER as $key => $value) {
        if (substr($key, 0, 4) == "HTTP") {
            $header[substr($key, 5)] = $value;
        }
    }
    return $header;

    /*
     * Fonction equivalente pour NGINX
     */
    /*
     * function apache_request_headers() {
     * foreach($_SERVER as $key=>$value) {
     * if (substr($key,0,5)=="HTTP_") {
     * $key=str_replace(" ","-",ucwords(strtolower(str_replace("_"," ",substr($key,5)))));
     * $out[$key]=$value;
     * }else{
     * $out[$key]=$value;
     * }
     * }
     * return $out;
     * }
     * }
     * printr($_SERVER);
     * return apache_request_headers();
     */
}
?>
