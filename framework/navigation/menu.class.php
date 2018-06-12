<?php

/**
 * @author Eric Quinton
 * @copyright Copyright (c) 2015, IRSTEA / Eric Quinton
 * @license http://www.cecill.info/licences/Licence_CeCILL-C_V1-fr.html LICENCE DE LOGICIEL LIBRE CeCILL-C
 *  Creation 23 juin 2015
 */
class Menu
{

    public $menuList;

    private $menuArray;

    /**
     * Charge la classe avec les informations fournies
     *
     * @param string $filename
     * @param string $language
     */
    function __construct($filename)
    {
        /*
         * Transforme le menu en tableau
         */
        $xml = simplexml_load_file($filename);
        $this->menuArray = json_decode(json_encode($xml), true);
    }

    /**
     * Declenche la generation du menu
     *
     * @return string
     */
    function generateMenu()
    {
        $this->menuList = "";
        foreach ($this->menuArray["item"] as $value) {
            $this->menuList .= $this->lireItem($value);
        }
        return $this->menuList;
    }

    /**
     * Lecture de chaque valeur du tableau
     *
     * @param array $valeur
     * @return string
     */
    function lireItem($valeur)
    {
        $texte = "";
        $attributes = $valeur["@attributes"];
        $ok = true;
        /*
         * Recherche des droits
         */
        if (isset($attributes["droits"])) {
            $ok = false;
            $tdroits = explode(",", $attributes["droits"]);
            foreach ($tdroits as $droit) {
                if ($_SESSION["droits"][$droit] == 1) {
                    $ok = true;
                }
            }
        }
        /*
         * Recherche si le login est requis
         */
        if ($attributes["loginrequis"] == 1 && ! isset($_SESSION["login"])) {
            $ok = false;
        }
        /*
         * Recherche si l'utilisateur n'est pas connecte
         */
        if ($attributes["onlynoconnect"] == 1 && isset($_SESSION["login"])) {
            $ok = false;
        }
        if ($ok) {
            if (isset($attributes["divider"])) {
                $texte = '<li class="divider"></li>';
            } else {
                /*
                 * Traitement de l'item
                 */
                $texte = '<li><a href="index.php?module=' . $attributes["module"] . '" title="' . gettext($attributes["tooltip"]) . '">' .  gettext($attributes["label"]) . '</a>';
                
                if (isset($valeur["item"])) {
                    /*
                     * Il s'agit d'un tableau imbrique
                     */
                    $texte .= '<ul class="dropdown-menu">';
                    if (count($valeur["item"]) == 1) {
                        $texte .= $this->lireItem($valeur["item"]);
                    } else {
                        foreach ($valeur["item"] as $value) {
                            $texte .= $this->lireItem($value);
                        }
                    }
                    $texte .= "</ul>";
                }
                
                $texte .= "</li>";
            }
        }
        return $texte;
    }
}

?>