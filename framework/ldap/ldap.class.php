<?php

/**
 * @author Eric Quinton
 *
 */

/**
 *
 * @author eric.quinton
 *
 */
class Ldap
{

    /**
     * Tableau des informations retournees
     *
     * @var array
     */
    var $listegroupe = array();

    var $LDAP;

    /**
     * Identifiant de connexion de l'annuaire ldap
     *
     * @var int
     */
    var $idldap;

    /**
     * Message retourne en cas d'anomalie
     *
     * @var string
     */
    var $message;

    /**
     * Constructeur de la classe
     *
     * @param array $LDAP
     * @return void;
     */
    function __construct($LDAP)
    {
        $this->LDAP = $LDAP;
    }

    /**
     * Fonction realisant la connexion a l'annuaire
     * Retourne -1 en cas d'echec
     *
     * @return int
     */
    function connect()
    {
        $this->idldap = @ldap_connect($this->LDAP["address"], $this->LDAP["port"]);
        /**
         * Set options
         */
        ldap_set_option($this->idldap, LDAP_OPT_NETWORK_TIMEOUT, $this->LDAP["timeout"]);
        ldap_set_option($this->idldap, LDAP_OPT_TIMELIMIT, $this->LDAP["timeout"]);
        ldap_set_option($this->idldap, LDAP_OPT_TIMEOUT, $this->LDAP["timeout"]);
        if ($this->idldap > 0) {
            if ($this->LDAP["v3"] == 1) {
                ldap_set_option($this->idldap, LDAP_OPT_PROTOCOL_VERSION, 3);
            }
            if ($this->LDAP["tls"] == 1) {
                ldap_start_tls($this->idldap);
            }
        } else {
            $this->message = "Impossible de se connecter au serveur LDAP<br>";
            $this->idldap = -1;
        }
        return $this->idldap;
    }

    /**
     * Fonction permettant de realiser le bind avec le login/passwd
     * Permet de verifier le couple login/passwd
     * Retourne 1 en cas de reussite
     *
     * @param string $login
     * @param string $password
     * @return int
     */
    function login($login, $password)
    {
        $login = str_replace(array(
            '\\',
            '*',
            '(',
            ')'
        ), array(
            '\5c',
            '\2a',
            '\28',
            '\29'
        ), $login);
        for ($i = 0; $i < strlen($login); $i++) {
            $char = substr($login, $i, 1);
            if (ord($char) < 32) {
                $hex = dechex(ord($char));
                if (strlen($hex) == 1) {
                    $hex = '0' . $hex;
                }
                $login = str_replace($char, '\\' . $hex, $login);
            }
        }
        /*
         * Pour OpenLDAP et Active Directory, "bind rdn" de la forme : user_attrib=login,basedn
         *     avec généralement user_attrib=uid pour OpenLDAP,
         *                    et user_attrib=cn pour Active Directory
         * Pour Active Directory aussi, "bind rdn" de la forme : login@upn_suffix
         * D'où un "bind rdn" de la forme générique suivante :
         *     (user_attrib=)login(@upn_suffix)(,basedn)
         */
        $user_attrib_part = !empty($this->LDAP["user_attrib"]) ? $this->LDAP["user_attrib"] . "=" : "";
        $upn_suffix_part = !empty($this->LDAP["upn_suffix"]) ? "@" . $this->LDAP["upn_suffix"] : "";
        $basedn_part = !empty($this->LDAP["basedn"]) ? "," . $this->LDAP["basedn"] : "";
        //          (user_attrib=)login(@upn_suffix)(,basedn)
        $this->dn = $user_attrib_part . $login . $upn_suffix_part . $basedn_part;
        $rep = ldap_bind($this->idldap, $this->dn, $password);
        if ($rep != 1) {
            $this->message .= "Connexion refusee avec le login/mot de passe fournis<br>";
            $this->message .= "dn : " . $this->dn . "<br>";
        }
        return $rep;
    }

    /**
     * Fonction retournant les messages d'erreur, si existants
     *
     * @return string
     */
    function getMessage()
    {
        return $this->message;
    }

    /**
     * Fonction retournant un tableau contenant les attributs demandes
     * pour une liste d'objets recherches dans l'annuaire
     *
     * @param string $basedn
     *            : base de recherche
     * @param string $filtre
     *            : filtre de recherche - ex : cn=*
     * @param array $attribut
     *            : tableau contenant en cle les attributs que l'on souhaite retourner
     * @return array : tableau multiple (avec tableaux imbriques pour chaque attribut : [count] et [0] à [n]
     */
    function getAttributs($basedn, $filtre, $attribut)
    {
        // Test si $attribut est un tableau
        $a_attribut = array();
        if (!is_array($attribut)) {
            $a_attribut = array($attribut);
        } else {
            $a_attribut = $attribut;
        }
        if (strlen($basedn) == 0) {
            $basedn = $this->LDAP_basedn;
        }
        $sr = ldap_search($this->idldap, $basedn, $filtre, $a_attribut);
        if ($sr) {
        return ldap_get_entries($this->idldap, $sr);
        } else {
            global $message;
            $message->setSyslog(ldap_error($this->idldap));
            return array();
        }
    }

    function __destruct()
    {
        if ($this->idldap > 0) {
            ldap_close($this->idldap);
        }
    }
}
