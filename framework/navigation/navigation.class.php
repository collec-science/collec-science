<?php
/** Fichier cree le 10 juil. 08 par quinton
 *
 *UTF-8
 */

/**
 * @class Navigation
 * @author Eric Quinton - eric.quinton@free.fr
 *
 */
class Navigation {
	var $doc;
	var $module;
	var $nommodule = "";
	var $t_module = array();
	var $g_module = array();


	/**
	 * Fonction de creation de la classe
	 * lecture du fichier xml contenant la navigation de l'application
	 *
	 * @param string $nomfichier
	 * @return Navigation
	 */
	function Navigation($nomfichier) {
		$this->dom = new DOMDocument();
		$this->dom->load($nomfichier);
		$this->g_module = $this->lireGlobal();
	}
	/**
	 * Retourne un tableau contenant tous les attributs du module
	 *
	 * @param string $module
	 * @return array
	 */
	function getModule($module) {
		return $this->g_module[$module];
	}
	/**
	 * Fonction retournant la valeur d'un attribut pour le module considere
	 *
	 * @param string $nommodule
	 * @param string $attribut
	 * @return string
	 */

	function getAttribut($nommodule, $attribut){
		return $this->g_module[$nommodule][$attribut];
	}

	/**
	 * Fonction lisant l'arborescence sur 2 niveaux du fichier xml
	 * Lecture depuis la racine du fichier xml, des noeuds de niveau 1
	 * et des attributs associes
	 *
	 * @param string $racine
	 * @return array
	 */
	function lireGlobal() {
		$root = $this->dom->getElementsByTagName($this->dom->documentElement->tagName);
		$root = $root->item(0);
		$noeuds = $root->childNodes;
		$g_module = array();
		foreach ($noeuds as $noeud){
			// Exclusion du modele
			
			if ($noeud->hasAttributes()&&$noeud->tagName<>"model") {
				foreach ($noeud->attributes as $attname=>$noeud_attribute) {
					$g_module[$noeud->tagName][$attname] = $noeud->getAttribute($attname);
				}
			}
		}
		return $g_module;
	}
}

?>