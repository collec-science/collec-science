<?php

require_once ('XMLElement.abstract.php');
require_once ('Fonction.class.php');

/**
 * OpenOfficeSpreadsheet est un ensemble de classes permettant de générer un document OpenOffice
 * Spreadsheet (feuille de calcul ou tableur). Ces classes contiennent un certain nombre de
 * fonctions permettant la mise en page et le remplissage de cellules. Euh, sinon c'est tout.
 * Mais il y a de quoi faire, notamment au niveau des classes Settings et Styles, mais ça
 * viendra (peut-être) plus tard.
 *
 * Sinon, c'est gratuit, c'est sympa, et même si ça ne sert pas à grand chose, ça sert quand
 * même à quelque chose. Donc finalement, c'est cool. Alors enjoy!
 *
 * @package		OpenOfficeGeneration
 * @version		0.2
 * @copyright	(C) 2006 Tafel. All rights reserved
 * @license		http://www.gnu.org/copyleft/lesser.html LGPL License
 * @author		Tafel <fab_tafelmak@hotmail.com>
 *
 * Programme sous licence GPL. Toute reproduction, même patielle, est autorisée, avec ou sans le
 * consentement du programmeur principal (avec, c'est mieux, quand même ;) ...)
 */
class Picture extends XMLElement {
	
	/**
	 *-------------------------------------------------------------------------------
	 * Propriétés
	 *-------------------------------------------------------------------------------
	 */
	
	/**
	 * @access 	protected
	 * @var 	string			$picturePath			Le chemin et nom de l'image
	 */
	protected $picturePath;
	
	/**
	 * @access 	protected
	 * @var 	TableCell		$cellAddress			La cellule qui contient le coin bas-droite de l'image
	 */
	protected $cellAddress;
	
	/**
	 * @access 	protected
	 * @var 	string			$sheetAddress			Le nom de la feuille concernée
	 */
	protected $sheetAddress;
	
	/**
	 * @access 	protected
	 * @var 	float			$xEnd					La position en X du coin bas-droite dans la cellule
	 */
	protected $xEnd;
	
	/**
	 * @access 	protected
	 * @var 	float			$yEnd					La position en Y du coin bas-droite dans la cellule
	 */
	protected $yEnd;
	
	/**
	 * @access 	protected
	 * @var 	integer			$zIndex					L'index de superposition
	 */
	protected $zIndex;
	
	/**
	 * @access 	protected
	 * @var 	string			$name					Le nom de l'image
	 */
	protected $name;
	
	/**
	 * @access 	protected
	 * @var 	string			$style					Le style de l'image
	 */
	protected $style;
	
	/**
	 * @access 	protected
	 * @var 	string			$textStyle				Le style du texte de l'image
	 */
	protected $textStyle;
	
	/**
	 * @access 	protected
	 * @var 	float			$width					La largeur de l'image
	 */
	protected $width;
	
	/**
	 * @access 	protected
	 * @var 	float			$height					La hauteur de l'image
	 */
	protected $height;
	
	/**
	 * @access 	protected
	 * @var 	float			$svgx					Valeur en X pour le SVG
	 */
	protected $svgx;
	
	/**
	 * @access 	protected
	 * @var 	float			$svgy					Valeur en Y pour le SVG
	 */
	protected $svgy;
	
	/**
	 * @access 	protected
	 * @var 	string			$type					Le type du link de l'image
	 */
	protected $type;
	
	/**
	 * @access 	protected
	 * @var 	string			$show					La manière dont est montré le link de l'image
	 */
	protected $show;
	
	/**
	 * @access 	protected
	 * @var 	string			$actuate				Le moment où apparaît l'image
	 */
	protected $actuate;
	
	
	/**
	 *-------------------------------------------------------------------------------
	 * Constructeur
	 *-------------------------------------------------------------------------------
	 */

	/**
	 * Constructeur qui load une Picture
	 *
	 * @access 	public
	 * @param 	object			$core					Objet DOM du fichier XML
	 * @param 	object			$xpath					Objet DOMXPath du fichier XML
	 * @param 	string			$picture_path			Le chemin et nom de l'image
	 * @param 	string			$sheet_name				Le nom de la feuille
	 * @return 	object									L'objet classe
	 */
	public function __construct($core = '', $xpath = '', $picture_path = '', $sheet_name = '') {
		if ($core && $xpath) {
			$this->load('picture', $core, $xpath);
			$this->root = $xpath->query('//office:spreadsheet')->item(0);
			$path = explode('/', Fonction::removeLastSlash($picture_path));
			$name = array_pop($path);
			//$path = (count($path) == 0) ? $path = '' : implode('/', $path);
			$this->picturePath = implode('/', $path);
			$this->name = $name;
			$this->sheetAddress = $sheet_name;
			$this->type = 'simple';
			$this->show = 'embed';
			$this->actuate = 'onLoad';
			$this->type = 'image/gif';
			$this->zIndex = 0;
		}
	}
	
	
	/**
	 *-------------------------------------------------------------------------------
	 * Méthodes publiques
	 *-------------------------------------------------------------------------------
	 */
	
