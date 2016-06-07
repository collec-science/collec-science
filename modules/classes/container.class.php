<?php
/**
 * Created : 2 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
class Container extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	function __construct($bdd, $param = null) {
		$this->table = "container";
		$this->colonnes = array (
				"container_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"uid" => array (
						"type" => 1,
						"parentAttrib" => 1,
						"requis" => 1 
				),
				"container_type_id"=>array("type"=>1, "requis"=>1)
		);
		parent::__construct ( $bdd, $param );
	}
	
	function getChildren($uid) {
		if ($uid > 0 && is_numeric($uid)) {
			$sql = "select o.uid, o.identifier, sa.*, container_type_id, container_type_name
					from object o
					left outer join sample sa on (sa.uid = o.uid)
					left outer join container co on (co.uid = o.uid)
					left outer join container_type using (container_type_id)
					join storage st on (o.uid = st.uid)
					where st.storage_id = (
						select st1.storage_id
						from storage st1
						join container co1 on (st1.container_id = co1.container_id)
						where co1.uid = :uid
						and st1.movement_type_id = 1
						order by st1.storage_date desc limit 1)
					";
		}
	}
}

?>