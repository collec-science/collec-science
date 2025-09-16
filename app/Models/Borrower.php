<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * ORM for table borrower
 */
class Borrower extends PpciModel
{
    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct()
    {
        $this->table = "borrower";
        $this->fields = array(
            "borrower_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "borrower_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "borrower_address" => array(
                "type" => 0
            ),
            "borrower_phone" => array(
                "type" => 0,
            ),
            "laboratory_code" => array(
                "type" => 0
            ),
            "borrower_mail" => array(
                "type" => 0
            )
        );
        parent::__construct();
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
        borrower_name, laboratory_code, borrower_mail,
        case when sample_type_id > 0 then
        'sample'
        else 'container' end as object_type,
         case when sample_type_id > 0 then
        sample_type_name
        else
        container_type_name
        end as name_type
        from borrowing
        join object using (uid)
        join borrower using (borrower_id)
        left outer join object_status using (object_status_id)
        left outer join sample using (uid)
        left outer join container using (uid)
        left outer join sample_type using (sample_type_id)
        left outer join container_type on (container.container_type_id = container_type.container_type_id)";
        $where = " where borrower_id = :borrower_id:";
        if ($is_active) {
            $where .= " and return_date is null";
        }
        /**
         * Add the dates of borrowings
         */
        $this->dateFields[] = "borrowing_date";
        $this->dateFields[] = "expected_return_date";
        $this->dateFields[] = "return_date";
        return $this->getListeParamAsPrepared($sql . $where, array("borrower_id" => $borrower_id));
    }
}
