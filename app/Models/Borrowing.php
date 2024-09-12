<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class Borrowing extends PpciModel
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
    function __construct()
    {
        $this->table = "borrowing";
        $this->fields = array(
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
                "defaultValue" => $this->getDateJour()
            ),
            "expected_return_date" => array(
                "type" => 2
            ),
            "return_date" => array(
                "type" => 2
            )
        );
        parent::__construct();
    }
    /**
     * Get the content of a borrowing
     *
     * @param int $id
     * @param boolean $getDefault
     * @param integer $parentValue
     * @return array
     */
    function read(int $id, bool $getDefault = false, $parentValue = 0): array
    {
        if ($id == 0 && $getDefault) {
            $data = $this->getDefaultValues($parentValue);
        } else {
            $data = $this->lireParamAsPrepared(
                $this->sql . " where borrowing_id = :borrowing_id:",
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
        $where = " where borrower_id = :borrower_id:";
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
        $where = " where uid = :uid:";
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
        $sql = "select borrowing_id from last_borrowing where uid = :uid:";
        $data = $this->lireParamAsPrepared($sql, array("uid" => $uid));
        return ($data["borrowing_id"]);
    }

    /**
     * Set the borrowing for an object and all objects contained (containers)
     *
     * @param int $uid
     * @param int $borrower_id
     * @param string $borrowing_date
     * @param string $expected_return_date
     * @param ObjectClass $object
     * @param Container $container
     * @return int
     */
    function setBorrowing($uid, $borrower_id, $borrowing_date, $expected_return_date, ObjectClass $object = null, Container $container = null)
    {
        $data = array(
            "uid" => $uid,
            "borrower_id" => $borrower_id,
            "borrowing_date" => $borrowing_date,
            "expected_return_date" => $expected_return_date
        );
        $borrowing_id = $this->ecrire($data);
        if ($borrowing_id > 0) {
            if ($object == null) {
                $object = new ObjectClass();
            }
            $object->setStatus($uid, 6);
            /**
             * Get all children
             */
            $do = $object->readWithType($uid);
            if ($do["type_name"] == 'container') {
                if ($container == null) {
                    $container = new Container();
                }
                $children = $container->getContentSample($uid);
                foreach ($children as $child) {
                    $this->setBorrowing($child["uid"], $borrower_id, $borrowing_date, $expected_return_date, $object);
                }
                $children = $container->getContentContainer($uid);
                foreach ($children as $child) {
                    $this->setBorrowing($child["uid"], $borrower_id, $borrowing_date, $expected_return_date, $object, $container);
                }
            }
        }
        return $borrowing_id;
    }

    /**
     * Set the return of an object
     *
     * @param int $uid
     * @param string $return_date
     * @param ObjectClass $object
     * @param Container $container
     * @return void
     */
    function setReturn($uid, $return_date, ObjectClass $object = null, Container $container = null)
    {
        if ($uid > 0 && !empty($return_date)) {
            if (str_contains($return_date, '-')) {
                $return_date = $this->formatDateDBtoLocal($return_date);
            }
            $borrowing_id = $this->getLastborrowing($uid);
            if ($borrowing_id > 0) {
                $db = $this->lire($borrowing_id);
                $db["return_date"] = $return_date;
                $this->ecrire($db);
                /**
                 * Set the status of the object
                 */
                if ($object == null) {
                    $object = new ObjectClass;
                }
                $do = $object->readWithType($uid);
                if ($do["object_status_id"] == 6) {
                    $object->setStatus($uid, 1);
                }
                /**
                 * If container, set return for all objects included
                 */
                if ($do["type_name"] == 'container') {
                    if ($container == null) {
                        $container = new Container;
                    }
                    $children = $container->getContentSample($uid);
                    foreach ($children as $child) {
                        $this->setReturn($child["uid"], $return_date, $object);
                    }
                    $children = $container->getContentContainer($uid);
                    foreach ($children as $child) {
                        $this->setReturn($child["uid"], $return_date, $object, $container);
                    }
                }
            }
        }
    }
}