	/**
	 * Fonction qui set les valeurs pour le SVG
	 *
	 * @access 	public
	 * @param 	float			$x						Valeur en X pour le SVG
	 * @param 	float			$y						Valeur en Y pour le SVG
	 * @return 	void
	 */
	public function setSVG($x, $y) {
		$this->setSVGX($x);
		$this->setSVGY($y);
	}
	
	/**
	 * Fonction qui set les dimensons de l'image
	 *
	 * @access 	public
	 * @param 	float			$width					La largeur de l'image
	 * @param 	float			$heigh					La hauteur de l'image
	 * @return 	void
	 */
	public function setSize($width, $height) {
		$this->setWidth($width);
		$this->setHeight($height);
	}
	
	/**
	 * Fonction qui set la position du coin bas-droite
	 *
	 * @access 	public
	 * @param 	float			$x_end					La position en X du coin bas-droite dans la cellule
	 * @param 	float			$y_end					La position en Y du coin bas-droite dans la cellule
	 * @param 	TableCell		$cell					La cellule qui contient le coin bas-droite de l'image
	 * @return 	void
	 */
	public function setBottomRightCorner($x_end, $y_end, $cell) {
		$this->setCellAddress($cell);
		$this->setXEnd($x_end);
		$this->setYEnd($y_end);
	}
	
	/**
	 * Fonction qui retourne le chemin et le nom de l'image
	 *
	 * @access 	public
	 * @return 	string									Le chemin et le nom de l'image
	 */
	public function getPathName() {
		if ($this->picturePath == '') {
			return $this->getName();	
		} else {
			return $this->getPath().'/'.$this->getName();	
		}
	}
	
	
	/**
	 *-------------------------------------------------------------------------------
	 * Méthodes getters et setters
	 *-------------------------------------------------------------------------------
	 */	
	
	/**
	 * Fonction qui set le moment où apparaît l'image
	 *
	 * @access 	public
	 * @param 	string			$actuate				Le moment où apparaît l'image
	 * @return 	void
	 */
	public function setActuate($actuate) {
		$this->actuate = $actuate;
	}
	
	/**
	 * Fonction qui set la manière dont est montré le link de l'image
	 *
	 * @access 	public
	 * @param 	string			$show					La manière dont est montré le link de l'image
	 * @return 	void
	 */
	public function setShow($show) {
		$this->show = $show;
	}
	
	/**
	 * Fonction qui set le type du link de l'image
	 *
	 * @access 	public
	 * @param 	string			$type					Le type du link de l'image
	 * @return 	void
	 */
	public function setType($type) {
		$this->type = $type;
	}
	
	/**
	 * Fonction qui set le style du texte de l'image
	 *
	 * @access 	public
	 * @param 	string			$style					Le style du texte de l'image
	 * @return 	void
	 */
	public function setTextStyle($style) {
		$this->textStyle = $style;
	}
	
	/**
	 * Fonction qui set le style de l'image
	 *
	 * @access 	public
	 * @param 	string			$style					Le style de l'image
	 * @return 	void
	 */
	public function setStyle($style) {
		$this->style = $style;
	}
	
	/**
	 * Fonction qui set le nom de l'image
	 *
	 * @access 	public
	 * @param 	string			$name					Le nom de l'image
	 * @return 	void
	 */
	public function setName($name) {
		$this->name = $name;
	}
	
	/**
	 * Fonction qui set l'index de superposition
	 *
	 * @access 	public
	 * @param 	integer			$index					L'index de superposition
	 * @return 	void
	 */
	public function setZIndex($index) {
		$this->zIndex = $index;
	}
	
	/**
	 * Fonction qui récupère la cellule qui contient le coin bas-droite de l'image
	 *
	 * @access 	public
	 * @return 	TableCell		$style					La cellule qui contient le coin bas-droite de l'image
	 */
	public function getCellAddress() {
		$cell = $this->cellAddress;
		$l = Fonction::getLetters(true);
		return $this->sheetAddress.'.'.$l[$cell->getX()].$cell->getY();
	}
	
	/**
	 * Fonction qui récupère le moment où apparaît l'image
	 *
	 * @access 	public
	 * @return 	string									Le moment où apparaît l'image
	 */
	public function getActuate() {
		return $this->actuate;
	}
	
	/**
	 * Fonction qui récupère la manière dont est montré le link de l'image
	 *
	 * @access 	public
	 * @return 	string									La manière dont est montré le link de l'image
	 */
	public function getShow() {
		return $this->show;
	}
	
