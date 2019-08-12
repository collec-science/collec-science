<?php
/**
 * ORM for table borrower
 */
class Borrower extends ObjetBDD {
	/**
	 *
	 * @param PDO $bdd        	
	 * @param array $param        	
	 */
	function __construct($bdd, $param = array()) {
		$this->table = "borrower";
		$this->colonnes = array (
				"borrower_id" => array (
						"type" => 1,
						"key" => 1,
						"requis" => 1,
						"defaultValue" => 0 
				),
				"borrower_name" => array (
						"type" => 0,
						"requis" => 1 
				),
				"borrower_address" => array (
						"type" => 0
				),
				"borrower_phone" => array (
						"type" => 0,
				) 
		);
		parent::__construct ( $bdd, $param );
    }

    /**
     * Get the list of borrowings by a borrower
     *
     * @param [type] $borrower_id
     * @param boolean $is_active
     * @return void
     */
    function getBorrowings($borrower_id, $is_active = false)
    {
        $sql = "select uid, identifier, object_status_id, object_status_name,
                borrowing_id, borrowing_date, expected_return_date, return_date,
                borrowing_name
                from borrowing
                join object using (uid)
                join borrower using (borrower_id)
                left outer join object_status using (object_status_id)";
        $where = " where borrower_id = :borrower_id";
        if ($is_active) {
            $where .= " and return_date is null";
        }
        return $this->getListeParamAsPrepared($this->sql . $where, array("borrower_id" => $borrower_id));
    }
}