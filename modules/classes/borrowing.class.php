<?php
class Borrowing extends ObjetBDD
{

    private $sql = "select uid, identifier, object_status_id, object_status_name,
                borrowing_id, borrowing_date, expected_return_date, return_date,
                borrower_id, borrower_name
                from borrowing
                join object using (uid)
                join borrower using (borrower_id)
                left outer join object_status using (object_status_id)";
    /**
     *
     * @param PDO $bdd        	
     * @param array $param        	
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "borrowing";
        $this->colonnes = array(
            "borrowing_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "uid" => array(
                "type" => 1,
                "requis" => 1,
                "parentAttrib" => 1
            ),
            "borrower_id" => array(
                "type" => 1,
                "requis" => 1
            ),
            "borrowing_date" => array(
                "type" => 2,
                "requis" => 1,
                "defaultValue" => "getDateJour"
            ),
            "expected_return_date" => array(
                "type" => 2
            ),
            "return_date" => array(
                "type" => 2
            )
        );
        parent::__construct($bdd, $param);
    }
    /**
     * Get the content of a borrowing
     *
     * @param int $id
     * @param boolean $getDefault
     * @param integer $parentValue
     * @return array
     */
    function lire($id, $getDefault = false, $parentValue = 0)
    {
        if ($id == 0 && $getDefault) {
            $data = $this->getDefaultValue($parentValue);
        } else {
            $data = $this->lireParamAsPrepared(
                $this->sql . " where borrowing_id = :borrowing_id",
                array("borrowing_id" => $id)
            );
        }
        return ($data);
    }
    /**
     * Get the list of borrowings by a borrower
     *
     * @param [type] $borrower_id
     * @param boolean $is_active
     * @return void
     */
    function getFromBorrower($borrower_id, $is_active = false)
    {
        $where = " where borrower_id = :borrower_id";
        if ($is_active) {
            $where .= " and return_date is null";
        }
        return $this->getListeParamAsPrepared($this->sql . $where, array("borrower_id" => $borrower_id));
    }
    /**
     * Get the list of borrowings for a uid
     *
     * @param [type] $uid
     * @param boolean $is_active
     * @return void
     */
    function getFromUid($uid, $is_active = false)
    {
        $where = " where uid = :uid";
        if ($is_active) {
            $where .= " and return_date is null";
        }
        return $this->getListeParamAsPrepared($this->sql . $where, array("uid" => $uid));
    }
    /**
     * Get the last active borrowing
     *
     * @param int $uid
     * @return int
     */
    function getLastborrowing($uid)
    {
        $sql = "select borrowing_id from last_borrowing where uid = :uid";
        $data = $this->lireParamAsPrepared($sql, array("uid" => $uid));
        return ($data["borrowing_id"]);
    }
}