	/**
	 * Fonction qui récupère le type du link de l'image
	 *
	 * @access 	public
	 * @return 	string									Le type du link de l'image
	 */
	public function getType() {
		return $this->type;
	}
	
	/**
	 * Fonction qui récupère la valeur en X pour le SVG
	 *
	 * @access 	public
	 * @return 	float									Valeur en X pour le SVG
	 */
	public function getSVGX() {
		return $this->svgx;
	}
	
	/**
	 * Fonction qui récupère la valeur en Y pour le SVG
	 *
	 * @access 	public
	 * @return 	float									Valeur en Y pour le SVG
	 */
	public function getSVGY() {
		return $this->svgy;
	}
	
	/**
	 * Fonction qui récupère la largeur de l'image
	 *
	 * @access 	public
	 * @return 	float									La largeur de l'image
	 */
	public function getWidth() {
		return $this->width;
	}
	
	/**
	 * Fonction qui récupère la hauteur de l'image
	 *
	 * @access 	public
	 * @return 	float									La hauteur de l'image
	 */
	public function getHeight() {
		return $this->height;
	}
	
	/**
	 * Fonction qui récupère le style du texte de l'image
	 *
	 * @access 	public
	 * @return 	string									Le style du texte de l'image
	 */
	public function getTextStyle() {
		return $this->textStyle;
	}
	
	/**
	 * Fonction qui récupère le style de l'image
	 *
	 * @access 	public
	 * @return 	string									Le style de l'image
	 */
	public function getStyle() {
		return $this->style;
	}
	
	/**
	 * Fonction qui récupère le nom de l'image
	 *
	 * @access 	public
	 * @return 	string									Le nom de l'image
	 */
	public function getName() {
		return $this->name;
	}
	
	/**
	 * Fonction qui récupère l'index de superposition
	 *
	 * @access 	public
	 * @return 	integer									L'index de superposition
	 */
	public function getZIndex() {
		return $this->zIndex;
	}
	
	/**
	 * Fonction qui récupère la position en X du coin bas-droite dans la cellule
	 *
	 * @access 	public
	 * @return 	float									La position en X du coin bas-droite dans la cellule
	 */
	public function getXEnd() {
		return $this->xEnd;
	}
	
	/**
	 * Fonction qui récupère la position en Y du coin bas-droite dans la cellule
	 *
	 * @access 	public
	 * @return 	float								La position en Y du coin bas-droite dans la cellule
	 */
	public function getYEnd() {
		return $this->yEnd;
	}
	
	/**
	 * Fonction qui récupère le nom et chemin de l'image
	 *
	 * @access 	public
	 * @return 	string								Le nom et chemin de l'image
	 */
	public function getPath() {
		return $this->picturePath;
	}
	
	
	/**
	 *-------------------------------------------------------------------------------
	 * Méthodes privées
	 *-------------------------------------------------------------------------------
	 */	
	
	/**
	 * Fonction qui set la cellule qui contient le coin bas-droite de l'image
	 *
	 * @access 	protected
	 * @param 	TableCell		$cell					La cellule qui contient le coin bas-droite de l'image
	 * @return 	void
	 */
	protected function setCellAddress($cell) {
		$this->cellAddress = $cell;
	}
	
	/**
	 * Fonction qui set la valeur en X pour le SVG
	 *
	 * @access 	protected
	 * @param 	float			$x						Valeur en X pour le SVG
	 * @return 	void
	 */
	protected function setSVGX($x) {
		$this->svgx = $x;
	}
	
	/**
	 * Fonction qui set la valeur en Y pour le SVG
	 *
	 * @access 	protected
	 * @param 	float			$y						Valeur en Y pour le SVG
	 * @return 	void
	 */
	protected function setSVGY($y) {
		$this->svgy = $y;
	}
	
	/**
	 * Fonction qui set la largeur de l'image
	 *
	 * @access 	protected
	 * @param 	float			$width					La largeur de l'image
	 * @return 	void
	 */
	protected function setWidth($width) {
		$this->width = $width;
	}
	
	/**
	 * Fonction qui set la hauteur de l'image
	 *
	 * @access 	protected
	 * @param 	float			$height					La hauteur de l'image
	 * @return 	void
	 */
	protected function setHeight($height) {
		$this->height = $height;
	}
	
	/**
	 * Fonction qui set la position en X du coin bas-droite dans la cellule
	 *
	 * @access 	protected
	 * @param 	float			$x						La position en X du coin bas-droite dans la cellule
	 * @return 	void
	 */
	protected function setXEnd($x) {
		$this->xEnd = $x;
	}
	
	/**
	 * Fonction qui set la position en Y du coin bas-droite dans la cellule
	 *
	 * @access 	protected
	 * @param 	float			$y					La position en Y du coin bas-droite dans la cellule
	 * @return 	void
	 */
	protected function setYEnd($y) {
		$this->yEnd = $y;
	}
	
}

?>
