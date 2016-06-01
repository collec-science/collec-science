<?php
/**
 * @author Eric Quinton
 * 11 août 2009
 */

class Test extends ObjetBDD {
	function __construct($bdd,$param=NULL){
		$this->table="Test";
		$this->id_auto = 1;
		$this->colonnes = array(
		"id"=>array("type"=>1,"requested"=>1),
		"datemodif"=>array("types"=>2),
		"champtexte"=>array("longueur"=>10,"pattern"=>"#^[a-zA-Z]+$#","requested"=>1),
		"champtexte2"=>array("longueur"=>5),
		"mel"=>array("pattern"=>"#^.+@.+\.[a-zA-Z]{2,6}$#")
		);
/*		$this->types=array(
		'id'=>1,
		'datemodif'=>2);
		$this->longueurs=array(
		'champtexte'=>10,
		'champtexte2'=>5);
		$this->cle="Id";
		$this->champs_nonvides=array(
		"champvide",
		"champtexte",
		"id");
		
		$this->pattern=array("mel"=>"#^.+@.+\.[a-zA-Z]{2,6}$#",
		'champtexte'=>"#^[a-zA-Z]+$#");
		*/
		parent::__construct($bdd,$param);
	}
	function ecrire($data) {
		parent::ecrire($data);
	}

	
}

?>