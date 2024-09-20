<?php
namespace PPCI\Models;
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
            $this->menuList .= $this->lireItem($value, 0);
        }
        return $this->menuList;
    }

    /**
     * Lecture de chaque valeur du tableau
     *
     * @param array $valeur
     * @return string
     */
    function lireItem($valeur, $level = 0)
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
                if (isset ($_SESSION["userRights"][$droit])) {
                    $ok = true;
                }
            }
        }
        /*
         * Recherche si le login est requis
         */
        if (isset($attributes["loginrequis"]) && !$_SESSION["isLogged"]) {
            $ok = false;
        }
        /*
         * Recherche si l'utilisateur n'est pas connecte
         */
        if (isset ($attributes["onlynoconnect"]) && $_SESSION["isLogged"]) {
            $ok = false;
        }
        /**
         * Search for language
         */
        if (isset($attributes["language"]) && $attributes["language"] != $_SESSION["locale"]) {
            $ok = false;
        }
        if ($ok) {
            if (isset($attributes["divider"])) {
                $texte = '<li class="divider"></li>';
            } else {
                /*
                 * Traitement de l'item
                 */
                $label = gettext($attributes["label"]);
                if (isset($valeur["item"]) && $level > 0) {
                    $label .= " >";
                }
                if ($level == 0) {
                    $level = 1;
                }
                $texte = '<li><a href="' . $attributes["module"] . '" title="' . gettext($attributes["tooltip"]) . '">' . $label . '</a>';
                if (isset($valeur["item"])) {
                    /*
                     * Il s'agit d'un tableau imbrique
                     */
                    $texte .= '<ul class="dropdown-menu">';
                    if (count($valeur["item"]) == 1) {
                        $texte .= $this->lireItem($valeur["item"], $level);
                    } else {
                        foreach ($valeur["item"] as $value) {
                            $texte .= $this->lireItem($value, $level++);
                        }
                    }
                    $texte .= "</ul>";
                }

                $texte .= "</li>";
            }
        }
        return $texte;
    }
    /**
     * Generate submenu to display on action framework/utils/submenu.php
     *
     * @param string $moduleName
     * @return string
     */
    function getSubmenu(string $moduleName): string
    {
        $submenu = "";
        $isfound = false;
        foreach ($this->menuArray["item"] as $entry) {
            if ($entry["@attributes"]["module"] == $moduleName) {
                $isfound = true;
                $submenu = "<h2><span title=" . $entry["@attributes"]["tooltip"] . ">" . $entry["@attributes"]["label"] . "<span></h2>";
                foreach ($entry["item"] as $value) {
                    $submenu .= $this->lireItem($value, 0);
                }
            }
            if (!$isfound && !empty($entry["item"])) {
                foreach ($entry["item"] as $value) {
                    if ($value["@attributes"]["module"] == $moduleName) {
                        //printA($entry["@attributes"]["module"]);
                        $isfound = true;
                        $submenu = "<h2>" .
                            '<a href="index.php?module=' . $entry["@attributes"]["module"] .
                            '" title="' . $entry["@attributes"]["tooltip"] . '">' .
                            $entry["@attributes"]["label"] . "</a> > " .
                            '<span title="' . $value["@attributes"]["tooltip"] . '">' . $value["@attributes"]["label"] .
                            "<span>" .
                            "</h2>";
                        foreach ($value["item"] as $subvalue) {
                            $submenu .= $this->lireItem($subvalue, 0);
                        }
                    }
                }
            }
        }
        return $submenu;
    }

}