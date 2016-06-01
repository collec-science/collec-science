<?php
class Example extends ObjetBDD {
	/**
	 * Constructeur de la classe
	 * @param instance ADODB $bdd
	 * @param array $param
	 */
	function __construct($bdd,$param=null) {
		$this->param = $param;
		$this->table="Example";
		$this->id_auto="1";
		$this->colonnes=array(
				"idExample"=>array("type"=>1,"key"=>1, "requis"=>1, "defaultValue"=>0),
				"idParent"=>array("type"=>1, "requis"=>1, "parentAttrib"=>1),
				"comment"=>array("defaultValue"=>"Comment",longueur=>"255"),
				"dateExample"=>array("type"=>2,"requis"=>1, "defaultValue"=>"getDateJour"),
		);
		if(!is_array($param)) $param==array();
		$param["fullDescription"]=1;
		parent::__construct($bdd,$param);
	}
}
?>